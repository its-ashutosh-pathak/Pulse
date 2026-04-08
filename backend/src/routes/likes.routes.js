const express = require('express');
const router  = express.Router();
const auth    = require('../middleware/auth');
const ctrl    = require('../controllers/likes.controller');

router.post  ('/:videoId/like', auth, ctrl.like);
router.delete('/:videoId/like', auth, ctrl.unlike);
router.get   ('/:videoId/liked',auth, ctrl.isLiked);

module.exports = router;
