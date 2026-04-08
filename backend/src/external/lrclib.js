/**
 * lrclib.js — Fetches synced and plain lyrics from LRCLIB (free, no key required).
 * Primary lyrics source.
 */
const axios  = require('axios');
const logger = require('../utils/logger');

const BASE    = 'https://lrclib.net/api';
const TIMEOUT = 8000;

/**
 * Search LRCLIB for lyrics by track title and artist.
 * Returns { syncedLyrics, plainLyrics } or null if not found.
 */
async function search({ title, artist, duration }) {
  try {
    const params = { track_name: title, artist_name: artist };
    if (duration) params.duration = Math.floor(duration);

    const res = await axios.get(`${BASE}/search`, { params, timeout: TIMEOUT });
    const results = res.data || [];
    if (!results.length) return null;

    // Prefer exact duration match, else take first result
    const best = results.find(
      (r) => duration && Math.abs((r.duration || 0) - duration) <= 2
    ) || results[0];

    return {
      syncedLyrics: best.syncedLyrics || null,
      plainLyrics:  best.plainLyrics  || best.syncedLyrics?.replace(/\[.*?\]/g, '').trim() || null,
      source:       'lrclib',
    };
  } catch (e) {
    logger.warn('lrclib_failed', { title, artist, error: e.message });
    return null;
  }
}

module.exports = { search };
