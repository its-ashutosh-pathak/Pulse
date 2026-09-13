import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/toast_utils.dart';
import 'package:media_kit/media_kit.dart';

import '../services/wakelock_manager.dart';
import '../data/api/music_api.dart';
import '../data/models/song.dart';
import '../core/utils/thumbnail_utils.dart';
import '../services/audio_handler.dart';
import '../services/crossfade_engine.dart';
import '../services/stream_extractor.dart';
import '../main.dart' show scaffoldMessengerKey;
import 'auth_provider.dart';
import 'download_provider.dart';
import 'settings_provider.dart';
import 'playlist_provider.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';
import 'sleep_timer_provider.dart';

// ── Audio State ─────────────────────────────────────────────────────────────

enum RepeatMode { off, all, one }

class AudioState {
  final Song? currentSong;
  final String? contextPlaylistId;
  final bool isPlaying;
  final bool isLoading;
  final Duration progress;
  final Duration duration;
  final List<Song> queue;
  final List<Song> baseQueue; // Original unshuffled queue
  final List<Song> history;
  final bool isShuffled;
  final RepeatMode repeatMode;

  const AudioState({
    this.currentSong,
    this.contextPlaylistId,
    this.isPlaying = false,
    this.isLoading = false,
    this.progress = Duration.zero,
    this.duration = Duration.zero,
    this.queue = const [],
    this.baseQueue = const [],
    this.history = const [],
    this.isShuffled = false,
    this.repeatMode = RepeatMode.off,
  });

  AudioState copyWith({
    Song? currentSong,
    String? contextPlaylistId,
    bool clearContextPlaylistId = false,
    bool? isPlaying,
    bool? isLoading,
    Duration? progress,
    Duration? duration,
    List<Song>? queue,
    List<Song>? baseQueue,
    List<Song>? history,
    bool? isShuffled,
    RepeatMode? repeatMode,
  }) {
    return AudioState(
      currentSong: currentSong ?? this.currentSong,
      contextPlaylistId: clearContextPlaylistId ? null : (contextPlaylistId ?? this.contextPlaylistId),
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      duration: duration ?? this.duration,
      queue: queue ?? this.queue,
      baseQueue: baseQueue ?? this.baseQueue,
      history: history ?? this.history,
      isShuffled: isShuffled ?? this.isShuffled,
      repeatMode: repeatMode ?? this.repeatMode,
    );
  }
}

// ── Audio Provider ──────────────────────────────────────────────────────────

/// Port of AudioContext.jsx (983 lines) → Riverpod Notifier.
///
/// Manages: playback, queue, shuffle, repeat, crossfade, background playback,
/// lock screen controls, wake lock, and playback stats.
class AudioNotifier extends Notifier<AudioState> {
  late PulseAudioHandler _handler;
  late CrossfadeEngine _crossfadeEngine;
  final _musicApi = MusicApi();

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<bool>? _bufferingSub;

  /// Incremented on each new song load to cancel stale async operations.
  /// Mirrors `loadGenRef` in AudioContext.jsx (line 43).
  int _loadGeneration = 0;

  /// Whether the stats threshold has been reached for the current song.
  /// Mirrors `statsThresholdReached` ref in AudioContext.jsx (line 39).
  bool _statsThresholdReached = false;

  String? _preloadedNextSongId;
  bool _isPreloadingNext = false;
  bool _hasEagerPreloaded = false;

  int _consecutiveFailures = 0;

  bool _isInitialized = false;

  @override
  AudioState build() {
    ref.onDispose(_dispose);
    
    // Sync the notification/lock screen like button when playlists change from the app UI
    ref.listen(playlistProvider, (previous, next) {
      if (!_isInitialized) return;
      final current = state.currentSong;
      if (current != null) {
        final isLiked = ref.read(playlistProvider.notifier).isLiked(current.videoId);
        _handler.updateLikedState(isLiked);
      }
    });

    // When the user toggles Data Saver or changes streaming quality, invalidate
    // any preloaded next-song URL so the correct quality is used on the next skip.
    ref.listen(settingsProvider, (previous, next) {
      if (!_isInitialized) return;
      final prevQuality = previous?.dataSaverMode == true ? 'low' : previous?.streamingQuality;
      final nextQuality = next.dataSaverMode ? 'low' : next.streamingQuality;
      if (prevQuality != nextQuality && _preloadedNextSongId != null) {
        StreamExtractor.invalidateCache(_preloadedNextSongId!);
        _preloadedNextSongId = null;
        _hasEagerPreloaded = false;
        _crossfadeEngine.cancelCrossfade(); // drop the buffered wrong-quality audio
      }
    });

    // Sync EQ settings to the audio handler
    ref.listen(settingsProvider, (previous, next) {
      if (!_isInitialized) return;
      if (previous?.equalizerEnabled != next.equalizerEnabled || previous?.equalizerGains != next.equalizerGains) {
         _handler.setEqualizerState(enabled: next.equalizerEnabled, gains: next.equalizerGains);
      }
    });

    // Initialization is deferred — must call initialize() after handler is ready.
    return const AudioState();
  }

