const settingsSvc = require('../services/settings.service');
const { successBody } = require('../utils/errorResponse');

async function get(req, res, next) {
  try {
    const settings = await settingsSvc.getSettings(req.user.userId);
    res.json(successBody(settings));
  } catch (e) { next(e); }
}

async function update(req, res, next) {
  try {
    const settings = await settingsSvc.updateSettings(req.user.userId, req.body);
    res.json(successBody(settings));
  } catch (e) { next(e); }
}

module.exports = { get, update };
