/**
 * history.service.js
 * Records playback events to user history.
 * Used by recommendations and repeat-avoidance logic.
 */
const historyRepo = require('../repositories/history.repository');
const logger      = require('../utils/logger');

async function recordPlay(userId, videoId) {
  try {
    await historyRepo.upsert(userId, videoId);
  } catch (e) {
    // History write failure must never crash the playback flow
    logger.warn('history_write_failed', { userId, videoId, error: e.message });
  }
}

async function getRecent(userId, limit = 50) {
  return historyRepo.getRecent(userId, limit);
}

module.exports = { recordPlay, getRecent };
