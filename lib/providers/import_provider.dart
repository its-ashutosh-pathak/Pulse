import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/music_api.dart';
import '../data/models/song.dart';
import '../services/spotify_parser.dart';
import 'playlist_provider.dart';

// ── User-Agent pool ─────────────────────────────────────────────────────────
const _userAgents = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0',
  'Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0',
  'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.82 Mobile Safari/537.36',
];

// ── ImportTask model ─────────────────────────────────────────────────────────
class ImportTask {
  final String id;
  final String url;
  final String name;
  final int totalSongs;
  final int processedSongs;
  final int matchedSongs;
  /// 'queued' | 'fetching' | 'matching' | 'saving' | 'done' | 'error'
  final String status;
  final bool isSpotify;
  final String? clientId;

  ImportTask({
    required this.id,
    required this.url,
    required this.name,
    this.totalSongs = 0,
    this.processedSongs = 0,
    this.matchedSongs = 0,
    this.status = 'fetching',
    required this.isSpotify,
    this.clientId,
  });

  ImportTask copyWith({
    String? name,
    int? totalSongs,
    int? processedSongs,
    int? matchedSongs,
    String? status,
  }) {
    return ImportTask(
      id: id,
      url: url,
      name: name ?? this.name,
      totalSongs: totalSongs ?? this.totalSongs,
      processedSongs: processedSongs ?? this.processedSongs,
      matchedSongs: matchedSongs ?? this.matchedSongs,
      status: status ?? this.status,
      isSpotify: isSpotify,
      clientId: clientId,
    );
  }

  bool get isActive => status == 'fetching' || status == 'matching' || status == 'saving';
  bool get isQueued => status == 'queued';
}

// ── ImportNotifier ───────────────────────────────────────────────────────────
class ImportNotifier extends StateNotifier<Map<String, ImportTask>> {
  final Ref ref;
  final _rng = Random();

  ImportNotifier(this.ref) : super({});

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> startImport(String url, {String? clientId}) async {
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    final isSpotify = url.contains('spotify.com') || url.contains('spotify.link');

    // Check if anything is already running
    final hasActive = state.values.any((t) => t.isActive);

    state = {
      ...state,
      taskId: ImportTask(
        id: taskId,
        url: url,
        name: hasActive ? 'Waiting in queue...' : 'Parsing URL...',
        isSpotify: isSpotify,
        clientId: clientId,
        status: hasActive ? 'queued' : 'fetching',
      ),
    };

    if (!hasActive) {
      _runTask(taskId);
    }
  }

  void dismissTask(String taskId) {
    final newState = {...state};
    newState.remove(taskId);
    state = newState;
  }

  // ── Task runner ─────────────────────────────────────────────────────────────

  void _runTask(String taskId) {
    final task = state[taskId];
    if (task == null) return;

    _executeTask(taskId).then((_) {
      _onTaskFinished(taskId);
    });
  }

  Future<void> _executeTask(String taskId) async {
    final task = state[taskId]!;
    try {
      if (task.isSpotify) {
        await _importSpotify(taskId, task.url, clientId: task.clientId);
      } else {
        await _importYtMusic(taskId, task.url);
      }
    } catch (e) {
      String errMsg = 'Error importing playlist';
      final eStr = e.toString();
      if (eStr.contains('highly populated')) {
        errMsg = eStr.replaceFirst('Exception: ', '');
      }
      if (state.containsKey(taskId)) {
        state = {
          ...state,
          taskId: state[taskId]!.copyWith(name: errMsg, status: 'error'),
        };
      }
    }
  }

  void _onTaskFinished(String finishedTaskId) {
    // Find the oldest queued task and start it
    final queued = state.values
        .where((t) => t.isQueued)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    if (queued.isEmpty) return;

    final next = queued.first;
    state = {
      ...state,
      next.id: next.copyWith(name: 'Parsing URL...', status: 'fetching'),
    };
    _runTask(next.id);
  }

  // ── Spotify Import ──────────────────────────────────────────────────────────

