import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';
import 'wakelock_manager.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:pulse/l10n/generated/app_localizations.dart';
import '../main.dart' show scaffoldMessengerKey;

/// Custom [BaseAudioHandler] for Pulse — bridges `media_kit` with `audio_service`
/// to provide background playback and lock screen / notification controls.
class PulseAudioHandler extends BaseAudioHandler with SeekHandler {
  Player _activePlayer;
  
  /// Second player used exclusively during crossfade transitions.
  Player? _crossfadePlayer;

  AudioSession? _session;

  StreamSubscription<bool>? _playingSub;
  StreamSubscription<bool>? _bufferingSub;
  StreamSubscription<bool>? _completedSub;
  StreamSubscription<Duration>? _positionSub;

  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _position = Duration.zero;
  Duration _bufferedPosition = Duration.zero;

  /// Equalizer state
  bool _eqEnabled = false;
  List<double> _eqGains = List.filled(10, 0.0);

  /// Callback invoked when the current track naturally ends (not crossfaded).
  /// The audio provider listens to this to trigger playNext().
  void Function()? onTrackEnded;

  /// Callback invoked when user presses next via lock screen / notification.
  void Function()? onSkipToNext;

  /// Callback invoked when user presses previous via lock screen / notification.
  void Function()? onSkipToPrevious;

  /// Callback invoked when user presses Like in the notification.
  void Function()? onLikePressed;

  /// Callback to check if sleep timer has expired, blocking play requests if true.
  bool Function()? isSleepTimerExpired;

  /// Whether the current song is liked — controls filled vs outline heart icon.
  bool _isLiked = false;