  /// Initialize with the audio handler (must be called after AudioService.init).
  void initialize(PulseAudioHandler handler) {
    _handler = handler;
    _isInitialized = true;
    _handler.isSleepTimerExpired = () => ref.read(sleepTimerProvider).isExpired;
    
    _crossfadeEngine = CrossfadeEngine(
      primaryPlayer: _handler.primaryPlayer,
      crossfadePlayer: _handler.crossfadePlayer,
    );

    // Apply initial EQ state
    final settings = ref.read(settingsProvider);
    _handler.setEqualizerState(enabled: settings.equalizerEnabled, gains: settings.equalizerGains);

    // Wire up handler callbacks for lock screen controls
    _handler.onTrackEnded = _onTrackEnded;
    _handler.onSkipToNext = playNext;
    _handler.onSkipToPrevious = playPrev;
    _handler.onLikePressed = () {
      final song = state.currentSong;
      if (song != null) {
        final wasLiked = ref.read(playlistProvider.notifier).isLiked(song.videoId);
        ref.read(playlistProvider.notifier).toggleLike(song);
        _handler.updateLikedState(!wasLiked);
      }
    };

    // Wire up crossfade callbacks
    _crossfadeEngine.onSwapComplete = _onCrossfadeSwapComplete;
    _crossfadeEngine.onMidpointReached = _onCrossfadeMidpoint;

    // Listen to the primary player's streams
    _attachPlayerListeners(_handler.primaryPlayer);
  }
  void _attachPlayerListeners(Player player) {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playingSub?.cancel();
    _bufferingSub?.cancel();

    // Sync immediate states from the player (in case streams already emitted)
    state = state.copyWith(
      progress: player.state.position,
      duration: player.state.duration,
      isPlaying: player.state.playing,
      isLoading: player.state.buffering,
    );
    if (player.state.duration != Duration.zero) {
      _updateMediaItemDuration(player.state.duration);
    }

      // Position updates
      _positionSub = player.stream.position.listen((position) {
        state = state.copyWith(progress: position);

        final dur = player.state.duration;
        final posSeconds = position.inSeconds;

        // Eagerly preload the next song after 1 second of playback to ensure instant skips
        if (!_hasEagerPreloaded && posSeconds >= 1) {
          _hasEagerPreloaded = true;
          _preloadNextSong();
        }

        // ── Crossfade trigger (mirrors timeupdate handler, lines 194-213) ──
        final settings = ref.read(settingsProvider);
        final fadeSeconds = settings.crossfadeDuration;

        if (fadeSeconds > 0 && dur.inSeconds > 0) {
          final timeLeftMs = dur.inMilliseconds - position.inMilliseconds;
          final timeLeftSeconds = timeLeftMs / 1000.0;

          // 1. Preload next song's URL 15 seconds before the crossfade starts (fallback if eager preload missed)
          if (!_hasEagerPreloaded && timeLeftSeconds <= (fadeSeconds + 15) && timeLeftSeconds > fadeSeconds) {
            _hasEagerPreloaded = true;
            _preloadNextSong();
          }

          // 2. Trigger crossfade
          if (!_crossfadeEngine.isCrossfading &&
              !_isCrossfadePending &&
              timeLeftSeconds <= fadeSeconds &&
              timeLeftSeconds > 0) {
            _triggerCrossfade(fadeSeconds);
          }
        }

      // ── Stats tracking (mirrors lines 216-223) ──
      if (!_statsThresholdReached && dur.inSeconds > 0) {
        if (posSeconds > 30 || posSeconds > dur.inSeconds / 2) {
          _reportStats();
          _statsThresholdReached = true;
        }
      }
    });

    // Duration updates
    _durationSub = player.stream.duration.listen((duration) {
      state = state.copyWith(duration: duration);
      _updateMediaItemDuration(duration);
    });

    // Player state updates
    _playingSub = player.stream.playing.listen((playing) {
      state = state.copyWith(
        isPlaying: playing,
      );

      // Wake lock management
      WakelockManager().setPlaying(playing);
    });

    _bufferingSub = player.stream.buffering.listen((buffering) {
      // Ignore spurious buffering:false emitted by player.stop() during URL extraction.
      if (!buffering && state.isLoading && !player.state.playing && player.state.position.inSeconds == 0) {
        return;
      }
      state = state.copyWith(
        isLoading: buffering,
      );
    });
  }

  /// Called when a track finishes playing (not via crossfade).
  /// Mirrors the `onEnded` handler in AudioContext.jsx (lines 240-253).
  void _onTrackEnded() {
    // If crossfade already handled or is pending transition, skip.
    if (_crossfadeEngine.isCrossfading || _isCrossfadePending) return;

    if (state.repeatMode == RepeatMode.one) {
      // If native LoopMode.one fails (common with offline files on some Android devices), 
      // this fallback will manually restart the song.
      _crossfadeEngine.primaryPlayer.seek(Duration.zero);
      if (!ref.read(sleepTimerProvider).isExpired) {
        _crossfadeEngine.primaryPlayer.play();
      }
    } else {
      playNext();
    }
  }

