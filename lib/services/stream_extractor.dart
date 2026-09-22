import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Client-side audio stream extractor using youtube_explode_dart v2.5.3.
///
/// WHY 2.5.3:
///   v3.x switched from a built-in Dart JSEngine to spawning an external
///   `deno` process for signature deciphering. `deno` doesn't exist on
///   Android phones → every extraction fails with "process not found".
///   v2.5.3 is the last version with the built-in engine — works on-device.
///
/// WHY CLIENT-SIDE IS CORRECT:
///   YouTube stream URLs are IP-locked. When extracted on the user's phone,
///   the URL is locked to the phone's IP → the phone plays from its own IP → ✅
///   (Backend extraction → URL locked to server IP → phone can't play → ❌)
class StreamExtractor {
  /// Singleton YoutubeExplode client — reused across calls for performance.
  static YoutubeExplode? _yt;
  static Timer? _refreshTimer;
  static final Map<String, _CachedStream> _cache = {};

  // Apple Vision Pro spoof profile bypassing PoToken requirements
  static const YoutubeApiClient _visionosClient = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'VISIONOS',
        'clientVersion': '1.02',
        'deviceMake': 'Apple',
        'deviceModel': 'RealityDevice17,1',
        'userAgent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 15_7_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15',
        'osName': 'visionOS',
        'osVersion': '26.5.23O471',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false');

  static Future<YoutubeExplode> _getYtClient() async {
    _yt ??= YoutubeExplode();
    return _yt!;
  }

  static void _ensureTimer() {
    _refreshTimer ??= Timer.periodic(const Duration(hours: 4), (_) {
      debugPrint('[StreamExtractor] 🔄 Proactively refreshing YoutubeExplode session');
      _yt?.close();
      _yt = null;
    });
  }

  /// Gets an audio stream URL for a given videoId.
  ///
  /// [quality]: 'automatic' | 'high' | 'normal' | 'low'
  ///   - 'high'      → highest bitrate available (≥ 128 kbps preferred)
  ///   - 'normal'    → ≤ 128 kbps
  ///   - 'low'       → ≤ 64 kbps
  ///   - 'automatic' → highest available (same as 'high')
  static Future<String> getAudioStreamUrl(String videoId, {String quality = 'automatic'}) async {
    _ensureTimer();

    final cacheKey = '${videoId}_$quality';
    final cached = _cache[cacheKey];

    // Use cached URL if less than 2 hours old
    if (cached != null && DateTime.now().difference(cached.timestamp).inHours < 2) {
       return cached.url;
    }

    try {
      final yt = await _getYtClient();
      final manifest = await yt.videos.streamsClient
          .getManifest(videoId, ytClients: [_visionosClient]);

      final audioStreams = manifest.audioOnly.toList();
      if (audioStreams.isEmpty) throw Exception('No audio streams found for $videoId');

      // Sort by bitrate descending
      audioStreams.sort(
        (a, b) => b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond),
      );

      final candidates = audioStreams.toList();

      // Apply quality filter
      AudioOnlyStreamInfo chosen;
      if (quality == 'low') {
        chosen = candidates.last;
      } else if (quality == 'normal') {
        chosen = candidates[(candidates.length / 2).floor()];
      } else {
        chosen = candidates.first;
      }

      final url = chosen.url.toString();
      if (kDebugMode) debugPrint('[StreamExtractor] ✅ $videoId via visionos: ${chosen.audioCodec} ${chosen.bitrate} (q=$quality)');

      // Evict the oldest entry if cache exceeds 150 items to prevent
      // unbounded RAM growth during long listening sessions.
      if (_cache.length >= 150) {
        _cache.remove(_cache.keys.first);
      }
      _cache[cacheKey] = _CachedStream(url, DateTime.now());
      return url;
    } catch (e) {
      if (kDebugMode) debugPrint('[StreamExtractor] ⚠️ $videoId visionos failed: $e');
      _yt?.close();
      _yt = null;
      rethrow;
    }
  }

  static void invalidateCache(String videoId) {
    _cache.removeWhere((key, value) => key.startsWith('${videoId}_'));
  }

  /// Close the YoutubeExplode client at app exit.
  static void dispose() {
    _yt?.close();
    _yt = null;
    _refreshTimer?.cancel();
  }
}

class _CachedStream {
  final String url;
  final DateTime timestamp;

  _CachedStream(this.url, this.timestamp);
}
