/**
 * playlist.service.js
 * Full playlist business logic:
 * - CRUD, permissions, collaborative editing
 * - Idempotent addTrack with dedup
 * - Float-based ordering with rebalance
 * - Copy/fork with full track duplication
 * - Chunked batch import
 * - System playlist guard (Liked Songs)
 */
const { v4: uuid }  = require('uuid');
const { db }        = require('../config/firebase');
const playlistRepo  = require('../repositories/playlist.repository');
const trackRepo     = require('../repositories/track.repository');
const songRepo      = require('../repositories/song.repository');
const metaSvc       = require('./metadata.service');
const validate      = require('../utils/validate');
const { createError } = require('../utils/errorResponse');
const logger        = require('../utils/logger');
const { IMPORT_CHUNK_SIZE, TRACK_PAGE_SIZE } = require('../config/constants');

// ── Permission helpers ────────────────────────────────────────────────────────

function assertExists(playlist) {
  if (!playlist || playlist.deletedAt) {
    throw createError(404, 'PLAYLIST_NOT_FOUND', 'Playlist not found');
  }
}

function assertCanEdit(playlist, userId) {
  assertExists(playlist);
  if (playlist.ownerId !== userId && !playlist.collaborators?.includes(userId)) {
    throw createError(403, 'FORBIDDEN', 'You do not have permission to edit this playlist');
  }
}

function assertIsOwner(playlist, userId) {
  assertExists(playlist);
  if (playlist.ownerId !== userId) {
    throw createError(403, 'FORBIDDEN', 'Only the playlist owner can do this');
  }
}

function assertNotSystemPlaylist(playlist, action = 'modify') {
  if (playlist.isSystemPlaylist) {
    throw createError(403, 'SYSTEM_PLAYLIST', `Cannot ${action} a system playlist directly`);
  }
}

// ── CRUD ─────────────────────────────────────────────────────────────────────

async function listPlaylists(userId) {
  return playlistRepo.findByOwner(userId);
}

async function createPlaylist(userId, { name, isCollaborative = false }) {
  validate.playlist({ name });
  const now = new Date();
  const playlist = {
    playlistId:      uuid(),
    name:            name.trim(),
    ownerId:         userId,
    isCollaborative: Boolean(isCollaborative),
    isFork:          false,
    originalPlaylistId: null,
    originalOwnerId:    null,
    isSystemPlaylist:   false,
    systemType:         null,
    collaborators:      [],
    deletedAt:          null,
    createdAt:          now,
    updatedAt:          now,
  };
  return playlistRepo.create(playlist);
}

async function getPlaylistById(playlistId, userId) {
  const playlist = await playlistRepo.findById(playlistId);
  assertExists(playlist);
  // Collaborators and owner can view; anyone else gets 403
  if (
    playlist.ownerId !== userId &&
    !playlist.collaborators?.includes(userId) &&
    !playlist.isCollaborative // public collaborative playlists are viewable
  ) {
    throw createError(403, 'FORBIDDEN', 'You do not have access to this playlist');
  }
  return playlist;
}

async function deletePlaylist(playlistId, userId) {
  const playlist = await playlistRepo.findById(playlistId);
  assertIsOwner(playlist, userId);
  assertNotSystemPlaylist(playlist, 'delete');
  await playlistRepo.softDelete(playlistId);
  logger.info('playlist_edit', { playlistId, action: 'delete', userId });
}

// ── Tracks ────────────────────────────────────────────────────────────────────

async function getTracks(playlistId, userId, { cursor, limit = TRACK_PAGE_SIZE } = {}) {
  const playlist = await playlistRepo.findById(playlistId);
  assertExists(playlist);
  const tracks = await trackRepo.findByPlaylist(playlistId, { cursor, limit: limit + 1 });
  const hasMore = tracks.length > limit;
  const page    = hasMore ? tracks.slice(0, limit) : tracks;
  const nextCursor = hasMore ? page[page.length - 1].order : null;
  return { tracks: page, pagination: { nextCursor, hasMore } };
}

async function addTrack(playlistId, userId, trackData) {
  const playlist = await playlistRepo.findById(playlistId);
  assertCanEdit(playlist, userId);
  assertNotSystemPlaylist(playlist, 'add tracks to');
  validate.track(trackData);

  // Idempotency — if videoId already in playlist, return existing
  const existing = await trackRepo.findByVideoId(playlistId, trackData.videoId);
  if (existing) {
    logger.info('playlist_edit', { playlistId, action: 'add_track_dedup', userId, videoId: trackData.videoId });
    return existing;
  }

  const maxOrder = await trackRepo.getMaxOrder(playlistId);
  const track = {
    trackId:     uuid(),
    videoId:     trackData.videoId,
    spotifyId:   trackData.spotifyId   || null,
    title:       trackData.title,
    artist:      trackData.artist,
    cover:       trackData.cover       || '',
    duration:    trackData.duration    || 0,
    addedBy:     userId,
    addedAt:     new Date(),
    order:       maxOrder + 1.0,
    isAvailable: trackData.isAvailable !== false,
  };

  await trackRepo.create(playlistId, track);
  await playlistRepo.update(playlistId, { updatedAt: new Date() });
  logger.info('playlist_edit', { playlistId, action: 'add_track', userId, videoId: track.videoId });
  return track;
}

