/**
 * prefetch.service.js
 * Background prefetch — warms the stream cache for upcoming tracks.
 * Always fire-and-forget; never blocks the current playback response.
 */
const streamService = require('./stream.service');
const cache         = require('../cache/memoryCache');
const logger        = require('../utils/logger');
const { PREFETCH_COUNT } = require('../config/constants');

/**
 * Prefetch stream URLs for the next N tracks in the background.
 *
 * @param {string[]} videoIds   - Array of upcoming videoIds
 * @param {string}   quality    - Quality setting from user preferences
 * @param {boolean}  dataSaver  - If true, skip prefetch entirely
 */
function prefetchNext(videoIds, quality = 'auto', dataSaver = false) {
  if (dataSaver || !videoIds?.length) return;

  const toFetch = videoIds
    .slice(0, PREFETCH_COUNT)
    .filter((id) => id && !cache.has(`stream:${id}`));

  if (!toFetch.length) return;

  // Fire and forget — setImmediate ensures response is sent first
  setImmediate(async () => {
    for (const id of toFetch) {
      try {
        await streamService.getStreamUrl(id, { quality });
        logger.info('prefetch_complete', { videoId: id });
      } catch (e) {
        logger.warn('prefetch_failed', { videoId: id, error: e.message });
      }
    }
  });
}

module.exports = { prefetchNext };
