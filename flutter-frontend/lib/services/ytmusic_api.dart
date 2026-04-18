import 'dart:convert';
import 'package:dio/dio.dart';
import '../data/models/song.dart';
import '../data/models/home_section.dart';
import '../data/models/artist.dart';
import '../data/models/playlist.dart';
import 'ytmusic_parser.dart';

/// Dart implementation of YouTube Music InnerTube web client.
/// Bypasses need for full backend by sending payloads directly to the thin proxy
/// (which just relays them to music.youtube.com).
class YtMusicApi {
  static const String proxyUrl = 'https://its-ashutosh-pathak-pulse-flutter-backend-by-ap.hf.space/proxy';
  static const String apiKey = 'YOUR_YT_API_KEY_OR_USE_PROXY_DEFAULT'; // The proxy usually appends this if missing. We'll pass it if needed, or proxy handles it.
  
  final Dio _dio;

  YtMusicApi() : _dio = Dio() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    };
  }

  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    // The thin proxy appends the key automatically, we just pass the endpoint
    try {
      final response = await _dio.post(
        '$proxyUrl/$endpoint',
        data: body,
      );
      return response.data;
    } catch (e) {
      throw Exception('InnerTube request failed: $e');
    }
  }

  Map<String, dynamic> _buildContext() {
    return {
      "context": {
        "client": {
          "clientName": "WEB_REMIX",
          "clientVersion": "1.20240320.00.00", // Standard YTM web client version
          "hl": "en",
          "gl": "US"
        }
      }
    };
  }

  Future<List<HomeSection>> getHome() async {
    final payload = _buildContext();
    final data = await _post('browse', payload);
    return YtMusicParser.parseHomeFeed(data);
  }

  Future<List<Song>> search(String query, {String type = 'song'}) async {
    final payload = _buildContext();
    payload['query'] = query;
    // Real Innertube has search params base64 strings, we can omit them for 'all' or hardcode
    // "EgWKAQIIAWoMEAMQBBAJEA4QChAF" is songs
    if (type == 'song') payload['params'] = 'EgWKAQIIAWoMEAMQBBAJEA4QChAF';
    else if (type == 'album') payload['params'] = 'EgWKAQIYAWoMEAMQBBAJEA4QChAF';
    else if (type == 'playlist') payload['params'] = 'EgWKAQICAWoMEAMQBBAJEA4QChAF';
    else if (type == 'artist') payload['params'] = 'EgWKAQIgAWoMEAMQBBAJEA4QChAF';

    final data = await _post('search', payload);
    return YtMusicParser.parseSearch(data, type);
  }

  Future<Playlist> getPlaylist(String browseId) async {
    final payload = _buildContext();
    payload['browseId'] = browseId;
    final data = await _post('browse', payload);
    return YtMusicParser.parsePlaylist(data, browseId);
  }

  Future<Artist> getArtist(String browseId) async {
    final payload = _buildContext();
    payload['browseId'] = browseId;
    final data = await _post('browse', payload);
    return YtMusicParser.parseArtist(data, browseId);
  }

  Future<List<Song>> getWatchNext(String videoId) async {
    final payload = _buildContext();
    payload['videoId'] = videoId;
    final data = await _post('next', payload);
    return YtMusicParser.parseWatchNext(data);
  }
}
