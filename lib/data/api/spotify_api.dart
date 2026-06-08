import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SpotifyTrackData {
  final String title;
  final String artist;
  final String album;
  final String thumbnail;
  
  SpotifyTrackData({
    required this.title,
    required this.artist,
    required this.album,
    required this.thumbnail,
  });
}

class SpotifyPlaylistData {
  final String name;
  final List<SpotifyTrackData> tracks;
  SpotifyPlaylistData({required this.name, required this.tracks});
}

class SpotifyApi {
  String? _accessToken;
  DateTime? _tokenExpiry;
  final Dio _dio = Dio();

  /// Fetches an anonymous device-specific token by scraping a public playlist page.
  /// This completely bypasses Cloudflare's block on the direct API endpoint.
  Future<String> _getAnonymousToken() async {
    if (_accessToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    try {
      final response = await _dio.get(
        'https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M',
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        final html = response.data.toString();
        // The token is embedded inside a JSON object in the HTML
        final tokenRegex = RegExp(r'"accessToken":"([^"]+)"');
        final match = tokenRegex.firstMatch(html);
        
        if (match != null) {
          _accessToken = match.group(1);
          // Set an arbitrary expiration (e.g. 1 hour) since we don't parse the exact timestamp
          _tokenExpiry = DateTime.now().add(const Duration(minutes: 55));
          return _accessToken!;
        }
      }
    } catch (e) {
      debugPrint('Failed to get Spotify token from HTML: $e');
    }
    
    throw Exception('Could not fetch Spotify token - Cloudflare block active');
  }

  /// Extracts playlist ID from open.spotify.com/playlist/...
  String? extractPlaylistId(String url) {
    final regex = RegExp(r'playlist/([a-zA-Z0-9]+)');
    final match = regex.firstMatch(url);
    if (match != null) {
      // Sometimes it has ?si= parameters
      return match.group(1)?.split('?').first;
    }
    return null;
  }

  /// Fetches playlist metadata and raw tracks
  Future<SpotifyPlaylistData> getPlaylist(String playlistId) async {
    final token = await _getAnonymousToken();
    
    // 1. Fetch Playlist Name
    final metaRes = await _dio.get(
      'https://api.spotify.com/v1/playlists/$playlistId',
      options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (_) => true),
    );

    if (metaRes.statusCode != 200) {
      throw Exception('Failed to fetch Spotify playlist metadata');
    }

    final metaData = metaRes.data is String ? json.decode(metaRes.data) : metaRes.data;
    final String name = metaData['name'] ?? 'Spotify Import';
    
    // 2. Paginate Tracks (cap at 1000)
    List<SpotifyTrackData> tracks = [];
    String? nextUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks?limit=100';

    while (nextUrl != null && tracks.length < 1000) {
      final trackRes = await _dio.get(
        nextUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (_) => true),
      );

      if (trackRes.statusCode != 200) {
        break;
      }

      final trackData = trackRes.data is String ? json.decode(trackRes.data) : trackRes.data;
      final items = trackData['items'] as List<dynamic>? ?? [];
      
      for (var item in items) {
        final track = item['track'];
        if (track == null || track['is_local'] == true) continue; // Skip local files
        
        final title = track['name'] ?? '';
        final album = track['album']?['name'] ?? '';
        
        final artistsList = track['artists'] as List<dynamic>? ?? [];
        final artist = artistsList.map((a) => a['name']).join(', ');
        
        final images = track['album']?['images'] as List<dynamic>? ?? [];
        String thumbnail = '';
        if (images.isNotEmpty) {
          thumbnail = images.first['url'] ?? '';
        }

        tracks.add(SpotifyTrackData(
          title: title,
          artist: artist,
          album: album,
          thumbnail: thumbnail,
        ));
      }

      nextUrl = trackData['next']; // Null if last page
    }

    if (tracks.length > 1000) {
      tracks = tracks.take(1000).toList();
    }

    return SpotifyPlaylistData(name: name, tracks: tracks);
  }
}
