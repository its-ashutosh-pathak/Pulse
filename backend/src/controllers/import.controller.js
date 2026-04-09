/**
 * import.controller.js
 * Handles playlist extraction and bulk importing into Firebase.
 * Utilizes a Hybrid Sync/Async model to prevent HTTP connection timeouts on massive playlists.
 *
 * IMPORTANT: Writes directly to Firestore using the frontend-compatible schema
 * (members[], createdBy, songs[]) so PlaylistContext can find the playlist immediately.
 */
const { successBody, createError } = require('../utils/errorResponse');
const logger = require('../utils/logger');
const spotifyService = require('../services/spotify.service');
const metadataService = require('../services/metadata.service');
const { db } = require('../config/firebase');
const { FieldValue } = require('firebase-admin/firestore');

/**
 * Save a single song into the Firestore playlist's songs[] array.
 * Uses the same schema as PlaylistContext (songs embedded in the playlist doc).
 */
async function appendSongToPlaylist(playlistId, song) {
  await db.collection('playlists').doc(playlistId).update({
    songs: FieldValue.arrayUnion({
      videoId:   song.videoId,
      id:        song.videoId,
      title:     song.title || '',
      artist:    song.artist || '',
      thumbnail: song.cover || song.thumbnail || '',
      duration:  song.duration || 0,
    }),
    lastUpdated: FieldValue.serverTimestamp(),
  });
}

/**
 * For Spotify tracks that have no videoId yet, search YouTube Music to resolve one.
 */
async function resolveVideoId(track) {
  if (track.videoId) return track.videoId;
  try {
    const results = await metadataService.searchSongs(`${track.title} ${track.artist}`);
    return results[0]?.videoId || null;
  } catch {
    return null;
  }
}

/**
 * Common Hybrid Execution Strategy for both sources.
 * Writes directly to Firestore using the frontend-compatible schema so
 * PlaylistContext (which queries by members[]) can see the playlist instantly.
 */
async function executeHybridImport(res, userId, userDisplayName, playlistData, source) {
  // 1. Create playlist with the schema PlaylistContext already understands
  const docRef = db.collection('playlists').doc(); // auto-generated ID
  const playlistId = docRef.id;
  await docRef.set({
    name:        playlistData.name,
    createdBy:   userId,
    ownerName:   userDisplayName || 'Pulse User',
    members:     [userId],          // ← PlaylistContext queries this field
    songs:       [],
    visibility:  'Public',
    importedFrom: source,
    createdAt:   FieldValue.serverTimestamp(),
    lastUpdated: FieldValue.serverTimestamp(),
  });

  const total = playlistData.tracks.length;
  logger.info(`import_${source}_started`, { userId, playlistId, totalTracks: total });

  // Helper: resolve + save one track, returns true on success
  const processTrack = async (track) => {
    const videoId = await resolveVideoId(track);
    if (!videoId) return false;
    await appendSongToPlaylist(playlistId, { ...track, videoId });
    return true;
  };

  // 2. Hybrid Split Strategy (Threshold: 50)
  if (total <= 50) {
    // A. Synchronous: small playlist, finish completely before responding
    let succeeded = 0;
    for (const track of playlistData.tracks) {
      if (await processTrack(track)) succeeded++;
    }
    logger.info(`import_${source}_completed_sync`, { userId, playlistId, succeeded });
    return res.json(successBody({ status: 'completed', playlistId, totalProcessed: succeeded }));
  } else {
    // B. Asynchronous: process first 20 tracks synchronously so UI has content,
    //    then release the HTTP response and finish the rest in background.
    const INITIAL_CHUNK_SIZE = 20;
    const initialChunk    = playlistData.tracks.slice(0, INITIAL_CHUNK_SIZE);
    const backgroundChunk = playlistData.tracks.slice(INITIAL_CHUNK_SIZE);

    for (const track of initialChunk) await processTrack(track);

    // Respond immediately so the user can navigate to their playlist
    res.json(successBody({ status: 'processing', playlistId, totalExpected: total }));

    // Fire-and-forget the remainder
    (async () => {
      let succeeded = INITIAL_CHUNK_SIZE;
      for (const track of backgroundChunk) {
        if (await processTrack(track)) succeeded++;
      }
      logger.info(`import_${source}_completed_async`, { playlistId, succeeded });
    })().catch(err =>
      logger.error(`import_${source}_failed_async`, { playlistId, error: err.message })
    );
  }
}