  // ── Core play function ─────────────────────────────────────────────────────
  // Port of `playSong()` from AudioContext.jsx (lines 636-770).

  Future<void> playSong(Song song, {String? offlineFilePath, bool clearQueue = false, String? contextPlaylistId, bool isPrev = false, bool isManual = false}) async {
    if (isManual && ref.read(sleepTimerProvider).isExpired) {
      ref.read(sleepTimerProvider.notifier).cancelTimer();
    }

    // Normalize (mirrors lines 638-643)
    final normalizedSong = song.copyWith(
      id: song.videoId.isNotEmpty ? song.videoId : song.id,
      videoId: song.videoId.isNotEmpty ? song.videoId : song.id,
    );

    // Guard: only valid 11-char YouTube video IDs unless offline
    if (normalizedSong.videoId.isEmpty ||
        (normalizedSong.videoId.length != 11 &&
            offlineFilePath == null)) {
      return;
    }

    // Same song → toggle play/pause (mirrors lines 654-658)
    if (state.currentSong != null &&
        state.currentSong!.videoId == normalizedSong.videoId &&
        offlineFilePath == null) {
      if (contextPlaylistId != null && contextPlaylistId != state.contextPlaylistId) {
        state = state.copyWith(contextPlaylistId: contextPlaylistId);
      }
      togglePlay();
      return;
    }

    // Push current to history (mirrors lines 660-663)
    if (state.currentSong != null && !isPrev) {
      final newHistory = [state.currentSong!, ...state.history];
      state = state.copyWith(
        history: newHistory.length > 50
            ? newHistory.sublist(0, 50)
            : newHistory,
      );
    }

    // ── Fast path: next song already buffered in the crossfade player ──
    // Skip cancelCrossfade (which would destroy the buffer) and setUrl entirely.
    // Only possible for online songs — offline/downloads always use the normal path.
    final canInstantSwap = offlineFilePath == null &&
        _preloadedNextSongId == normalizedSong.videoId &&
        _crossfadeEngine.isPrepared;

    // Cancel any active crossfade, but ONLY if we can't fast-swap
    // (cancelling destroys the pre-buffered audio).
    if (!canInstantSwap) {
      _crossfadeEngine.cancelCrossfade();
    }
    _isCrossfadePending = false;

    // Reset state for new song
    _statsThresholdReached = false;
    _hasEagerPreloaded = false;
    final myGen = ++_loadGeneration;
    bool isStale() => _loadGeneration != myGen;

    // Force audio_service to buffering state so it holds the background wake lock.
    // Skip this on the fast path — no network round-trip is happening.
    if (!canInstantSwap) {
      _handler.setBufferingState();
    }

    final shouldClearContext = normalizedSong.playlistId == '__suggested__' ||
        (clearQueue && contextPlaylistId == null);

    state = state.copyWith(
      isLoading: !canInstantSwap, // no loading spinner on instant swap
      currentSong: normalizedSong,
      contextPlaylistId: contextPlaylistId,
      clearContextPlaylistId: shouldClearContext,
      isPlaying: true,
      progress: Duration.zero,
      duration: Duration.zero,
      queue: clearQueue ? [] : state.queue,
      baseQueue: clearQueue ? [] : state.baseQueue,
    );

    // ── Proactive queue fetch (non-blocking) ──
    // Refetch when queue has <= 9 songs remaining so it fetches suggestions.
    // Done early so it fetches in parallel with the slow stream extraction below.
    if (state.queue.length <= 9) {
      _fetchWatchNext(normalizedSong.videoId);
    }

    // Update media notification (mirrors lines 360-365)
    _updateMediaItem(normalizedSong);

    // Sync liked state on the notification heart icon
    final isLiked = ref.read(playlistProvider.notifier).isLiked(normalizedSong.videoId);
    _handler.updateLikedState(isLiked);

    // ── INSTANT SWAP: use pre-buffered player, skip network entirely ──
    if (canInstantSwap) {
      _preloadedNextSongId = null;
      final newPrimary = await _crossfadeEngine.instantSwap();
      if (isStale()) return;
      if (newPrimary != null) {
        // Wire listeners and OS handler to the new primary
        _attachPlayerListeners(newPrimary);
        _handler.setPrimaryPlayer(newPrimary);
        // Player is already loaded — just play
        newPrimary.setVolume(100.0);
        if (!ref.read(sleepTimerProvider).isExpired) {
          await _handler.requestAudioFocus();
          if (isStale()) return;
          await newPrimary.play();
        }
        if (isStale()) return;
        // Sync real duration now that player is active
        state = state.copyWith(
          isLoading: false,
          duration: newPrimary.state.duration,
          progress: newPrimary.state.position,
        );
        _consecutiveFailures = 0;
        return;
      }
      // instantSwap returned null — fall through to normal path
      _handler.setBufferingState();
      state = state.copyWith(isLoading: true);
    }

    try {
      final player = _crossfadeEngine.primaryPlayer;

      // Stop current playback
      await player.stop();

      // Apply the current EQ state NOW — this is the most reliable moment:
      // the old audio pipeline is torn down, the new one hasn't started yet.
      // Await ensures af is set in MPV's state before player.open() builds the new pipeline.
      await _handler.applyCurrentFilter(player);

      // ── OFFLINE PATH (mirrors lines 708-713) ──
      if (offlineFilePath != null) {
        await player.setVolume(100.0);
        final shouldPlay = !ref.read(sleepTimerProvider).isExpired;
        if (shouldPlay) {
          await _handler.requestAudioFocus();
          if (isStale()) return;
        }
        await player.open(Media(offlineFilePath), play: shouldPlay);
        if (isStale()) return;
        return;
      }

      // ── Check downloads DB (mirrors lines 717-731) ──
      final downloads = ref.read(downloadProvider.notifier);
      if (normalizedSong.videoId.length == 11) {
        final downloaded = await downloads.isDownloaded(normalizedSong.videoId);
        if (isStale()) return;
        if (downloaded) {
          final localPath =
              await downloads.getFilePath(normalizedSong.videoId);
          if (isStale()) return;
          if (localPath != null) {
            await player.setVolume(100.0);
            final shouldPlay = !ref.read(sleepTimerProvider).isExpired;
            if (shouldPlay) {
              await _handler.requestAudioFocus();
              if (isStale()) return;
            }
            await player.open(Media(localPath), play: shouldPlay);
            if (isStale()) return;
            return;
          }
        }
      }
      if (isStale()) return;

      // ── Debounce rapid skipping ──
      await Future.delayed(const Duration(milliseconds: 200));
      if (isStale()) return;

      // ── Stream via youtube_explode_dart v2.5.3 (client-side, on-device) ──
      // Extraction runs on the user's phone with their own IP.
      // URL is IP-locked to the phone → phone plays it → always works.
      // If extraction fails, throw immediately with a clear message.
      final settings = ref.read(settingsProvider);
      final streamQuality = settings.dataSaverMode ? 'low' : settings.streamingQuality;
      
      int retryCount = 0;
      const maxRetries = 1;
      bool success = false;
      
      while (retryCount <= maxRetries && !success) {
        try {
          final streamUrl = await StreamExtractor.getAudioStreamUrl(
            normalizedSong.videoId, quality: streamQuality,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Stream extraction timed out. Check internet connection.'),
          );
          
          if (isStale()) return;

          await player.setVolume(100.0);
          final shouldPlay = !ref.read(sleepTimerProvider).isExpired;
          if (shouldPlay) {
            await _handler.requestAudioFocus();
            if (isStale()) return;
          }
          await player.open(
            Media(
              streamUrl,
              httpHeaders: const {},
            ),
            play: shouldPlay,
          );
          
          if (isStale()) return;
          success = true; // Loop will exit
        } catch (e) {
          final isNetworkError = e is TimeoutException || e.toString().contains('SocketException') || e.toString().contains('HandshakeException');
          
          if (isNetworkError && retryCount < maxRetries) {
            retryCount++;
            const delaySeconds = 3; // flat 3s delay before retry
            debugPrint('[AudioProvider] Network error fetching stream. Retrying $retryCount/$maxRetries in ${delaySeconds}s...');
            await Future.delayed(Duration(seconds: delaySeconds));
            if (isStale()) return;
          } else {
            rethrow; // If not a network error or out of retries, throw it to the outer catch
          }
        }
      }
      
      _consecutiveFailures = 0; // Reset on success

      // (Queue fetching was moved to the top of the method for parallel execution)
    } catch (e) {
      debugPrint('[AudioProvider] playSong error: $e');
      StreamExtractor.invalidateCache(normalizedSong.videoId);
      if (!isStale()) {
        state = state.copyWith(isLoading: false);

        _consecutiveFailures++;
        if (_consecutiveFailures <= 2) {
          debugPrint('[AudioProvider] Auto-skipping to next song due to failure...');
          playNext();
        } else {
          // Hard stop after 2 consecutive failures — show toast and release resources.
          _handler.stopCurrent(); // Clears buffering state and drops wake lock
          final ctx = scaffoldMessengerKey.currentContext;
          if (ctx != null && ctx.mounted) {
            ToastUtils.show(ctx, AppLocalizations.of(ctx)!.audioPlaybackFailed);
          }
        }
      }
    }
  }

