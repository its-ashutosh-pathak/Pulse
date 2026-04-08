const { distance } = require('fastest-levenshtein');

/**
 * Compute title similarity ratio between two strings.
 * Returns a value between 0 (completely different) and 1 (identical).
 */
function titleSimilarity(a, b) {
  if (!a || !b) return 0;
  const s1 = a.toLowerCase().trim();
  const s2 = b.toLowerCase().trim();
  if (s1 === s2) return 1;
  const maxLen = Math.max(s1.length, s2.length);
  if (maxLen === 0) return 1;
  const d = distance(s1, s2);
  return 1 - d / maxLen;
}

/**
 * Check if two artist names match (case-insensitive).
 */
function artistMatch(a, b) {
  if (!a || !b) return false;
  return a.toLowerCase().trim() === b.toLowerCase().trim();
}

/**
 * Check if two durations are within a tolerance (in seconds).
 */
function durationMatch(d1, d2, toleranceS = 2) {
  if (d1 == null || d2 == null) return true; // unknown duration — don't block
  return Math.abs(d1 - d2) <= toleranceS;
}

/**
 * Determine if two songs are likely duplicates.
 * Returns true if they match on title similarity + artist + duration.
 */
function isSongDuplicate(a, b, { titleThreshold = 0.85, toleranceS = 2 } = {}) {
  return (
    titleSimilarity(a.title, b.title) >= titleThreshold &&
    artistMatch(a.artist, b.artist) &&
    durationMatch(a.duration, b.duration, toleranceS)
  );
}

module.exports = { titleSimilarity, artistMatch, durationMatch, isSongDuplicate };
