/// Backend API configuration.
class ApiConstants {
  ApiConstants._();

  /// Default backend URL — matches frontend's VITE_API_URL.
  /// In production, this should be configured via environment or build config.
  static const String defaultBaseUrl = 'http://localhost:5000';

  /// Request timeout for metadata calls.
  static const Duration requestTimeout = Duration(seconds: 15);

  /// Request timeout for streaming/download calls.
  static const Duration streamTimeout = Duration(seconds: 45);

  // ── Endpoints (from music.routes.js) ──
  static const String home = '/api/home';
  static const String search = '/api/search';
  static const String suggestions = '/api/suggestions';
  static const String artistResolve = '/api/artist-resolve';
  static String artist(String browseId) => '/api/artist/$browseId';
  static String ytPlaylist(String id) => '/api/playlist/$id';
  static String resolve(String id) => '/api/resolve/$id';
  static const String albumSearch = '/api/album-search';
  static const String proxyImage = '/api/proxy-image';
  static String play(String videoId) => '/api/play/$videoId';
  static String stream(String videoId) => '/api/stream/$videoId';
  static String lyrics(String videoId) => '/api/lyrics/$videoId';
  static String recommendations(String videoId) =>
      '/api/recommendations/$videoId';
  static String watchNext(String videoId) => '/api/watch-next/$videoId';
  static String download(String videoId) => '/api/download/$videoId';

  // ── Auth ──
  static const String authVerify = '/auth/verify';

  // ── Playlists (Firestore routes) ──
  static const String playlists = '/playlists';

  // ── Stats ──
  static const String statsPlay = '/stats/play';
  static const String statsProfile = '/stats/profile';

  // ── Settings ──
  static const String settings = '/settings';

  // ── Import ──
  static const String importSpotifyPreview = '/api/import/spotify/preview';
  static const String importSpotifyConfirm = '/api/import/spotify/confirm';
}
