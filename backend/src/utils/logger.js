/**
 * Structured logger — outputs JSON lines to stdout.
 * In production, forward these to a log aggregator (Logtail, Papertrail, etc.)
 * Note: uses process.env directly to avoid circular dependency with env.js.
 */

const IS_DEV = (process.env.NODE_ENV || 'development') === 'development';

function log(level, event, meta = {}) {
  const entry = {
    level,
    event,
    ...meta,
    ts: new Date().toISOString(),
  };

  if (IS_DEV) {
    // Human-readable in dev
    const metaStr = Object.keys(meta).length
      ? ' ' + JSON.stringify(meta)
      : '';
    console.log(`[${level}] ${entry.ts} ${event}${metaStr}`);
  } else {
    console.log(JSON.stringify(entry));
  }
}

const logger = {
  info:  (event, meta) => log('INFO',  event, meta),
  warn:  (event, meta) => log('WARN',  event, meta),
  error: (event, meta) => log('ERROR', event, meta),
};

module.exports = logger;
