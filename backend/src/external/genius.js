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
  if (!env.GENIUS_ACCESS_TOKEN) {
    logger.warn('genius_skipped', { reason: 'GENIUS_ACCESS_TOKEN not set' });
    return null;
  }

  // Sanitize inputs — strip feat./ft./brackets that confuse Genius search
  const cleanTitle  = (title  || '').replace(/\s*[\(\[].*?[\)\]]/g, '').replace(/\s*(feat\.?|ft\.?)\s*.*/i, '').trim();
  const cleanArtist = (artist || '').replace(/\s*[\(\[].*?[\)\]]/g, '').trim();
  if (!cleanTitle) return null;

  try {
    const res = await axios.get(`${BASE}/search`, {
      params: { q: `${cleanTitle} ${cleanArtist}` },
      headers: { Authorization: `Bearer ${env.GENIUS_ACCESS_TOKEN}` },
      timeout: TIMEOUT,
      validateStatus: (s) => s < 500, // Don't throw on 4xx — handle manually
    });

    // Handle auth failures gracefully so lyrics chain falls through
    if (res.status === 401 || res.status === 403) {
      logger.error('genius_auth_failed', {
        status: res.status,
        hint: 'GENIUS_ACCESS_TOKEN is invalid or expired. Get a valid token from https://genius.com/api-clients',
      });
      return null;
    }

    if (res.status !== 200) {
      logger.warn('genius_http_error', { status: res.status });
      return null;
    }

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

