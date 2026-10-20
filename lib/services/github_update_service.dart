import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../core/constants/app_constants.dart';

class GitHubUpdateService {
  GitHubUpdateService._();
  static final GitHubUpdateService instance = GitHubUpdateService._();

  static const String repoOwner = 'its-ashutosh-pathak';
  static const String repoName = 'Pulse';
  static String get currentVersion => kAppVersion;

  bool _isChecking = false;

  /// Compares semantic versions (e.g. "3.5.1" > "3.5.0")
  bool _isNewerVersion(String latestTag, String current) {
    try {
      final cleanLatest = latestTag.replaceAll(RegExp(r'[^0-9.]'), '');
      final cleanCurrent = current.replaceAll(RegExp(r'[^0-9.]'), '');

      final latestParts = cleanLatest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final currentParts = cleanCurrent.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      for (int i = 0; i < 3; i++) {
        final l = i < latestParts.length ? latestParts[i] : 0;
        final c = i < currentParts.length ? currentParts[i] : 0;
        if (l > c) return true;
        if (l < c) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Checks GitHub Releases for a newer full binary release (APK or Windows Setup).
  Future<void> checkForUpdates({
    required BuildContext context,
    bool silentIfUpToDate = true,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isWindows)) {
      return;
    }

    if (_isChecking) return;
    _isChecking = true;

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.github.com/repos/$repoOwner/$repoName/releases/latest',
        options: Options(
          headers: {'Accept': 'application/vnd.github.v3+json'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final tagName = data['tag_name'] as String? ?? '';
        final releaseNotes = data['body'] as String? ?? 'Bug fixes and performance improvements.';
        final assets = (data['assets'] as List<dynamic>?) ?? [];

        if (_isNewerVersion(tagName, currentVersion)) {
          // Find matching asset: .apk for Android, .exe for Windows
          String? downloadUrl;
          String? fileName;

          for (final asset in assets) {
            final name = asset['name'] as String? ?? '';
            final url = asset['browser_download_url'] as String?;

            if (Platform.isAndroid && name.endsWith('.apk')) {
              downloadUrl = url;
              fileName = name;
              break;
            } else if (Platform.isWindows && name.endsWith('.exe')) {
              downloadUrl = url;
              fileName = name;
              break;
            }
          }

          if (downloadUrl != null && fileName != null && context.mounted) {
            _showUpdateDialog(
              context: context,
              newVersion: tagName,
              releaseNotes: releaseNotes,
              downloadUrl: downloadUrl,
              fileName: fileName,
            );
          }
        } else if (!silentIfUpToDate && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pulse is already up to date!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[GitHubUpdateService] Error checking for updates: $e');
    } finally {
      _isChecking = false;
    }
  }

  void _showUpdateDialog({
    required BuildContext context,
    required String newVersion,
    required String releaseNotes,
    required String downloadUrl,
    required String fileName,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return _UpdateDownloadDialog(
          newVersion: newVersion,
          releaseNotes: releaseNotes,
          downloadUrl: downloadUrl,
          fileName: fileName,
        );
      },
    );
  }
}

class _UpdateDownloadDialog extends StatefulWidget {
  final String newVersion;
  final String releaseNotes;
  final String downloadUrl;
  final String fileName;

  const _UpdateDownloadDialog({
    required this.newVersion,
    required this.releaseNotes,
    required this.downloadUrl,
    required this.fileName,
  });

  @override
  State<_UpdateDownloadDialog> createState() => _UpdateDownloadDialogState();
}

class _UpdateDownloadDialogState extends State<_UpdateDownloadDialog> {
  bool _downloading = false;
  double _progress = 0.0;
  String _status = '';

  Future<void> _startDownload() async {
    setState(() {
      _downloading = true;
      _status = 'Downloading update...';
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${widget.fileName}';

      final dio = Dio();
      await dio.download(
        widget.downloadUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
              _status = '${((_progress * 100).toInt())}% downloaded';
            });
          }
        },
      );

      setState(() {
        _status = 'Installing...';
      });

      if (Platform.isWindows) {
        // Run Inno Setup installer silently or normally
        await Process.start(filePath, ['/SILENT', '/NORESTART']);
        exit(0);
      } else {
        // Android: Open APK using OpenFilex to trigger system package installer
        final result = await OpenFilex.open(filePath);
        if (result.type != ResultType.done) {
          setState(() {
            _status = 'Error opening APK: ${result.message}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _status = 'Download failed: $e';
        _downloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF18181B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.system_update_rounded, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            'Update Available (${widget.newVersion})',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.releaseNotes,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          if (_downloading) ...[
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _progress > 0 ? _progress : null,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _status,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (!_downloading) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _startDownload,
            child: const Text('Update Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ],
    );
  }
}