  // ── Queue controls ─────────────────────────────────────────────────────────
  // Port of playNext/playPrev from AudioContext.jsx (lines 774-863).

  void playNext() {
    _statsThresholdReached = false;

    if (state.queue.isNotEmpty) {
      final nextSong = state.queue.first;
      final rest = state.queue.sublist(1);
      state = state.copyWith(queue: rest);
      playSong(nextSong);
      return;
    }

    // If repeat ALL and queue empty, restart from baseQueue (mirrors lines 785-801)
    if (state.repeatMode == RepeatMode.all && state.baseQueue.isNotEmpty) {
      // Only loop over playlist songs, not suggestions
      final playlistBase = state.baseQueue.where((s) => s.playlistId != '__suggested__').toList();
      if (playlistBase.isEmpty) return;

      var rebuilt = state.isShuffled
          ? ([...playlistBase]..shuffle())
          : [...playlistBase];
      final first = rebuilt.first;
      final rest = rebuilt.sublist(1);
      state = state.copyWith(queue: rest);
      playSong(first);
      return;
    }

    // Queue empty — fetch watch-next (mirrors lines 803-834)
    final currentId = state.currentSong?.videoId;
    if (currentId != null && currentId.isNotEmpty) {
      _fetchWatchNextAndPlayFirst(currentId);
    } else {
      state = state.copyWith(isPlaying: false, progress: Duration.zero);
      _crossfadeEngine.primaryPlayer.stop();
    }
  }

