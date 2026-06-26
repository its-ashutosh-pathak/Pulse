import 'dart:async';
import 'package:just_audio/just_audio.dart';

/// Dual-player crossfade engine — replaces the Web Audio GainNode crossfade
/// from AudioContext.jsx (lines 455-633).
///
/// Web Audio API used `GainNode.linearRampToValueAtTime()` on the audio thread.
/// Flutter's just_audio doesn't expose Web Audio, so we use software volume
/// interpolation via `Timer.periodic(50ms)`. The result is functionally identical
/// but uses CPU instead of the audio thread.
///
/// Architecture:
///   - Primary player: currently audible track, volume at 1.0
///   - Crossfade player: next track, starts at volume 0.0
///   - During crossfade: primary ramps 1.0→0.0, crossfade ramps 0.0→1.0
///   - On completion: crossfade player becomes the new primary
class CrossfadeEngine {
  /// The two audio players used for crossfading.
  AudioPlayer _primaryPlayer;
  AudioPlayer _crossfadePlayer;

  /// Timer for the volume interpolation (replaces setInterval in JS fallback).
  Timer? _rampTimer;

  /// Whether a crossfade is currently in progress.
  bool _isCrossfading = false;

  /// Callback: crossfade completed, players have been swapped.
  /// The caller should update state (currentSong, queue, etc.).
  void Function(AudioPlayer newPrimary)? onSwapComplete;

  /// Callback: crossfade is at the 50% volume midpoint.
  /// The caller should update song metadata here for the best UX.
  void Function()? onMidpointReached;

  CrossfadeEngine({
    required AudioPlayer primaryPlayer,
    required AudioPlayer crossfadePlayer,
  })  : _primaryPlayer = primaryPlayer,
        _crossfadePlayer = crossfadePlayer;

  bool get isCrossfading => _isCrossfading;
  AudioPlayer get primaryPlayer => _primaryPlayer;
  AudioPlayer get crossfadePlayer => _crossfadePlayer;

  /// Whether the crossfade player is pre-buffered.
  bool _isPrepared = false;
  bool get isPrepared => _isPrepared;

  /// Tracks whether onMidpointReached has already fired for this crossfade.
  bool _midpointFired = false;

  /// Preload the next track into the crossfade player so that startCrossfade is instant.
  Future<bool> prepareCrossfade({
    String? nextUrl,
    String? localFilePath,
    Map<String, String>? headers,
  }) async {
    if (_isCrossfading) return false;
    if (nextUrl == null && localFilePath == null) return false;

    try {
      await _crossfadePlayer.stop();
      await _crossfadePlayer.setVolume(0.0);

      if (localFilePath != null) {
        await _crossfadePlayer.setFilePath(localFilePath);
      } else {
        await _crossfadePlayer.setUrl(nextUrl!, headers: headers);
      }
      
      _isPrepared = true;
      return true;
    } catch (e) {
      _isPrepared = false;
      return false;
    }
  }

  /// Start a crossfade transition.
  /// If not prepared, it will prepare inline (which may cause a delay).
  ///
  /// [fadeDuration] is in seconds (matches `crossfadeDurationRef.current` in React).
  /// [headers] are passed through for auth-token-bearing stream URLs.
  /// [localFilePath] is used for offline playback instead of [nextUrl].
  ///
  /// This mirrors `_startCrossfade()` in AudioContext.jsx (line 456).
  Future<bool> startCrossfade({
    required int fadeDuration,
    String? nextUrl,
    String? localFilePath,
    Map<String, String>? headers,
  }) async {
    if (_isCrossfading) return false;
    if (fadeDuration <= 0) return false;
    if (nextUrl == null && localFilePath == null && !_isPrepared) return false;

    _isCrossfading = true;

    try {
      // 1. Prepare secondary player if not already prepared
      if (!_isPrepared) {
        await _crossfadePlayer.stop();
        await _crossfadePlayer.setVolume(0.0);

        if (localFilePath != null) {
          await _crossfadePlayer.setFilePath(localFilePath);
        } else {
          await _crossfadePlayer.setUrl(nextUrl!, headers: headers);
        }
      }

      // 2. Start playing secondary at 0 volume (do not await, play() blocks until track ends!)
      _crossfadePlayer.play();

      // Begin the volume ramp
      final fadeMs = fadeDuration * 1000;
      final startTime = DateTime.now().millisecondsSinceEpoch;

      // 50ms interval matches the setInterval(50) fallback in AudioContext.jsx line 615
      _rampTimer?.cancel();
      _rampTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (!_isCrossfading) {
          timer.cancel();
          return;
        }
        
        final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
        final progress = (elapsed / fadeMs).clamp(0.0, 1.0);

        // Primary fades out, crossfade fades in (linear ramp)
        _primaryPlayer.setVolume(1.0 - progress);
        _crossfadePlayer.setVolume(progress);

        // Fire midpoint callback once at the 50% mark
        if (!_midpointFired && progress >= 0.5) {
          _midpointFired = true;
          onMidpointReached?.call();
        }

        if (progress >= 1.0) {
          timer.cancel();
          if (_rampTimer == timer) _rampTimer = null;
          _isPrepared = false;
          _midpointFired = false;
          _completeCrossfadeSwap();
        }
      });

