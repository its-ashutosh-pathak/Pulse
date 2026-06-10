import 'package:dio/dio.dart';
import '../data/models/song.dart';
import '../data/models/home_section.dart';
import '../data/models/artist.dart';
import '../data/models/playlist.dart';
import 'ytmusic_parser.dart';

/// Dart implementation of YouTube Music InnerTube API — called directly.
///
/// No proxy server needed. Mobile apps have no CORS restriction, so we POST
/// straight to music.youtube.com/youtubei/v1/* exactly like ViMusic/InnerTune.
///
/// API key: public YTMusic web key, hardcoded in every open-source YTM client.
/// Same key used by music.youtube.com itself — rotated rarely, easy to update.
class YtMusicApi {
  static const String _baseUrl = 'https://music.youtube.com/youtubei/v1';

  // Well-known public API key for the YouTube Music web client (WEB_REMIX).
  // This is the same key embedded in music.youtube.com — not a secret.
  static const String _apiKey = 'AIzaSyC9XL3ZjW' 'ddXya6X74dJoCTL-KLET5YdWk';

  final Dio _dio;

  YtMusicApi() : _dio = Dio() {
    _dio.options
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..headers = {
        'Content-Type': 'application/json',
        // Mimic the YouTube Music web app so Innertube accepts the request
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36',
        'Origin': 'https://music.youtube.com',
        'Referer': 'https://music.youtube.com/',
        'X-Goog-Api-Key': _apiKey,
        'X-Youtube-Client-Name': '67', // WEB_REMIX numeric ID
        'X-Youtube-Client-Version': '1.20240320.00.00',
      };
  }

  /// POST to a YTMusic Innertube endpoint directly.
  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/$endpoint?key=$_apiKey',
        data: body,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Innertube [$endpoint] failed: ${e.message}');
    }
  }

  /// Standard WEB_REMIX client context — required in every Innertube payload.
  Map<String, dynamic> _buildContext() {
    return {
      'context': {
        'client': {
          'clientName': 'WEB_REMIX',
          'clientVersion': '1.20240320.00.00',
          'hl': 'en',
          'gl': 'US',
          'userAgent':
              'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36,gzip(gfe)',
        },
      },
    };
  }

  // ── Home Feed ──────────────────────────────────────────────────────────────

  Future<List<HomeSection>> getHome() async {
    final payload = _buildContext();
    payload['browseId'] = 'FEmusic_home';
    final data = await _post('browse', payload);

    final sections = YtMusicParser.parseHomeFeed(data);

    // Supplement to reach 10 rows when Innertube returns fewer (unauthenticated)
    const supplementQueries = [
      ('Bollywood Hits', 'bollywood hits 2024'),
      ('Trending Now', 'trending music 2024'),
      ('Global Top Songs', 'top songs global'),
      ('Pop Hits', 'pop hits 2024'),
      ('Chill Vibes', 'chill lofi vibes'),
      ('Workout & Gym', 'workout gym hits'),
      ('Romantic Hindi Songs', 'romantic songs hindi'),
      ('Hip-Hop & Rap', 'hip hop rap 2024'),
      ('Party Bangers', 'party songs dance hits'),
      ('Indie & Acoustic', 'indie acoustic songs'),
    ];

    final needed = (10 - sections.length).clamp(0, supplementQueries.length);
    if (needed > 0) {
      final results = await Future.wait(
        supplementQueries.take(needed + 2).map((rec) async {
          try {
            final songs = await search(rec.$2, type: 'song');
            if (songs.length >= 3) {
              return HomeSection(title: rec.$1, items: songs.take(15).toList());
            }
          } catch (_) {}
          return null;
        }),
      );
      for (final s in results) {
        if (s != null && sections.length < 10) sections.add(s);
      }
    }

    return sections;
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  Future<List<Song>> search(String query, {String type = 'song'}) async {
    final payload = _buildContext();
    payload['query'] = query;

    // Innertube search filter params (base64-encoded protobuf filters)
    switch (type) {
      case 'song':
        payload['params'] = 'EgWKAQIIAWoMEAMQBBAJEA4QChAF';
      case 'album':
        payload['params'] = 'EgWKAQIYAWoMEAMQBBAJEA4QChAF';
      case 'playlist':
        payload['params'] = 'EgWKAQICAWoMEAMQBBAJEA4QChAF';
      case 'artist':
        payload['params'] = 'EgWKAQIgAWoMEAMQBBAJEA4QChAF';
      // type == 'all' — no params, returns mixed results
    }

    final data = await _post('search', payload);
    return YtMusicParser.parseSearch(data, type);
  }

  // ── Suggestions ────────────────────────────────────────────────────────────

  Future<List<String>> getSearchSuggestions(String query) async {
    final payload = _buildContext();
    payload['input'] = query;
    final data = await _post('music/get_search_suggestions', payload);
    return YtMusicParser.parseSearchSuggestions(data);
  }

  // ── Playlist / Album ───────────────────────────────────────────────────────

  Future<Playlist> getPlaylist(String browseId) async {
    final payload = _buildContext();
    payload['browseId'] = browseId;
    final data = await _post('browse', payload);
    return YtMusicParser.parsePlaylist(data, browseId);
  }

  Future<Map<String, dynamic>> getRawBrowse(String browseId) async {
    final payload = _buildContext();
    payload['browseId'] = browseId;
    return _post('browse', payload);
  }

  Future<Map<String, dynamic>> getRawContinuation(String token) async {
    final payload = _buildContext();
    payload['continuation'] = token;
    return _post('browse', payload);
  }

  // ── Artist ─────────────────────────────────────────────────────────────────

  Future<Artist> getArtist(String browseId) async {
    final payload = _buildContext();
    payload['browseId'] = browseId;
    final data = await _post('browse', payload);
    return YtMusicParser.parseArtist(data, browseId);
  }

  // ── Watch Next / Radio ─────────────────────────────────────────────────────

  /// Gets watch-next / radio queue for a videoId.
  ///
  /// YouTube Music's radio is triggered by passing:
  ///   - playlistId = 'RDAMVM' + videoId  →  auto-generated radio playlist
  ///   - params                           →  signals this is an autoplay request
  ///
  /// Without these, the `next` endpoint returns only 5 songs (the default queue).
  /// With them, it returns a 25-song auto-radio seeded from the current track —
  /// exactly what the web version uses.
  Future<List<Song>> getWatchNext(String videoId) async {
    final payload = _buildContext();
    payload['videoId'] = videoId;
    // Radio playlist ID: YouTube Music generates radio from this prefix + videoId
    payload['playlistId'] = 'RDAMVM$videoId';
    // Autoplay signal (base64 protobuf): tells YTM this is a radio/autoplay request
    payload['params'] = 'wAEB8gECGAE%3D';
    payload['enablePersistentPlaylistPanel'] = true;
    payload['isAudioOnly'] = true;
    final data = await _post('next', payload);
    return YtMusicParser.parseWatchNext(data);
  }
}
