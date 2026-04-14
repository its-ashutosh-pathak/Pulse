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

  CrossfadeEngine({
    required AudioPlayer primaryPlayer,
    required AudioPlayer crossfadePlayer,
  })  : _primaryPlayer = primaryPlayer,
        _crossfadePlayer = crossfadePlayer;

  bool get isCrossfading => _isCrossfading;
  AudioPlayer get primaryPlayer => _primaryPlayer;
  AudioPlayer get crossfadePlayer => _crossfadePlayer;

  /// Start a crossfade transition to [nextUrl].
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
    if (nextUrl == null && localFilePath == null) return false;

    _isCrossfading = true;

    try {
      // Load the next track into the crossfade player at volume 0
      _crossfadePlayer.setVolume(0.0);

      if (localFilePath != null) {
        await _crossfadePlayer.setFilePath(localFilePath);
      } else {
        await _crossfadePlayer.setUrl(nextUrl!, headers: headers);
      }

      // Start playing the crossfade player (at volume 0 — inaudible)
      await _crossfadePlayer.play();

      // Begin the volume ramp
      final fadeMs = fadeDuration * 1000;
      final startTime = DateTime.now().millisecondsSinceEpoch;

      // 50ms interval matches the setInterval(50) fallback in AudioContext.jsx line 615
      _rampTimer?.cancel();
      _rampTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
        final progress = (elapsed / fadeMs).clamp(0.0, 1.0);

        // Primary fades out, crossfade fades in (linear ramp)
        _primaryPlayer.setVolume(1.0 - progress);
        _crossfadePlayer.setVolume(progress);

        if (progress >= 1.0) {
          timer.cancel();
          _rampTimer = null;
          _completeCrossfadeSwap();
        }
      });

      return true;
    } catch (e) {
      // Crossfade failed — caller should fall back to normal transition
      _isCrossfading = false;
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

    // Notify the audio provider
    onSwapComplete?.call(_primaryPlayer);
  }

  /// Cancel an in-progress crossfade (e.g., user manually plays a different song).
  /// Mirrors the cancel logic in AudioContext.jsx playSong() lines 667-674.
  void cancelCrossfade() {
    if (!_isCrossfading) return;
    _rampTimer?.cancel();
    _rampTimer = null;
    _isCrossfading = false;

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
