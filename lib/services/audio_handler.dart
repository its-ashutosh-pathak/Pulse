import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Custom [BaseAudioHandler] for Pulse — bridges `just_audio` with `audio_service`
/// to provide background playback and lock screen / notification controls.
///
/// This replaces the Media Session API integration from AudioContext.jsx (lines 339-401).
/// On Android, this runs as a foreground service; on iOS, it uses the MPNowPlayingInfoCenter.
class PulseAudioHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayer _activePlayer;

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

  /// Callback invoked when user presses Like in the notification.
  void Function()? onLikePressed;

  /// Whether the current song is liked — controls filled vs outline heart icon.
  bool _isLiked = false;

  /// Update the liked state and refresh the notification controls.
  void updateLikedState(bool liked) {
    _isLiked = liked;
    _broadcastState(_activePlayer.playerState);
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'like') {
      onLikePressed?.call();
    }
    await super.customAction(name, extras);
  }

  PulseAudioHandler(this._activePlayer) {
    _initListeners();
  }

  void _initListeners() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _eventSub?.cancel();

    // Broadcast playback state changes to the OS (lock screen, notification).
    _stateSub = _activePlayer.playerStateStream.listen((playerState) {
      _broadcastState(playerState);
    });

    // Broadcast position updates (for seek bar on lock screen).
    _positionSub = _activePlayer.positionStream.listen((position) {
      // Position is already available via _activePlayer.position — the OS reads it
      // from the broadcast state, which we update on every state change.
    });

    // Listen for completion to trigger playNext.
    _eventSub = _activePlayer.playbackEventStream.listen((event) {
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
    await _activePlayer.setUrl(url, headers: headers);
    await _activePlayer.play();
  }

  /// Set audio source from a local file path (offline playback).
  Future<void> playFile(String path) async {
    await _activePlayer.setFilePath(path);
    await _activePlayer.play();
  }

  /// Stop current playback without disposing the player.
  Future<void> stopCurrent() async {
    await _activePlayer.stop();
  }

  /// Force the OS to think we are buffering (holds wake lock during network requests)
  void setBufferingState() {
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.buffering,
    ));
  }

  // ── BaseAudioHandler overrides (OS media control callbacks) ──

  @override
  Future<void> play() async {
    await _activePlayer.play();
  }

  @override
  Future<void> pause() async {
    await _activePlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _activePlayer.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _activePlayer.seek(position);
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
  AudioPlayer get primaryPlayer => _activePlayer;

  /// The crossfade player — lazily created when crossfade starts.
  AudioPlayer get crossfadePlayer {
    _crossfadePlayer ??= AudioPlayer();
    return _crossfadePlayer!;
  }

  /// After crossfade completes, promote the crossfade player to primary.
  void setPrimaryPlayer(AudioPlayer newPrimary) {
    _activePlayer = newPrimary;
    _initListeners();
    // Trigger an immediate broadcast with the new primary's state
    _broadcastState(_activePlayer.playerState);
  }

  // ── Internal ──

  /// Map the just_audio PlayerState → audio_service PlaybackState and broadcast.
  /// This is what makes the lock screen controls + seek bar work.
  void _broadcastState(PlayerState playerState) {
    final playing = playerState.playing;
    final processingState = _mapProcessingState(playerState.processingState);

    final likeIcon = _isLiked ? 'drawable/ic_favorite' : 'drawable/ic_favorite_outline';
    final likeLabel = _isLiked ? 'Unlike' : 'Like';

    playbackState.add(PlaybackState(
      controls: [
        const MediaControl(
          androidIcon: 'drawable/ic_skip_previous',
          label: 'Previous',
          action: MediaAction.skipToPrevious,
        ),
        if (playing)
          const MediaControl(
            androidIcon: 'drawable/ic_pause_circle_fill',
            label: 'Pause',
            action: MediaAction.pause,
          )
        else
          const MediaControl(
            androidIcon: 'drawable/ic_play_circle_fill',
            label: 'Play',
            action: MediaAction.play,
          ),
        const MediaControl(
          androidIcon: 'drawable/ic_skip_next',
          label: 'Next',
          action: MediaAction.skipToNext,
        ),
        MediaControl.custom(
          androidIcon: likeIcon,
          label: likeLabel,
          name: 'like',
        ),
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: processingState,
      playing: playing,
      updatePosition: _activePlayer.position,
      bufferedPosition: _activePlayer.bufferedPosition,
      speed: _activePlayer.speed,
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
    await _activePlayer.dispose();
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
      androidNotificationIcon: 'drawable/ic_logo',
    ),
  );
}
