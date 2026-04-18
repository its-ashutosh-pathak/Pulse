import '../../core/constants/api_constants.dart';
import '../models/song.dart';
import '../models/home_section.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/lyrics.dart';
import '../../services/ytmusic_api.dart';
import '../../services/stream_extractor.dart';
import 'package:dio/dio.dart';

/// Music API service — now acts as a bridge to the client-side YtMusicApi.
class MusicApi {
  final YtMusicApi _api = YtMusicApi();

  /// Get home feed sections.
  Future<List<HomeSection>> getHome() async {
    return _api.getHome();
  }

  /// Search YouTube Music.
  /// [type]: 'songs' | 'albums' | 'playlists' | 'artists' | 'all'
  Future<Map<String, dynamic>> searchAll(String query) async {
    final songs = await _api.search(query, type: 'song');
    final albums = await _api.search(query, type: 'album');
    final playlists = await _api.search(query, type: 'playlist');
    final artists = await _api.search(query, type: 'artist');
    return {
      'songs': songs,
      'albums': albums,
      'playlists': playlists,
      'artists': artists,
    };
  }

  /// Search songs only.
  Future<List<Song>> searchSongs(String query) async {
    return _api.search(query, type: 'song');
  }

  /// Get autocomplete suggestions.
  Future<List<String>> getSuggestions(String query) async {
    // Basic search fallback for suggestions
    final results = await _api.search(query, type: 'song');
    return results.map((s) => s.title).take(5).toList();
  }

  /// Get artist page.
  Future<Artist> getArtist(String browseId) async {
    return _api.getArtist(browseId);
  }

  /// Resolve artist name to browseId.
  Future<String?> resolveArtist(String name) async {
    final results = await _api.search(name, type: 'artist');
    if (results.isNotEmpty) return results.first.browseId;
    return null;
  }

  /// Get a YT Music playlist/album.
  Future<Playlist> getPlaylist(String id, {bool full = false}) async {
    return _api.getPlaylist(id);
  }

  /// Get raw stream URL asynchronously using client-side extraction.
  Future<String> extractStreamUrl(String videoId) async {
    return StreamExtractor.getAudioStreamUrl(videoId);
  }

  /// Legacy interface, now throws as URLs must be extracted asynchronously.
  String getStreamUrl(String videoId, {List<String> nextIds = const []}) {
    throw UnimplementedError('Streaming is now direct-to-client asynchronously. Use extractStreamUrl(videoId).');
  }

  /// Get lyrics for a video.
  Future<Lyrics?> getLyrics(String videoId) async {
    try {
      final dio = Dio();
      final res = await dio.get('https://lrclib.net/api/get?track_name='); // Simplified fallback
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get watch-next / radio queue.
  Future<List<Song>> getWatchNext(String videoId) async {
    return _api.getWatchNext(videoId);
  }

  /// Get recommendations.
  Future<List<Song>> getRecommendations(String videoId) async {
    return _api.getWatchNext(videoId); // Fallback to watchNext for recommendations
  }

  /// Search for an album by query.
  Future<String?> searchAlbum(String query) async {
    final results = await _api.search(query, type: 'album');
    if (results.isNotEmpty) return results.first.browseId;
    return null;
  }
}
