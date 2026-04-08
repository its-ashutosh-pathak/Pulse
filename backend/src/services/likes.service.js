/**
 * likes.service.js
 * Manages the Liked Songs system playlist and the likes lookup collection.
 *
 * - Auto-creates "Liked Songs" playlist on first like (lazy init)
 * - Caches the Liked Songs playlistId in memory per userId
 * - like/unlike are both idempotent
 */
const { v4: uuid }  = require('uuid');
const playlistRepo  = require('../repositories/playlist.repository');
const trackRepo     = require('../repositories/track.repository');
const likesRepo     = require('../repositories/likes.repository');
const songRepo      = require('../repositories/song.repository');
const metaSvc       = require('./metadata.service');
const { createError } = require('../utils/errorResponse');
const logger        = require('../utils/logger');

// In-memory cache: userId → likedSongsPlaylistId
const likedPlaylistCache = new Map();

async function getLikedPlaylistId(userId) {
  if (likedPlaylistCache.has(userId)) return likedPlaylistCache.get(userId);

  let playlist = await playlistRepo.findLikedSongs(userId);
  if (!playlist) {
    const now = new Date();
    playlist  = {
      playlistId:         uuid(),
      name:               'Liked Songs',
      ownerId:            userId,
      isCollaborative:    false,
      isFork:             false,
      originalPlaylistId: null,
      originalOwnerId:    null,
      isSystemPlaylist:   true,
      systemType:         'liked_songs',
      collaborators:      [],
      deletedAt:          null,
      createdAt:          now,
      updatedAt:          now,
    };
    await playlistRepo.create(playlist);
    logger.info('liked_songs_created', { userId, playlistId: playlist.playlistId });
  }

  likedPlaylistCache.set(userId, playlist.playlistId);
  return playlist.playlistId;
}

async function likeSong(userId, videoId) {
  // Already liked? Return early (idempotent)
  const alreadyLiked = await likesRepo.isLiked(userId, videoId);
  if (alreadyLiked) return { liked: true };

  const playlistId = await getLikedPlaylistId(userId);

  // Get or fetch song metadata
  let song = await songRepo.findByVideoId(videoId);
  if (!song) {
    const results = await metaSvc.searchSongs(videoId).catch(() => []);
    song = results.find((s) => s.videoId === videoId) || { videoId, title: 'Unknown', artist: 'Unknown', cover: '', duration: 0 };
    if (song.videoId) await songRepo.upsert(song);
  }

  // Add to Liked Songs playlist (bypass the assertNotSystemPlaylist guard — internal call)
  const existing = await trackRepo.findByVideoId(playlistId, videoId);
  if (!existing) {
    const maxOrder = await trackRepo.getMaxOrder(playlistId);
    await trackRepo.create(playlistId, {
      trackId:     uuid(),
      videoId,
      spotifyId:   song.spotifyId   || null,
      title:       song.title,
      artist:      song.artist,
      cover:       song.cover       || '',
      duration:    song.duration    || 0,
      addedBy:     userId,
      addedAt:     new Date(),
      order:       maxOrder + 1.0,
      isAvailable: true,
    });
    await playlistRepo.update(playlistId, { updatedAt: new Date() });
  }

  // Write fast lookup doc
  await likesRepo.like(userId, videoId);
  logger.info('song_liked', { userId, videoId });
  return { liked: true };
}

async function unlikeSong(userId, videoId) {
  const alreadyLiked = await likesRepo.isLiked(userId, videoId);
  if (!alreadyLiked) return { liked: false }; // idempotent

  const playlistId = await getLikedPlaylistId(userId);

  await trackRepo.deleteByVideoId(playlistId, videoId);
  await playlistRepo.update(playlistId, { updatedAt: new Date() });
  await likesRepo.unlike(userId, videoId);
  logger.info('song_unliked', { userId, videoId });
  return { liked: false };
}

async function isLiked(userId, videoId) {
  return likesRepo.isLiked(userId, videoId);
}

module.exports = { likeSong, unlikeSong, isLiked };
