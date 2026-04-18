const express        = require('express');
const cors           = require('cors');
const requestLogger  = require('./middleware/requestLogger');
const errorHandler   = require('./middleware/errorHandler');
const rateLimiter    = require('./middleware/rateLimiter');
const { RATE_LIMIT_GENERAL } = require('./config/constants');
const env            = require('./config/env');

// Routes
const musicRoutes    = require('./routes/music.routes');
const statsRoutes    = require('./routes/stats.routes');
const healthRoutes   = require('./routes/health.routes');
const importRoutes   = require('./routes/import.routes');

const app = express();

app.set('trust proxy', 1); // trust X-Forwarded-For from HF/Vercel reverse proxy

// ── CORS ─────────────────────────────────────────────────────────────────────
// Stream/download routes need `Access-Control-Allow-Origin: *` so that:
//   1. Web Audio API's crossorigin="anonymous" CORS check passes (crossfade works)
//   2. Android's notification system can fetch proxied thumbnails
// All other routes use the specific frontend URL with credentials support.
const corsOptions = {
  origin: (origin, callback) => {
    // Allow requests with no origin (curl, mobile apps, server-to-server)
    if (!origin) return callback(null, true);
    // Allow the configured frontend URL (or any origin if FRONTEND_URL = '*')
    const allowed = env.FRONTEND_URL;
    if (allowed === '*' || origin === allowed) return callback(null, true);
    // Also allow *.vercel.app previews so PR deploys work
    if (/\.vercel\.app$/.test(origin)) return callback(null, true);
    // Allow local development server
    if (origin.startsWith('http://localhost:')) return callback(null, true);
    return callback(null, false);
  },
  credentials: true,
  exposedHeaders: ['Content-Range', 'Accept-Ranges', 'Content-Length', 'Content-Type'],
};
app.use(cors(corsOptions));
// Pre-flight for all routes
app.options('*', cors(corsOptions));
app.use(express.json({ limit: '2mb' }));
app.use(requestLogger);

// ── Root health endpoint — prevents 404 on GET / ─────────────────────────────
app.get('/', (req, res) => {
  res.json({ status: 'ok', service: 'pulse-backend', uptime: Math.floor(process.uptime()), timestamp: new Date().toISOString() });
});

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/health',    healthRoutes);
app.use('/api/import', importRoutes);                                    // /api/import/spotify — has its own rate limiter in the route
app.use('/api',       rateLimiter(RATE_LIMIT_GENERAL), musicRoutes);    // /api/home, /api/search, /api/play, etc.
app.use('/stats',     statsRoutes);

// ── 404 catch ─────────────────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ success: false, error: 'NOT_FOUND', message: `Route ${req.method} ${req.path} not found` });
});

// ── Global error handler (must be last) ───────────────────────────────────────
app.use(errorHandler);

module.exports = app;
