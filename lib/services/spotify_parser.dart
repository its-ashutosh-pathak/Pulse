import 'package:dio/dio.dart';
import 'package:pulse/services/spotify_embed_scraper.dart';
import 'package:pulse/services/spotify_auth_service.dart';

class SpotifyTrack {
  final String title;
  final String artist;

  SpotifyTrack({required this.title, required this.artist});

  String get query => '$title $artist';
}

class SpotifyPlaylist {
  final String name;
  final int totalTracks;
  final List<SpotifyTrack> tracks;

  SpotifyPlaylist({
    required this.name,
    required this.totalTracks,
    required this.tracks,
  });
}

class SpotifyParser {
  static final _dio = Dio(BaseOptions(
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Pulse/1.0.0',
    },
  ));

  // ── ≤100 tracks path (embed scraper, no auth required) ──────────────────
  static Future<SpotifyPlaylist> scrapePlaylist(String url) async {
    return await SpotifyEmbedScraper.scrapePlaylist(url);
  }

  // ── >100 tracks path (BYOA — requires user's own Client ID + Premium) ───
  static Future<SpotifyPlaylist> getPlaylist(String url, {required String clientId}) async {
    final match = RegExp(r'playlist/([a-zA-Z0-9]+)').firstMatch(url);
    if (match == null) throw Exception('Invalid Spotify playlist URL');

    final userToken = await SpotifyAuthService.getValidAccessToken(clientId);
    if (userToken == null) throw Exception('User token expired or missing. Please reconnect.');

    final playlistId = match.group(1)!;
    final headers = {'Authorization': 'Bearer $userToken'};

    // 1. Metadata
    final metaRes = await _dio.get(
      'https://api.spotify.com/v1/playlists/$playlistId',
      options: Options(headers: headers),
    );
    final name = metaRes.data['name'] ?? 'Spotify Playlist';
    final total = metaRes.data['tracks']['total'] ?? 0;

    // 2. Paginated tracks
    final tracks = <SpotifyTrack>[];
    int offset = 0;
    const limit = 100;

    while (offset < total) {
      final tracksRes = await _dio.get(
        'https://api.spotify.com/v1/playlists/$playlistId/tracks?limit=$limit&offset=$offset',
        options: Options(headers: headers),
      );

      final items = tracksRes.data['items'] as List<dynamic>? ?? [];
      if (items.isEmpty) break;

      for (final item in items) {
        final trackObj = item['track'];
        if (trackObj == null || trackObj['type'] != 'track') continue;
        final title = trackObj['name'] ?? '';
        final artistsList = trackObj['artists'] as List<dynamic>? ?? [];
        final artists = artistsList.map((a) => a['name']).join(', ');
        if (title.isNotEmpty) tracks.add(SpotifyTrack(title: title, artist: artists));
      }

      offset += limit;
    }

    return SpotifyPlaylist(name: name, totalTracks: tracks.length, tracks: tracks);
  }

  /// Fetches all playlists saved in the user's Spotify library (BYOA).
  static Future<List<Map<String, dynamic>>> getUserPlaylists(String clientId) async {
    final token = await SpotifyAuthService.getValidAccessToken(clientId);
    if (token == null) throw Exception('User not authenticated');

    final headers = {'Authorization': 'Bearer $token'};
    final playlists = <Map<String, dynamic>>[];
    int offset = 0;
    const limit = 50;

    while (true) {
      final res = await _dio.get(
        'https://api.spotify.com/v1/me/playlists?limit=$limit&offset=$offset',
        options: Options(headers: headers),
      );

      final items = res.data['items'] as List<dynamic>? ?? [];
      if (items.isEmpty) break;

      for (final item in items) {
        playlists.add({
          'id': item['id'],
          'name': item['name'],
          'tracks': item['tracks']['total'] ?? 0,
          'image': (item['images'] != null && (item['images'] as List).isNotEmpty)
              ? item['images'][0]['url']
              : null,
          'url': item['external_urls']['spotify'],
        });
      }

      offset += limit;
      if (offset >= (res.data['total'] ?? 0)) break;
    }

    return playlists;
  }
}
