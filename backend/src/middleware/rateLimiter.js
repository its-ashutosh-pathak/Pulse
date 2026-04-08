const logger        = require('../utils/logger');
const { errorBody } = require('../utils/errorResponse');

/**
 * In-memory sliding window rate limiter.
 * Keyed by userId (if authenticated) or IP address.
 *
 * @param {number} limit      - Max requests allowed in the window
 * @param {number} windowMs   - Window duration in milliseconds (default: 60s)
 */
const windows = new Map(); // key → [timestamps]

function rateLimiter(limit, windowMs = 60_000) {
  return (req, res, next) => {
    const key = req.user?.userId || req.ip;
    const now = Date.now();

    // Slide the window — keep only timestamps within the current window
    const hits = (windows.get(key) || []).filter((t) => now - t < windowMs);

    if (hits.length >= limit) {
      logger.warn('rate_limit_hit', { key, path: req.path, hits: hits.length });
      return res
        .status(429)
        .json(errorBody('RATE_LIMITED', 'Too many requests. Please slow down.'));
    }

    hits.push(now);
    windows.set(key, hits);
    next();
  };
}

// Periodically prune stale entries (every 5 min) to avoid memory leak
setInterval(() => {
  const now = Date.now();
  for (const [key, hits] of windows.entries()) {
    const fresh = hits.filter((t) => now - t < 60_000);
    if (fresh.length === 0) windows.delete(key);
    else windows.set(key, fresh);
  }
}, 5 * 60_000);

module.exports = rateLimiter;