  void playPrev() {
    // If >3s into song, restart it (mirrors lines 839-843)
    final posSeconds = state.progress.inSeconds;
    if (posSeconds > 3) {
      _crossfadeEngine.primaryPlayer.seek(Duration.zero);
      state = state.copyWith(progress: Duration.zero);
      return;
    }

    // Go to previous from history (mirrors lines 844-858)
    if (state.history.isNotEmpty) {
      final prevSong = state.history.first;
      final restHistory = state.history.sublist(1);

      // Push current song back to front of queue
      if (state.currentSong != null) {
        state = state.copyWith(
          queue: [state.currentSong!, ...state.queue],
          history: restHistory,
        );
      } else {
        state = state.copyWith(history: restHistory);
      }

      playSong(prevSong, isPrev: true);
    } else {
      // No history: just restart
      _crossfadeEngine.primaryPlayer.seek(Duration.zero);
      state = state.copyWith(progress: Duration.zero);
    }
  }

  /// Add a song to the front of the queue (Play Next).
  /// Mirrors addToQueue in AudioContext.jsx (lines 866-876).
  void addToQueue(Song song) {
    final normalized = song.copyWith(
      id: song.videoId.isNotEmpty ? song.videoId : song.id,
      videoId: song.videoId.isNotEmpty ? song.videoId : song.id,
    );
    state = state.copyWith(
      queue: [normalized, ...state.queue],
      baseQueue: [normalized, ...state.baseQueue],
    );
  }

  /// Play a song from a specific index in the queue.
  /// Removes only that song from the queue and plays it.
  void playFromQueue(int index) {
    if (index < 0 || index >= state.queue.length) return;

    final selectedSong = state.queue[index];
    final updatedQueue = List<Song>.from(state.queue);
    updatedQueue.removeAt(index);

    state = state.copyWith(
      queue: updatedQueue,
    );

    playSong(selectedSong, isManual: true);
  }

  /// Replace the entire queue.
  /// Mirrors replaceQueue in AudioContext.jsx (lines 878-885).
  void replaceQueue(List<Song> newQueue) {
    state = state.copyWith(baseQueue: newQueue);
    if (state.isShuffled) {
      final shuffled = [...newQueue]..shuffle();
      state = state.copyWith(queue: shuffled);
    } else {
      state = state.copyWith(queue: newQueue);
    }
  }

