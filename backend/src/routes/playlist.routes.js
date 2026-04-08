const express     = require('express');
const router      = express.Router();
const auth        = require('../middleware/auth');
const rateLimiter = require('../middleware/rateLimiter');
const ctrl        = require('../controllers/playlist.controller');
const { RATE_LIMIT_IMPORT } = require('../config/constants');

router.get ('/',                  auth, ctrl.list);
router.post('/',                  auth, ctrl.create);
router.get ('/:id/tracks',        auth, ctrl.getTracks);
router.post('/:id/add',           auth, ctrl.addTrack);
router.post('/:id/reorder',       auth, ctrl.reorder);
router.post('/:id/copy',          auth, ctrl.copy);
router.post('/:id/collaborators', auth, ctrl.manageCollaborators);
router.post('/:id/import',        auth, rateLimiter(RATE_LIMIT_IMPORT), ctrl.importTracks);
router.delete('/:id',             auth, ctrl.remove);

module.exports = router;
