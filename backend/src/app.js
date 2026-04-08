const express        = require('express');
const cors           = require('cors');
const requestLogger  = require('./middleware/requestLogger');
const errorHandler   = require('./middleware/errorHandler');
const rateLimiter    = require('./middleware/rateLimiter');
const { RATE_LIMIT_GENERAL } = require('./config/constants');
const env            = require('./config/env');

// Routes
const authRoutes     = require('./routes/auth.routes');
const musicRoutes    = require('./routes/music.routes');
const playlistRoutes = require('./routes/playlist.routes');
const statsRoutes    = require('./routes/stats.routes');
const settingsRoutes = require('./routes/settings.routes');
const likesRoutes    = require('./routes/likes.routes');
const healthRoutes   = require('./routes/health.routes');
const importRoutes   = require('./routes/import.routes');

const app = express();

// ── Global middleware ─────────────────────────────────────────────────────────
app.set('trust proxy', 1); // trust X-Forwarded-For from Railway/Render reverse proxy
app.use(cors({ origin: env.FRONTEND_URL, credentials: true }));
app.use(express.json({ limit: '2mb' }));
app.use(requestLogger);

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/health',    healthRoutes);
app.use('/auth',      rateLimiter(RATE_LIMIT_GENERAL), authRoutes);
app.use('/api/import', importRoutes);                                    // /api/import/spotify — has its own rate limiter in the route
app.use('/api',       rateLimiter(RATE_LIMIT_GENERAL), musicRoutes);    // /api/home, /api/search, /api/play, etc.
app.use('/playlists', rateLimiter(RATE_LIMIT_GENERAL), playlistRoutes);
app.use('/stats',     statsRoutes);
app.use('/settings',  settingsRoutes);
app.use('/songs',     rateLimiter(RATE_LIMIT_GENERAL), likesRoutes);

// ── 404 catch ─────────────────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ success: false, error: 'NOT_FOUND', message: `Route ${req.method} ${req.path} not found` });
});

// ── Global error handler (must be last) ───────────────────────────────────────
app.use(errorHandler);

module.exports = app;
