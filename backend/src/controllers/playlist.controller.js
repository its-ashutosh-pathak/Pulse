const playlistSvc   = require('../services/playlist.service');
const { successBody } = require('../utils/errorResponse');
const { RATE_LIMIT_IMPORT } = require('../config/constants');

async function list(req, res, next) {
  try {
    const playlists = await playlistSvc.listPlaylists(req.user.userId);
    res.json(successBody(playlists));
  } catch (e) { next(e); }
}

async function create(req, res, next) {
  try {
    const playlist = await playlistSvc.createPlaylist(req.user.userId, req.body);
    res.status(201).json(successBody(playlist));
  } catch (e) { next(e); }
}

async function getTracks(req, res, next) {
  try {
    const { cursor, limit } = req.query;
    const result = await playlistSvc.getTracks(
      req.params.id,
      req.user.userId,
      { cursor: cursor ? parseFloat(cursor) : undefined, limit: parseInt(limit) || 50 }
    );
    res.json({ success: true, ...result });
  } catch (e) { next(e); }
}

async function addTrack(req, res, next) {
  try {
    const track = await playlistSvc.addTrack(req.params.id, req.user.userId, req.body);
    res.json(successBody(track));
  } catch (e) { next(e); }
}

async function reorder(req, res, next) {
  try {
    await playlistSvc.reorderTracks(req.params.id, req.user.userId, req.body.tracks);
    res.json(successBody({ reordered: true }));
  } catch (e) { next(e); }
}

async function copy(req, res, next) {
  try {
    const playlist = await playlistSvc.copyPlaylist(req.params.id, req.user.userId);
    res.status(201).json(successBody(playlist));
  } catch (e) { next(e); }
}

async function manageCollaborators(req, res, next) {
  try {
    const playlist = await playlistSvc.manageCollaborators(req.params.id, req.user.userId, req.body);
    res.json(successBody(playlist));
  } catch (e) { next(e); }
}

async function importTracks(req, res, next) {
  try {
    const result = await playlistSvc.importTracks(req.params.id, req.user.userId, req.body.tracks);
    res.json({ success: true, partial: result.failed > 0, data: result });
  } catch (e) { next(e); }
}

async function remove(req, res, next) {
  try {
    await playlistSvc.deletePlaylist(req.params.id, req.user.userId);
    res.json(successBody({ deleted: true }));
  } catch (e) { next(e); }
}

module.exports = { list, create, getTracks, addTrack, reorder, copy, manageCollaborators, importTracks, remove };