      return true;
    } catch (e) {
      // Crossfade failed — caller should fall back to normal transition
      _isCrossfading = false;
      _isPrepared = false;
      _rampTimer?.cancel();
      _rampTimer = null;
      return false;
    }
  }

  /// Apply the fade-out volume to the primary player during crossfade.
  /// Called from timeupdate-equivalent (position stream listener) to smoothly
  /// fade out current track. Mirrors AudioContext.jsx lines 202-213.
  void applyFadeOutVolume(double timeLeftSeconds, int fadeDuration) {
    if (!_isCrossfading) return;
    if (fadeDuration <= 0) return;
    final vol = (timeLeftSeconds / fadeDuration).clamp(0.0, 1.0);
    _primaryPlayer.setVolume(vol);
  }

  /// Complete the crossfade: swap audio players, reset state.
  /// Mirrors `_completeCrossfadeSwap()` in AudioContext.jsx (lines 407-453).
  void _completeCrossfadeSwap() {
    final oldPrimary = _primaryPlayer;

    // Stop the old primary — it has faded to 0
    oldPrimary.stop();

    // Swap: crossfade becomes primary
    _primaryPlayer = _crossfadePlayer;
    _crossfadePlayer = oldPrimary;

    // Reset new primary volume to 1.0
    _primaryPlayer.setVolume(1.0);

    _isCrossfading = false;
    _isPrepared = false;

    // Notify the audio provider
    onSwapComplete?.call(_primaryPlayer);
  }

  /// Instantly promotes the pre-buffered crossfade player to primary without
  /// any volume ramp. Used for manual skips when the next song is already buffered,
  /// making the transition essentially zero-latency.
  ///
  /// Returns the new primary [AudioPlayer] on success, or null if the crossfade
  /// player was not prepared (caller should fall back to normal setUrl path).
  Future<AudioPlayer?> instantSwap() async {
    if (!_isPrepared || _isCrossfading) return null;

    final oldPrimary = _primaryPlayer;

    // Swap player references
    _primaryPlayer = _crossfadePlayer;
    _crossfadePlayer = oldPrimary;

    _isPrepared = false;
    _midpointFired = false;

    // Stop and reset the old primary (now the crossfade slot)
    oldPrimary.stop();
    oldPrimary.setVolume(1.0);

    return _primaryPlayer;
  }

  /// Cancel an in-progress crossfade (e.g., user manually plays a different song).
  /// Mirrors the cancel logic in AudioContext.jsx playSong() lines 667-674.
  void cancelCrossfade() {
    if (!_isCrossfading) {
      _isPrepared = false;
      _crossfadePlayer.stop();
      return;
    }
    _rampTimer?.cancel();
    _rampTimer = null;
    _isCrossfading = false;
    _isPrepared = false;
    _midpointFired = false;

    // Stop and reset the crossfade player
    _crossfadePlayer.stop();
    _crossfadePlayer.setVolume(1.0);

    // Restore primary volume
    _primaryPlayer.setVolume(1.0);
  }

  /// Dispose both players and cancel any active timers.
  Future<void> dispose() async {
    _rampTimer?.cancel();
    _rampTimer = null;
    await _primaryPlayer.dispose();
    await _crossfadePlayer.dispose();
  }
}
