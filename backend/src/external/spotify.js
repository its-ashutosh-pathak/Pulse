/**
 * spotify.js — Optional Spotify metadata enrichment.
 * Used to add spotifyId to song records for better recommendation matching.
 * Requires SPOTIFY_CLIENT_ID + SPOTIFY_CLIENT_SECRET.
 * Uses Client Credentials flow — no user login needed.
 */
const axios  = require('axios');
const env    = require('../config/env');
const logger = require('../utils/logger');

let _accessToken  = null;
let _tokenExpires = 0;

async function getToken() {
  if (_accessToken && Date.now() < _tokenExpires) return _accessToken;

  if (!env.SPOTIFY_CLIENT_ID || !env.SPOTIFY_CLIENT_SECRET) return null;

  try {
    const credentials = Buffer.from(
      `${env.SPOTIFY_CLIENT_ID}:${env.SPOTIFY_CLIENT_SECRET}`
    ).toString('base64');

    const res = await axios.post(
      'https://accounts.spotify.com/api/token',
      'grant_type=client_credentials',
      {
        headers: {
          Authorization: `Basic ${credentials}`,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        timeout: 8000,
      }
    );

    _accessToken  = res.data.access_token;
    _tokenExpires = Date.now() + (res.data.expires_in - 60) * 1000; // 60s buffer
    return _accessToken;
  } catch (e) {
    logger.warn('spotify_token_failed', { error: e.message });
    return null;
  }
}

/**
 * Search Spotify for a song and return its Spotify track ID.
 * Returns null if Spotify credentials are not configured or search fails.
 */
async function findSpotifyId({ title, artist }) {
  const token = await getToken();
  if (!token) return null;

  try {
    const res = await axios.get('https://api.spotify.com/v1/search', {
      params: {
        q:     `track:${title} artist:${artist}`,
        type:  'track',
        limit: 1,
      },
      headers: { Authorization: `Bearer ${token}` },
      timeout: 8000,
    });

    const items = res.data?.tracks?.items || [];
    return items[0]?.id || null;
  } catch (e) {
    logger.warn('spotify_search_failed', { title, artist, error: e.message });
    return null;
  }
}

module.exports = { findSpotifyId };
