/**
 * stream.service.js — Core streaming engine.
 *
 * Priority (dynamic):
 *   - WITH cookies: yt-dlp → Piped → Innertube
 *     (cookies let yt-dlp bypass YouTube's cloud IP restrictions)
 *   - WITHOUT cookies: Piped → Innertube → yt-dlp
 *     (Piped CDN avoids YouTube IP-locking entirely)
 *
 * - Extraction lock prevents duplicate concurrent fetches for the same videoId
 * - Stream URLs stored ONLY in memory — never in Firestore
 */
const cache = require('../cache/memoryCache');
const piped = require('../external/piped');
const playdl = require('../external/playdl');
const innertube = require('../external/innertube');
const ytdlp = require('../external/ytdlp');
const settingsRepo = require('../repositories/settings.repository');
const logger = require('../utils/logger');
const { createError } = require('../utils/errorResponse');
const { STREAM_TTL_MS } = require('../config/constants');

// In-flight dedup — prevents two concurrent requests for the same videoId
// triggering two separate extractions
const inFlight = new Map();

async function _doExtract(videoId, quality) {
  const errors = [];
  const cookieManager = require('../utils/cookieManager');
  const hasCookies = !!cookieManager.getRandomCookieFile();

  const tiers = [
    { source: 'ytdlp', func: ytdlp.extract },
    { source: 'piped', func: piped.extract },
    { source: 'innertube', func: innertube.extract },
    { source: 'playdl', func: playdl.extract }
  ];

  for (const tier of tiers) {
    try {
      const data = await tier.func(videoId, quality);
      if (data && data.url) {
        cache.set(`stream:${videoId}`, { ...data, expiry: Date.now() + STREAM_TTL_MS }, STREAM_TTL_MS);
        logger.info('stream_extracted', { videoId, source: tier.source, hasCookies });
        return data;
      }
      errors.push(`${tier.source}: returned empty URL`);
    } catch (e) {
      errors.push(`${tier.source}: ${e.message}`);
      logger.warn('stream_fallback', { videoId, failedSource: tier.source, reason: e.message });
    }
  }

  logger.error('stream_all_sources_failed', { videoId, diagnostics: errors.join(' | ') });
  throw createError(502, 'STREAM_FAILED', `Music extraction failed. Diagnostic: ${errors.join(' | ')}`);
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
