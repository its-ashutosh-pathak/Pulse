const likesSvc    = require('../services/likes.service');
const { successBody } = require('../utils/errorResponse');

async function like(req, res, next) {
  try {
    const result = await likesSvc.likeSong(req.user.userId, req.params.videoId);
    res.json(successBody(result));
  } catch (e) { next(e); }
}

async function unlike(req, res, next) {
  try {
    const result = await likesSvc.unlikeSong(req.user.userId, req.params.videoId);
    res.json(successBody(result));
  } catch (e) { next(e); }
}

async function isLiked(req, res, next) {
  try {
    const liked = await likesSvc.isLiked(req.user.userId, req.params.videoId);
    res.json(successBody({ liked }));
  } catch (e) { next(e); }
}

module.exports = { like, unlike, isLiked };
