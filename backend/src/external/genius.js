/**
 * genius.js — Fetches plain lyrics from Genius API.
 * Fallback lyrics source #3. Requires GENIUS_ACCESS_TOKEN.
 */
const axios  = require('axios');
const env    = require('../config/env');
const logger = require('../utils/logger');

const BASE    = 'https://api.genius.com';
const TIMEOUT = 8000;

async function search({ title, artist }) {
  if (!env.GENIUS_ACCESS_TOKEN) return null;

  try {
    const res = await axios.get(`${BASE}/search`, {
      params: { q: `${title} ${artist}` },
      headers: { Authorization: `Bearer ${env.GENIUS_ACCESS_TOKEN}` },
      timeout: TIMEOUT,
    });

    const hits = res.data?.response?.hits || [];
    if (!hits.length) return null;

    // Genius search returns metadata only — lyrics body requires page scraping
    // We return the lyrics URL and signal partial availability
    const hit = hits[0]?.result;
    if (!hit) return null;

    // Genius API doesn't return lyrics text on the free plan without scraping.
    // Return the URL so the frontend can optionally deep-link to the lyrics page.
    return {
      syncedLyrics: null,
      plainLyrics:  null, // Not available without scraping
      lyricsUrl:    hit.url || null,
      source:       'genius',
    };
  } catch (e) {
    logger.warn('genius_failed', { title, artist, error: e.message });
    return null;
  }
}

module.exports = { search };
