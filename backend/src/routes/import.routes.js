const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/import.controller');
const rateLimiter = require('../middleware/rateLimiter');
const auth = require('../middleware/auth');
const { RATE_LIMIT_IMPORT } = require('../config/constants');

// Public: preview — just fetches name + total, no auth needed
router.get('/spotify/preview', rateLimiter(RATE_LIMIT_IMPORT), ctrl.importSpotifyPreview);

// Protected: Hybrid imports require a user context to construct the playlist in Firestore
router.post('/spotify', auth, rateLimiter(RATE_LIMIT_IMPORT), ctrl.importSpotify);
router.post('/ytmusic', auth, rateLimiter(RATE_LIMIT_IMPORT), ctrl.importYTMusic);

module.exports = router;
