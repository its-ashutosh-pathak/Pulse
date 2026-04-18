import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Custom [BaseAudioHandler] for Pulse — bridges `just_audio` with `audio_service`
/// to provide background playback and lock screen / notification controls.
///
/// This replaces the Media Session API integration from AudioContext.jsx (lines 339-401).
/// On Android, this runs as a foreground service; on iOS, it uses the MPNowPlayingInfoCenter.
class PulseAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;

  /// Second player used exclusively during crossfade transitions.
  AudioPlayer? _crossfadePlayer;

  StreamSubscription<PlaybackEvent>? _eventSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  /// Callback invoked when the current track naturally ends (not crossfaded).
  /// The audio provider listens to this to trigger playNext().
  void Function()? onTrackEnded;

  /// Callback invoked when user presses next via lock screen / notification.
  void Function()? onSkipToNext;

  /// Callback invoked when user presses previous via lock screen / notification.
  void Function()? onSkipToPrevious;

  PulseAudioHandler(this._player) {
    _initListeners();
  }

  void _initListeners() {
    // Broadcast playback state changes to the OS (lock screen, notification).
    _stateSub = _player.playerStateStream.listen((playerState) {
      _broadcastState(playerState);
    });

    // Broadcast position updates (for seek bar on lock screen).
    _positionSub = _player.positionStream.listen((position) {
      // Position is already available via _player.position — the OS reads it
      // from the broadcast state, which we update on every state change.
    });

    // Listen for completion to trigger playNext.
    _eventSub = _player.playbackEventStream.listen((event) {
      // Track ended naturally
      if (event.processingState == ProcessingState.completed) {
        onTrackEnded?.call();
      }
    });
  }

  /// Update the OS media notification with current song metadata.
  /// Replaces navigator.mediaSession.metadata = new MediaMetadata({...})
  /// from AudioContext.jsx lines 360-365.
  @override
  Future<void> updateMediaItem(MediaItem item) async {
    mediaItem.add(item);
  }

  /// Set the audio source URL and begin playback.
  /// [headers] can include auth tokens for the backend stream proxy.
  Future<void> playUrl(String url, {Map<String, String>? headers}) async {
    await _player.setUrl(url, headers: headers);
    await _player.play();
  }

  /// Set audio source from a local file path (offline playback).
  Future<void> playFile(String path) async {
    await _player.setFilePath(path);
    await _player.play();
  }

  /// Stop current playback without disposing the player.
  Future<void> stopCurrent() async {
    await _player.stop();
  }

  // ── BaseAudioHandler overrides (OS media control callbacks) ──

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    onSkipToNext?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    onSkipToPrevious?.call();
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    // Repeat is managed by the audio provider, not the player directly.
    // We still report it to the OS via the inherited BehaviorSubject.
    await super.setRepeatMode(repeatMode);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    // Shuffle is managed by the audio provider.
    await super.setShuffleMode(shuffleMode);
  }

  // ── Crossfade support ──

  /// Get the primary player (used by CrossfadeEngine for volume control).
  AudioPlayer get primaryPlayer => _player;

  /// The crossfade player — lazily created when crossfade starts.
  AudioPlayer get crossfadePlayer {
    _crossfadePlayer ??= AudioPlayer();
    return _crossfadePlayer!;
  }

  /// After crossfade completes, promote the crossfade player to primary.
  /// The caller creates a new player for the next crossfade.
  void swapPlayers() {
    final oldPrimary = _player;

    // Cancel old subscriptions
    _eventSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();

    // Old primary is now available as the next crossfade player.
    // Don't dispose — just stop. The CrossfadeEngine handles cleanup.
    oldPrimary.stop();

    // Note: We can't reassign _player because it's final.
    // Instead, CrossfadeEngine manages the player lifecycle externally
    // and creates a new PulseAudioHandler when swapping.
    // See CrossfadeEngine._completeCrossfadeSwap().
  }

  // ── Internal ──

  /// Map the just_audio PlayerState → audio_service PlaybackState and broadcast.
  /// This is what makes the lock screen controls + seek bar work.
  void _broadcastState(PlayerState playerState) {
    final playing = playerState.playing;
    final processingState = _mapProcessingState(playerState.processingState);

    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: processingState,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    ));
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  /// Dispose all resources.
  Future<void> dispose() async {
    await _eventSub?.cancel();
    await _positionSub?.cancel();
    await _stateSub?.cancel();
    await _player.dispose();
    await _crossfadePlayer?.dispose();
  }
}

/// Initialize the audio_service handler as a singleton.
/// Must be called once in main() before runApp().
Future<PulseAudioHandler> initAudioService() async {
  final player = AudioPlayer();
  return await AudioService.init(
    builder: () => PulseAudioHandler(player),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.pulse.music.channel',
      androidNotificationChannelName: 'Pulse Music',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );
}