  /// Reorder the queue by dragging
  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1; // Adjust for the removed item shifting indices down
    }
    if (oldIndex < 0 || oldIndex >= state.queue.length) return;
    if (newIndex < 0 || newIndex > state.queue.length) return;

    final prevFirst = state.queue.isNotEmpty ? state.queue.first.videoId : null;

    final updatedQueue = List<Song>.from(state.queue);
    final item = updatedQueue.removeAt(oldIndex);
    updatedQueue.insert(newIndex, item);

    state = state.copyWith(queue: updatedQueue);

    // If the first item changed, the preloaded audio is now for the wrong song
    final newFirst = updatedQueue.isNotEmpty ? updatedQueue.first.videoId : null;
    if (prevFirst != newFirst && _preloadedNextSongId != null) {
      _crossfadeEngine.cancelCrossfade();
      _preloadedNextSongId = null;
      _hasEagerPreloaded = false;
    }
  }

  /// Remove a song from the queue
  void removeFromQueue(int index) {
    if (index < 0 || index >= state.queue.length) return;

    // If removing the first item, the preloaded audio is now for the wrong song
    if (index == 0 && _preloadedNextSongId != null) {
      _crossfadeEngine.cancelCrossfade();
      _preloadedNextSongId = null;
      _hasEagerPreloaded = false;
    }

    final updatedQueue = List<Song>.from(state.queue);
    updatedQueue.removeAt(index);
    state = state.copyWith(queue: updatedQueue);
  }

  // ── Shuffle / Repeat toggles ───────────────────────────────────────────────
  // Port of toggleShuffle (line 887) and toggleRepeat (line 903).

  void toggleShuffle() {
    final newShuffled = !state.isShuffled;
    List<Song> newQueue;

    if (newShuffled) {
      // Separate playlist songs from YouTube suggestions
      final playlistSongs = state.queue.where((s) => s.playlistId != '__suggested__').toList();
      final suggestions = state.queue.where((s) => s.playlistId == '__suggested__').toList();

      // Shuffle only the playlist songs, keep suggestions at the end (untouched)
      playlistSongs.shuffle();
      newQueue = [...playlistSongs, ...suggestions];
    } else {
      // Restore un-shuffled order but filter out consumed songs
      newQueue = state.baseQueue
          .where((s) => state.queue.any((q) => q.videoId == s.videoId))
          .toList();
    }

    state = state.copyWith(isShuffled: newShuffled, queue: newQueue);

    // Report to OS
    _handler.setShuffleMode(
      newShuffled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
    );
  }

  void toggleRepeat() {
    final next = switch (state.repeatMode) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };

    var newQueue = state.queue;
    var newBaseQueue = state.baseQueue;

    // When turning on repeat queue, ensure the currently playing song is in the queue
    // so it doesn't get lost when the queue loops around.
    if (next == RepeatMode.all && state.currentSong != null) {
      if (!newBaseQueue.any((s) => s.videoId == state.currentSong!.videoId)) {
        newBaseQueue = [...newBaseQueue, state.currentSong!];
        newQueue = [...newQueue, state.currentSong!];
      }
    }

    state = state.copyWith(repeatMode: next, queue: newQueue, baseQueue: newBaseQueue);

    // Report to OS
    _handler.setRepeatMode(switch (next) {
      RepeatMode.off => AudioServiceRepeatMode.none,
      RepeatMode.all => AudioServiceRepeatMode.all,
      RepeatMode.one => AudioServiceRepeatMode.one,
    });
    
    // Natively loop the current track if RepeatMode.one
    _crossfadeEngine.primaryPlayer.setPlaylistMode(
        next == RepeatMode.one ? PlaylistMode.single : PlaylistMode.none);
    _crossfadeEngine.crossfadePlayer.setPlaylistMode(
        next == RepeatMode.one ? PlaylistMode.single : PlaylistMode.none);
  }

  // ── Playback controls ──────────────────────────────────────────────────────
  // Port of togglePlay (line 912) and seek (line 924).

  void togglePlay() {
    if (state.currentSong == null) return;
    
    if (ref.read(sleepTimerProvider).isExpired) {
      ref.read(sleepTimerProvider.notifier).cancelTimer();
    }
    
    final player = _crossfadeEngine.primaryPlayer;
    if (player.state.playing) {
      player.pause();
    } else {
      _handler.requestAudioFocus().then((_) {
        // Double check that the player hasn't swapped/been destroyed while waiting
        if (state.currentSong != null && _crossfadeEngine.primaryPlayer == player) {
          player.play();
        }
      });
    }
  }

  void pause() {
    if (state.currentSong == null) return;
    _crossfadeEngine.cancelCrossfade();
    _crossfadeEngine.primaryPlayer.pause();
  }

  void seek(Duration position) {
    _crossfadeEngine.primaryPlayer.seek(position);
    state = state.copyWith(progress: position);
  }

  // ── Crossfade trigger ──────────────────────────────────────────────────────

  Future<void> _preloadNextSong() async {

    Song? nextSong;
    if (state.repeatMode == RepeatMode.one) {
      nextSong = state.currentSong;
    } else if (state.queue.isNotEmpty) {
      nextSong = state.queue.first;
    } else if (state.repeatMode == RepeatMode.all && state.baseQueue.isNotEmpty) {
      nextSong = (state.isShuffled ? ([...state.baseQueue]..shuffle()) : state.baseQueue).first;
    }

    if (nextSong == null || nextSong.videoId.isEmpty) return;
    if (_preloadedNextSongId == nextSong.videoId) return;

    final targetId = nextSong.videoId;
    if (_isPreloadingNext && _preloadedNextSongId == targetId) return;

    _isPreloadingNext = true;
    _preloadedNextSongId = targetId;
    
    try {
      final downloads = ref.read(downloadProvider.notifier);
      final settings = ref.read(settingsProvider);
      final streamQuality = settings.dataSaverMode ? 'low' : settings.streamingQuality;
      String? localPath;
      String? streamUrl;
      
      if (await downloads.isDownloaded(nextSong.videoId)) {
        localPath = await downloads.getFilePath(nextSong.videoId);
      } else {
        streamUrl = await StreamExtractor.getAudioStreamUrl(
                nextSong.videoId, quality: streamQuality)
            .timeout(const Duration(seconds: 15));
      }

      final success = await _crossfadeEngine.prepareCrossfade(
        nextUrl: streamUrl,
        localFilePath: localPath,
      );

      if (!success && _preloadedNextSongId == targetId) {
        _preloadedNextSongId = null;
      }
    } catch (_) {
      if (_preloadedNextSongId == targetId) {
        _preloadedNextSongId = null;
      }
    } finally {
      if (_preloadedNextSongId == targetId) {
        _isPreloadingNext = false;
      }
    }
  }

  Future<void> _triggerCrossfade(int fadeSeconds) async {
    final myGen = _loadGeneration;

    // Determine the next song to crossfade into
    Song? nextSong;
    List<Song> remainingQueue = state.queue;

    if (state.repeatMode == RepeatMode.one) {
      nextSong = state.currentSong;
      remainingQueue = state.queue;
    } else if (state.queue.isNotEmpty) {
      nextSong = state.queue.first;
      remainingQueue = state.queue.sublist(1);
    } else if (state.repeatMode == RepeatMode.all &&
        state.baseQueue.isNotEmpty) {
      // Rebuild queue for repeat-all (mirrors lines 535-543)
      var rebuilt = state.isShuffled
          ? ([...state.baseQueue]..shuffle())
          : [...state.baseQueue];
      nextSong = rebuilt.first;
      remainingQueue = rebuilt.sublist(1);
    }

    if (nextSong == null || nextSong.videoId.isEmpty) return;

    // Set pending flag immediately so _onTrackEnded backs off during async work
    _isCrossfadePending = true;

    String? localPath;
    String? streamUrl;

    if (_preloadedNextSongId != nextSong.videoId) {
      // Fallback: extract inline if preload didn't finish or song changed
      final downloads = ref.read(downloadProvider.notifier);
      final settings = ref.read(settingsProvider);
      final streamQuality = settings.dataSaverMode ? 'low' : settings.streamingQuality;
      try {
        if (await downloads.isDownloaded(nextSong.videoId)) {
          localPath = await downloads.getFilePath(nextSong.videoId);
        } else {
          streamUrl = await StreamExtractor.getAudioStreamUrl(
                  nextSong.videoId, quality: streamQuality)
              .timeout(const Duration(seconds: 15));
        }
      } catch (e) {
        debugPrint('[AudioProvider] Crossfade fallback extraction failed: $e');
        StreamExtractor.invalidateCache(nextSong.videoId);
        if (_loadGeneration == myGen) {
          _isCrossfadePending = false;
          playNext();
        }
        return;
      }
    }

    _preloadedNextSongId = null;

    if (_loadGeneration != myGen) {
      _isCrossfadePending = false;
      return;
    }

    try {
      final success = await _crossfadeEngine.startCrossfade(
        fadeDuration: fadeSeconds,
        nextUrl: streamUrl,
        localFilePath: localPath,
      );

      if (_loadGeneration != myGen) return;

      if (success) {
        _pendingCrossfadeSong = nextSong;
        _pendingCrossfadeQueue = remainingQueue;
        // Metadata update is deferred to onMidpointReached (50% of fade)
      } else {
        if (_loadGeneration == myGen) playNext();
      }
    } catch (e) {
      debugPrint('[AudioProvider] startCrossfade threw: $e');
      if (_loadGeneration == myGen) playNext();
    } finally {
      if (_loadGeneration == myGen) {
        _isCrossfadePending = false;
      }
    }
  }

  Song? _pendingCrossfadeSong;
  List<Song>? _pendingCrossfadeQueue;
  
  /// Set to true as soon as _triggerCrossfade begins extracting/loading,
  /// to prevent _onTrackEnded from firing playNext() during the async gap.
  bool _isCrossfadePending = false;

  /// Called at the 50% midpoint of the crossfade volume ramp.
  /// Both songs are equally audible here — the ideal moment to switch everything to Song B.
  void _onCrossfadeMidpoint() {
    final nextSong = _pendingCrossfadeSong;
    final remainingQueue = _pendingCrossfadeQueue;
    if (nextSong == null) return;

    // Song B player reference (still crossfadePlayer until swap completes at t=end)
    final songBPlayer = _crossfadeEngine.crossfadePlayer;

    // Reset so Song B triggers its own eager preload for Song C at t=5s.
    _hasEagerPreloaded = false;

    // 1. Re-attach position/duration/state listeners to Song B
    //    so the progress bar and isLoading/isPlaying UI reflect Song B.
    _attachPlayerListeners(songBPlayer);

    // 2. Tell the OS handler to report Song B's position on the lock screen.
    _handler.setPrimaryPlayer(songBPlayer);

    // 3. Sync duration & progress from Song B right now.
    _statsThresholdReached = false;
    state = state.copyWith(
      currentSong: nextSong,
      clearContextPlaylistId: nextSong.playlistId == '__suggested__',
      isPlaying: true,
      queue: remainingQueue ?? state.queue,
      duration: songBPlayer.state.duration,
      progress: songBPlayer.state.position,
    );

    // 4. Update notification artwork/title and liked state.
    _updateMediaItem(nextSong);
    final isLiked = ref.read(playlistProvider.notifier).isLiked(nextSong.videoId);
    _handler.updateLikedState(isLiked);
  }

  /// Called by CrossfadeEngine when the crossfade volume ramp completes and
  /// players are swapped. All metadata and listeners were already moved to
  /// Song B at the midpoint, so this just does final cleanup.
  void _onCrossfadeSwapComplete(Player newPrimary) {
    // Re-attach to the now-official primary player (same object as crossfadePlayer
    // at midpoint, but engine has swapped references — safe to re-attach).
    _attachPlayerListeners(newPrimary);
    _handler.setPrimaryPlayer(newPrimary);

    _pendingCrossfadeSong = null;
    _pendingCrossfadeQueue = null;
  }

  // ── Watch-next queue fetching ──────────────────────────────────────────────

  /// Fetch watch-next suggestions and add to queue (non-blocking).
  /// Mirrors lines 752-765 of AudioContext.jsx.
  Future<void> _fetchWatchNext(String videoId) async {
    final currentGen = _loadGeneration;
    try {
      final tracks = await _musicApi.getWatchNext(videoId);
      if (_loadGeneration != currentGen) return; // Discard if generation changed
      
      if (tracks.isNotEmpty) {
        // Filter out current song if it happens to be the first search result seed
        final filtered = state.currentSong != null 
            ? tracks.where((t) => t.videoId != state.currentSong!.videoId).toList() 
            : tracks;
        
        final currentQueueIds = state.queue.map((s) => s.videoId).toSet();
        final newTracks = filtered
            .where((t) => !currentQueueIds.contains(t.videoId))
            .map((t) => t.copyWith(playlistId: '__suggested__'))
            .toList();

        if (newTracks.isNotEmpty) {
          state = state.copyWith(
            queue: [...state.queue, ...newTracks],
            baseQueue: [...state.baseQueue, ...newTracks],
          );
        }
      }
    } catch (_) {
      // Watch-next fetch failed silently
    }
  }

  /// Fetch watch-next and immediately play the first result.
  /// Mirrors lines 803-834 of AudioContext.jsx.
  Future<void> _fetchWatchNextAndPlayFirst(String videoId) async {
    try {
      final tracks = await _musicApi.getWatchNext(videoId);
      if (tracks.isNotEmpty) {
        final suggestedTracks = tracks.map((t) => t.copyWith(playlistId: '__suggested__')).toList();
        final first = suggestedTracks.first;
        final rest = suggestedTracks.sublist(1);
        state = state.copyWith(queue: rest);
        playSong(first);
      } else {
        state = state.copyWith(isPlaying: false, progress: Duration.zero);
        _crossfadeEngine.primaryPlayer.stop();
      }
    } catch (_) {
      state = state.copyWith(isPlaying: false, progress: Duration.zero);
      _crossfadeEngine.primaryPlayer.stop();
    }
  }

  // ── Media notification helpers ─────────────────────────────────────────────

  void _updateMediaItem(Song song) {
    Uri? artUri;
    if (song.thumbnail.isNotEmpty) {
      if (!song.thumbnail.startsWith('http')) {
        artUri = Uri.file(song.thumbnail);
      } else {
        final artUrl = ThumbnailUtils.getHighRes(song.thumbnail, size: 800);
        artUri = Uri.parse(artUrl);
      }
    }

    _handler.updateMediaItem(MediaItem(
      id: song.videoId,
      title: song.title,
      artist: song.artist,
      album: song.album,
      duration: song.duration > 0
          ? Duration(seconds: song.duration)
          : null,
      artUri: artUri,
    ));
  }

  void _updateMediaItemDuration(Duration duration) {
    final current = state.currentSong;
    if (current == null) return;
    
    // Ignore rapid Duration.zero updates during track transitions
    // if we already know the song has a valid length.
    if (duration == Duration.zero && current.duration > 0) return;
    
    Uri? artUri;
    if (current.thumbnail.isNotEmpty) {
      if (!current.thumbnail.startsWith('http')) {
        artUri = Uri.file(current.thumbnail);
      } else {
        final artUrl = ThumbnailUtils.getHighRes(current.thumbnail, size: 800);
        artUri = Uri.parse(artUrl);
      }
    }

    _handler.updateMediaItem(MediaItem(
      id: current.videoId,
      title: current.title,
      artist: current.artist,
      album: current.album,
      duration: duration,
      artUri: artUri,
    ));
  }

  // ── Stats ──────────────────────────────────────────────────────────────────

  void _reportStats() {
    final song = state.currentSong;
    if (song == null) return;
    final auth = ref.read(authProvider.notifier);
    
    // Convert local cover paths back to network paths for Firestore to avoid cross-device breakage
    final coverUrl = (!song.thumbnail.startsWith('http') && song.thumbnail.isNotEmpty)
        ? 'https://i.ytimg.com/vi/${song.videoId}/hqdefault.jpg'
        : song.thumbnail;

    auth.updatePlaybackStats(
      videoId: song.videoId,
      secondsListened: state.progress.inSeconds,
      title: song.title,
      artist: song.artist,
      cover: coverUrl,
    );
  }

  // ── Cleanup ────────────────────────────────────────────────────────────────

  void _dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playingSub?.cancel();
    _bufferingSub?.cancel();
    _crossfadeEngine.dispose();
    _handler.dispose();
    WakelockManager().setPlaying(false);
  }
}

// ── Provider Registration ───────────────────────────────────────────────────

final audioProvider = NotifierProvider<AudioNotifier, AudioState>(
  AudioNotifier.new,
);

/// Provider for the PulseAudioHandler singleton (initialized in main.dart).
final audioHandlerProvider = Provider<PulseAudioHandler>((ref) {
  throw UnimplementedError(
    'audioHandlerProvider must be overridden with the initialized PulseAudioHandler',
  );
});
