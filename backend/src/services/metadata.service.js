/**
 * metadata.service.js
 * Handles music search and metadata normalization.
 * Caches search results in memory for 1 hour.
 * Persists song metadata in Firestore for reuse.
 */
const ytmusic   = require('../external/ytmusic');
const spotify   = require('../external/spotify');
const songRepo  = require('../repositories/song.repository');
const cache     = require('../cache/memoryCache');
const { normalizeSong } = require('../utils/normalize');
const { isSongDuplicate } = require('../utils/similarity');
const logger    = require('../utils/logger');
const { SEARCH_CACHE_TTL_MS } = require('../config/constants');

/**
 * Search songs (flat list).
 */
async function searchSongs(q) {
  const cacheKey = `search:songs:${q.trim().toLowerCase()}`;
  const cached   = cache.get(cacheKey);
  if (cached) return cached;

  const raw     = await ytmusic.search(q, 'songs');
  const results = Array.isArray(raw) ? raw.map(normalizeSong) : [];

  // Enrich top 3 with Spotify IDs (fire and forget — don't block response)
  enrichWithSpotify(results.slice(0, 3)).catch(() => {});

  // Persist to Firestore in background — never block or throw
  persistSongs(results).catch(() => {});

  cache.set(cacheKey, results, SEARCH_CACHE_TTL_MS);
  return results;
}

/**
 * Search all types: songs + albums + playlists + artists.
 */
async function searchAll(q) {
  const cacheKey = `search:all:${q.trim().toLowerCase()}`;
  const cached   = cache.get(cacheKey);
  if (cached) return cached;

  const raw = await ytmusic.search(q, 'all');
  const result = {
    songs:     (raw.songs     || []).map(normalizeSong),
    albums:    (raw.albums    || []).map(normalizeSong),
    playlists: (raw.playlists || []).map(normalizeSong),
    artists:   (raw.artists   || []).map(normalizeSong),
  };

  persistSongs(result.songs).catch(() => {});
  cache.set(cacheKey, result, SEARCH_CACHE_TTL_MS);
  return result;
}

async function getHome() {
  const cacheKey = 'home:sections';
  const cached   = cache.get(cacheKey);
  if (cached) return cached;

  try {
    const sections = await ytmusic.getHome();
    cache.set(cacheKey, sections, SEARCH_CACHE_TTL_MS);
    return sections;
  } catch (e) {
    logger.warn('ytmusic_home_failed', { error: e.message });
    return []; // Return empty so frontend gets 200 with empty data, not a 500
  }
}

async function getSuggestions(q) {
  try {
    return await ytmusic.getSuggestions(q);
  } catch {
    return [];
  }
}

async function getArtist(browseId) {
  const cacheKey = `artist:${browseId}`;
  const cached   = cache.get(cacheKey);
  if (cached) return cached;

  const data = await ytmusic.getArtist(browseId);
  cache.set(cacheKey, data, SEARCH_CACHE_TTL_MS);
  return data;
}

async function getWatchNext(videoId) {
  const cacheKey = `watch-next:${videoId}`;
  const cached   = cache.get(cacheKey);
  if (cached) return cached;

  const tracks = await ytmusic.getWatchNext(videoId);
  const result = (tracks || []).map(normalizeSong);
  cache.set(cacheKey, result, SEARCH_CACHE_TTL_MS);
  return result;
}

async function getPlaylist(playlistId, opts = {}) {
  return ytmusic.getPlaylist(playlistId, opts);
}

async function resolveId(id) {
  return ytmusic.resolve(id);
}

/**
 * Get or fetch song metadata. Used by other services.
 */
async function getSongMeta(videoId) {
  const existing = await songRepo.findByVideoId(videoId);
  if (existing) return existing;
  return null;
}

// ── Internal helpers ──────────────────────────────────────────────────────────

async function enrichWithSpotify(songs) {
  for (const song of songs) {
    if (song.spotifyId) continue;
    try {
      const id = await spotify.findSpotifyId({ title: song.title, artist: song.artist });
      if (id) {
        await songRepo.upsert({ ...song, spotifyId: id });
      }
    } catch {}
  }
}

async function persistSongs(songs) {
  for (const song of songs) {
    if (!song.videoId) continue;
    try {
      await songRepo.upsert(song);
    } catch (e) {
      logger.warn('song_persist_failed', { videoId: song.videoId, error: e.message });
    }
  }
}

module.exports = {
  searchSongs,
  searchAll,
  getHome,
  getSuggestions,
  getArtist,
  getWatchNext,
  getPlaylist,
  resolveId,
  getSongMeta,
};
