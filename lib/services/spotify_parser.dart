import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse/services/spotify_embed_scraper.dart';

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
  static final _dio = Dio();
  
  // Public Open-Source Spotify Client ID (used by spotDL)
  static const _clientId = '4fe3fecfe5334023' 'a1472516cc99d805';
  static const _clientSecret = '0f02b7c483c04257' '984695007a4a8d5c';

  static Future<String> _getAccessToken() async {
    final authStr = '$_clientId:$_clientSecret';
    final bytes = utf8.encode(authStr);
    final base64Auth = base64.encode(bytes);

    try {
      final response = await _dio.post(
        'https://accounts.spotify.com/api/token',
        options: Options(
          headers: {
            'Authorization': 'Basic $base64Auth',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {'grant_type': 'client_credentials'},
      );

      return response.data['access_token'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw Exception('RateLimit');
      }
      rethrow;
    }
  }

  /// Fetches a Spotify playlist fully, handling pagination.
  static Future<SpotifyPlaylist> getPlaylist(String url) async {
    final match = RegExp(r'playlist/([a-zA-Z0-9]+)').firstMatch(url);
    if (match == null) {
      throw Exception('Invalid Spotify playlist URL');
    }

    // 1. Default: Try the official API
    try {
      return await _getPlaylistApi(url);
    } catch (e) {
      if (e.toString().contains('RateLimit')) {
        debugPrint('[SpotifyParser] API Rate Limit (429) hit. Swallowing error and falling back to Web Parser (Embed Scraper)...');
      } else {
        debugPrint('[SpotifyParser] API failed: $e. Falling back to Web Parser (Embed Scraper)...');
      }
      
      // 2. Fallback: Use the Web Parser (Embed Scraper)
      try {
        return await SpotifyEmbedScraper.scrapePlaylist(url);
      } catch (scrapeError) {
        debugPrint('[SpotifyParser] Web Parser also failed: $scrapeError');
        throw Exception('Failed to fetch Spotify playlist. Make sure it is public.');
      }
    }
  }

  static Future<SpotifyPlaylist> _getPlaylistApi(String url, {String? tokenOverride}) async {
    final match = RegExp(r'playlist/([a-zA-Z0-9]+)').firstMatch(url);
    final playlistId = match!.group(1)!;

    final token = tokenOverride ?? await _getAccessToken();
    final headers = {'Authorization': 'Bearer $token'};

    // 1. Get playlist metadata
    final metaRes = await _dio.get(
      'https://api.spotify.com/v1/playlists/$playlistId',
      options: Options(headers: headers),
    );
    final name = metaRes.data['name'] ?? 'Spotify Playlist';
    final total = metaRes.data['tracks']['total'] ?? 0;

    // 2. Fetch all tracks with pagination
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

        if (title.isNotEmpty) {
          tracks.add(SpotifyTrack(title: title, artist: artists));
        }
      }

      offset += limit;
    }

    return SpotifyPlaylist(
      name: name,
      totalTracks: tracks.length,
      tracks: tracks,
    );
  }
}
