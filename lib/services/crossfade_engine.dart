import 'dart:async';
import 'dart:math' show pi, cos, sin;
import 'package:media_kit/media_kit.dart';

/// Dual-player crossfade engine — replaces the Web Audio GainNode crossfade
/// from AudioContext.jsx (lines 455-633).
///
/// Architecture:
///   - Primary player: currently audible track, volume at 100.0
///   - Crossfade player: next track, starts at volume 0.0
///   - During crossfade: primary ramps 100.0→0.0, crossfade ramps 0.0→100.0
///   - On completion: crossfade player becomes the new primary
class CrossfadeEngine {
  /// The two audio players used for crossfading.
  Player _primaryPlayer;
  Player _crossfadePlayer;

  /// Timer for the volume interpolation.
  Timer? _rampTimer;

  /// Whether a crossfade is currently in progress.
  bool _isCrossfading = false;

  /// Callback: crossfade completed, players have been swapped.
  /// The caller should update state (currentSong, queue, etc.).
  void Function(Player newPrimary)? onSwapComplete;

  /// Callback: crossfade is at the 50% volume midpoint.
  /// The caller should update song metadata here for the best UX.
  void Function()? onMidpointReached;

  CrossfadeEngine({
    required Player primaryPlayer,
    required Player crossfadePlayer,
  })  : _primaryPlayer = primaryPlayer,
        _crossfadePlayer = crossfadePlayer;

  bool get isCrossfading => _isCrossfading;
  Player get primaryPlayer => _primaryPlayer;
  Player get crossfadePlayer => _crossfadePlayer;

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
        await _crossfadePlayer.open(Media(localFilePath), play: false);
      } else {
        await _crossfadePlayer.open(
          Media(nextUrl!, httpHeaders: headers ?? {}), 
          play: false,
        );
      }
      
      _isPrepared = true;
      return true;
    } catch (e) {
      _isPrepared = false;
      return false;
    }
  }

  /// Start a crossfade transition.
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
      if (!_isPrepared) {
        await _crossfadePlayer.stop();
        await _crossfadePlayer.setVolume(0.0);

        if (localFilePath != null) {
          await _crossfadePlayer.open(Media(localFilePath), play: false);
        } else {
          await _crossfadePlayer.open(
            Media(nextUrl!, httpHeaders: headers ?? {}), 
            play: false,
          );
        }
      }

      await _crossfadePlayer.play();

      final fadeMs = fadeDuration * 1000;
      final startTime = DateTime.now().millisecondsSinceEpoch;

      _rampTimer?.cancel();
      _rampTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        if (!_isCrossfading) {
          timer.cancel();
          return;
        }
        
        final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
        final progress = (elapsed / fadeMs).clamp(0.0, 1.0);

        // Equal-power crossfade (cos/sin curve) — keeps perceived loudness
        // constant throughout the fade, eliminating the audible dip that a
        // linear ramp produces at the midpoint due to logarithmic hearing.
        final angle = progress * pi / 2.0;
        _primaryPlayer.setVolume(cos(angle) * 100.0);
        _crossfadePlayer.setVolume(sin(angle) * 100.0);

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
      _isCrossfading = false;
      _isPrepared = false;
      _rampTimer?.cancel();
      _rampTimer = null;
      return false;
    }
  }

  /// Apply the fade-out volume to the primary player during crossfade.
  void applyFadeOutVolume(double timeLeftSeconds, int fadeDuration) {
    if (!_isCrossfading) return;
    if (fadeDuration <= 0) return;
    final vol = (timeLeftSeconds / fadeDuration).clamp(0.0, 1.0);
    _primaryPlayer.setVolume(vol * 100.0);
  }

  /// Complete the crossfade: swap audio players, reset state.
  void _completeCrossfadeSwap() {
    final oldPrimary = _primaryPlayer;

    // media_kit does not deadlock on stop() with audio filters!
    oldPrimary.stop();

    // Swap: crossfade becomes primary
    _primaryPlayer = _crossfadePlayer;
    _crossfadePlayer = oldPrimary;

    // Reset new primary volume to 100.0
    _primaryPlayer.setVolume(100.0);

    _isCrossfading = false;
    _isPrepared = false;

    // Notify the audio provider
    onSwapComplete?.call(_primaryPlayer);
  }

  /// Instantly promotes the pre-buffered crossfade player to primary without
  /// any volume ramp. Used for manual skips when the next song is already buffered.
  Future<Player?> instantSwap() async {
    if (!_isPrepared || _isCrossfading) return null;

    final oldPrimary = _primaryPlayer;

    _primaryPlayer = _crossfadePlayer;
    _crossfadePlayer = oldPrimary;

    _isPrepared = false;
    _midpointFired = false;

    await oldPrimary.stop();
    await oldPrimary.setVolume(100.0);

    return _primaryPlayer;
  }

  /// Cancel an in-progress crossfade (e.g., user manually plays a different song).
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

    _crossfadePlayer.stop();
    _crossfadePlayer.setVolume(100.0);
    _primaryPlayer.setVolume(100.0);
  }

  /// Dispose both players and cancel any active timers.
  Future<void> dispose() async {
    _rampTimer?.cancel();
    _rampTimer = null;
    await _primaryPlayer.dispose();
    await _crossfadePlayer.dispose();
  }
}
