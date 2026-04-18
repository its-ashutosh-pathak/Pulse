import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Client-side stream extractor using youtube_explode_dart.
/// Bypasses the need for server-side yt-dlp by extracting directly from YouTube CDN.
class StreamExtractor {
  static final YoutubeExplode _yt = YoutubeExplode();

  /// Gets the highest quality audio stream URL for a given video ID.
  static Future<String> getAudioStreamUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      
      // Get all audio-only streams
      final audioStreams = manifest.audioOnly.toList();
      if (audioStreams.isEmpty) {
        throw Exception("No audio streams found for $videoId");
      }

      // Sort streams by bitrate (highest first)
      audioStreams.sort((a, b) => b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond));
      
      // Prefer mp4a (m4a) if available, otherwise return the highest bitrate stream
      // m4a has better compatibility with iOS/macOS audio players than webm (opus).
      final audioInfo = audioStreams.firstWhere(
        (s) => s.audioCodec.contains('mp4') || s.audioCodec.contains('m4a'),
        orElse: () => audioStreams.first,
      );

      return audioInfo.url.toString();
    } catch (e) {
      throw Exception("Failed to extract stream for $videoId: $e");
    }
  }

  /// Close the YoutubeExplode client when done (usually at app exit).
  static void dispose() {
    _yt.close();
  }
}
