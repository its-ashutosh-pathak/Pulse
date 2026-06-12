import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
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
  final Song? song;
  final double progress; // 0.0 to 1.0
  final bool isComplete;
  final String? error;
  final int receivedBytes;
  final int totalBytes;
  final bool isPaused;
  final CancelToken? cancelToken;

  const DownloadProgress({
    required this.videoId,
    this.song,
    this.progress = 0.0,
    this.isComplete = false,
    this.error,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.isPaused = false,
    this.cancelToken,
  });

  DownloadProgress copyWith({
    String? videoId,
    Song? song,
    double? progress,
    bool? isComplete,
    String? error,
    int? receivedBytes,
    int? totalBytes,
    bool? isPaused,
    CancelToken? cancelToken,
  }) {
    return DownloadProgress(
      videoId: videoId ?? this.videoId,
      song: song ?? this.song,
      progress: progress ?? this.progress,
      isComplete: isComplete ?? this.isComplete,
      error: error ?? this.error,
      receivedBytes: receivedBytes ?? this.receivedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      isPaused: isPaused ?? this.isPaused,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }
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

class DownloadNotifier extends Notifier<DownloadState> {
  final _db = DownloadDb.instance;

  @override
  DownloadState build() {
    Future.microtask(() => _refreshCounts());
    return const DownloadState();
  }

  final List<_DownloadTask> _queue = [];
  int _activeTaskCount = 0;
  static const int _maxConcurrent = 5;

  Future<void> _refreshCounts() async {
    final count = await _db.getDownloadCount();
    final size = await _db.getTotalSize();
    state = state.copyWith(downloadedCount: count, totalSizeBytes: size);
  }

  Future<bool> isDownloaded(String videoId) => _db.isDownloaded(videoId);
  Future<String?> getFilePath(String videoId) => _db.getFilePath(videoId);

  void downloadSong(Song song, {Playlist? contextPlaylist}) {
    final videoId = song.videoId;
    if (videoId.isEmpty) return;

    if (state.activeDownloads.containsKey(videoId)) {
      final active = state.activeDownloads[videoId]!;
      if (!active.isPaused && active.error == null) return; // Already downloading/queued
    }
    
    final cancelToken = CancelToken();
    _updateProgress(videoId, 0.0, song: song, cancelToken: cancelToken, isPaused: false);

    _queue.add(_DownloadTask(song: song, contextPlaylist: contextPlaylist, cancelToken: cancelToken));
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_queue.isEmpty || _activeTaskCount >= _maxConcurrent) return;

    final task = _queue.removeAt(0);
    _activeTaskCount++;
    
    try {
      await _executeDownload(task.song, task.cancelToken, contextPlaylist: task.contextPlaylist);
    } finally {
      _activeTaskCount--;
      _processQueue();
    }
  }

  Future<void> _executeDownload(Song song, CancelToken cancelToken, {Playlist? contextPlaylist}) async {
    final videoId = song.videoId;

    if (await _db.isDownloaded(videoId)) {
      _markComplete(videoId);
      return;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory(p.join(appDir.path, 'downloads'));
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final dlQuality = ref.read(settingsProvider).downloadQuality;
      String? directUrl;
      String ext = 'm4a';
      try {
        directUrl = await StreamExtractor.getAudioStreamUrl(videoId, quality: dlQuality)
            .timeout(const Duration(seconds: 20));
        if (directUrl.contains('mime=audio%2Fwebm') || directUrl.contains('mime=audio/webm')) {
          ext = 'webm';
        } else if (directUrl.contains('mime=audio%2Fmp4') || directUrl.contains('mime=audio/mp4')) {
          ext = 'm4a';
        }
      } catch (e) {
        debugPrint('[Download] Client extraction failed: $e');
        throw Exception('Stream extraction failed');
      }

      final tempPath = p.join(downloadDir.path, '$videoId.tmp');
      final tempFile = File(tempPath);
      
      int downloadedBytes = 0;
      if (await tempFile.exists()) {
        downloadedBytes = await tempFile.length();
      }

      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 300),
      ));
      
      final response = await dio.get<ResponseBody>(
        directUrl,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Range': 'bytes=$downloadedBytes-',
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36',
            'Origin': 'https://www.youtube.com',
            'Referer': 'https://www.youtube.com/',
          },
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      final totalHeader = response.headers.value(HttpHeaders.contentRangeHeader);
      int totalLength = 0;
      if (totalHeader != null && totalHeader.contains('/')) {
        totalLength = int.tryParse(totalHeader.split('/').last) ?? 0;
      } else {
        totalLength = int.tryParse(response.headers.value(HttpHeaders.contentLengthHeader) ?? '0') ?? 0;
        totalLength += downloadedBytes;
      }
      
      // Add a realistic 150KB for cover art and lyrics instead of 2MB
      final estimatedTotalData = totalLength + (150 * 1024); 

      final sink = tempFile.openWrite(mode: FileMode.append);
      int currentBytes = downloadedBytes;

      try {
        await for (final chunk in response.data!.stream) {
          if (cancelToken.isCancelled) {
            await sink.close();
            return; // Paused/Cancelled
          }
          sink.add(chunk);
          currentBytes += chunk.length;
          _updateProgress(
            videoId, 
            totalLength > 0 ? currentBytes / totalLength : 0.5,
            song: song,
            receivedBytes: currentBytes,
            totalBytes: estimatedTotalData,
            cancelToken: cancelToken,
          );
        }
      } finally {
        await sink.close();
      }

      final filePath = p.join(downloadDir.path, '$videoId.$ext');
      await tempFile.rename(filePath);

      int finalFileSize = await File(filePath).length();

      String localThumbnailPath = song.thumbnail;
      try {
        if (song.thumbnail.isNotEmpty) {
          final largeThumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 500);
          final res = await Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 300),
          )).get<List<int>>(
            largeThumb,
            options: Options(responseType: ResponseType.bytes),
          );
          if (res.data != null) {
            final coverDir = Directory(p.join(appDir.path, 'downloads', 'covers'));
            if (!await coverDir.exists()) await coverDir.create(recursive: true);
            final coverFile = File(p.join(coverDir.path, '$videoId.jpg'));
            await coverFile.writeAsBytes(res.data!);
            localThumbnailPath = coverFile.path;
            finalFileSize += await coverFile.length();
          }
        }
      } catch (e) {
        debugPrint('[Download] Thumbnail download failed: $e');
      }

      try {
        final musicApi = MusicApi();
        final lyrics = await musicApi.getLyricsBySong(song);
        if (lyrics != null) {
          await _db.cacheLyrics(videoId, lyrics.toJson());
          // Approximate lyrics size
          finalFileSize += lyrics.toJson().toString().length;
        }
      } catch (e) {
        debugPrint('[Download] Lyrics download failed: $e');
      }

      await _db.saveTrack(
        videoId: videoId,
        title: song.title,
        artist: song.artist,
        album: song.album,
        thumbnail: localThumbnailPath,
        duration: song.duration,
        filePath: filePath,
        fileSize: finalFileSize,
      );

      if (contextPlaylist != null) {
        await _db.addTrackToPlaylist('__pl__${contextPlaylist.id}', contextPlaylist.name, videoId);
      }

      try {
        final onlinePlaylists = ref.read(playlistProvider);
        for (final pl in onlinePlaylists.playlists) {
          if (pl.songs.any((s) => s.videoId == videoId || s.id == videoId)) {
            await _db.addTrackToPlaylist('__pl__${pl.id}', pl.name, videoId);
          }
        }
      } catch (e) {
        debugPrint('[Download] Add to playlist failed: $e');
      }

      _markComplete(videoId);
      await _refreshCounts();
    } catch (e) {
      if (cancelToken.isCancelled) return;
      _markError(videoId, e.toString());
    }
  }

  void pauseDownload(String videoId) {
    final active = state.activeDownloads[videoId];
    if (active != null && !active.isPaused) {
      active.cancelToken?.cancel('paused');
      final updated = Map<String, DownloadProgress>.from(state.activeDownloads);
      updated[videoId] = active.copyWith(isPaused: true);
      state = state.copyWith(activeDownloads: updated);
    }
  }

  void resumeDownload(String videoId) {
    final active = state.activeDownloads[videoId];
    if (active != null && (active.isPaused || active.error != null) && active.song != null) {
      downloadSong(active.song!);
    }
  }

  Future<void> cancelAndRemoveDownload(String videoId) async {
    _queue.removeWhere((t) => t.song.videoId == videoId);
    if (state.activeDownloads.containsKey(videoId)) {
      final active = state.activeDownloads[videoId]!;
      active.cancelToken?.cancel();
      _markComplete(videoId); // Removes from active state
    }
    final appDir = await getApplicationDocumentsDirectory();
    final tempPath = p.join(appDir.path, 'downloads', '$videoId.tmp');
    final tempFile = File(tempPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  }

  Future<void> deleteDownload(String videoId) async {
    if (state.activeDownloads.containsKey(videoId)) {
      debugPrint('[Download] Cannot delete $videoId while it is actively downloading');
      return;
    }
    final filePath = await _db.getFilePath(videoId);
    if (filePath != null) {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    }
    final appDir = await getApplicationDocumentsDirectory();
    final coverFile = File(p.join(appDir.path, 'downloads', 'covers', '$videoId.jpg'));
    if (await coverFile.exists()) await coverFile.delete();
    await _db.deleteTrack(videoId);
    await _refreshCounts();
  }

  Future<void> clearAll() async {
    if (state.activeDownloads.isNotEmpty) return;
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory(p.join(appDir.path, 'downloads'));
    if (await downloadDir.exists()) {
      await downloadDir.delete(recursive: true);
    }
    await _db.clearAll();
    state = const DownloadState();
  }

  Future<List<Song>> getAllDownloadedSongs() => _db.getAllTracks();
  Future<List<Playlist>> getAllOfflinePlaylists() => _db.getAllOfflinePlaylists();
  Future<List<Song>> getPlaylistTracks(String playlistId) => _db.getPlaylistTracks(playlistId);
  Future<void> renameOfflinePlaylist(String playlistId, String newName) => _db.renameOfflinePlaylist(playlistId, newName);
  Future<void> updateOfflinePlaylistSongs(String playlistId, List<String> videoIds) => _db.updateOfflinePlaylistSongs(playlistId, videoIds);
  Future<void> deleteOfflinePlaylist(String playlistId) => _db.deleteOfflinePlaylist(playlistId);

  void _updateProgress(String videoId, double progress, {Song? song, int receivedBytes = 0, int totalBytes = 0, CancelToken? cancelToken, bool? isPaused}) {
    final updated = Map<String, DownloadProgress>.from(state.activeDownloads);
    final existing = updated[videoId];
    updated[videoId] = DownloadProgress(
      videoId: videoId,
      song: song ?? existing?.song,
      progress: progress,
      receivedBytes: receivedBytes > 0 ? receivedBytes : (existing?.receivedBytes ?? 0),
      totalBytes: totalBytes > 0 ? totalBytes : (existing?.totalBytes ?? 0),
      cancelToken: cancelToken ?? existing?.cancelToken,
      isPaused: isPaused ?? existing?.isPaused ?? false,
    );
    state = state.copyWith(activeDownloads: updated);
  }

  void _markComplete(String videoId) {
    final updated = Map<String, DownloadProgress>.from(state.activeDownloads);
    updated.remove(videoId);
    state = state.copyWith(activeDownloads: updated);
  }

  void _markError(String videoId, String error) {
    debugPrint('[Download] Download failed for $videoId: $error');
    final updated = Map<String, DownloadProgress>.from(state.activeDownloads);
    final existing = updated[videoId];
    updated[videoId] = DownloadProgress(
      videoId: videoId,
      song: existing?.song,
      progress: 0,
      error: error,
    );
    state = state.copyWith(activeDownloads: updated);
  }
}

class _DownloadTask {
  final Song song;
  final Playlist? contextPlaylist;
  final CancelToken cancelToken;

  _DownloadTask({required this.song, this.contextPlaylist, required this.cancelToken});
}

final downloadProvider = NotifierProvider<DownloadNotifier, DownloadState>(
  DownloadNotifier.new,
);
