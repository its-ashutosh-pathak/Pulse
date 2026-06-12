import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/song.dart';
import '../models/playlist.dart';

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
      version: 2, // Bumped to 2 to trigger migration if needed
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
      onUpgrade: (db, oldVersion, newVersion) async {
        // Migration stubs for future schema changes.
        // Currently v1→v2 has no schema diff, but the hook ensures
        // future versions can add ALTER TABLE statements safely.
        // if (oldVersion < 3) { await db.execute('ALTER TABLE ...'); }
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
              localPath: row['filePath'] as String?,
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
        
    // Auto-delete offline playlists that have become empty
    await db.rawDelete('''
      DELETE FROM offline_playlists
      WHERE id NOT IN (
        SELECT DISTINCT playlistId FROM playlist_tracks
      )
    ''');
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

  /// Rename an offline playlist.
  Future<void> renameOfflinePlaylist(String playlistId, String newName) async {
    final db = await database;
    await db.update(
      'offline_playlists',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [playlistId],
    );
  }

  /// Update songs in an offline playlist (handles removals/reordering).
  Future<void> updateOfflinePlaylistSongs(String playlistId, List<String> videoIds) async {
    final db = await database;
    
    // Auto-delete if empty
    if (videoIds.isEmpty) {
      await deleteOfflinePlaylist(playlistId);
      return;
    }
    
    await db.transaction((txn) async {
      await txn.delete('playlist_tracks', where: 'playlistId = ?', whereArgs: [playlistId]);
      for (int i = 0; i < videoIds.length; i++) {
        await txn.insert(
          'playlist_tracks',
          {
            'playlistId': playlistId,
            'videoId': videoIds[i],
            'position': i,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }

  /// Delete an offline playlist entirely.
  Future<void> deleteOfflinePlaylist(String playlistId) async {
    final db = await database;
    await db.delete('offline_playlists', where: 'id = ?', whereArgs: [playlistId]);
    await db.delete('playlist_tracks', where: 'playlistId = ?', whereArgs: [playlistId]);
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
              localPath: row['filePath'] as String?,
            ))
        .toList();
  }

  /// Get all offline playlists.
  Future<List<Playlist>> getAllOfflinePlaylists() async {
    final db = await database;
    
    // Fetch playlists and only the thumbnail of the first track
    final rows = await db.rawQuery('''
      SELECT 
        op.id as playlistId, op.name as playlistName, op.createdAt,
        (SELECT COUNT(*) FROM playlist_tracks WHERE playlistId = op.id) as trackCount,
        (SELECT dt.thumbnail 
         FROM playlist_tracks pt 
         JOIN downloaded_tracks dt ON pt.videoId = dt.videoId 
         WHERE pt.playlistId = op.id 
         ORDER BY pt.position ASC 
         LIMIT 1) as thumbnail
      FROM offline_playlists op
      ORDER BY op.createdAt DESC
    ''');
    
    return rows.map((row) {
      return Playlist(
        id: row['playlistId'] as String,
        name: row['playlistName'] as String,
        type: 'OFFLINE_PLAYLIST',
        songs: [], // Lazy loaded
        totalTracks: row['trackCount'] as int?,
        thumbnail: row['thumbnail'] as String?,
      );
    }).toList();
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
