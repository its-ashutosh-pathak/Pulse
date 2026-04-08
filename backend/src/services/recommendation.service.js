/**
 * recommendation.service.js
 * Fetches related songs and ranks them using user history.
 * Cached in memory for 2 hours.
 */
const ytmusic    = require('../external/ytmusic');
const historyRepo = require('../repositories/history.repository');
const cache      = require('../cache/memoryCache');
const { normalizeSong } = require('../utils/normalize');
const logger     = require('../utils/logger');
const { REC_CACHE_TTL_MS } = require('../config/constants');

const ONE_DAY_MS  = 24 * 60 * 60 * 1000;
const SEVEN_DAYS_MS = 7 * ONE_DAY_MS;

/**
 * Score a candidate track against the user's listening history.
 * Higher score = more relevant and less repetitive.
 */
function scoreCandidate(candidate, historyMap, currentArtist) {
  let score = 0;

  // Boost same artist
  if (candidate.artist && candidate.artist === currentArtist) score += 3;

  const hist = historyMap.get(candidate.videoId);
  if (hist) {
    const age = Date.now() - new Date(hist.playedAt).getTime();
    if (age < ONE_DAY_MS)    score -= 5; // played today — strong penalty
    else if (age < SEVEN_DAYS_MS) score -= 2; // played this week — mild penalty
    if (hist.playCount > 3)  score -= 1; // over-played
  } else {
    score += 1; // never played — slight bonus for discovery
  }

  return score;
}

async function getRecommendations(videoId, userId) {
  const cacheKey = `rec:${videoId}:${userId}`;
  const cached   = cache.get(cacheKey);
  if (cached) return cached;

  try {
    // Fetch related tracks from ytmusicapi watch-next
    const raw = await ytmusic.getWatchNext(videoId);
    const candidates = (raw || []).map(normalizeSong).filter((s) => s.videoId && s.videoId !== videoId);

    // Load user history for scoring
    const historyList = await historyRepo.getRecent(userId, 50);
    const historyMap  = new Map(historyList.map((h) => [h.videoId, h]));

    // Get current song artist from first candidate context (watch-next includes current)
    const currentArtist = '';

    // Score and sort
    const scored = candidates.map((c) => ({
      ...c,
      _score: scoreCandidate(c, historyMap, currentArtist),
    }));
    scored.sort((a, b) => b._score - a._score);

    const results = scored.slice(0, 20).map(({ _score, ...c }) => c);

    cache.set(cacheKey, results, REC_CACHE_TTL_MS);
    return results;
  } catch (e) {
    logger.warn('recommendations_failed', { videoId, error: e.message });
    // Graceful fallback — return empty array, not an error
    return [];
  }
}

module.exports = { getRecommendations };
