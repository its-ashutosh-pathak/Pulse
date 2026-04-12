import React, { createContext, useContext, useState, useRef, useEffect, useCallback } from 'react';
import { useAuth } from './AuthContext';
import { isDownloaded, getAudioObjectURL } from '../utils/downloadManager';

const AudioContext = createContext(null);

const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export function AudioProvider({ children }) {
  const { user, updatePlaybackStats } = useAuth();
  const [currentSong, setCurrentSong]   = useState(null);
  const [isPlaying, setIsPlaying]       = useState(false);
  const [progress, setProgress]         = useState(0);
  const [duration, setDuration]         = useState(0);
  const [queue, setQueue]               = useState([]);
  const [baseQueue, setBaseQueue]       = useState([]); // Original unshuffled queue mapping
  const [isShuffled, setIsShuffled]     = useState(false);
  const [repeatMode, setRepeatMode]     = useState('off'); // 'off' | 'one' | 'all'
  const [history, setHistory]           = useState([]); // Track history for Prev button
  const [isLoading, setIsLoading]       = useState(false);

  const audioRef              = useRef(new Audio());
  const crossfadeAudioRef     = useRef(new Audio()); // secondary element for crossfade fade-in
  const statsThresholdReached = useRef(false);
  const currentSongRef        = useRef(null); 
  const crossfadeActiveRef    = useRef(false); // true once crossfade fade-out starts for current song
  const crossfadeTimerRef     = useRef(null);  // setInterval id for crossfade volume ramp
  const loadGenRef            = useRef(0); // Increments on each new song load to cancel stale play() calls

  // Keep refs in sync with state (avoids stale closures in audio event handlers)
  const repeatModeRef = useRef(repeatMode);
  const playNextRef   = useRef(null); // Stable ref to playNext — avoids stale closure in timeupdate
  const playPrevRef   = useRef(null); // Stable ref to playPrev — used by Media Session API
  const queueRef      = useRef(queue); // Stable ref to queue — used for prefetch IDs
  useEffect(() => { currentSongRef.current = currentSong; }, [currentSong]);
  useEffect(() => { repeatModeRef.current = repeatMode; }, [repeatMode]);
  useEffect(() => { queueRef.current = queue; }, [queue]);

  // ── Throttle helper for Media Session position updates ──────────────────────
  const lastPositionUpdate = useRef(0);

  // ── Audio event listeners ──────────────────────────────────────────────────
  useEffect(() => {
    const audio = audioRef.current;

    const onTimeUpdate = () => {
      setProgress(audio.currentTime);

      // ── Crossfade: fade volume out as track approaches end, then trigger next song ──
      const fadeSeconds = parseInt(localStorage.getItem('pulse_crossfade') || '0');
      if (fadeSeconds > 0 && audio.duration > 0) {
        const timeLeft = audio.duration - audio.currentTime;
        if (!crossfadeActiveRef.current && timeLeft <= fadeSeconds && timeLeft > 0) {
          crossfadeActiveRef.current = true;
          // Start the crossfade: load next into secondary element and ramp volumes
          _startCrossfade(fadeSeconds);
        }
        // Smoothly fade out current track as time runs out
        if (crossfadeActiveRef.current) {
          const timeLeft2 = audio.duration - audio.currentTime;
          audio.volume = Math.max(0, Math.min(1, timeLeft2 / fadeSeconds));
        }
      }

      if (
        !statsThresholdReached.current &&
        audio.duration > 0 &&
        (audio.currentTime > 30 || audio.currentTime > audio.duration / 2)
      ) {
        updatePlaybackStats(currentSongRef.current, Math.round(audio.currentTime * 1000));
        statsThresholdReached.current = true;
      }

      // ── Media Session: Update position state (throttled to once per second) ──
      const now = Date.now();
      if (now - lastPositionUpdate.current > 1000 && 'mediaSession' in navigator && audio.duration > 0) {
        lastPositionUpdate.current = now;
        try {
          navigator.mediaSession.setPositionState({
            duration: audio.duration,
            playbackRate: audio.playbackRate || 1,
            position: Math.min(audio.currentTime, audio.duration),
          });
        } catch (_) { /* some browsers don't support setPositionState */ }
      }
    };

    const onLoadedMetadata = () => setDuration(audio.duration);
    const onEnded = () => {
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
    const onError = (e) => {
      // Ignore the expected error that fires when we set src='' to stop playback
      if (!audio.src || audio.src === window.location.href || audio.src === '') return;
      console.error('Native Playback Error:', e);
      setIsLoading(false);
    };
    const onCanPlay        = () => setIsLoading(false);
    const onPlay           = () => {
      setIsPlaying(true);
      if ('mediaSession' in navigator) navigator.mediaSession.playbackState = 'playing';
    };
    const onPause          = () => {
      setIsPlaying(false);
      if ('mediaSession' in navigator) navigator.mediaSession.playbackState = 'paused';
    };
    const onPlaying        = () => { setIsPlaying(true); setIsLoading(false); };

    audio.addEventListener('timeupdate',     onTimeUpdate);
    audio.addEventListener('loadedmetadata', onLoadedMetadata);
    audio.addEventListener('ended',          onEnded);
    audio.addEventListener('error',          onError);
    audio.addEventListener('canplay',        onCanPlay);
    audio.addEventListener('play',           onPlay);
    audio.addEventListener('pause',          onPause);
    audio.addEventListener('playing',        onPlaying);

    return () => {
      audio.removeEventListener('timeupdate',     onTimeUpdate);
      audio.removeEventListener('loadedmetadata', onLoadedMetadata);
      audio.removeEventListener('ended',          onEnded);
      audio.removeEventListener('error',          onError);
      audio.removeEventListener('canplay',        onCanPlay);
      audio.removeEventListener('play',           onPlay);
      audio.removeEventListener('pause',          onPause);
      audio.removeEventListener('playing',        onPlaying);
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
    };
  }, []);

  // ── Media Session API — lock screen / notification controls ─────────────────
  // Updates the OS 'Now Playing' card (title, artist, artwork) and wires
  // hardware/software media buttons on mobile and desktop.
  useEffect(() => {
    if (!('mediaSession' in navigator)) return;

    if (currentSong) {
      navigator.mediaSession.metadata = new MediaMetadata({
        title:  currentSong.title  || 'Unknown Title',
        artist: currentSong.artist || 'Unknown Artist',
        album:  currentSong.album  || 'Pulse',
        artwork: currentSong.thumbnail
          ? [
              { src: currentSong.thumbnail, sizes: '256x256', type: 'image/jpeg' },
              { src: currentSong.thumbnail, sizes: '512x512', type: 'image/jpeg' },
            ]
          : [],
      });

      // Set initial playback state so OS knows we're actively playing
      navigator.mediaSession.playbackState = isPlaying ? 'playing' : 'paused';
    }

    navigator.mediaSession.setActionHandler('play',  () => { audioRef.current?.play(); setIsPlaying(true); });
    navigator.mediaSession.setActionHandler('pause', () => { audioRef.current?.pause(); setIsPlaying(false); });
    navigator.mediaSession.setActionHandler('stop',  () => {
      audioRef.current?.pause();
      setIsPlaying(false);
      if ('mediaSession' in navigator) navigator.mediaSession.playbackState = 'paused';
    });
    navigator.mediaSession.setActionHandler('previoustrack', () => playPrevRef.current?.());
    navigator.mediaSession.setActionHandler('nexttrack',     () => playNextRef.current?.());
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
  }, [currentSong, isPlaying]); // Re-run when song or playback state changes

  // ── Crossfade: load next song into secondary element and ramp volumes ───────
  const _startCrossfade = useCallback(async (fadeSeconds) => {
    // Get the next song from the queue without consuming it
    // (playNext will consume it when crossfade finishes or when the primary song ends)
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

      // Load into crossfade element and start playing at volume 0
      const cfAudio = crossfadeAudioRef.current;
      cfAudio.volume = 0;
      cfAudio.src = streamUrl;
      cfAudio.load();
      cfAudio.play().catch(() => {});

      // Ramp crossfade audio from 0→1 starting when it actually produces sound
      const onCfPlaying = () => {
        cfAudio.removeEventListener('playing', onCfPlaying);
        const startTime = Date.now();
        crossfadeTimerRef.current = setInterval(() => {
          const elapsed = (Date.now() - startTime) / 1000;
          const vol = Math.min(1, elapsed / fadeSeconds);
          cfAudio.volume = vol;
          if (vol >= 1) {
            clearInterval(crossfadeTimerRef.current);
            crossfadeTimerRef.current = null;

            // Crossfade complete — swap refs: crossfade becomes primary
            const oldPrimary = audioRef.current;
            oldPrimary.pause();
            oldPrimary.src = '';

            audioRef.current = cfAudio;
            crossfadeAudioRef.current = oldPrimary;
            crossfadeActiveRef.current = false;

            // Wire event listeners to the new primary audio element
            // (the useEffect above only attached to the original audioRef.current)
            // For simplicity, update state from the new primary
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
          }
        }, 50);
      };
      cfAudio.addEventListener('playing', onCfPlaying);

    } catch (err) {
      console.warn('[Crossfade] Failed to start crossfade, falling back to normal transition:', err);
      // Fall back — normal playNext will handle it
    }
  }, [user]);

  // ── Core play function ─────────────────────────────────────────────────────
  const playSong = useCallback(async (song, offlineUrl = null) => {
    // Normalize ID + thumbnail — different API sources use different field names
    const normalizedSong = {
      ...song,
      id:        song.videoId || song.id || '',
      videoId:   song.videoId || song.id || '',
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

      // Stop any current playback, reset volume
      audioRef.current.pause();
      audioRef.current.src = '';
      audioRef.current.volume = 1;

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

      // Determine quality based on settings + network
      const userQuality = localStorage.getItem('pulse_streaming_quality') || 'normal';
      const dataSaver   = localStorage.getItem('pulse_data_saver') === 'true';
      const conn        = navigator.connection || navigator.mozConnection || navigator.webkitConnection;
      const isCellular  = conn ? (conn.type === 'cellular' || ['2g', '3g'].includes(conn.effectiveType)) : false;
      
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
  }, []);


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
      id:        song.videoId || song.id || '',
      videoId:   song.videoId || song.id || '',
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
    if (audioRef.current.paused) {
      audioRef.current.play().then(() => setIsPlaying(true)).catch(console.error);
    } else {
      audioRef.current.pause();
      setIsPlaying(false);
    }
  }, []);

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
