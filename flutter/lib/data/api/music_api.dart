import '../../core/constants/api_constants.dart';
import '../models/song.dart';
import '../models/home_section.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/lyrics.dart';
import 'api_client.dart';

/// Music API service — wraps all /api/* endpoints from music.routes.js.
class MusicApi {
  final _dio = ApiClient.instance.dio;

  /// Get home feed sections.
  Future<List<HomeSection>> getHome() async {
    final response = await _dio.get(ApiConstants.home);
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => HomeSection.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Search YouTube Music.
  /// [type]: 'songs' | 'albums' | 'playlists' | 'artists' | 'all'
  Future<Map<String, dynamic>> searchAll(String query) async {
    final response = await _dio.get(
      ApiConstants.search,
      queryParameters: {'q': query, 'type': 'all'},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return {
      'songs': (data['songs'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      'albums': (data['albums'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      'playlists': (data['playlists'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      'artists': (data['artists'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    };
  }

  /// Search songs only.
  Future<List<Song>> searchSongs(String query) async {
    final response = await _dio.get(
      ApiConstants.search,
      queryParameters: {'q': query, 'type': 'songs'},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => Song.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get autocomplete suggestions.
  Future<List<String>> getSuggestions(String query) async {
    final response = await _dio.get(
      ApiConstants.suggestions,
      queryParameters: {'q': query},
    );
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  /// Get artist page.
  Future<Artist> getArtist(String browseId) async {
    final response = await _dio.get(ApiConstants.artist(browseId));
    return Artist.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Resolve artist name to browseId.
  Future<String?> resolveArtist(String name) async {
    final response = await _dio.get(
      ApiConstants.artistResolve,
      queryParameters: {'name': name},
    );
    return response.data['data']?['browseId']?.toString();
  }

  /// Get a YT Music playlist/album.
  Future<Playlist> getPlaylist(String id, {bool full = false}) async {
    final response = await _dio.get(
      ApiConstants.ytPlaylist(id),
      queryParameters: full ? {'full': 'true'} : null,
    );
    return Playlist.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Get stream URLs for a video (used when playing via backend proxy).
  /// Returns the full stream data including URL and metadata.
  Future<Map<String, dynamic>> getPlayData(
    String videoId, {
    List<String> nextIds = const [],
  }) async {
    final response = await _dio.get(
      ApiConstants.play(videoId),
      queryParameters: {
        if (nextIds.isNotEmpty) 'next': nextIds.join(','),
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Get the proxied stream URL for playback.
  /// The Flutter audio player will use this URL directly.
  String getStreamUrl(String videoId, {List<String> nextIds = const []}) {
    final base = ApiClient.instance.dio.options.baseUrl;
    final nextParam =
        nextIds.isNotEmpty ? '&next=${nextIds.join(',')}' : '';
    return '$base${ApiConstants.stream(videoId)}?$nextParam';
  }

  /// Get lyrics for a video.
  Future<Lyrics?> getLyrics(String videoId) async {
    try {
      final response = await _dio.get(ApiConstants.lyrics(videoId));
      if (response.data['success'] == true && response.data['data'] != null) {
        return Lyrics.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get watch-next / radio queue.
  Future<List<Song>> getWatchNext(String videoId) async {
    final response = await _dio.get(ApiConstants.watchNext(videoId));
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => Song.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get recommendations.
  Future<List<Song>> getRecommendations(String videoId) async {
    final response = await _dio.get(ApiConstants.recommendations(videoId));
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => Song.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Search for an album by query.
  Future<String?> searchAlbum(String query) async {
    final response = await _dio.get(
      ApiConstants.albumSearch,
      queryParameters: {'q': query},
    );
    return response.data['data']?['browseId']?.toString();
  }
}
