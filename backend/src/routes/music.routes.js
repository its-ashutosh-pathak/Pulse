const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const rateLimiter = require('../middleware/rateLimiter');
const ctrl = require('../controllers/music.controller');
const { RATE_LIMIT_SEARCH, RATE_LIMIT_PLAY } = require('../config/constants');

// Public endpoints
router.get('/home', rateLimiter(RATE_LIMIT_SEARCH), ctrl.home);
router.get('/search', rateLimiter(RATE_LIMIT_SEARCH), ctrl.search);
router.get('/suggestions', rateLimiter(RATE_LIMIT_SEARCH), ctrl.suggestions);
router.get('/artist-resolve', rateLimiter(RATE_LIMIT_SEARCH), ctrl.resolveArtist);
router.get('/artist/:browseId', rateLimiter(RATE_LIMIT_SEARCH), ctrl.artist);
router.get('/playlist/:id', rateLimiter(RATE_LIMIT_SEARCH), ctrl.ytPlaylist);
router.get('/resolve/:id', ctrl.resolveId);
router.get('/album-search', rateLimiter(RATE_LIMIT_SEARCH), ctrl.albumSearch);

// Protected endpoints
router.get('/play/:videoId', auth, rateLimiter(RATE_LIMIT_PLAY), ctrl.play);
router.get('/stream/:videoId', auth, rateLimiter(RATE_LIMIT_PLAY), ctrl.streamProxy);
router.get('/lyrics/:videoId', auth, ctrl.lyrics);
router.get('/recommendations/:videoId', auth, ctrl.recommendations);
router.get('/watch-next/:videoId', auth, ctrl.watchNext);
router.get('/download/:videoId', auth, rateLimiter(RATE_LIMIT_PLAY), ctrl.downloadOffline);

module.exports = router;
