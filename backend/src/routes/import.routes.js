const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/import.controller');
const rateLimiter = require('../middleware/rateLimiter');
const { RATE_LIMIT_SEARCH } = require('../config/constants');

// Public: Spotify Client Credentials doesn't require the user's token
router.get('/spotify', rateLimiter(RATE_LIMIT_SEARCH), ctrl.importSpotify);

module.exports = router;
