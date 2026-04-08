const express = require('express');
const router  = express.Router();
const auth    = require('../middleware/auth');
const ctrl    = require('../controllers/settings.controller');

router.get  ('/', auth, ctrl.get);
router.patch('/', auth, ctrl.update);

module.exports = router;
