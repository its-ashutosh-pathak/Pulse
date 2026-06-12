import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pulse/services/spotify_parser.dart';

class SpotifyEmbedScraper {
  static final _dio = Dio();

  /// Scrapes a Spotify playlist using the Embed Widget.
  /// This is extremely fast and completely bypasses API limits, 
  /// but it ONLY returns a maximum of 100 songs.
  static Future<SpotifyPlaylist> scrapePlaylist(String url) async {
    final match = RegExp(r'playlist/([a-zA-Z0-9]+)').firstMatch(url);
    if (match == null) throw Exception('Invalid Spotify playlist URL');
    final playlistId = match.group(1)!;

    final embedUrl = 'https://open.spotify.com/embed/playlist/$playlistId';
    final response = await _dio.get(
      embedUrl,
      options: Options(
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        },
      ),
    );

    final html = response.data.toString();
    final scriptMatch = RegExp(r'<script[^>]*id="__NEXT_DATA__"[^>]*>(.*?)</script>', dotAll: true).firstMatch(html);

    if (scriptMatch == null) throw Exception('Could not find Spotify __NEXT_DATA__ in HTML');

    Map<String, dynamic> jsonData;
    try {
      jsonData = json.decode(scriptMatch.group(1)!);
    } catch (e) {
      throw Exception('Failed to decode JSON: $e');
    }

    try {
      final props = jsonData['props'] as Map<String, dynamic>?;
      final pageProps = props?['pageProps'] as Map<String, dynamic>?;
      final state = pageProps?['state'] as Map<String, dynamic>?;
      final data = state?['data'] as Map<String, dynamic>?;
      final entity = data?['entity'] as Map<String, dynamic>?;

      if (entity == null) throw Exception('Entity is null');

      final name = entity['name'] ?? 'Spotify Playlist';
      final trackListItems = entity['trackList'] as List<dynamic>? ?? [];

      final tracks = <SpotifyTrack>[];
      for (final item in trackListItems) {
        if (item == null) continue;
        final title = item['title'] ?? '';
        
        // Artists might be nested in subtitle or a list of objects
        String artist = '';
        if (item['subtitle'] != null) {
          artist = item['subtitle'].toString();
        } else if (item['artists'] != null) {
          final artistList = item['artists'] as List<dynamic>;
          artist = artistList.map((a) => a['name']).join(', ');
        }

        if (title.isNotEmpty) {
          tracks.add(SpotifyTrack(title: title.toString(), artist: artist));
        }
      }

      return SpotifyPlaylist(
        name: name.toString(),
        totalTracks: tracks.length,
        tracks: tracks,
      );
    } catch (e) {
      throw Exception('Invalid Spotify data format: $e');
    }
  }
}
