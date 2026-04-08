require('dotenv').config();
const app = require('./src/app');
const env = require('./src/config/env');
const logger = require('./src/utils/logger');
const { warmUp } = require('./src/external/innertube.singleton');

const PORT = env.PORT || 5000;

const server = app.listen(PORT, () => {
  logger.info('server_started', {
    port: PORT,
    env:  env.NODE_ENV,
    msg:  'Pulse backend running — single Node.js process, no Python required',
  });
  // Warm up Innertube in background so first request is fast
  warmUp();
});

// ── Graceful shutdown ─────────────────────────────────────────────────────────
process.on('SIGTERM', () => {
  logger.info('server_shutdown', { signal: 'SIGTERM' });
  server.close(() => process.exit(0));
});

process.on('unhandledRejection', (reason) => {
  logger.error('unhandled_rejection', { reason: String(reason) });
});

process.on('uncaughtException', (err) => {
  logger.error('uncaught_exception', { error: err.message, stack: err.stack });
  process.exit(1);
});
