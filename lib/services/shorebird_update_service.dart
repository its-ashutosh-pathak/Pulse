import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdUpdateService {
  ShorebirdUpdateService._();
  static final ShorebirdUpdateService instance = ShorebirdUpdateService._();

  final ShorebirdUpdater _updater = ShorebirdUpdater();
  bool _isChecking = false;

  /// Checks for available Shorebird patches in the background.
  Future<void> checkForUpdates({
    GlobalKey<ScaffoldMessengerState>? messengerKey,
  }) async {
    // Shorebird code push is only active on Android & iOS mobile devices
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    if (_isChecking) return;
    _isChecking = true;

    try {
      final status = await _updater.checkForUpdate();

      if (status == UpdateStatus.outdated) {
        debugPrint('[Shorebird] New patch available. Downloading...');
        await _updater.update();
        debugPrint('[Shorebird] Patch downloaded and applied for next restart.');

        if (messengerKey?.currentState != null) {
          messengerKey!.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                'A new update was downloaded! Restart Pulse to apply.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF1E1E1E),
              duration: Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else if (status == UpdateStatus.upToDate) {
        debugPrint('[Shorebird] Pulse is up-to-date.');
      } else if (status == UpdateStatus.restartRequired) {
        debugPrint('[Shorebird] Restart required to apply already-downloaded patch.');
      }
    } catch (e) {
      debugPrint('[Shorebird] Error checking for updates: $e');
    } finally {
      _isChecking = false;
    }
  }
}