  Future<void> _importSpotify(String taskId, String url, {String? clientId}) async {
    _updateTask(taskId, name: 'Fetching Spotify Metadata...', status: 'fetching');

    final SpotifyPlaylist playlist;
    if (clientId != null) {
      playlist = await SpotifyParser.getPlaylist(url, clientId: clientId);
    } else {
      playlist = await SpotifyParser.scrapePlaylist(url);
    }

    if (playlist.tracks.isEmpty) throw Exception('Playlist is empty or private');

    _updateTask(
      taskId,
      name: playlist.name,
      totalSongs: playlist.tracks.length,
      status: 'matching',
    );

    // Pick a random UA for this session
    final ua = _userAgents[_rng.nextInt(_userAgents.length)];

    // ── Create empty playlist immediately (incremental save) ────────────────
    final playlistId = await ref.read(playlistProvider.notifier).createPlaylist(
      name: playlist.name,
      initialSongs: [],
    );
    if (playlistId == null) throw Exception('Failed to create local playlist');

    final api = MusicApi();
    int matched = 0;

    for (int i = 0; i < playlist.tracks.length; i++) {
      if (!state.containsKey(taskId)) return; // task was dismissed

      final track = playlist.tracks[i];

      // ── Jitter delay ───────────────────────────────────────────────────────
      final minMs = playlist.tracks.length <= 100 ? 400 : 800;
      final maxMs = playlist.tracks.length <= 100 ? 900 : 2000;
      await Future.delayed(Duration(milliseconds: minMs + _rng.nextInt(maxMs - minMs)));

      // ── Retry loop (3 attempts) ────────────────────────────────────────────
      bool success = false;
      for (int attempt = 0; attempt < 3 && !success; attempt++) {
        try {
          final res = await api.searchAll('${track.title} ${track.artist}');
          final songs = res['songs'] as List<Song>?;
          if (songs != null && songs.isNotEmpty) {
            // ── Incremental save — fire-and-forget ─────────────────────────
            ref.read(playlistProvider.notifier).addSongToPlaylist(playlistId, songs.first);
            matched++;
            success = true;
          }
        } on DioException catch (e) {
          final code = e.response?.statusCode;
          if (code == 429 || code == 403) {
            // ── Exponential backoff on rate-limit ──────────────────────────
            final cooldown = 30 + _rng.nextInt(30); // 30–60 seconds
            _updateTask(taskId, name: '${playlist.name} (rate limited — cooling down ${cooldown}s)');
            await Future.delayed(Duration(seconds: cooldown));
            _updateTask(taskId, name: playlist.name);
            // Retry same song immediately (don't increment attempt)
            attempt--;
          } else if (attempt < 2) {
            // Backoff between generic retries: 2s, 4s
            await Future.delayed(Duration(seconds: pow(2, attempt + 1).toInt()));
          }
        } catch (_) {
          if (attempt < 2) {
            await Future.delayed(Duration(seconds: pow(2, attempt + 1).toInt()));
          }
        }
      }

      _updateTask(
        taskId,
        processedSongs: i + 1,
        matchedSongs: matched,
      );
    }

    _updateTask(taskId, status: 'done');
  }

  // ── YT Music Import (mechanism unchanged — just queue-wrapped) ──────────────

  Future<void> _importYtMusic(String taskId, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) throw Exception('Invalid URL');

    final listParam = uri.queryParameters['list'];
    if (listParam == null || listParam.isEmpty) {
      throw Exception('Could not find playlist ID (list=) in URL');
    }
    String listId = listParam;

    if (!listId.startsWith('VL') &&
        (listId.startsWith('PL') ||
            listId.startsWith('OLAK') ||
            listId.startsWith('RD'))) {
      listId = 'VL$listId';
    }

    _updateTask(taskId, name: 'Fetching Playlist...', status: 'fetching');

    final api = MusicApi();
    final playlist = await api.getPlaylist(listId, full: true);

    if (playlist.songs.isEmpty) throw Exception('Playlist is empty or private');

    _updateTask(
      taskId,
      name: playlist.name,
      totalSongs: playlist.songs.length,
      status: 'saving',
    );

    final newPlaylistId = await ref.read(playlistProvider.notifier).createPlaylist(
      name: playlist.name,
      initialSongs: playlist.songs,
    );

    if (newPlaylistId == null) throw Exception('Failed to create local playlist');

    _updateTask(taskId, status: 'done');
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _updateTask(
    String taskId, {
    String? name,
    int? totalSongs,
    int? processedSongs,
    int? matchedSongs,
    String? status,
  }) {
    if (!state.containsKey(taskId)) return;
    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        name: name,
        totalSongs: totalSongs,
        processedSongs: processedSongs,
        matchedSongs: matchedSongs,
        status: status,
      ),
    };
  }
}

final importProvider =
    StateNotifierProvider<ImportNotifier, Map<String, ImportTask>>((ref) {
  return ImportNotifier(ref);
});
