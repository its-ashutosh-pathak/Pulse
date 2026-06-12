import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/music_api.dart';
import '../data/models/song.dart';
import '../services/spotify_parser.dart';
import 'download_provider.dart';
import 'playlist_provider.dart';

class ImportTask {
  final String id;
  final String url;
  final String name;
  final int totalSongs;
  final int processedSongs;
  final String status; // 'fetching', 'matching', 'saving', 'done', 'error'
  final bool isSpotify;

  ImportTask({
    required this.id,
    required this.url,
    required this.name,
    this.totalSongs = 0,
    this.processedSongs = 0,
    this.status = 'fetching',
    required this.isSpotify,
  });

  ImportTask copyWith({
    String? name,
    int? totalSongs,
    int? processedSongs,
    String? status,
  }) {
    return ImportTask(
      id: id,
      url: url,
      name: name ?? this.name,
      totalSongs: totalSongs ?? this.totalSongs,
      processedSongs: processedSongs ?? this.processedSongs,
      status: status ?? this.status,
      isSpotify: isSpotify,
    );
  }
}

class ImportNotifier extends StateNotifier<Map<String, ImportTask>> {
  final Ref ref;
  ImportNotifier(this.ref) : super({});

  Future<void> startImport(String url) async {
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    final isSpotify = url.contains('spotify.com') || url.contains('spotify.link');
    
    state = {
      ...state,
      taskId: ImportTask(
        id: taskId,
        url: url,
        name: 'Parsing URL...',
        isSpotify: isSpotify,
      ),
    };

    try {
      if (isSpotify) {
        await _importSpotify(taskId, url);
      } else {
        await _importYtMusic(taskId, url);
      }
    } catch (e) {
      String errMsg = 'Error importing playlist';
      final eStr = e.toString();
      if (eStr.contains('highly populated')) {
        errMsg = eStr.replaceFirst('Exception: ', '');
      }
      state = {
        ...state,
        taskId: state[taskId]!.copyWith(
          name: errMsg,
          status: 'error',
        ),
      };
    }
  }

  Future<void> _importSpotify(String taskId, String url) async {
    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        name: 'Fetching Spotify Metadata...',
        status: 'fetching',
      ),
    };

    final playlist = await SpotifyParser.getPlaylist(url);

    if (playlist.tracks.isEmpty) {
      throw Exception('Playlist is empty or private');
    }

    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        name: playlist.name,
        totalSongs: playlist.tracks.length,
        status: 'matching',
      ),
    };

    final api = MusicApi();
    final matchedSongs = <Song>[];

    for (int i = 0; i < playlist.tracks.length; i++) {
      final track = playlist.tracks[i];
      try {
        final res = await api.searchAll(track.query);
        final songs = res['songs'] as List<Song>?;
        if (songs != null && songs.isNotEmpty) {
          matchedSongs.add(songs.first);
        }
      } catch (e) {
        // Skip track on error
      }
      
      // Add a small delay to prevent rate limits
      await Future.delayed(const Duration(milliseconds: 500));

      state = {
        ...state,
        taskId: state[taskId]!.copyWith(
          processedSongs: i + 1,
        ),
      };
    }

    if (matchedSongs.isEmpty) {
      throw Exception('Could not match any songs on YouTube Music');
    }

    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        status: 'saving',
      ),
    };

    final newPlaylistId = await ref.read(playlistProvider.notifier).createPlaylist(
      name: playlist.name,
      initialSongs: matchedSongs,
    );
    
    if (newPlaylistId == null) {
      throw Exception('Failed to create local playlist');
    }

    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        status: 'done',
      ),
    };
  }

  Future<void> _importYtMusic(String taskId, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) throw Exception('Invalid URL');

    final listParam = uri.queryParameters['list'];
    if (listParam == null || listParam.isEmpty) {
      throw Exception('Could not find playlist ID (list=) in URL');
    }
    String listId = listParam;
    
    // YT Music InnerTube API requires 'VL' prefix for standard playlists and album playlists
    if (!listId.startsWith('VL') && (listId.startsWith('PL') || listId.startsWith('OLAK') || listId.startsWith('RD'))) {
      listId = 'VL$listId';
    }

    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        name: 'Fetching Playlist...',
        status: 'fetching',
      ),
    };

    final api = MusicApi();
    final playlist = await api.getPlaylist(listId, full: true);

    if (playlist.songs.isEmpty) {
      throw Exception('Playlist is empty or private');
    }

    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        name: playlist.name,
        totalSongs: playlist.songs.length,
        status: 'saving',
      ),
    };

    // Create a new local playlist instead of downloading
    final newPlaylistId = await ref.read(playlistProvider.notifier).createPlaylist(
      name: playlist.name,
      initialSongs: playlist.songs,
    );
    
    if (newPlaylistId == null) {
      throw Exception('Failed to create local playlist');
    }

    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        status: 'done',
      ),
    };
  }

  void dismissTask(String taskId) {
    final newState = {...state};
    newState.remove(taskId);
    state = newState;
  }
}

final importProvider = StateNotifierProvider<ImportNotifier, Map<String, ImportTask>>((ref) {
  return ImportNotifier(ref);
});
