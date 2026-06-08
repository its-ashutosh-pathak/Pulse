/// API constants — kept as a stub after migrating to zero-backend architecture.
/// All actual API calls now go direct: Innertube, YouTube CDN, lrclib.net.
/// This file exists only to prevent import errors from any code not yet cleaned.
class ApiConstants {
  // No backend URLs. The Flutter app is fully self-contained.
  // Stream extraction: youtube_explode_dart (on-device)
  // Metadata: Innertube direct (music.youtube.com)
  // Lyrics: lrclib.net direct
  // Stats/Playlists: Firebase Firestore direct

  /// Request timeout for Innertube metadata calls.
  static const Duration requestTimeout = Duration(seconds: 15);

  /// Request timeout for stream extraction.
  static const Duration streamTimeout = Duration(seconds: 30);
}
