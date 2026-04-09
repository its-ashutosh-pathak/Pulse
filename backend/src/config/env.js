require('dotenv').config();

const required = [
  'FIREBASE_PROJECT_ID',
  'FIREBASE_CLIENT_EMAIL',
  'FIREBASE_PRIVATE_KEY',
];

required.forEach((key) => {
  if (!process.env[key]) {
    throw new Error(`Missing required environment variable: ${key}`);
  }
});

module.exports = {
  PORT:               process.env.PORT || 5000,
  NODE_ENV:           process.env.NODE_ENV || 'development',
  FRONTEND_URL:       (process.env.FRONTEND_URL || '*').replace(/\/$/, ''),

  // Firebase
  FIREBASE_PROJECT_ID:    process.env.FIREBASE_PROJECT_ID,
  FIREBASE_CLIENT_EMAIL:  process.env.FIREBASE_CLIENT_EMAIL,
  FIREBASE_PRIVATE_KEY:   (process.env.FIREBASE_PRIVATE_KEY || '')
                            .replace(/\\n/g, '\n')
                            .replace(/"/g, '') // remove any stray quotes
                            .trim(),

  // Optional enrichment
  SPOTIFY_CLIENT_ID:      process.env.SPOTIFY_CLIENT_ID || '',
  SPOTIFY_CLIENT_SECRET:  process.env.SPOTIFY_CLIENT_SECRET || '',
  GENIUS_ACCESS_TOKEN:    process.env.GENIUS_ACCESS_TOKEN || '',
  PIPED_API_BASE:         process.env.PIPED_API_BASE || 'https://pipedapi.kavin.rocks',
  YTDLP_PATH:             process.env.YTDLP_PATH || 'yt-dlp',
};
