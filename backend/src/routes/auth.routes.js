const express  = require('express');
const router   = express.Router();
const auth     = require('../middleware/auth');
const ctrl     = require('../controllers/auth.controller');

router.post('/profile', auth, ctrl.createProfile);
router.get('/me',       auth, ctrl.getMe);

module.exports = router;
