/**
 * stats.service.js
 * Records listening events and computes listening time stats.
 */
const statsRepo  = require('../repositories/stats.repository');
const historyRepo = require('../repositories/history.repository');
const validate   = require('../utils/validate');
const { toArtistKey } = require('../utils/normalize');
const { MAX_SECONDS_PER_EVENT } = require('../config/constants');
const logger     = require('../utils/logger');

/**
 * Record a play event. Called from the frontend every 30s during playback.
 */
async function recordPlay(userId, body) {
  validate.statsPlay(body);

  // Skip no-op writes
  const secondsListened = Math.min(body.secondsListened, MAX_SECONDS_PER_EVENT);
  if (secondsListened <= 0) return;

  const artistKey = toArtistKey(body.artist);

  // Write stats + history in parallel
  await Promise.all([
    statsRepo.recordPlay(userId, {
      videoId:         body.videoId,
      secondsListened,
      date:            body.date,
      title:           body.title   || '',
      artist:          body.artist  || '',
      cover:           body.cover   || '',
      artistKey,
    }),
    historyRepo.upsert(userId, body.videoId).catch((e) => {
      logger.warn('history_upsert_failed', { userId, videoId: body.videoId, error: e.message });
    }),
  ]);
}

/**
 * Compute listening time stats for a given period.
 * Returns totalSeconds, totalMinutes, totalHours, dailyAverageMinutes, and per-day breakdown.
 *
 * dailyAverageMinutes is ALWAYS computed from lifetime data / total active days,
 * so it stays consistent regardless of which period is being viewed.
 */
async function getListeningTime(userId, period) {
  validate.statsPeriod(period);

  let rows;

  if (period === 'lifetime') {
    rows = await statsRepo.getAll(userId);
  } else {
    const days = { day: 1, week: 7, month: 30, year: 365 }[period] || 30;
    const dates = buildDateRange(days);
    rows = await statsRepo.getByDates(userId, dates);
  }

  const totalSeconds = rows.reduce((sum, r) => sum + (r.totalSeconds || 0), 0);

  // ── Compute daily average from LIFETIME data (stable across all period views) ──
  let dailyAverageMinutes = 0;
  try {
    const allRows = period === 'lifetime' ? rows : await statsRepo.getAll(userId);
    const lifetimeSeconds = allRows.reduce((sum, r) => sum + (r.totalSeconds || 0), 0);

    // Count actual days with recorded activity, or fall back to date span
    let accountDays = 1;
    if (allRows.length > 0) {
      // Get earliest and latest dates in the user's stats
      const sortedDates = allRows.map(r => r.date).filter(Boolean).sort();
      if (sortedDates.length >= 2) {
        const earliest = new Date(sortedDates[0]);
        const latest   = new Date(sortedDates[sortedDates.length - 1]);
        accountDays = Math.max(1, Math.round((latest - earliest) / (1000 * 60 * 60 * 24)) + 1);
      } else {
        accountDays = 1; // Only one day of data
      }
    }

    dailyAverageMinutes = Math.round(lifetimeSeconds / 60 / accountDays);
  } catch (e) {
    // If lifetime query fails, fall back to period-based calculation
    const fallbackDays = rows.length || 1;
    dailyAverageMinutes = Math.round(totalSeconds / 60 / fallbackDays);
  }

  return {
    period,
    totalSeconds,
    totalMinutes:         Math.floor(totalSeconds / 60),
    totalHours:           Math.floor(totalSeconds / 3600),
    dailyAverageMinutes,
    days: rows.map((r) => ({ date: r.date, totalSeconds: r.totalSeconds || 0 })),
  };
}

async function getTopSongs(userId, limit = 10) {
  const results = await statsRepo.getTopSongs(userId, limit);
  return results.map((s, i) => ({
    ...s,
    rank:      i + 1,
    thumbnail: s.cover || s.thumbnail || '',   // alias so frontend can use either field
    cover:     s.cover || s.thumbnail || '',
  }));
}

async function getTopArtists(userId, limit = 10) {
  const results = await statsRepo.getTopArtists(userId, limit);
  return results.map((a, i) => ({
    ...a,
    rank:      i + 1,
    thumbnail: a.cover || a.thumbnail || '',
    cover:     a.cover || a.thumbnail || '',
  }));
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function buildDateRange(days) {
  const dates = [];
  const now   = new Date();
  for (let i = 0; i < days; i++) {
    const d = new Date(now);
    d.setDate(d.getDate() - i);
    dates.push(d.toISOString().slice(0, 10)); // YYYY-MM-DD
  }
  return dates;
}

module.exports = { recordPlay, getListeningTime, getTopSongs, getTopArtists };
