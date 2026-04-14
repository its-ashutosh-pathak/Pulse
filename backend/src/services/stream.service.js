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
const ytdlp = require('../external/ytdlp');
const innertube = require('../external/innertube');
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

  // With cookies: yt-dlp goes first — cookies let it bypass YouTube's cloud IP restrictions.
  // Without cookies: Piped goes first — avoids YouTube CDN IP-locking entirely.
  const tiers = hasCookies
    ? ['ytdlp', 'piped', 'innertube']
    : ['piped', 'innertube', 'ytdlp'];

  for (const source of tiers) {
    try {
      let data;
      if (source === 'ytdlp') {
         data = await ytdlp.extract(videoId, quality);
      } else {
         continue; // skip broken pipelines
      }

      if (data?.url) {
        cache.set(`stream:${videoId}`, { ...data, expiry: Date.now() + STREAM_TTL_MS }, STREAM_TTL_MS);
        logger.info('stream_extracted', { videoId, source, hasCookies });
        return data;
      }
      errors.push(`${source}: returned empty URL`);
    } catch (e) {
      errors.push(`${source}: ${e.message}`);
      logger.warn('stream_fallback', { videoId, failedSource: source, reason: e.message });
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
