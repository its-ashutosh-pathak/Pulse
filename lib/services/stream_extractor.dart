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
  static YoutubeExplode _yt = YoutubeExplode();
  static Timer? _refreshTimer;
  static final Map<String, _CachedStream> _cache = {};

  static void _ensureTimer() {
    _refreshTimer ??= Timer.periodic(const Duration(hours: 4), (_) {
      debugPrint('[StreamExtractor] 🔄 Proactively refreshing YoutubeExplode session');
      _yt.close();
      _yt = YoutubeExplode();
    });
  }

  /// Gets an audio stream URL for a given videoId.
  /// Tries multiple YouTube API clients in order of reliability on mobile.
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

    final clients = [
      YoutubeApiClient.androidVr,
      YoutubeApiClient.ios,
      YoutubeApiClient.safari,
      YoutubeApiClient.tv,
    ];

    Exception? lastError;
    for (final client in clients) {
      try {
        final manifest = await _yt.videos.streamsClient
            .getManifest(videoId, ytClients: [client]);

        final audioStreams = manifest.audioOnly.toList();
        if (audioStreams.isEmpty) continue;

        // Sort by bitrate descending
        audioStreams.sort(
          (a, b) => b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond),
        );

        // Do not restrict to m4a so we can see all available qualities (160, 128, 64, 48)
        final candidates = audioStreams.toList();

        // Apply quality filter
        AudioOnlyStreamInfo chosen;
        if (quality == 'low') {
          // Lowest quality available
          chosen = candidates.last;
        } else if (quality == 'normal') {
          // Middle tier quality
          chosen = candidates[(candidates.length / 2).floor()];
        } else {
          // 'high' or 'automatic' → highest bitrate
          chosen = candidates.first;
        }

        final url = chosen.url.toString();
        debugPrint('[StreamExtractor] ✅ $videoId via ${client.runtimeType}: ${chosen.audioCodec} ${chosen.bitrate} (q=$quality)');
        
        _cache[cacheKey] = _CachedStream(url, DateTime.now());
        return url;
      } catch (e) {
        debugPrint('[StreamExtractor] ⚠️ $videoId client ${client.runtimeType} failed: $e');
        if (e is VideoUnplayableException || e.toString().toLowerCase().contains('403') || e.toString().toLowerCase().contains('unplayable')) {
          _yt.close();
          _yt = YoutubeExplode();
        }
        lastError = e is Exception ? e : Exception(e.toString());
      }
    }

    throw lastError ?? Exception('All client types failed for $videoId');
  }

  static void invalidateCache(String videoId) {
    _cache.removeWhere((key, value) => key.startsWith('${videoId}_'));
  }

  /// Close the YoutubeExplode client at app exit.
  static void dispose() {
    _yt.close();
  }
}

class _CachedStream {
  final String url;
  final DateTime timestamp;

  _CachedStream(this.url, this.timestamp);
}
