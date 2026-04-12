import React, { createContext, useContext, useState, useRef, useEffect, useCallback } from 'react';
import { useAuth } from './AuthContext';
import { isDownloaded, getAudioObjectURL } from '../utils/downloadManager';

const AudioContext = createContext(null);

const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export function AudioProvider({ children }) {
  const { user, updatePlaybackStats } = useAuth();
  const [currentSong, setCurrentSong] = useState(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [progress, setProgress] = useState(0);
  const [duration, setDuration] = useState(0);
  const [queue, setQueue] = useState([]);
  const [baseQueue, setBaseQueue] = useState([]); // Original unshuffled queue mapping
  const [isShuffled, setIsShuffled] = useState(false);
  const [repeatMode, setRepeatMode] = useState('off'); // 'off' | 'one' | 'all'
  const [history, setHistory] = useState([]); // Track history for Prev button
  const [isLoading, setIsLoading] = useState(false);

  // ── CRITICAL: Use DOM-attached <audio> elements, NOT floating new Audio() objects.
  // Android Chrome only grants OS-level media session focus (lock screen / notification controls)
  // to <audio> elements that exist in the document. Floating objects are silently ignored.
  //
  // We use a lazy ref initializer (function passed to useRef) so the DOM elements are
  // resolved SYNCHRONOUSLY before any useEffect fires — avoiding race conditions with
  // the listener-attachment effect that also runs at mount.
  const audioRef = useRef(
    typeof document !== 'undefined'
      ? document.getElementById('pulse-primary-audio') || new Audio()
      : null
  );
  const crossfadeAudioRef = useRef(
    typeof document !== 'undefined'
      ? document.getElementById('pulse-crossfade-audio') || new Audio()
      : null
  );
  const statsThresholdReached = useRef(false);
  const currentSongRef = useRef(null);
  const crossfadeActiveRef = useRef(false); // true once crossfade fade-out starts for current song
  const crossfadeTimerRef = useRef(null);  // fallback setInterval id (only if Web Audio unavailable)
  const loadGenRef = useRef(0); // Increments on each new song load to cancel stale play() calls

  // Keep refs in sync with state (avoids stale closures in audio event handlers)
  const repeatModeRef = useRef(repeatMode);
  const playNextRef = useRef(null); // Stable ref to playNext — avoids stale closure in timeupdate
  const playPrevRef = useRef(null); // Stable ref to playPrev — used by Media Session API
  const queueRef = useRef(queue); // Stable ref to queue — used for prefetch IDs
  useEffect(() => { currentSongRef.current = currentSong; }, [currentSong]);
  useEffect(() => { repeatModeRef.current = repeatMode; }, [repeatMode]);
  useEffect(() => { queueRef.current = queue; }, [queue]);

  // ── Throttle helper for Media Session position updates ──────────────────────
  const lastPositionUpdate = useRef(0);

  // ── Cached settings (FIX #1: avoid synchronous localStorage in hot path) ────
  const crossfadeDurationRef = useRef(
    parseInt(localStorage.getItem('pulse_crossfade') || '0')
  );
  const streamingQualityRef = useRef(
    localStorage.getItem('pulse_streaming_quality') || 'normal'
  );
  const dataSaverRef = useRef(
    localStorage.getItem('pulse_data_saver') === 'true'
  );

  // Sync cached settings when they change (storage event = other tabs, visibilitychange = same tab)
  // Also expose syncSettings so it can be called directly after in-tab localStorage writes
  const syncSettings = useCallback(() => {
    crossfadeDurationRef.current = parseInt(localStorage.getItem('pulse_crossfade') || '0');
    streamingQualityRef.current = localStorage.getItem('pulse_streaming_quality') || 'normal';
    dataSaverRef.current = localStorage.getItem('pulse_data_saver') === 'true';
  }, []);

  useEffect(() => {
    const onStorage = (e) => {
      if (['pulse_crossfade', 'pulse_streaming_quality', 'pulse_data_saver'].includes(e.key)) {
        syncSettings();
      }
    };
    // Also sync on visibilitychange to catch same-tab writes (e.g., Settings page)
    const onVisChange = () => syncSettings();
    window.addEventListener('storage', onStorage);
    document.addEventListener('visibilitychange', onVisChange);
    // Periodically sync to catch any in-tab writes that don't fire either event
    // (e.g., Settings page changing crossfade without navigating away)
    const interval = setInterval(syncSettings, 5000);
    return () => {
      window.removeEventListener('storage', onStorage);
      document.removeEventListener('visibilitychange', onVisChange);
      clearInterval(interval);
    };
  }, [syncSettings]);

  // ── Web Audio API context for crossfade (FIX #5: runs on audio thread, immune to throttling) ──
  const webAudioCtxRef = useRef(null);
  // GainNodes for primary and crossfade elements
  const primaryGainRef = useRef(null);
  const crossfadeGainRef = useRef(null);
  // Track which elements are already connected to Web Audio (can only connect once per element)
  const connectedElementsRef = useRef(new WeakSet());

  /**
   * Lazily initialize Web Audio API context.
   * Must be called from a user gesture context on first use.
   */
  const ensureWebAudioCtx = useCallback(() => {
    if (webAudioCtxRef.current && webAudioCtxRef.current.state !== 'closed') {
      // Resume if suspended (mobile browsers suspend until gesture)
      if (webAudioCtxRef.current.state === 'suspended') {
        webAudioCtxRef.current.resume().catch(() => { });
      }
      return webAudioCtxRef.current;
    }
    try {
      const ctx = new (window.AudioContext || window.webkitAudioContext)();
      webAudioCtxRef.current = ctx;
      return ctx;
    } catch (e) {
      console.warn('[WebAudio] AudioContext not available:', e.message);
      return null;
    }
  }, []);

  /**
   * Connect an HTMLAudioElement to a GainNode via Web Audio API.
   * Returns the GainNode. Safe to call multiple times — only connects once per element.
   */
  const connectElementToGain = useCallback((audioElement) => {
    const ctx = ensureWebAudioCtx();
    if (!ctx) return null;
    try {
      // Only create MediaElementSource once per element (it's a one-way connection)
      if (!connectedElementsRef.current.has(audioElement)) {
        const source = ctx.createMediaElementSource(audioElement);
        const gain = ctx.createGain();
        source.connect(gain);
        gain.connect(ctx.destination);
        connectedElementsRef.current.add(audioElement);
        // Store gain node on the element for retrieval
        audioElement._pulseGainNode = gain;
      }
      return audioElement._pulseGainNode || null;
    } catch (e) {
      console.warn('[WebAudio] Failed to connect element:', e.message);
      return null;
    }
  }, [ensureWebAudioCtx]);

  // ── Transferable event listener system (FIX #6: re-attach on crossfade swap) ──
  const handlersRef = useRef(null);

  const attachAudioListeners = useCallback((audio) => {
    if (!handlersRef.current) return;
    const h = handlersRef.current;
    audio.addEventListener('timeupdate', h.onTimeUpdate);
    audio.addEventListener('loadedmetadata', h.onLoadedMetadata);
    audio.addEventListener('ended', h.onEnded);
    audio.addEventListener('error', h.onError);
    audio.addEventListener('canplay', h.onCanPlay);
    audio.addEventListener('play', h.onPlay);
    audio.addEventListener('pause', h.onPause);
    audio.addEventListener('playing', h.onPlaying);
  }, []);

  const detachAudioListeners = useCallback((audio) => {
    if (!handlersRef.current) return;
    const h = handlersRef.current;
    audio.removeEventListener('timeupdate', h.onTimeUpdate);
    audio.removeEventListener('loadedmetadata', h.onLoadedMetadata);
    audio.removeEventListener('ended', h.onEnded);
    audio.removeEventListener('error', h.onError);
    audio.removeEventListener('canplay', h.onCanPlay);
    audio.removeEventListener('play', h.onPlay);
    audio.removeEventListener('pause', h.onPause);
    audio.removeEventListener('playing', h.onPlaying);
  }, []);

  // ── Audio event listeners ──────────────────────────────────────────────────
  // IMPORTANT: Handlers must NOT capture `audioRef.current` in a closure variable.
  // After crossfade swaps, audioRef.current changes. Handlers must always read
  // audioRef.current dynamically, or use `this` (the element the listener is on).
  useEffect(() => {
    const audio = audioRef.current;

    const onTimeUpdate = function () {
      // `this` = the HTMLAudioElement this listener is attached to
      // After crossfade swap, `this` correctly refers to the NEW primary element
      const el = this;
      setProgress(el.currentTime);

      // ── Crossfade: check if we should start fade-out (using cached ref, not localStorage) ──
      const fadeSeconds = crossfadeDurationRef.current;
      if (fadeSeconds > 0 && el.duration > 0) {
        const timeLeft = el.duration - el.currentTime;
        if (!crossfadeActiveRef.current && timeLeft <= fadeSeconds && timeLeft > 0) {
          crossfadeActiveRef.current = true;
          _startCrossfade(fadeSeconds);
        }
        // Smoothly fade out current track via GainNode (preferred) or direct volume
        if (crossfadeActiveRef.current) {
          const timeLeft2 = el.duration - el.currentTime;
          const vol = Math.max(0, Math.min(1, timeLeft2 / fadeSeconds));
          const gain = primaryGainRef.current;
          if (gain) {
            // Use Web Audio GainNode — runs on audio thread
            gain.gain.setValueAtTime(vol, webAudioCtxRef.current?.currentTime || 0);
          } else {
            // Fallback to direct volume
            el.volume = vol;
          }
        }
      }

      if (
        !statsThresholdReached.current &&
        el.duration > 0 &&
        (el.currentTime > 30 || el.currentTime > el.duration / 2)
      ) {
        updatePlaybackStats(currentSongRef.current, Math.round(el.currentTime * 1000));
        statsThresholdReached.current = true;
      }

      // ── Media Session: Update position state (throttled to once per second) ──
      const now = Date.now();
      if (now - lastPositionUpdate.current > 1000 && 'mediaSession' in navigator && el.duration > 0) {
        lastPositionUpdate.current = now;
        try {
          navigator.mediaSession.setPositionState({
            duration: el.duration,
            playbackRate: el.playbackRate || 1,
            position: Math.min(el.currentTime, el.duration),
          });
        } catch (_) { /* some browsers don't support setPositionState */ }
      }
    };

    const onLoadedMetadata = function () { setDuration(this.duration); };
    const onEnded = function () {
      // If crossfade already triggered next song, don't play next again
      if (crossfadeActiveRef.current) {
        crossfadeActiveRef.current = false;
        return;
      }
      // Use ref to avoid stale closures
      if (repeatModeRef.current === 'one') {
        audioRef.current.currentTime = 0;
        audioRef.current.play();
      } else {
        playNextRef.current?.();
      }
    };
    const onError = function (e) {
      // Ignore the expected error that fires when we set src='' to stop playback
      const el = this;
      if (!el.src || el.src === window.location.href || el.src === '') return;
      console.error('Native Playback Error:', e);
      setIsLoading(false);
    };
    const onCanPlay = () => setIsLoading(false);
    const onPlay = () => {
      setIsPlaying(true);
      if ('mediaSession' in navigator) navigator.mediaSession.playbackState = 'playing';
    };
    const onPause = () => {
      setIsPlaying(false);
      if ('mediaSession' in navigator) navigator.mediaSession.playbackState = 'paused';
    };
    const onPlaying = () => { setIsPlaying(true); setIsLoading(false); };

    // Store handlers for transferability (FIX #6)
    handlersRef.current = { onTimeUpdate, onLoadedMetadata, onEnded, onError, onCanPlay, onPlay, onPause, onPlaying };
    attachAudioListeners(audio);

    return () => {
      detachAudioListeners(audio);
    };
  }, []); // Only attach once — currentSong read via ref

  // Cleanup native audio to prevent zombie tabs during Vite Hot Reloading
  useEffect(() => {
    return () => {
      if (audioRef.current) {
        audioRef.current.pause();
        audioRef.current.src = '';
      }
      if (crossfadeAudioRef.current) {
        crossfadeAudioRef.current.pause();
        crossfadeAudioRef.current.src = '';
      }
      if (crossfadeTimerRef.current) clearInterval(crossfadeTimerRef.current);
      // Close Web Audio context
      if (webAudioCtxRef.current && webAudioCtxRef.current.state !== 'closed') {
        webAudioCtxRef.current.close().catch(() => { });
      }
    };
  }, []);

  // ── Wake Lock API — prevent screen/process sleep during playback (FIX #5) ──
  const wakeLockRef = useRef(null);
  useEffect(() => {
    const requestWakeLock = async () => {
      if (!('wakeLock' in navigator)) return;
      try {
        wakeLockRef.current = await navigator.wakeLock.request('screen');
        wakeLockRef.current.addEventListener('release', () => {
          wakeLockRef.current = null;
        });
      } catch (e) {
        // Wake Lock request failed (e.g., low battery, not in foreground)
      }
    };
    const releaseWakeLock = () => {
      if (wakeLockRef.current) {
        wakeLockRef.current.release().catch(() => { });
        wakeLockRef.current = null;
      }
    };

    if (isPlaying) {
      requestWakeLock();
      // Re-acquire wake lock when page becomes visible again (released on hide)
      const onVisChange = () => {
        if (document.visibilityState === 'visible' && isPlaying) {
          requestWakeLock();
        }
      };
      document.addEventListener('visibilitychange', onVisChange);
      return () => {
        document.removeEventListener('visibilitychange', onVisChange);
        releaseWakeLock();
      };
    } else {
      releaseWakeLock();
    }
  }, [isPlaying]);

  // ── Media Session API — lock screen / notification controls (FIX #4) ────────
  // Metadata: updates when song changes
  useEffect(() => {
    if (!('mediaSession' in navigator) || !currentSong) return;

    // ── Artwork: proxy YouTube thumbnails through backend to avoid CORS rejections.
    // Android's notification system fetches artwork independently — direct ytimg.com
    // URLs fail CORS checks and result in blank/missing notification art on many devices.
    const buildArtwork = (thumb) => {
      if (!thumb) return [{ src: '/pwa-512x512.png', sizes: '512x512', type: 'image/png' }];
      // Use backend proxy if it's a remote URL
      const isRemote = thumb.startsWith('http');
      const proxied = isRemote ? `${API}/api/proxy-image?url=${encodeURIComponent(thumb)}` : thumb;
      return [
        { src: proxied, sizes: '96x96',   type: 'image/jpeg' },
        { src: proxied, sizes: '128x128', type: 'image/jpeg' },
        { src: proxied, sizes: '256x256', type: 'image/jpeg' },
        { src: proxied, sizes: '512x512', type: 'image/jpeg' },
      ];
    };

    navigator.mediaSession.metadata = new MediaMetadata({
      title: currentSong.title || 'Unknown Title',
      artist: currentSong.artist || 'Unknown Artist',
      album: currentSong.album || 'Pulse',
      artwork: buildArtwork(currentSong.thumbnail),
    });
  }, [currentSong]);

  // Action handlers: register once (use refs to avoid stale closures)
  useEffect(() => {
    if (!('mediaSession' in navigator)) return;

    navigator.mediaSession.setActionHandler('play', () => { audioRef.current?.play(); });
    navigator.mediaSession.setActionHandler('pause', () => { audioRef.current?.pause(); });
    navigator.mediaSession.setActionHandler('stop', () => {
      audioRef.current?.pause();
      setIsPlaying(false);
      if ('mediaSession' in navigator) navigator.mediaSession.playbackState = 'paused';
    });
    navigator.mediaSession.setActionHandler('previoustrack', () => playPrevRef.current?.());
    navigator.mediaSession.setActionHandler('nexttrack', () => playNextRef.current?.());
    navigator.mediaSession.setActionHandler('seekto', (d) => {
      if (audioRef.current && d.seekTime !== undefined) {
        audioRef.current.currentTime = d.seekTime;
        setProgress(d.seekTime);
      }
    });
    navigator.mediaSession.setActionHandler('seekbackward', (d) => {
      if (audioRef.current) {
        const offset = d?.seekOffset || 10;
        audioRef.current.currentTime = Math.max(0, audioRef.current.currentTime - offset);
        setProgress(audioRef.current.currentTime);
      }
    });
    navigator.mediaSession.setActionHandler('seekforward', (d) => {
      if (audioRef.current) {
        const offset = d?.seekOffset || 10;
        audioRef.current.currentTime = Math.min(audioRef.current.duration || 0, audioRef.current.currentTime + offset);
        setProgress(audioRef.current.currentTime);
      }
    });
  }, []); // Register once — handlers use refs internally

  /**
   * Complete the crossfade: swap audio refs, transfer listeners, update state.
   * Defined BEFORE _startCrossfade since it's called from within it.
   */
  const _completeCrossfadeSwap = useCallback((cfAudio, nextInQueue) => {
    const oldPrimary = audioRef.current;

    // Detach listeners from old primary BEFORE pausing (FIX #6)
    detachAudioListeners(oldPrimary);

    oldPrimary.pause();
    oldPrimary.src = '';

    // Swap refs: crossfade becomes primary
    audioRef.current = cfAudio;
    crossfadeAudioRef.current = oldPrimary;
    crossfadeActiveRef.current = false;

    // Reset gain nodes for the new primary
    primaryGainRef.current = cfAudio._pulseGainNode || null;
    crossfadeGainRef.current = null;

    // Re-attach event listeners to the new primary element (FIX #6 — the core fix)
    attachAudioListeners(cfAudio);

    // Update state from the new primary
    setDuration(cfAudio.duration || 0);
    setProgress(cfAudio.currentTime || 0);

    // Consume the queue entry
    setCurrentSong({
      ...nextInQueue,
      id: nextInQueue.videoId || nextInQueue.id || '',
      videoId: nextInQueue.videoId || nextInQueue.id || '',
      thumbnail: nextInQueue.thumbnail || nextInQueue.cover || nextInQueue.artworkUrl || '',
    });
    statsThresholdReached.current = false;
    setQueue(prev => prev.slice(1));
  }, [attachAudioListeners, detachAudioListeners]);

  // ── Crossfade: load next song into secondary element and ramp via Web Audio GainNode ──
  const _startCrossfade = useCallback(async (fadeSeconds) => {
    // Get the next song from the queue without consuming it
    const nextInQueue = queueRef.current?.[0];
    if (!nextInQueue) {
      // No next song — just let current fade out and trigger playNext on ended
      return;
    }

    try {
      const nextId = nextInQueue.videoId || nextInQueue.id || '';
      if (!nextId || nextId.length !== 11) return;

      // Build stream URL for the crossfade target
      const token = user ? await user.getIdToken() : '';
      let streamUrl;

      // Check offline first
      try {
        const downloaded = await isDownloaded(nextId);
        if (downloaded) {
          streamUrl = await getAudioObjectURL(nextId);
        }
      } catch (_) { /* not downloaded, fall through */ }

      if (!streamUrl) {
        streamUrl = `${API}/api/stream/${nextId}?token=${encodeURIComponent(token)}`;
      }

      // Load into crossfade element and start playing
      const cfAudio = crossfadeAudioRef.current;
      cfAudio.src = streamUrl;
      cfAudio.load();

      // Ensure Web Audio context is ready and resume it (user gesture context)
      const ctx = ensureWebAudioCtx();

      // Connect primary element to get its gain node for fade-out
      const primaryGain = connectElementToGain(audioRef.current);
      primaryGainRef.current = primaryGain;

      // Connect crossfade element and set initial volume to 0
      const cfGain = connectElementToGain(cfAudio);
      crossfadeGainRef.current = cfGain;

      if (cfGain && ctx) {
        // Web Audio path: set gain to 0, volume stays at 1
        cfGain.gain.setValueAtTime(0, ctx.currentTime);
        cfAudio.volume = 1;
      } else {
        // Fallback: use direct volume
        cfAudio.volume = 0;
      }

      cfAudio.play().catch(() => { });

      // Ramp crossfade audio from 0→1 starting when it actually produces sound
      const onCfPlaying = () => {
        cfAudio.removeEventListener('playing', onCfPlaying);

        if (cfGain && ctx) {
          // ── Web Audio API ramp (FIX #5: runs on audio thread, immune to throttling) ──
          cfGain.gain.setValueAtTime(0, ctx.currentTime);
          cfGain.gain.linearRampToValueAtTime(1, ctx.currentTime + fadeSeconds);

          // Schedule the swap after fade completes
          const swapDelay = fadeSeconds * 1000 + 100; // +100ms safety margin
          crossfadeTimerRef.current = setTimeout(() => {
            crossfadeTimerRef.current = null;
            _completeCrossfadeSwap(cfAudio, nextInQueue);
          }, swapDelay);
        } else {
          // ── Fallback: setInterval-based ramp ──
          const startTime = Date.now();
          crossfadeTimerRef.current = setInterval(() => {
            const elapsed = (Date.now() - startTime) / 1000;
            const vol = Math.min(1, elapsed / fadeSeconds);
            cfAudio.volume = vol;
            if (vol >= 1) {
              clearInterval(crossfadeTimerRef.current);
              crossfadeTimerRef.current = null;
              _completeCrossfadeSwap(cfAudio, nextInQueue);
            }
          }, 50);
        }
      };
      cfAudio.addEventListener('playing', onCfPlaying);

    } catch (err) {
      console.warn('[Crossfade] Failed to start crossfade, falling back to normal transition:', err);
      // Fall back — normal playNext will handle it
    }
  }, [user, ensureWebAudioCtx, connectElementToGain, _completeCrossfadeSwap]);

  // ── Core play function ─────────────────────────────────────────────────────
  const playSong = useCallback(async (song, offlineUrl = null) => {
    // Normalize ID + thumbnail — different API sources use different field names
    const normalizedSong = {
      ...song,
      id: song.videoId || song.id || '',
      videoId: song.videoId || song.id || '',
      thumbnail: song.thumbnail || song.cover || song.artworkUrl || '',
    };

    // Safety guard: YouTube video IDs are always exactly 11 characters.
    // Playlists, albums, and mixes have longer IDs — they must be navigated to,
    // not played. If something non-playable slips through, silently ignore it.
    // EXCEPTION: offline songs may not follow this rule — allow them through.
    if (!normalizedSong.id || (normalizedSong.id.length !== 11 && !offlineUrl && !song.offline)) {
      console.warn('[AudioContext] playSong blocked — not a valid video ID:', normalizedSong.id);
      return;
    }

    // Same song → toggle play/pause
    if (currentSongRef.current?.id && currentSongRef.current.id === normalizedSong.id && !offlineUrl) {
      togglePlay();
      return;
    }

    // Push current to history before switching
    if (currentSongRef.current) {
      setHistory(prev => [currentSongRef.current, ...prev].slice(0, 50));
    }

    try {
      // Cancel any active crossfade
      if (crossfadeTimerRef.current) {
        clearInterval(crossfadeTimerRef.current);
        clearTimeout(crossfadeTimerRef.current);
        crossfadeTimerRef.current = null;
      }
      crossfadeActiveRef.current = false;
      crossfadeAudioRef.current.pause();
      crossfadeAudioRef.current.src = '';

      statsThresholdReached.current = false;
      setIsLoading(true);
      setCurrentSong(normalizedSong);
      setIsPlaying(true);
      setProgress(0);
      setDuration(0);

      // Stop any current playback, reset volume/gain
      audioRef.current.pause();
      audioRef.current.src = '';
      audioRef.current.volume = 1;
      // Reset primary gain node to full volume
      if (primaryGainRef.current) {
        const ctx = webAudioCtxRef.current;
        if (ctx) primaryGainRef.current.gain.setValueAtTime(1, ctx.currentTime);
      }

      // Ensure Web Audio context is resumed (requires user gesture)
      ensureWebAudioCtx();

      // Increment load generation — any stale async play() calls will be aborted
      const myGen = ++loadGenRef.current;
      const isStale = () => loadGenRef.current !== myGen;

      // ── Helper: play with optional fade-in ──
      const playUrl = (url) => {
        audioRef.current.volume = 1;
        audioRef.current.src = url;
        audioRef.current.load();
        audioRef.current.play().catch(err => { if (!isStale()) console.error('Play error:', err); });
      };

      // ── OFFLINE PATH: explicit blobUrl provided (e.g. from Downloads page) ──
      const blobUrl = offlineUrl || (song.offline ? song.streamUrl : null);
      if (blobUrl) {
        playUrl(blobUrl);
        return;
      }

      // ── Check IndexedDB: if downloaded, play from blob (non-blocking) ────────
      // Only do this for valid 11-char video IDs to avoid IndexedDB lookup for playlists
      if (normalizedSong.id.length === 11) {
        try {
          const downloaded = await isDownloaded(normalizedSong.id);
          if (isStale()) return; // Song changed while we were checking
          if (downloaded) {
            const localUrl = await getAudioObjectURL(normalizedSong.id);
            if (isStale()) return;
            playUrl(localUrl);
            return;
          }
        } catch (_) {
          // Not downloaded or IndexedDB error — fall through to streaming
          if (isStale()) return;
        }
      }

      if (isStale()) return;

      // Determine quality based on cached settings + network (FIX #1: no localStorage in hot path)
      const userQuality = streamingQualityRef.current;
      const dataSaver = dataSaverRef.current;
      const conn = navigator.connection || navigator.mozConnection || navigator.webkitConnection;
      const isCellular = conn ? (conn.type === 'cellular' || ['2g', '3g'].includes(conn.effectiveType)) : false;

      const effectiveQuality = (dataSaver && isCellular) ? 'low' : userQuality;
      // ── Stream via backend proxy (YouTube CDN URLs are IP-locked to the server) ──
      const token = user ? await user.getIdToken() : '';
      if (isStale()) return;

      // Build stream URL — include next 3 queue IDs for backend prefetching
      const nextIds = queueRef.current.slice(0, 3).map(s => s.videoId || s.id).filter(Boolean).join(',');
      const streamUrl = `${API}/api/stream/${normalizedSong.id}?token=${encodeURIComponent(token)}${nextIds ? `&next=${nextIds}` : ''}`;
      playUrl(streamUrl);

      // Proactive Queue Fetching
      if (!normalizedSong._contextId) {
        fetch(`${API}/api/watch-next/${normalizedSong.id}`, { headers: { Authorization: `Bearer ${token}` } })
          .then(r => r.json())
          .then(res => {
            const tracks = res.data || [];
            if (res?.success && Array.isArray(tracks) && tracks.length > 0) {
              setQueue(tracks);
              setBaseQueue([normalizedSong, ...tracks]);
            }
          })
          .catch(err => console.error('Failed to pre-fetch watch-next:', err));
      }
    } catch (err) {
      console.error('Failed to load stream:', err);
      setIsLoading(false);
    }
  }, [ensureWebAudioCtx]);


  // ── Queue controls ─────────────────────────────────────────────────────────
  const playNext = useCallback(() => {
    statsThresholdReached.current = false;
    setQueue(prev => {
      if (prev.length > 0) {
        const [nextSong, ...rest] = prev;
        playSong(nextSong);
        return rest;
      }

      // If repeat ALL and queue empty, restart from baseQueue
      if (repeatModeRef.current === 'all' && baseQueue.length > 0) {
        const [first, ...rest] = isShuffled
          ? [...baseQueue].sort(() => Math.random() - 0.5)
          : baseQueue;
        playSong(first);
        return rest;
      }

      // Queue empty — fetch watch-next from ytmusicapi for radio-style continuity
      const currentId = currentSongRef.current?.id;
      if (currentId) {
        user?.getIdToken().then(token => {
          fetch(`${API}/api/watch-next/${currentId}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(r => r.json())
            .then(res => {
              const tracks = res.data || [];
              if (res?.success && Array.isArray(tracks) && tracks.length > 0) {
                const [first, ...rest] = tracks;
                playSong(first);
                setQueue(rest);
                console.log(`🎵 Watch-next loaded: ${tracks.length} tracks queued`);
              } else {
                setIsPlaying(false);
                setProgress(0);
                audioRef.current.pause();
              }
            })
            .catch(() => {
              setIsPlaying(false);
              setProgress(0);
              audioRef.current.pause();
            });
        });
      } else {
        setIsPlaying(false);
        setProgress(0);
        audioRef.current.pause();
      }
      return prev;
    });
  }, [playSong, baseQueue, isShuffled]);

  const playPrev = useCallback(() => {
    // If >3s into a song, restart it. Otherwise go to previous.
    if (audioRef.current.currentTime > 3) {
      audioRef.current.currentTime = 0;
      setProgress(0);
      return;
    }
    setHistory(prev => {
      if (prev.length > 0) {
        const [prevSong, ...rest] = prev;
        // Don't push to history again — internal navigation
        if (currentSongRef.current) {
          setQueue(q => [currentSongRef.current, ...q]);
        }
        playSong(prevSong);
        return rest;
      }
      // No history: just restart
      audioRef.current.currentTime = 0;
      setProgress(0);
      return prev;
    });
  }, [playSong]);

  // Keep playNextRef and playPrevRef in sync so crossfade/MediaSession handlers are never stale
  useEffect(() => { playNextRef.current = playNext; }, [playNext]);
  useEffect(() => { playPrevRef.current = playPrev; }, [playPrev]);

  // Add to queue — prepend (Play Next), same as Spotify / YT Music
  const addToQueue = useCallback((song) => {
    // Normalize song fields to match AudioContext standard
    const normalized = {
      ...song,
      id: song.videoId || song.id || '',
      videoId: song.videoId || song.id || '',
      thumbnail: song.thumbnail || song.cover || song.artworkUrl || '',
    };
    setQueue(prev => [normalized, ...prev]);
    setBaseQueue(prev => [normalized, ...prev]);
  }, []);

  const replaceQueue = useCallback((newQueueArray) => {
    setBaseQueue(newQueueArray);
    if (isShuffled) {
      setQueue([...newQueueArray].sort(() => Math.random() - 0.5));
    } else {
      setQueue(newQueueArray);
    }
  }, [isShuffled]);

  const toggleShuffle = useCallback(() => {
    setIsShuffled(prev => {
      const nextShuffle = !prev;
      setQueue(oldQueue => {
        if (nextShuffle) {
          // Explode strictly visually on UI side
          return [...oldQueue].sort(() => Math.random() - 0.5);
        } else {
          // Restore un-shuffled state but filter out consumed songs
          return baseQueue.filter(song => oldQueue.some(qSong => qSong.id === song.id));
        }
      });
      return nextShuffle;
    });
  }, [baseQueue]);

  const toggleRepeat = useCallback(() => {
    setRepeatMode(prev => {
      if (prev === 'off') return 'all';
      if (prev === 'all') return 'one';
      return 'off';
    });
  }, []);

  // ── Playback controls ──────────────────────────────────────────────────────
  const togglePlay = useCallback(() => {
    if (!currentSongRef.current) return;
    // Ensure Web Audio context is resumed on user gesture
    ensureWebAudioCtx();
    if (audioRef.current.paused) {
      audioRef.current.play().then(() => setIsPlaying(true)).catch(console.error);
    } else {
      audioRef.current.pause();
      setIsPlaying(false);
    }
  }, [ensureWebAudioCtx]);

  const seek = useCallback((time) => {
    audioRef.current.currentTime = time;
    setProgress(time);
  }, []);

  // ── Download (via Piped URL — user downloads directly from CDN) ────────────
  const downloadCurrentSong = useCallback(async () => {
    if (!currentSongRef.current) return;
    try {
      const q = localStorage.getItem('pulse_download_quality') || 'high';
      const token = user ? await user.getIdToken() : '';
      const response = await fetch(`${API}/api/play/${currentSongRef.current.id}?q=${q}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      const json = await response.json();
      const data = json.data || {};
      if (data.url) {
        const a = document.createElement('a');
        a.href = data.url;
        a.download = `${currentSongRef.current.title} - ${currentSongRef.current.artist}.webm`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
      }
    } catch (err) {
      console.error('Download failed:', err);
    }
  }, []);

  return (
    <AudioContext.Provider value={{
      currentSong,
      isPlaying,
      isLoading,
      progress,
      duration,
      queue,
      setQueue,
      baseQueue,
      isShuffled,
      toggleShuffle,
      replaceQueue,
      history,
      playSong,
      addToQueue,
      playNext,
      playPrev,
      togglePlay,
      toggleRepeat,
      repeatMode,
      seek,
      downloadCurrentSong
    }}>
      {children}
    </AudioContext.Provider>
  );
}

export const useAudio = () => useContext(AudioContext);
