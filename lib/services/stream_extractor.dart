import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  ///   - 'automatic' → adapts to network: 'high' on Wi-Fi/Ethernet, 'normal' on Mobile
  ///   - 'high'      → highest fidelity (prefer Opus ≥ 128 kbps itag 251, ~135-160 kbps)
  ///   - 'normal'    → clean standard tier (~128 kbps AAC itag 140, eliminates buffering & saves data)
  ///   - 'low'       → minimum bitrate (≤ 64 kbps, max data saving)
  static Future<String> getAudioStreamUrl(
    String videoId, {
    String quality = 'automatic',
    bool isDownload = false,
  }) async {
    _ensureTimer();

    // ── Resolve 'automatic' based on real-time network state ──
    String effectiveQuality = quality;
    if (quality == 'automatic') {
      try {
        final connectivity = await Connectivity().checkConnectivity();
        final isFastNetwork = connectivity.contains(ConnectivityResult.wifi) ||
            connectivity.contains(ConnectivityResult.ethernet);
        effectiveQuality = isFastNetwork ? 'high' : 'normal';
      } catch (_) {
        effectiveQuality = 'high';
      }
    }

    final cacheKey = '${videoId}_$effectiveQuality';
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

      final chosen = _selectStream(audioStreams, effectiveQuality);
      final url = chosen.url.toString();
      if (kDebugMode) {
        debugPrint(
          '[StreamExtractor] ✅ $videoId via visionos: ${chosen.audioCodec} '
          '${(chosen.bitrate.bitsPerSecond / 1000).toStringAsFixed(1)} kbps '
          '(q=$quality, effective=$effectiveQuality, dl=$isDownload)',
        );
      }

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

  /// Selects the optimal stream for [effectiveQuality].
  static AudioOnlyStreamInfo _selectStream(
    List<AudioOnlyStreamInfo> audioStreams,
    String effectiveQuality,
  ) {
    if (audioStreams.isEmpty) throw Exception('No audio streams found');

    // Sort by bitrate descending
    final sorted = List<AudioOnlyStreamInfo>.from(audioStreams)
      ..sort((a, b) => b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond));

    if (effectiveQuality == 'low') {
      // Pick lowest bitrate stream (≤ 64 kbps, e.g. itag 249 or 139)
      return sorted.last;
    }

    if (effectiveQuality == 'normal') {
      // Normal: standard quality (~128 kbps).
      // First look for standard AAC itag 140 (~128 kbps).
      final aac140 = sorted.firstWhere(
        (s) => s.tag == 140,
        orElse: () => sorted.firstWhere(
          // Or any stream between 100 kbps and 140 kbps
          (s) => s.bitrate.bitsPerSecond >= 100000 && s.bitrate.bitsPerSecond <= 140000,
          // Never plunge to 65 kbps (itag 250) if higher quality is available
          orElse: () => sorted.length > 1 ? sorted[1] : sorted.first,
        ),
      );
      return aac140;
    }

    // High quality (or fallback):
    // Prefer Opus >= 128 kbps (itag 251) for the highest fidelity lossless-like reproduction.
    // If Opus is not present, pick the stream with the highest raw bitrate.
    final opusHigh = sorted.firstWhere(
      (s) => s.audioCodec.toLowerCase().contains('opus') && s.bitrate.bitsPerSecond >= 128000,
      orElse: () => sorted.first,
    );
    return opusHigh;
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
