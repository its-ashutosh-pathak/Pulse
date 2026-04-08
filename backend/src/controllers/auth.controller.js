const authService   = require('../services/auth.service');
const { successBody } = require('../utils/errorResponse');

async function createProfile(req, res, next) {
  try {
    const { userId, email } = req.user;
    const { name }          = req.body;
    const profile = await authService.createProfile({ userId, email, name });
    res.status(201).json(successBody(profile));
  } catch (e) { next(e); }
}

async function getMe(req, res, next) {
  try {
    const profile = await authService.getProfile(req.user.userId);
    if (!profile) return res.json(successBody({ userId: req.user.userId, email: req.user.email }));
    res.json(successBody(profile));
  } catch (e) { next(e); }
}

module.exports = { createProfile, getMe };