async function reorderTracks(playlistId, userId, tracks) {
  const playlist = await playlistRepo.findById(playlistId);
  assertCanEdit(playlist, userId);
  validate.reorder(tracks);

  // Validate all trackIds belong to this playlist
  const allTracks = await trackRepo.getAll(playlistId);
  const validIds  = new Set(allTracks.map((t) => t.trackId));
  for (const { trackId } of tracks) {
    if (!validIds.has(trackId)) {
      throw createError(400, 'TRACK_NOT_FOUND', `Track ${trackId} not found in this playlist`);
    }
  }

  await trackRepo.batchUpdateOrder(playlistId, tracks.map(({ trackId, newOrder }) => ({ trackId, newOrder })));
  await playlistRepo.update(playlistId, { updatedAt: new Date() });
  logger.info('playlist_edit', { playlistId, action: 'reorder', userId });
}

// ── Copy / Fork ──────────────────────────────────────────────────────────────

async function copyPlaylist(playlistId, userId) {
  const source = await playlistRepo.findById(playlistId);
  assertExists(source);

  const now         = new Date();
  const newPlaylist = {
    playlistId:         uuid(),
    name:               `${source.name} (Copy)`,
    ownerId:            userId,
    isCollaborative:    false,
    isFork:             true,
    originalPlaylistId: source.playlistId,
    originalOwnerId:    source.ownerId,
    isSystemPlaylist:   false,
    systemType:         null,
    collaborators:      [],
    deletedAt:          null,
    createdAt:          now,
    updatedAt:          now,
  };

  await playlistRepo.create(newPlaylist);

  // Copy all tracks with new trackIds
  const sourceTracks = await trackRepo.getAll(playlistId);
  for (const t of sourceTracks) {
    await trackRepo.create(newPlaylist.playlistId, {
      ...t,
      trackId: uuid(),
      addedBy: userId,
      addedAt: now,
    });
  }

  logger.info('playlist_edit', {
    action:    'copy',
    userId,
    sourceId:  playlistId,
    newId:     newPlaylist.playlistId,
    trackCount: sourceTracks.length,
  });

  return newPlaylist;
}

// ── Collaborators ─────────────────────────────────────────────────────────────

async function manageCollaborators(playlistId, userId, { add = [], remove = [] }) {
  const playlist = await playlistRepo.findById(playlistId);
  assertIsOwner(playlist, userId);
  assertNotSystemPlaylist(playlist, 'add collaborators to');

  if (add.length) {
    validate.collaborators({ userIds: add });
    for (const uid of add) await playlistRepo.addCollaborator(playlistId, uid);
  }
  if (remove.length) {
    for (const uid of remove) await playlistRepo.removeCollaborator(playlistId, uid);
  }

  logger.info('playlist_edit', { playlistId, action: 'collaborators', userId, add, remove });
  return playlistRepo.findById(playlistId);
}

// ── Import ────────────────────────────────────────────────────────────────────

async function importTracks(playlistId, userId, tracks) {
  const playlist = await playlistRepo.findById(playlistId);
  assertCanEdit(playlist, userId);
  assertNotSystemPlaylist(playlist, 'import into');

  if (!Array.isArray(tracks) || tracks.length === 0) {
    throw createError(400, 'VALIDATION_ERROR', 'tracks array is required');
  }

  let succeeded = 0;
  let failed    = 0;
  const errors  = [];

  // Process in chunks
  for (let i = 0; i < tracks.length; i += IMPORT_CHUNK_SIZE) {
    const chunk = tracks.slice(i, i + IMPORT_CHUNK_SIZE);

    for (const [j, t] of chunk.entries()) {
      const globalIndex = i + j;
      try {
        // Normalize basic fields
        if (!t.title || !t.artist) {
          throw new Error('Missing title or artist');
        }

        // Try to resolve videoId via search if not provided
        let videoId = t.videoId;
        if (!videoId) {
          const results = await metaSvc.searchSongs(`${t.title} ${t.artist}`);
          videoId = results[0]?.videoId;
        }
        if (!videoId) throw new Error('Could not resolve videoId');

        await addTrack(playlistId, userId, {
          videoId,
          title:   t.title,
          artist:  t.artist,
          cover:   t.cover   || '',
          duration: t.duration || 0,
        });
        succeeded++;
      } catch (e) {
        failed++;
        errors.push({ index: globalIndex, title: t.title || '?', reason: e.message });
      }
    }
  }

  if (failed > 0 && failed >= tracks.length * 0.8) {
    logger.warn('import_anomaly', { playlistId, userId, succeeded, failed });
  }

  logger.info('import_complete', { playlistId, userId, succeeded, failed });
  return { succeeded, failed, errors };
}

module.exports = {
  listPlaylists,
  createPlaylist,
  getPlaylistById,
  deletePlaylist,
  getTracks,
  addTrack,
  reorderTracks,
  copyPlaylist,
  manageCollaborators,
  importTracks,
};
