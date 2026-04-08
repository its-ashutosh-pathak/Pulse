/**
 * musixmatch.js — Fetches lyrics from Musixmatch API.
 * Fallback lyrics source #2. Requires MUSIXMATCH_API_KEY.
 * Returns plain lyrics only (no synced LRC from free tier).
 */
const axios  = require('axios');
const env    = require('../config/env');
const logger = require('../utils/logger');

const BASE    = 'https://api.musixmatch.com/ws/1.1';
const TIMEOUT = 8000;

async function search({ title, artist }) {
  if (!env.MUSIXMATCH_API_KEY) return null;

  try {
    // 1. Search for the track to get track_id
    const searchRes = await axios.get(`${BASE}/track.search`, {
      params: {
        apikey:          env.MUSIXMATCH_API_KEY,
        q_track:         title,
        q_artist:        artist,
        s_track_rating:  'desc',
        page_size:       1,
        page:            1,
        f_has_lyrics:    1,
      },
      timeout: TIMEOUT,
    });

    const tracks =
      searchRes.data?.message?.body?.track_list || [];
    if (!tracks.length) return null;

    const trackId = tracks[0].track?.track_id;
    if (!trackId) return null;

    // 2. Fetch the lyrics snippet
    const lyricRes = await axios.get(`${BASE}/track.lyrics.get`, {
      params: { apikey: env.MUSIXMATCH_API_KEY, track_id: trackId },
      timeout: TIMEOUT,
    });

    const lyricsBody = lyricRes.data?.message?.body?.lyrics?.lyrics_body || '';
    if (!lyricsBody) return null;

    return {
      syncedLyrics: null,         // Musixmatch only gives plain on free tier
      plainLyrics:  lyricsBody,
      source:       'musixmatch',
    };
  } catch (e) {
    logger.warn('musixmatch_failed', { title, artist, error: e.message });
    return null;
  }
}

module.exports = { search };
