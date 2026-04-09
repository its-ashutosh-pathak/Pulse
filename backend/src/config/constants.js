module.exports = {
  // Cache TTLs
  STREAM_TTL_MS:        6 * 60 * 60 * 1000,   // 6 hours
  SEARCH_CACHE_TTL_MS:  4 * 60 * 60 * 1000,   // 4 hours  (was 1h)
  REC_CACHE_TTL_MS:     6 * 60 * 60 * 1000,   // 6 hours  (was 2h)

  // Auth
  BCRYPT_ROUNDS: 12,

  // Rate limiting (requests per minute)
  RATE_LIMIT_GENERAL: 60,
  RATE_LIMIT_SEARCH:  60,
  RATE_LIMIT_PLAY:    10,
  RATE_LIMIT_IMPORT:  5,
  RATE_LIMIT_AUTH:    10,
  RATE_LIMIT_STATS:   120, // high — called every 30s during playback

  // Streaming
  EXTRACT_DELAY_MS:  600,   // ~1.5 yt-dlp requests/sec max
  PREFETCH_COUNT:    3,
  PYTHON_TIMEOUT_MS: 15000,
  AXIOS_TIMEOUT_MS:  8000,

  // Playlist
  IMPORT_CHUNK_SIZE: 50,
  TRACK_PAGE_SIZE:   50,

  // Metadata matching
  DURATION_TOLERANCE_S:  2,
  TITLE_SIMILARITY_MIN:  0.85,
  LYRICS_SIMILARITY_MIN: 0.70,

  // Stats
  MAX_SECONDS_PER_EVENT: 600,  // cap at 10 min per reporting event

  // Piped instances (tried in order)
  PIPED_INSTANCES: [
    'https://pipedapi.kavin.rocks',
    'https://pipedapi.reallyaweso.me',
    'https://pipedapi.darkness.services',
    'https://piped-api.cfe.re',
    'https://watchapi.whatever.social',
    'https://api.piped.projectsegfau.lt',
    'https://piped-api.codeberg.page',
    'https://piped-api.hostux.net',
    'https://pa.il.ax',
    'https://piped.adminforge.de/api',
  ],
};
