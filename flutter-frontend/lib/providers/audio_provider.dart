import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../data/api/api_client.dart';
import '../data/api/music_api.dart';
import '../data/models/song.dart';
import '../core/constants/api_constants.dart';
import '../services/audio_handler.dart';
import '../services/crossfade_engine.dart';
import 'auth_provider.dart';
import 'download_provider.dart';
import 'settings_provider.dart';

// ── Audio State ─────────────────────────────────────────────────────────────

enum RepeatMode { off, all, one }

class AudioState {
  final Song? currentSong;
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

  @override
  AudioState build() {
    ref.onDispose(_dispose);
    // Initialization is deferred — must call initialize() after handler is ready.
    return const AudioState();
  }

  /// Initialize with the audio handler (must be called after AudioService.init).
  void initialize(PulseAudioHandler handler) {
    _handler = handler;
    _crossfadeEngine = CrossfadeEngine(
      primaryPlayer: _handler.primaryPlayer,
      crossfadePlayer: _handler.crossfadePlayer,
    );

    // Wire up handler callbacks for lock screen controls
    _handler.onTrackEnded = _onTrackEnded;
    _handler.onSkipToNext = playNext;
    _handler.onSkipToPrevious = playPrev;

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

      if (fadeSeconds > 0 && dur != null && dur.inSeconds > 0) {
        final timeLeftMs = dur.inMilliseconds - position.inMilliseconds;
        final timeLeftSeconds = timeLeftMs / 1000.0;

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

    // Completion event (replaces onEnded, lines 240-253)
    _eventSub = player.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _onTrackEnded();
      }
    });
  }

  /// Called when a track finishes playing (not via crossfade).
  /// Mirrors the `onEnded` handler in AudioContext.jsx (lines 240-253).
  void _onTrackEnded() {
    // If crossfade already handled transition, skip.
    if (_crossfadeEngine.isCrossfading) return;

    if (state.repeatMode == RepeatMode.one) {
      // Repeat one: seek to beginning and replay
      _crossfadeEngine.primaryPlayer.seek(Duration.zero);
      _crossfadeEngine.primaryPlayer.play();
    } else {
      playNext();
    }
  }

  // ── Core play function ─────────────────────────────────────────────────────
  // Port of `playSong()` from AudioContext.jsx (lines 636-770).

  Future<void> playSong(Song song, {String? offlineFilePath}) async {
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

    state = state.copyWith(
      isLoading: true,
      currentSong: normalizedSong,
      isPlaying: true,
      progress: Duration.zero,
      duration: Duration.zero,
    );

    // Update media notification (mirrors lines 360-365)
    _updateMediaItem(normalizedSong);

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

      // ── Stream from local extractor ──
      final streamUrl = await _musicApi.extractStreamUrl(normalizedSong.videoId);
      if (isStale()) return;

      await player.setUrl(streamUrl);
      if (isStale()) return;
      await player.play();

      // ── Proactive queue fetch (mirrors lines 752-765) ──
      // Only fetch when queue is empty to avoid replacing current queue.
      if (state.queue.isEmpty) {
        _fetchWatchNext(normalizedSong.videoId);
      }
    } catch (e) {
      if (!isStale()) {
        state = state.copyWith(isLoading: false);
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
      var fullList = [...state.baseQueue];
      final cs = state.currentSong;
      if (cs != null) {
        fullList.removeWhere((s) => s.videoId == cs.videoId);
        fullList.insert(0, cs);
      }
      if (state.isShuffled) {
        fullList.shuffle();
      }
      final first = fullList.first;
      final rest = fullList.sublist(1);
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

  Future<void> _triggerCrossfade(int fadeSeconds) async {
    // Determine the next song to crossfade into
    Song? nextSong;
    List<Song> remainingQueue = state.queue;

    if (state.repeatMode == RepeatMode.one) {
      // Repeat-one with crossfade: loop same song (mirrors lines 458-528)
      nextSong = state.currentSong;
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

    // Check if song is downloaded
    final downloads = ref.read(downloadProvider.notifier);
    String? localPath;
    try {
      if (await downloads.isDownloaded(nextSong.videoId)) {
        localPath = await downloads.getFilePath(nextSong.videoId);
      }
    } catch (_) {}

    String? streamUrl;
    Map<String, String>? headers;
    if (localPath == null) {
      streamUrl = await _musicApi.extractStreamUrl(nextSong.videoId);
    }

    final success = await _crossfadeEngine.startCrossfade(
      fadeDuration: fadeSeconds,
      nextUrl: streamUrl,
      localFilePath: localPath,
      headers: headers,
    );

    if (success) {
      // Pre-update queue to reflect next song consumption (will be finalized on swap).
      // Store the next song info for the swap callback.
      _pendingCrossfadeSong = nextSong;
      _pendingCrossfadeQueue = remainingQueue;
    }
  }

  Song? _pendingCrossfadeSong;
  List<Song>? _pendingCrossfadeQueue;

  /// Called by CrossfadeEngine when the crossfade swap completes.
  /// Mirrors `_completeCrossfadeSwap()` in AudioContext.jsx (lines 407-453).
  void _onCrossfadeSwapComplete(AudioPlayer newPrimary) {
    // Re-attach player listeners to the new primary
    _attachPlayerListeners(newPrimary);

    final nextSong = _pendingCrossfadeSong;
    final nextQueue = _pendingCrossfadeQueue;

    if (nextSong != null) {
      _statsThresholdReached = false;
      state = state.copyWith(
        currentSong: nextSong,
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
        state = state.copyWith(
          queue: tracks,
          baseQueue: [state.currentSong!, ...tracks],
        );
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
        final first = tracks.first;
        final rest = tracks.sublist(1);
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
    _handler.updateMediaItem(MediaItem(
      id: song.videoId,
      title: song.title,
      artist: song.artist,
      album: song.album,
      duration: song.duration > 0
          ? Duration(seconds: song.duration)
          : null,
      artUri: song.thumbnail.isNotEmpty ? Uri.parse(song.thumbnail) : null,
    ));
  }

  void _updateMediaItemDuration(Duration duration) {
    final current = state.currentSong;
    if (current == null) return;
    _handler.updateMediaItem(MediaItem(
      id: current.videoId,
      title: current.title,
      artist: current.artist,
      album: current.album,
      duration: duration,
      artUri:
          current.thumbnail.isNotEmpty ? Uri.parse(current.thumbnail) : null,
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
