/**
 * schemaValidator.js — Validates extracted YouTube Music data shapes.
 * 
 * FIX #3: Instead of silently returning null or 'Unknown' when YouTube
 * changes their API response structure, this validator logs structured
 * warnings so failures are visible in monitoring.
 */
const logger = require('./logger');

/**
 * Validate a normalized track object and log any issues.
 * Returns { valid: boolean, issues: string[] }
 */
function validateTrack(track, source = 'unknown') {
  const issues = [];

  if (!track) {
    logger.warn('schema_validation', { source, issue: 'null track' });
    return { valid: false, issues: ['null track'] };
  }

  if (!track.videoId || track.videoId.length !== 11) {
    issues.push(`invalid videoId: "${track.videoId}"`);
  }
  if (!track.title || track.title === 'Unknown') {
    issues.push('missing title');
  }
  if (!track.artist || track.artist === 'Unknown') {
    issues.push('missing artist');
  }
  if (!track.thumbnail) {
    issues.push('missing thumbnail');
  }

  if (issues.length > 0) {
    logger.warn('schema_validation', {
      source,
      videoId: track.videoId || 'none',
      issues,
      raw: JSON.stringify(track).slice(0, 300),
    });
  }

  return { valid: issues.length === 0, issues };
}

/**
 * Validate a home feed / search section.
 */
function validateSection(section, source = 'unknown') {
  const issues = [];

  if (!section.title) {
    issues.push('section missing title');
  }
  if (!section.items?.length) {
    issues.push('empty section');
  }

  if (issues.length > 0) {
    logger.warn('schema_validation', {
      source,
      issues,
      title: section.title || 'untitled',
    });
  }

  return { valid: issues.length === 0, issues };
}

/**
 * Validate a batch of items and return stats.
 * Useful for logging extraction quality.
 */
function validateBatch(items, source = 'unknown') {
  let valid = 0;
  let invalid = 0;
  const allIssues = [];

  for (const item of items) {
    const result = validateTrack(item, source);
    if (result.valid) {
      valid++;
    } else {
      invalid++;
      allIssues.push(...result.issues);
    }
  }

  if (invalid > 0) {
    logger.warn('schema_batch_validation', {
      source,
      total: items.length,
      valid,
      invalid,
      sampleIssues: allIssues.slice(0, 10),
    });
  }

  return { total: items.length, valid, invalid };
}

module.exports = { validateTrack, validateSection, validateBatch };
