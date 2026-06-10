import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../core/utils/thumbnail_utils.dart';
import '../data/api/music_api.dart';
import '../data/local/download_db.dart';
import '../data/models/song.dart';
import '../data/models/playlist.dart';
import 'playlist_provider.dart';
import 'settings_provider.dart';
import '../services/stream_extractor.dart';

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
  Future<void> downloadSong(Song song, {Playlist? contextPlaylist}) async {
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
      // ── PRIMARY: Get direct CDN URL via youtube_explode_dart ──
      // Downloads directly from YouTube CDN on the user's phone IP.
      // No backend bandwidth consumed. Fast — CDN is geographically distributed.
      final dlQuality = ref.read(settingsProvider).downloadQuality;
      String? directUrl;
      String ext = 'm4a'; // default — YTE prefers m4a streams
      try {
        directUrl = await StreamExtractor.getAudioStreamUrl(videoId, quality: dlQuality)
            .timeout(const Duration(seconds: 20));
        // YTE v2.5.3 prefers m4a; the URL path usually reveals the container
        if (directUrl.contains('mime=audio%2Fwebm') ||
            directUrl.contains('mime=audio/webm')) {
          ext = 'webm';
        } else if (directUrl.contains('mime=audio%2Fmp4') ||
            directUrl.contains('mime=audio/mp4')) {
          ext = 'm4a';
        }
      } catch (e) {
        debugPrint('[Download] Client extraction failed: $e. Falling back to backend.');
      }

      final tempPath = p.join(downloadDir.path, '$videoId.tmp');

      if (directUrl != null) {
        // Download directly from YouTube CDN.
        // IMPORTANT: YouTube CDN requires these headers or returns 403:
        //   - Range: bytes=0-  → CDN serves partial content only; this triggers it
        //   - User-Agent       → must match the client used during stream extraction
        await Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 300),
          headers: {
            'Range': 'bytes=0-',
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 14; Pixel 8) '  
                'AppleWebKit/537.36 (KHTML, like Gecko) '     
                'Chrome/124.0.0.0 Mobile Safari/537.36',
            'Origin': 'https://www.youtube.com',
            'Referer': 'https://www.youtube.com/',
          },
        )).download(
          directUrl,
          tempPath,
          deleteOnError: true,
          onReceiveProgress: (received, total) {
            if (total > 0) {
              _updateProgress(videoId, received / total);
            } else {
              // CDN may not send Content-Length for partial-content responses;
              // show indeterminate progress (value = -1 maps to 0.5 in UI)
              _updateProgress(videoId, 0.5);
            }
          },
          options: Options(
            followRedirects: true,
            maxRedirects: 5,
            // Accept both 200 OK and 206 Partial Content
            validateStatus: (status) => status != null && status < 400,
          ),
        );
      }

      // Move temp file to final path using detected extension
      final filePath = p.join(downloadDir.path, '$videoId.$ext');
      await File(tempPath).rename(filePath);

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

      // Add to context playlist if provided
      if (contextPlaylist != null) {
        await _db.addTrackToPlaylist(
          '__pl__${contextPlaylist.id}',
          contextPlaylist.name,
          videoId,
        );
      }

      // Background scan to link song to ANY existing user playlists
      try {
        final onlinePlaylists = ref.read(playlistProvider);
        for (final pl in onlinePlaylists.playlists) {
          if (pl.songs.any((s) => s.videoId == videoId || s.id == videoId)) {
            await _db.addTrackToPlaylist('__pl__${pl.id}', pl.name, videoId);
          }
        }
      } catch (e) {
        debugPrint('[Download] Offline Playlist Scan skipped: $e');
      }

      // Also pre-cache lyrics
      try {
        final musicApi = MusicApi();
        final lyrics = await musicApi.getLyricsBySong(song);
        if (lyrics != null) {
          await _db.cacheLyrics(videoId, lyrics.toJson());
        }
      } catch (_) {
        // Lyrics caching is best-effort
      }

      // Also pre-cache thumbnails forever
      try {
        if (song.thumbnail.isNotEmpty) {
          final smallThumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 120);
          final largeThumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 500);

          Future<void> cacheImage(String url) async {
            final res = await Dio().get<List<int>>(
              url,
              options: Options(responseType: ResponseType.bytes),
            );
            if (res.data != null) {
              final bytes = Uint8List.fromList(res.data!);
              await DefaultCacheManager().putFile(
                url,
                bytes,
                fileExtension: 'jpg',
                maxAge: const Duration(days: 36500),
              );
            }
          }

          await cacheImage(smallThumb);
          if (smallThumb != largeThumb) {
            await cacheImage(largeThumb);
          }
        }
      } catch (e) {
        debugPrint('[Download] Thumbnail caching failed: $e');
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

  /// Get all offline playlists.
  Future<List<Playlist>> getAllOfflinePlaylists() => _db.getAllOfflinePlaylists();

  /// Rename an offline playlist.
  Future<void> renameOfflinePlaylist(String playlistId, String newName) => _db.renameOfflinePlaylist(playlistId, newName);

  /// Update songs in an offline playlist.
  Future<void> updateOfflinePlaylistSongs(String playlistId, List<String> videoIds) => _db.updateOfflinePlaylistSongs(playlistId, videoIds);

  /// Delete an offline playlist.
  Future<void> deleteOfflinePlaylist(String playlistId) => _db.deleteOfflinePlaylist(playlistId);

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
