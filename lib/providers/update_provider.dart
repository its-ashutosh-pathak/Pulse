import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/constants/app_constants.dart';

part 'update_provider.g.dart';

class AppUpdateInfo {
  final bool isUpdateAvailable;
  final String latestVersion;
  final String downloadUrl;

  AppUpdateInfo({
    required this.isUpdateAvailable,
    required this.latestVersion,
    required this.downloadUrl,
  });
}

@riverpod
class UpdateNotifier extends _$UpdateNotifier {
  @override
  Future<AppUpdateInfo?> build() async {
    return _checkForUpdates();
  }

  Future<AppUpdateInfo?> _checkForUpdates() async {
    try {
      debugPrint('--- Checking for updates ---');
      final doc = await FirebaseFirestore.instance
          .collection('app_settings')
          .doc('version')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final latestVersion = data['latest_version'] as String?;
        final downloadUrl = data['download_url'] as String?;

        debugPrint('Firebase version: $latestVersion, App version: $kAppVersion');

        if (latestVersion != null && downloadUrl != null) {
          final isAvailable = _isVersionGreaterThan(latestVersion, kAppVersion);
          debugPrint('Is update available? $isAvailable');
          
          final cleanUrl = downloadUrl.replaceAll('"', '').replaceAll("'", "").trim();
          return AppUpdateInfo(
            isUpdateAvailable: isAvailable,
            latestVersion: latestVersion.replaceAll('"', '').replaceAll("'", "").trim(),
            downloadUrl: cleanUrl,
          );
        }
      } else {
        debugPrint('Version document does not exist!');
      }
    } catch (e) {
      debugPrint('Failed to check for updates (Firebase Error): $e');
    }
    return null;
  }

  bool _isVersionGreaterThan(String v1, String v2) {
    try {
      // Remove any accidental quotes from the Firebase string
      final cleanV1 = v1.replaceAll('"', '').replaceAll("'", "").trim();
      final cleanV2 = v2.replaceAll('"', '').replaceAll("'", "").trim();

      final v1Parts = cleanV1.split('.').map(int.parse).toList();
      final v2Parts = cleanV2.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        final p1 = i < v1Parts.length ? v1Parts[i] : 0;
        final p2 = i < v2Parts.length ? v2Parts[i] : 0;
        if (p1 > p2) return true;
        if (p1 < p2) return false;
      }
    } catch (e) {
      debugPrint('Version parse error: $e');
    }
    return false;
  }
}

