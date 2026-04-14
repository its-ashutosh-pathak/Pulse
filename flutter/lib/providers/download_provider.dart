import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../data/api/api_client.dart';
import '../data/api/music_api.dart';
import '../data/local/download_db.dart';
import '../data/models/song.dart';
import '../core/constants/api_constants.dart';

// ── Download State ──────────────────────────────────────────────────────────

class DownloadProgress {
  final String videoId;
  final double progress; // 0.0 to 1.0
  final bool isComplete;
  final String? error;

  const DownloadProgress({
    required this.videoId,
    this.progress = 0.0,
    this.isComplete = false,
    this.error,
  });
}

class DownloadState {
  final Map<String, DownloadProgress> activeDownloads;
  final int downloadedCount;
  final int totalSizeBytes;

  const DownloadState({
    this.activeDownloads = const {},
    this.downloadedCount = 0,
    this.totalSizeBytes = 0,
  });

  DownloadState copyWith({
    Map<String, DownloadProgress>? activeDownloads,
    int? downloadedCount,
    int? totalSizeBytes,
  }) {
    return DownloadState(
      activeDownloads: activeDownloads ?? this.activeDownloads,
      downloadedCount: downloadedCount ?? this.downloadedCount,
      totalSizeBytes: totalSizeBytes ?? this.totalSizeBytes,
    );
  }
}

// ── Download Provider ───────────────────────────────────────────────────────

/// Manages offline downloads — replaces downloadManager.js.
/// Downloads audio via backend proxy, saves to app directory, tracks in sqflite.
class DownloadNotifier extends Notifier<DownloadState> {
  final _db = DownloadDb.instance;

  @override
  DownloadState build() {
    Future.microtask(() => _refreshCounts());
    return const DownloadState();
  }

  Future<void> _refreshCounts() async {
    final count = await _db.getDownloadCount();
    final size = await _db.getTotalSize();
    state = state.copyWith(downloadedCount: count, totalSizeBytes: size);
  }

  /// Check if a track is downloaded.
  Future<bool> isDownloaded(String videoId) => _db.isDownloaded(videoId);

  /// Get local file path for playback.
  Future<String?> getFilePath(String videoId) => _db.getFilePath(videoId);

  /// Download a song for offline playback.
  Future<void> downloadSong(Song song) async {
    final videoId = song.videoId;
    if (videoId.isEmpty) return;

    // Skip if already downloaded or currently downloading
    if (await _db.isDownloaded(videoId)) return;
    if (state.activeDownloads.containsKey(videoId)) return;

    // Mark as active
    _updateProgress(videoId, 0.0);

    try {
      // Get download directory
      final appDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory(p.join(appDir.path, 'downloads'));
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final filePath = p.join(downloadDir.path, '$videoId.webm');

      // Download from backend proxy
      final url =
          '${ApiClient.instance.dio.options.baseUrl}${ApiConstants.download(videoId)}';

      await ApiClient.instance.dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _updateProgress(videoId, received / total);
          }
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      // Get file size
      final file = File(filePath);
      final fileSize = await file.length();

      // Save metadata to sqflite
      await _db.saveTrack(
        videoId: videoId,
        title: song.title,
        artist: song.artist,
        album: song.album,
        thumbnail: song.thumbnail,
        duration: song.duration,
        filePath: filePath,
        fileSize: fileSize,
      );

      // Also pre-cache lyrics
      try {
        final musicApi = MusicApi();
        final lyrics = await musicApi.getLyrics(videoId);
        if (lyrics != null) {
          await _db.cacheLyrics(videoId, lyrics.toJson());
        }
      } catch (_) {
        // Lyrics caching is best-effort
      }

      // Mark complete
      _markComplete(videoId);
      await _refreshCounts();
    } catch (e) {
      _markError(videoId, e.toString());
    }
  }

  /// Delete a downloaded track.
  Future<void> deleteDownload(String videoId) async {
    // Delete file from disk
    final filePath = await _db.getFilePath(videoId);
    if (filePath != null) {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    }

    // Remove from database
    await _db.deleteTrack(videoId);
    await _refreshCounts();
  }

  /// Clear all downloads.
  Future<void> clearAll() async {
    // Delete all downloaded files
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory(p.join(appDir.path, 'downloads'));
    if (await downloadDir.exists()) {
      await downloadDir.delete(recursive: true);
    }

    await _db.clearAll();
    state = const DownloadState();
  }

  /// Get all downloaded songs.
  Future<List<Song>> getAllDownloadedSongs() => _db.getAllTracks();

  // ── Internal helpers ──

  void _updateProgress(String videoId, double progress) {
    final updated = Map<String, DownloadProgress>.from(state.activeDownloads);
    updated[videoId] = DownloadProgress(videoId: videoId, progress: progress);
    state = state.copyWith(activeDownloads: updated);
  }

  void _markComplete(String videoId) {
    final updated = Map<String, DownloadProgress>.from(state.activeDownloads);
    updated.remove(videoId);
    state = state.copyWith(activeDownloads: updated);
  }

  void _markError(String videoId, String error) {
    final updated = Map<String, DownloadProgress>.from(state.activeDownloads);
    updated[videoId] = DownloadProgress(
      videoId: videoId,
      progress: 0,
      error: error,
    );
    state = state.copyWith(activeDownloads: updated);
  }
}

// ── Provider Registration ───────────────────────────────────────────────────

final downloadProvider = NotifierProvider<DownloadNotifier, DownloadState>(
  DownloadNotifier.new,
);
