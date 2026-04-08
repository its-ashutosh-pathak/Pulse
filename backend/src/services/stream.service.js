/**
 * stream.service.js — Core streaming engine.
 *
 * Priority: Piped → yt-dlp (1 retry) → Innertube
 * - All URLs validated before caching
 * - Extraction lock prevents duplicate concurrent fetches for the same videoId
 * - Stream URLs stored ONLY in memory — never in Firestore
 */
const axios    = require('axios');
const cache    = require('../cache/memoryCache');
const piped    = require('../external/piped');
const ytdlp    = require('../external/ytdlp');
const innertube= require('../external/innertube');
const settingsRepo = require('../repositories/settings.repository');
const logger   = require('../utils/logger');
const { createError } = require('../utils/errorResponse');
const { STREAM_TTL_MS } = require('../config/constants');

// In-flight dedup — prevents two concurrent requests for the same videoId
// triggering two separate extractions
const inFlight = new Map();

/**
 * Validate a stream URL is reachable by making a HEAD request.
 * Returns true if valid audio content, false otherwise.
 */
async function validateUrl(url) {
  try {
    const res = await axios.head(url, {
      timeout: 5000,
      validateStatus: (s) => s < 400,
    });
    const ct = res.headers['content-type'] || '';
    return ct.includes('audio') || ct.includes('video') || ct.includes('octet-stream');
  } catch {
    return false;
  }
}

async function _doExtract(videoId, quality) {
  const errors = [];

  // Tier 1: Piped
  try {
    const data = await piped.extract(videoId, quality);
    if (data?.url) {
      const valid = await validateUrl(data.url);
      if (valid) {
        cache.set(`stream:${videoId}`, { ...data, expiry: Date.now() + STREAM_TTL_MS }, STREAM_TTL_MS);
        logger.info('stream_extracted', { videoId, source: 'piped' });
        return data;
      }
      errors.push('piped: URL failed validation');
    }
  } catch (e) {
    errors.push(`piped: ${e.message}`);
    logger.warn('stream_fallback', { videoId, failedSource: 'piped', reason: e.message });
  }

  // Tier 2: yt-dlp (with exactly one retry)
  for (let attempt = 1; attempt <= 2; attempt++) {
    try {
      const data = await ytdlp.extract(videoId, quality);
      if (data?.url) {
        const valid = await validateUrl(data.url);
        if (valid) {
          cache.set(`stream:${videoId}`, { ...data, expiry: Date.now() + STREAM_TTL_MS }, STREAM_TTL_MS);
          logger.info('stream_extracted', { videoId, source: 'ytdlp', attempt });
          return data;
        }
        errors.push(`ytdlp attempt ${attempt}: URL failed validation`);
      }
    } catch (e) {
      errors.push(`ytdlp attempt ${attempt}: ${e.message}`);
      logger.warn('stream_fallback', { videoId, failedSource: `ytdlp_attempt_${attempt}`, reason: e.message });
      if (attempt < 2) await new Promise((r) => setTimeout(r, 1000)); // 1s before retry
    }
  }

  // Tier 3: Innertube
  try {
    const data = await innertube.extract(videoId, quality);
    if (data?.url) {
      const valid = await validateUrl(data.url);
      if (valid) {
        cache.set(`stream:${videoId}`, { ...data, expiry: Date.now() + STREAM_TTL_MS }, STREAM_TTL_MS);
        logger.info('stream_extracted', { videoId, source: 'innertube' });
        return data;
      }
      errors.push('innertube: URL failed validation');
    }
  } catch (e) {
    errors.push(`innertube: ${e.message}`);
  }

  logger.error('stream_all_sources_failed', { videoId, errors });
  throw createError(502, 'STREAM_FAILED', `Unable to fetch stream. Errors: ${errors.join(' | ')}`);
}

/**
 * Get the stream URL for a videoId.
 * Checks cache first, respects quality setting, enforces extraction lock.
 *
 * @param {string} videoId
 * @param {object} options  - { quality, forceRefresh }
 */
async function getStreamUrl(videoId, { quality = 'auto', forceRefresh = false } = {}) {
  const cacheKey = `stream:${videoId}`;

  if (forceRefresh) {
    cache.delete(cacheKey);
  }

  // Return cached entry if valid
  const cached = cache.get(cacheKey);
  if (cached) {
    logger.info('stream_cache_hit', { videoId });
    return cached;
  }

  // Extraction lock — if already in progress, wait for the same promise
  if (inFlight.has(videoId)) {
    return inFlight.get(videoId);
  }

  const promise = _doExtract(videoId, quality).finally(() => inFlight.delete(videoId));
  inFlight.set(videoId, promise);
  return promise;
}

module.exports = { getStreamUrl };