  /// Update the liked state and refresh the notification controls.
  void updateLikedState(bool liked) {
    _isLiked = liked;
    _broadcastState();
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'like') {
      onLikePressed?.call();
    }
    await super.customAction(name, extras);
  }

  PulseAudioHandler(this._activePlayer) {
    _applyOptimizations(_activePlayer);
    _activePlayer.setVolume(100.0);
    _initListeners();
    _initAudioSession();
  }

  void _applyOptimizations(Player player) {
    final platform = player.platform;
    if (platform is NativePlayer) {
      platform.setProperty('cache-pause', 'no');
      platform.setProperty('demuxer-readahead-secs', '60');
      platform.setProperty('network-timeout', '3');
      // NOTE: We do NOT pre-load any af filter here.
      // Applying a lavfi filter at player creation (before media opens) can
      // break the audio pipeline if the required FFmpeg filter is not available
      // in the bundled media_kit_libs_audio build on the device.
      // The EQ filter is applied on-demand only when the user enables EQ.
    }
  }

  Future<void> _initAudioSession() async {
    _session = await AudioSession.instance;
    await _session!.configure(const AudioSessionConfiguration.music());
    _session!.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            pause();
            break;
          case AudioInterruptionType.duck:
            _activePlayer.setVolume(20.0);
            if (_crossfadePlayer != null) {
              _crossfadePlayer!.setVolume(20.0);
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _activePlayer.setVolume(100.0);
            if (_crossfadePlayer != null) {
              _crossfadePlayer!.setVolume(100.0);
            }
            break;
          case AudioInterruptionType.pause:
            play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });
  }

  void _initListeners() {
    _playingSub?.cancel();
    _bufferingSub?.cancel();
    _completedSub?.cancel();
    _positionSub?.cancel();

    _playingSub = _activePlayer.stream.playing.listen((playing) {
      _isPlaying = playing;
      _broadcastState();
    });

    _bufferingSub = _activePlayer.stream.buffering.listen((buffering) {
      _isBuffering = buffering;
      _broadcastState();
    });

    _positionSub = _activePlayer.stream.position.listen((position) {
      _position = position;
      _bufferedPosition = _activePlayer.state.buffer;
      
      // Update AudioService periodically to keep notification panel in sync
      if (_isPlaying && position.inSeconds % 2 == 0) {
        _broadcastState();
      }
    });

    _completedSub = _activePlayer.stream.completed.listen((completed) {
      if (completed) {
        onTrackEnded?.call();
      }
    });
  }

  /// Update the OS media notification with current song metadata.
  @override
  Future<void> updateMediaItem(MediaItem item) async {
    mediaItem.add(item);
  }

  /// Set the audio source URL and begin playback.
  Future<void> playUrl(String url, {Map<String, String>? headers}) async {
    await _activePlayer.open(Media(url, httpHeaders: headers ?? {}));
    await _activePlayer.play();
  }

  /// Set audio source from a local file path (offline playback).
  Future<void> playFile(String path) async {
    await _activePlayer.open(Media(path));
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

  /// Expose the ability to request audio focus manually.
  Future<void> requestAudioFocus() async {
    if (_session != null) {
      await _session!.setActive(true);
    }
  }

  // ── BaseAudioHandler overrides (OS media control callbacks) ──

  @override
  Future<void> play() async {
    if (isSleepTimerExpired?.call() ?? false) return;
    
    await requestAudioFocus();
    await _activePlayer.play();
  }

  @override
  Future<void> pause() async {
    await _activePlayer.pause();
    if (_crossfadePlayer != null) {
      await _crossfadePlayer!.pause();
    }
  }

  @override
  Future<void> stop() async {
    await _activePlayer.stop();
    if (_session != null) {
      await _session!.setActive(false);
    }
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _activePlayer.seek(position);
    _position = position;
    _broadcastState();
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
  Future<void> onTaskRemoved() async {
    try {
      await WakelockManager().disableAll();
    } catch (_) {}
    
    if (!playbackState.value.playing) {
      await stop();
    } else {
      await stop();
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    await super.setRepeatMode(repeatMode);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await super.setShuffleMode(shuffleMode);
  }

  // ── Crossfade support ──

  /// Get the primary player (used by CrossfadeEngine for volume control).
  Player get primaryPlayer => _activePlayer;

  /// The crossfade player — lazily created when crossfade starts.
  Player get crossfadePlayer {
    if (_crossfadePlayer == null) {
      _crossfadePlayer = Player(configuration: const PlayerConfiguration(bufferSize: 4194304));
      _applyOptimizations(_crossfadePlayer!);
      // If EQ is currently active, apply the lavfi filter to the new player immediately
      if (_eqEnabled) {
        _applyFilter(_crossfadePlayer!, _buildFilterString());
      }
    }
    return _crossfadePlayer!;
  }

  /// After crossfade completes, promote the crossfade player to primary.
  void setPrimaryPlayer(Player newPrimary) {
    if (_crossfadePlayer != null && newPrimary == _crossfadePlayer) {
      _crossfadePlayer = _activePlayer;
    }
    _activePlayer = newPrimary;
    _initListeners();
    _broadcastState();
    // Re-apply current EQ state immediately to the new primary (no debounce needed — this is a player swap)
    final filterStr = _eqEnabled ? _buildFilterString() : _flatEqFilter;
    _applyFilter(_activePlayer, filterStr);
    // Reset the recycled old-primary (now the crossfade player) back to the flat
    // filter so it is clean for the next crossfade. Without this, stale EQ state
    // from the previous song leaks into the next crossfade buffer.
    if (_crossfadePlayer != null) {
      _applyFilter(_crossfadePlayer!, _flatEqFilter);
    }
  }

  // ── Equalizer logic ─────────────────────────────────────────────────────────

  // The bypass state — empty string means MPV uses its default audio path
  // with no filter chain. This is the safest possible state and works on all
  // devices regardless of what FFmpeg filters are bundled in media_kit_libs_audio.
  static const String _flatEqFilter = '';


  /// Generation counter — incremented on every setEqualizerState call.
  /// In-flight operations check this to abort if superseded by a newer call.
  int _eqApplyGeneration = 0;

  /// Update EQ state and schedule a debounced, race-safe application.
  Future<void> setEqualizerState({required bool enabled, required List<double> gains}) async {
    _eqEnabled = enabled;
    _eqGains = List<double>.from(gains);
    final thisGen = ++_eqApplyGeneration;

    // Debounce: absorbs rapid changes (e.g. dragging a slider, loading a preset
    // which fires setEqualizerGains + setEqualizerPreAmp in quick succession).
    // This means toggling EQ or switching presets quickly fires only ONE apply.
    await Future.delayed(const Duration(milliseconds: 150));
    if (thisGen != _eqApplyGeneration) return; // Superseded — abort

    await applyCurrentFilter(_activePlayer);
    if (_crossfadePlayer != null) {
      applyCurrentFilter(_crossfadePlayer!); // fire-and-forget, no seek on crossfade
    }
  }

  /// Apply the current EQ state to [player] NOW.
  /// Returns a Future so callers can await completion before seeking.
  /// Call AFTER player.stop() and BEFORE player.open() for guaranteed effect.
  Future<void> applyCurrentFilter(Player player) {
    final filterStr = _eqEnabled ? _buildFilterString() : '';
    return _applyFilter(player, filterStr);
  }

  /// Send a filter string to a player's mpv instance.
  /// Returns the Future so callers can await MPV acknowledgement.
  Future<void> _applyFilter(Player player, String filterStr) {
    final platform = player.platform;
    if (platform is! NativePlayer) return Future.value();
    return platform.setProperty('af', filterStr).onError((e, _) {
      debugPrint('[EQ] setProperty(af) failed: $e');
    });
  }

  /// Build the active lavfi filter string from current EQ state.
  /// Clamps all values to safe ranges and guards against NaN/Infinity.
  String _buildFilterString() {
    const frequencies = [31.25, 62.5, 125.0, 250.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0];
    final sb = StringBuffer();

    // Use raw MPV filter syntax. MPV will automatically bridge 'equalizer' to libavfilter.
    
    for (int i = 0; i < _eqGains.length && i < frequencies.length; i++) {
      if (i > 0) sb.write(',');
      // Guard: NaN or Infinity would produce invalid mpv filter syntax → clamp to 0
      final raw = _eqGains[i];
      final g = (raw.isNaN || raw.isInfinite) ? 0.0 : raw.clamp(-15.0, 15.0);
      sb.write('equalizer=f=${frequencies[i]}:g=${g.toStringAsFixed(4)}');
    }

    return sb.toString();
  }

  // ── Internal ──

  void _broadcastState() {
    AudioProcessingState processingState;
    if (_isBuffering) {
      processingState = AudioProcessingState.buffering;
    } else if (_isPlaying) {
      processingState = AudioProcessingState.ready;
    } else {
      processingState = AudioProcessingState.ready;
    }
    AppLocalizations l10n;
    final ctx = scaffoldMessengerKey.currentContext;
    if (ctx != null) {
      l10n = AppLocalizations.of(ctx)!;
    } else {
      l10n = lookupAppLocalizations(const Locale('en'));
    }

    final likeIcon = _isLiked ? 'drawable/ic_favorite' : 'drawable/ic_favorite_outline';
    final likeLabel = _isLiked ? l10n.audioControlUnlike : l10n.audioControlLike;

    playbackState.add(PlaybackState(
      controls: [
        MediaControl(
          androidIcon: 'drawable/ic_skip_previous',
          label: l10n.audioControlPrevious,
          action: MediaAction.skipToPrevious,
        ),
        if (_isPlaying)
          MediaControl(
            androidIcon: 'drawable/ic_pause_circle_fill',
            label: l10n.audioControlPause,
            action: MediaAction.pause,
          )
        else
          MediaControl(
            androidIcon: 'drawable/ic_play_circle_fill',
            label: l10n.audioControlPlay,
            action: MediaAction.play,
          ),
        MediaControl(
          androidIcon: 'drawable/ic_skip_next',
          label: l10n.audioControlNext,
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
      playing: _isPlaying,
      updatePosition: _position,
      bufferedPosition: _bufferedPosition,
      speed: _activePlayer.state.rate,
    ));
  }

  /// Dispose all resources.
  Future<void> dispose() async {
    await _playingSub?.cancel();
    await _bufferingSub?.cancel();
    await _completedSub?.cancel();
    await _positionSub?.cancel();
    await _activePlayer.dispose();
    await _crossfadePlayer?.dispose();
  }
}

/// Initialize the audio_service handler as a singleton.
Future<PulseAudioHandler> initAudioService() async {
  final player = Player(configuration: const PlayerConfiguration(bufferSize: 4194304));
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
