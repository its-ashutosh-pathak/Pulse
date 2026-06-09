import 'dart:async';
import 'package:flutter/material.dart' show SnackBar, Text, Colors, debugPrint;
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
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
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<PlaybackEvent>? _eventSub;

  /// Incremented on each new song load to cancel stale async operations.
  /// Mirrors `loadGenRef` in AudioContext.jsx (line 43).
  int _loadGeneration = 0;

  /// Whether the stats threshold has been reached for the current song.
  /// Mirrors `statsThresholdReached` ref in AudioContext.jsx (line 39).
  bool _statsThresholdReached = false;

  String? _preloadedNextSongId;
  bool _isPreloadingNext = false;

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

    // Initialization is deferred — must call initialize() after handler is ready.
    return const AudioState();
  }

  /// Initialize with the audio handler (must be called after AudioService.init).
  void initialize(PulseAudioHandler handler) {
    _handler = handler;
    _isInitialized = true;
    
    _crossfadeEngine = CrossfadeEngine(
      primaryPlayer: _handler.primaryPlayer,
      crossfadePlayer: _handler.crossfadePlayer,
    );

    // Wire up handler callbacks for lock screen controls
    _handler.onTrackEnded = _onTrackEnded;
    _handler.onSkipToNext = playNext;
    _handler.onSkipToPrevious = playPrev;
    _handler.onLikePressed = () {
      final song = state.currentSong;
      if (song != null) {
        ref.read(playlistProvider.notifier).toggleLike(song);
        // Toggle the notification heart icon immediately
        final wasLiked = ref.read(playlistProvider.notifier).isLiked(song.videoId);
        _handler.updateLikedState(!wasLiked);
      }
    };

    // Wire up crossfade swap callback
    _crossfadeEngine.onSwapComplete = _onCrossfadeSwapComplete;

    // Listen to the primary player's streams
    _attachPlayerListeners(_handler.primaryPlayer);
  }

  void _attachPlayerListeners(AudioPlayer player) {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _eventSub?.cancel();

    // Position updates (replaces onTimeUpdate in AudioContext.jsx line 187)
    _positionSub = player.positionStream.listen((position) {
      state = state.copyWith(progress: position);

      // ── Crossfade trigger (mirrors timeupdate handler, lines 194-213) ──
      final settings = ref.read(settingsProvider);
      final fadeSeconds = settings.crossfadeDuration;
      final dur = player.duration;

      if (fadeSeconds > 0 && dur != null && dur.inSeconds > 0 && state.repeatMode != RepeatMode.one) {
        final timeLeftMs = dur.inMilliseconds - position.inMilliseconds;
        final timeLeftSeconds = timeLeftMs / 1000.0;

        // 1. Preload next song's URL 15 seconds before the crossfade starts
        if (timeLeftSeconds <= (fadeSeconds + 15) && timeLeftSeconds > fadeSeconds) {
          _preloadNextSong();
        }

        // 2. Trigger crossfade
        if (!_crossfadeEngine.isCrossfading &&
            timeLeftSeconds <= fadeSeconds &&
            timeLeftSeconds > 0) {
          _triggerCrossfade(fadeSeconds);
        }
      }

      // ── Stats tracking (mirrors lines 216-223) ──
      if (!_statsThresholdReached && dur != null && dur.inSeconds > 0) {
        final posSeconds = position.inSeconds;
        if (posSeconds > 30 || posSeconds > dur.inSeconds / 2) {
          _reportStats();
          _statsThresholdReached = true;
        }
      }
    });

    // Duration updates (replaces onLoadedMetadata, line 239)
    _durationSub = player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
        _updateMediaItemDuration(duration);
      }
    });

    // Player state updates (replaces onPlay/onPause/onPlaying, lines 262-270)
    _playerStateSub = player.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      state = state.copyWith(
        isPlaying: playing,
        isLoading: playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering,
      );

      // Wake lock management (replaces lines 300-337)
      if (playing) {
        WakelockPlus.enable();
      } else {
        WakelockPlus.disable();
      }
    });

    // Event stream listener was here, but removed because PulseAudioHandler
    // already listens to playbackEventStream and invokes onTrackEnded,
    // which is mapped to _onTrackEnded() in initialize().
  }

  /// Called when a track finishes playing (not via crossfade).
  /// Mirrors the `onEnded` handler in AudioContext.jsx (lines 240-253).
  void _onTrackEnded() {
    // If crossfade already handled or is pending transition, skip.
    if (_crossfadeEngine.isCrossfading || _isCrossfadePending) return;

    if (state.repeatMode == RepeatMode.one) {
      // Handled natively by LoopMode.one on the player itself.
    } else {
      playNext();
    }
  }

  // ── Core play function ─────────────────────────────────────────────────────
  // Port of `playSong()` from AudioContext.jsx (lines 636-770).

  Future<void> playSong(Song song, {String? offlineFilePath, bool clearQueue = false, String? contextPlaylistId}) async {
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
    if (state.currentSong != null) {
      final newHistory = [state.currentSong!, ...state.history];
      state = state.copyWith(
        history: newHistory.length > 50
            ? newHistory.sublist(0, 50)
            : newHistory,
      );
    }

    // Cancel any active crossfade (mirrors lines 667-674)
    _crossfadeEngine.cancelCrossfade();

    // Reset state for new song
    _statsThresholdReached = false;
    final myGen = ++_loadGeneration;
    bool isStale() => _loadGeneration != myGen;

    // Force audio_service to buffering state so it holds the background wake lock
    _handler.setBufferingState();

    final shouldClearContext = normalizedSong.playlistId == '__suggested__' ||
        (clearQueue && contextPlaylistId == null);

    state = state.copyWith(
      isLoading: true,
      currentSong: normalizedSong,
      contextPlaylistId: contextPlaylistId, // If provided, it will be used (handled in copyWith)
      clearContextPlaylistId: shouldClearContext,
      isPlaying: true,
      progress: Duration.zero,
      duration: Duration.zero,
      queue: clearQueue ? [] : state.queue,
      baseQueue: clearQueue ? [] : state.baseQueue,
    );

    // ── Proactive queue fetch (non-blocking) ──
    // Refetch when queue has <= 7 songs remaining so the queue never runs dry.
    // Done early so it fetches in parallel with the slow stream extraction below.
    if (state.queue.length <= 7) {
      _fetchWatchNext(normalizedSong.videoId);
    }

    // Update media notification (mirrors lines 360-365)
    _updateMediaItem(normalizedSong);

    // Sync liked state on the notification heart icon
    final isLiked = ref.read(playlistProvider.notifier).isLiked(normalizedSong.videoId);
    _handler.updateLikedState(isLiked);

    try {
      final player = _crossfadeEngine.primaryPlayer;

      // Stop current playback, reset volume
      await player.stop();
      player.setVolume(1.0);

      // ── OFFLINE PATH (mirrors lines 708-713) ──
      if (offlineFilePath != null) {
        await player.setFilePath(offlineFilePath);
        if (isStale()) return;
        await player.play();
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
            await player.setFilePath(localPath);
            if (isStale()) return;
            await player.play();
            return;
          }
        }
      }
      if (isStale()) return;

      // ── Stream via youtube_explode_dart v2.5.3 (client-side, on-device) ──
      // Extraction runs on the user's phone with their own IP.
      // URL is IP-locked to the phone → phone plays it → always works.
      // If extraction fails, throw immediately with a clear message.
      final settings = ref.read(settingsProvider);
      final streamQuality = settings.dataSaverMode ? 'low' : settings.streamingQuality;
      final streamUrl = await StreamExtractor.getAudioStreamUrl(
        normalizedSong.videoId, quality: streamQuality,
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeoutException('Stream extraction timed out. Check internet connection.'),
      );
      if (isStale()) return;
      await player.setUrl(streamUrl).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Player failed to load stream. Try again.'),
      );
      if (isStale()) return;
      await player.play();
      _consecutiveFailures = 0; // Reset on success

      // (Queue fetching was moved to the top of the method for parallel execution)
    } catch (e) {
      debugPrint('[AudioProvider] playSong error: $e');
      if (!isStale()) {
        state = state.copyWith(isLoading: false);
        
        _consecutiveFailures++;
        if (_consecutiveFailures <= 3) {
          debugPrint('[AudioProvider] Auto-skipping to next song due to failure...');
          playNext();
        } else {
          // Hard stop after 3 consecutive failures to prevent infinite looping
          _handler.stopCurrent(); // Clears buffering state and drops wake lock
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: const Text('Playback failed. Check your internet connection.'),
              backgroundColor: Colors.red.shade800,
            ),
          );
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
      var rebuilt = state.isShuffled
          ? ([...state.baseQueue]..shuffle())
          : [...state.baseQueue];
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

      playSong(prevSong);
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
  /// Removes all songs up to that index from the queue and adds them to history.
  void playFromQueue(int index) {
    if (index < 0 || index >= state.queue.length) return;

    final selectedSong = state.queue[index];
    final songsBefore = state.queue.sublist(0, index);
    final newQueue = state.queue.sublist(index + 1);

    // Add skipped songs to history in reverse order so the most recently skipped is first
    final newHistory = [...songsBefore.reversed, ...state.history];

    state = state.copyWith(
      queue: newQueue,
      history: newHistory.length > 50 ? newHistory.sublist(0, 50) : newHistory,
    );

    playSong(selectedSong);
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

    final updatedQueue = List<Song>.from(state.queue);
    final item = updatedQueue.removeAt(oldIndex);
    updatedQueue.insert(newIndex, item);

    state = state.copyWith(queue: updatedQueue);
  }

  /// Remove a song from the queue
  void removeFromQueue(int index) {
    if (index < 0 || index >= state.queue.length) return;
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
      newQueue = [...state.queue]..shuffle();
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
    state = state.copyWith(repeatMode: next);

    // Report to OS
    _handler.setRepeatMode(switch (next) {
      RepeatMode.off => AudioServiceRepeatMode.none,
      RepeatMode.all => AudioServiceRepeatMode.all,
      RepeatMode.one => AudioServiceRepeatMode.one,
    });
    
    // Natively loop the current track if RepeatMode.one
    _crossfadeEngine.primaryPlayer.setLoopMode(
        next == RepeatMode.one ? LoopMode.one : LoopMode.off);
    _crossfadeEngine.crossfadePlayer.setLoopMode(
        next == RepeatMode.one ? LoopMode.one : LoopMode.off);
  }

  // ── Playback controls ──────────────────────────────────────────────────────
  // Port of togglePlay (line 912) and seek (line 924).

  void togglePlay() {
    if (state.currentSong == null) return;
    final player = _crossfadeEngine.primaryPlayer;
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void seek(Duration position) {
    _crossfadeEngine.primaryPlayer.seek(position);
    state = state.copyWith(progress: position);
  }

  // ── Crossfade trigger ──────────────────────────────────────────────────────

  Future<void> _preloadNextSong() async {
    if (_isPreloadingNext) return;

    Song? nextSong;
    if (state.queue.isNotEmpty) {
      nextSong = state.queue.first;
    } else if (state.repeatMode == RepeatMode.all && state.baseQueue.isNotEmpty) {
      nextSong = (state.isShuffled ? ([...state.baseQueue]..shuffle()) : state.baseQueue).first;
    }

    if (nextSong == null || nextSong.videoId.isEmpty) return;
    if (_preloadedNextSongId == nextSong.videoId) return;

    _isPreloadingNext = true;
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

      if (success) {
        _preloadedNextSongId = nextSong.videoId;
      }
    } catch (_) {
    } finally {
      _isPreloadingNext = false;
    }
  }

  Future<void> _triggerCrossfade(int fadeSeconds) async {
    // Determine the next song to crossfade into
    Song? nextSong;
    List<Song> remainingQueue = state.queue;

    if (state.queue.isNotEmpty) {
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
        _isCrossfadePending = false;
        // Song ended naturally with no crossfade, fall through to normal next
        playNext();
        return;
      }
    }

    _preloadedNextSongId = null;

    try {
      final success = await _crossfadeEngine.startCrossfade(
        fadeDuration: fadeSeconds,
        nextUrl: streamUrl,
        localFilePath: localPath,
      );

      if (success) {
        _pendingCrossfadeSong = nextSong;
        _pendingCrossfadeQueue = remainingQueue;
      } else {
        playNext();
      }
    } catch (e) {
      debugPrint('[AudioProvider] startCrossfade threw: $e');
      playNext();
    } finally {
      _isCrossfadePending = false;
    }
  }

  Song? _pendingCrossfadeSong;
  List<Song>? _pendingCrossfadeQueue;
  
  /// Set to true as soon as _triggerCrossfade begins extracting/loading,
  /// to prevent _onTrackEnded from firing playNext() during the async gap.
  bool _isCrossfadePending = false;

  /// Called by CrossfadeEngine when the crossfade swap completes.
  /// Mirrors `_completeCrossfadeSwap()` in AudioContext.jsx (lines 407-453).
  void _onCrossfadeSwapComplete(AudioPlayer newPrimary) {
    // Re-attach player listeners to the new primary
    _attachPlayerListeners(newPrimary);
    
    // Sync handler to new primary player so lockscreen works properly
    _handler.setPrimaryPlayer(newPrimary);

    final nextSong = _pendingCrossfadeSong;
    final nextQueue = _pendingCrossfadeQueue;

    if (nextSong != null) {
      _statsThresholdReached = false;
      state = state.copyWith(
        currentSong: nextSong,
        clearContextPlaylistId: nextSong.playlistId == '__suggested__',
        isPlaying: true,
        duration: newPrimary.duration ?? Duration.zero,
        progress: newPrimary.position,
        queue: nextQueue ?? state.queue,
      );
      _updateMediaItem(nextSong);
    }

    _pendingCrossfadeSong = null;
    _pendingCrossfadeQueue = null;
  }

  // ── Watch-next queue fetching ──────────────────────────────────────────────

  /// Fetch watch-next suggestions and add to queue (non-blocking).
  /// Mirrors lines 752-765 of AudioContext.jsx.
  Future<void> _fetchWatchNext(String videoId) async {
    try {
      final tracks = await _musicApi.getWatchNext(videoId);
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
    final artUrl = song.thumbnail.isNotEmpty
        ? ThumbnailUtils.getHighRes(song.thumbnail, size: 800)
        : '';
    _handler.updateMediaItem(MediaItem(
      id: song.videoId,
      title: song.title,
      artist: song.artist,
      album: song.album,
      duration: song.duration > 0
          ? Duration(seconds: song.duration)
          : null,
      artUri: artUrl.isNotEmpty ? Uri.parse(artUrl) : null,
    ));
  }

  void _updateMediaItemDuration(Duration duration) {
    final current = state.currentSong;
    if (current == null) return;
    final artUrl = current.thumbnail.isNotEmpty
        ? ThumbnailUtils.getHighRes(current.thumbnail, size: 800)
        : '';
    _handler.updateMediaItem(MediaItem(
      id: current.videoId,
      title: current.title,
      artist: current.artist,
      album: current.album,
      duration: duration,
      artUri: artUrl.isNotEmpty ? Uri.parse(artUrl) : null,
    ));
  }

  // ── Stats ──────────────────────────────────────────────────────────────────

  void _reportStats() {
    final song = state.currentSong;
    if (song == null) return;
    final auth = ref.read(authProvider.notifier);
    auth.updatePlaybackStats(
      videoId: song.videoId,
      secondsListened: state.progress.inSeconds,
      title: song.title,
      artist: song.artist,
      cover: song.thumbnail,
    );
  }

  // ── Cleanup ────────────────────────────────────────────────────────────────

  void _dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _eventSub?.cancel();
    _crossfadeEngine.dispose();
    _handler.dispose();
    WakelockPlus.disable();
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
