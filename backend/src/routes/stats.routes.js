const express     = require('express');
const router      = express.Router();
const auth        = require('../middleware/auth');
const rateLimiter = require('../middleware/rateLimiter');
const ctrl        = require('../controllers/stats.controller');
const { RATE_LIMIT_STATS } = require('../config/constants');

router.post('/play',        auth, rateLimiter(RATE_LIMIT_STATS), ctrl.recordPlay);
router.get ('/listening',   auth, ctrl.getListeningTime);
router.get ('/top-songs',   auth, ctrl.getTopSongs);
router.get ('/top-artists', auth, ctrl.getTopArtists);

module.exports = router;
