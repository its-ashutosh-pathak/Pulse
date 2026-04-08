const statsSvc    = require('../services/stats.service');
const { successBody } = require('../utils/errorResponse');

async function recordPlay(req, res, next) {
  try {
    await statsSvc.recordPlay(req.user.userId, req.body);
    res.json(successBody({ recorded: true }));
  } catch (e) { next(e); }
}

async function getListeningTime(req, res, next) {
  try {
    const period = req.query.period || 'week';
    const data   = await statsSvc.getListeningTime(req.user.userId, period);
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function getTopSongs(req, res, next) {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 10, 50);
    const data  = await statsSvc.getTopSongs(req.user.userId, limit);
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function getTopArtists(req, res, next) {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 10, 50);
    const data  = await statsSvc.getTopArtists(req.user.userId, limit);
    res.json(successBody(data));
  } catch (e) { next(e); }
}

module.exports = { recordPlay, getListeningTime, getTopSongs, getTopArtists };