/**
 * POST /api/import/spotify
 * Body: { url: 'https://open.spotify.com/playlist/...' }
 */
async function importSpotify(req, res, next) {
  try {
    const { url } = req.body;
    if (!url) return next(createError(400, 'MISSING_URL', 'Spotify playlist URL is required'));

    // Extract Base62 ID
    let id = url.trim();
    const uriMatch = id.match(/^spotify:playlist:([A-Za-z0-9]+)/);
    if (uriMatch) {
      id = uriMatch[1];
    } else {
      try {
        const u = new URL(id);
        const m = u.pathname.match(/\/playlist\/([A-Za-z0-9]+)/);
        if (m) id = m[1];
      } catch { }
    }
    
    if (id.length < 10 || id.length > 30 || /[^A-Za-z0-9]/.test(id)) {
      return next(createError(400, 'INVALID_URL', 'Not a valid Spotify playlist URL.'));
    }

    // Call our robust Spotify wrapper Service
    const playlistData = await spotifyService.getFullPlaylist(id);

    // Filter out missing names just in case
    playlistData.tracks = playlistData.tracks.filter(t => t.title && t.artist);

    // Pass off to the execution core
    await executeHybridImport(res, req.user.userId, req.user.displayName, playlistData, 'spotify');
  } catch (e) {
    next(e);
  }
}

/**
 * POST /api/import/ytmusic
 * Body: { url: 'https://music.youtube.com/playlist?list=...' }
 */
async function importYTMusic(req, res, next) {
  try {
    const { url } = req.body;
    if (!url) return next(createError(400, 'MISSING_URL', 'YouTube playlist URL is required'));

    // Extract Youtube Playlist ID (PL... or VL... or RD...)
    let id = url.trim();
    try {
      const u = new URL(id);
      const list = u.searchParams.get('list');
      if (list) {
        id = list;
      } else {
        const m = u.pathname.match(/\/(PL|VL|RD|OL|MPRE)[A-Za-z0-9_-]+/);
        if (m) id = m[0].slice(1);
      }
    } catch { }

    if (!/^(PL|VL|RD|OL|MPRE)[A-Za-z0-9_-]+$/.test(id)) {
      return next(createError(400, 'INVALID_URL', 'Not a valid YouTube Music playlist URL.'));
    }

    // Call innerTube wrapper (metadataService directly fetches massive metadata + tracks)
    const ytmData = await metadataService.getPlaylist(id);

    // Standardize array structure for Hybrid Exec
    const playlistData = {
      name: ytmData.title || 'Imported YT Playlist',
      tracks: (ytmData.items || ytmData.tracks || ytmData.songs || [])
        .map(s => ({
            videoId: s.videoId || s.id,
            title: s.title || s.name || '',
            artist: s.artist || (s.artists || []).map(a => a.name).join(', ') || '',
            duration: s.duration || 0,
            cover: s.thumbnail || s.cover || ''
        }))
        .filter(s => s.videoId && s.videoId.length === 11) // standard validation
    };

    if (playlistData.tracks.length === 0) {
      return next(createError(404, 'EMPTY_PLAYLIST', 'Could not extract valid videos from this YouTube Playlist.'));
    }

    // Pass off to execution core
    await executeHybridImport(res, req.user.userId, req.user.displayName, playlistData, 'ytmusic');
  } catch (e) {
    logger.warn('import_ytmusic_failed', { error: e.message });
    next(createError(500, 'YTM_IMPORT_FAILED', 'Failed to fetch YouTube Music playlist. Make sure the playlist is Public.'));
  }
}

module.exports = { 
  importSpotify,
  importYTMusic
};
