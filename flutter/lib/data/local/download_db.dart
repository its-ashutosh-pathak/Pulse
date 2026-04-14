import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/song.dart';

/// Local SQLite database for offline downloads — replaces IndexedDB.
///
/// Schema:
///   downloaded_tracks — track metadata + file path
///   offline_playlists — offline playlist definitions
///   playlist_tracks  — many-to-many relation (playlist ↔ track)
///   cached_lyrics    — lyrics cache
class DownloadDb {
  static DownloadDb? _instance;
  static Database? _db;

  DownloadDb._();

  static DownloadDb get instance {
    _instance ??= DownloadDb._();
    return _instance!;
  }

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'pulse_downloads.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // ── Downloaded Tracks ──
        await db.execute('''
          CREATE TABLE downloaded_tracks (
            videoId TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            artist TEXT NOT NULL,
            album TEXT DEFAULT '',
            thumbnail TEXT DEFAULT '',
            duration INTEGER DEFAULT 0,
            filePath TEXT NOT NULL,
            fileSize INTEGER DEFAULT 0,
            downloadedAt INTEGER NOT NULL
          )
        ''');

        // ── Offline Playlists ──
        await db.execute('''
          CREATE TABLE offline_playlists (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            createdAt INTEGER NOT NULL
          )
        ''');

        // ── Playlist ↔ Track mapping ──
        await db.execute('''
          CREATE TABLE playlist_tracks (
            playlistId TEXT NOT NULL,
            videoId TEXT NOT NULL,
            position INTEGER NOT NULL,
            PRIMARY KEY (playlistId, videoId),
            FOREIGN KEY (playlistId) REFERENCES offline_playlists(id) ON DELETE CASCADE,
            FOREIGN KEY (videoId) REFERENCES downloaded_tracks(videoId) ON DELETE CASCADE
          )
        ''');

        // ── Cached Lyrics ──
        await db.execute('''
          CREATE TABLE cached_lyrics (
            videoId TEXT PRIMARY KEY,
            data TEXT NOT NULL,
            cachedAt INTEGER NOT NULL
          )
        ''');

        // ── Indexes ──
        await db.execute(
            'CREATE INDEX idx_playlist_tracks_playlist ON playlist_tracks(playlistId)');
        await db.execute(
            'CREATE INDEX idx_playlist_tracks_video ON playlist_tracks(videoId)');
      },
    );
  }

  // ── Track CRUD ──

  /// Check if a track is downloaded.
  Future<bool> isDownloaded(String videoId) async {
    final db = await database;
    final result = await db.query(
      'downloaded_tracks',
      where: 'videoId = ?',
      whereArgs: [videoId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Save a downloaded track's metadata.
  Future<void> saveTrack({
    required String videoId,
    required String title,
    required String artist,
    required String album,
    required String thumbnail,
    required int duration,
    required String filePath,
    required int fileSize,
  }) async {
    final db = await database;
    await db.insert(
      'downloaded_tracks',
      {
        'videoId': videoId,
        'title': title,
        'artist': artist,
        'album': album,
        'thumbnail': thumbnail,
        'duration': duration,
        'filePath': filePath,
        'fileSize': fileSize,
        'downloadedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all downloaded tracks.
  Future<List<Song>> getAllTracks() async {
    final db = await database;
    final rows = await db.query('downloaded_tracks', orderBy: 'downloadedAt DESC');
    return rows
        .map((row) => Song(
              id: row['videoId'] as String,
              videoId: row['videoId'] as String,
              title: row['title'] as String,
              artist: row['artist'] as String,
              album: (row['album'] as String?) ?? '',
              thumbnail: (row['thumbnail'] as String?) ?? '',
              duration: (row['duration'] as int?) ?? 0,
            ))
        .toList();
  }

  /// Get the local file path for a downloaded track.
  Future<String?> getFilePath(String videoId) async {
    final db = await database;
    final rows = await db.query(
      'downloaded_tracks',
      columns: ['filePath'],
      where: 'videoId = ?',
      whereArgs: [videoId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['filePath'] as String;
  }

  /// Delete a downloaded track.
  Future<void> deleteTrack(String videoId) async {
    final db = await database;
    await db.delete('downloaded_tracks',
        where: 'videoId = ?', whereArgs: [videoId]);
    await db.delete('playlist_tracks',
        where: 'videoId = ?', whereArgs: [videoId]);
  }

  /// Get total download size in bytes.
  Future<int> getTotalSize() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(fileSize) as total FROM downloaded_tracks');
    return (result.first['total'] as int?) ?? 0;
  }

  /// Get download count.
  Future<int> getDownloadCount() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM downloaded_tracks');
    return (result.first['count'] as int?) ?? 0;
  }

  // ── Offline Playlists ──

  /// Add a track to an offline playlist.
  Future<void> addTrackToPlaylist(
    String playlistId,
    String playlistName,
    String videoId,
  ) async {
    final db = await database;

    // Ensure playlist exists
    await db.insert(
      'offline_playlists',
      {
        'id': playlistId,
        'name': playlistName,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // Get next position
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM playlist_tracks WHERE playlistId = ?',
      [playlistId],
    );
    final position = (countResult.first['count'] as int?) ?? 0;

    await db.insert(
      'playlist_tracks',
      {
        'playlistId': playlistId,
        'videoId': videoId,
        'position': position,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Get tracks for an offline playlist.
  Future<List<Song>> getPlaylistTracks(String playlistId) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT dt.* FROM downloaded_tracks dt
      INNER JOIN playlist_tracks pt ON dt.videoId = pt.videoId
      WHERE pt.playlistId = ?
      ORDER BY pt.position ASC
    ''', [playlistId]);

    return rows
        .map((row) => Song(
              id: row['videoId'] as String,
              videoId: row['videoId'] as String,
              title: row['title'] as String,
              artist: row['artist'] as String,
              album: (row['album'] as String?) ?? '',
              thumbnail: (row['thumbnail'] as String?) ?? '',
              duration: (row['duration'] as int?) ?? 0,
            ))
        .toList();
  }

  // ── Lyrics Cache ──

  /// Cache lyrics for a videoId.
  Future<void> cacheLyrics(String videoId, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'cached_lyrics',
      {
        'videoId': videoId,
        'data': jsonEncode(data),
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get cached lyrics.
  Future<Map<String, dynamic>?> getCachedLyrics(String videoId) async {
    final db = await database;
    final rows = await db.query(
      'cached_lyrics',
      where: 'videoId = ?',
      whereArgs: [videoId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
  }

  // ── Nuke everything ──

  /// Clear all downloads and cached data.
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('playlist_tracks');
    await db.delete('offline_playlists');
    await db.delete('downloaded_tracks');
    await db.delete('cached_lyrics');
  }
}
