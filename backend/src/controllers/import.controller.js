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
 * Returns the FULL matched YouTube track so we can inherit its cover art.
 */
async function resolveYTSong(track) {
  if (track.videoId) return track;
  try {
    const results = await metadataService.searchSongs(`${track.title} ${track.artist}`);
    return results[0] || null;
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
    const ytMatch = await resolveYTSong(track);
    if (!ytMatch || !ytMatch.videoId) return false;
    
    // Inherit the cover art from YouTube if Spotify didn't provide one
    const mergedTrack = { 
      ...track, 
      videoId: ytMatch.videoId,
      cover: track.cover || ytMatch.thumbnail || ''
    };
    
    await appendSongToPlaylist(playlistId, mergedTrack);
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
 * GET /api/import/spotify/preview?url=...
 * Lightweight: returns { name, total } for the preview card.
 * No auth needed — just validates the playlist is public.
 */
async function importSpotifyPreview(req, res, next) {
  try {
    const { url } = req.query;
    if (!url) return next(createError(400, 'MISSING_URL', 'url query param is required'));

    // Extract Base62 ID (same logic as the POST)
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

    const meta = await spotifyService.getPlaylistMeta(id);
    return res.json(successBody({ id, name: meta.name, total: meta.total }));
  } catch (e) {
    next(e);
  }
}

/**
 * POST /api/import/spotify
 * Streams real-time per-song progress via Server-Sent Events (SSE).
 * The frontend reads the stream and updates the progress bar after every matched song.
 */
async function importSpotify(req, res, next) {
  // ── SSE setup ──────────────────────────────────────────────────────────────
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no'); // disable nginx/Railway response buffering
  res.flushHeaders();

  const send = (obj) => res.write(`data: ${JSON.stringify(obj)}\n\n`);
  const sendError = (msg) => { send({ type: 'error', message: msg }); res.end(); };

  try {
    const { url } = req.body;
    if (!url) return sendError('Spotify playlist URL is required');

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
      return sendError('Not a valid Spotify playlist URL.');
    }

    // 1. Send an immediate signal so the frontend knows we're working
    send({ type: 'fetching', message: 'Fetching tracks from Spotify…' });

    // 2. Fetch all tracks from Spotify (using API + embed fallback)
    const playlistData = await spotifyService.getFullPlaylist(id);
    playlistData.tracks = playlistData.tracks.filter(t => t.title && t.artist);

    const total = playlistData.tracks.length;
    if (total === 0) return sendError('This playlist is empty or tracks are hidden.');

    // 2. Create the Firestore playlist doc immediately
    const docRef = db.collection('playlists').doc();
    const playlistId = docRef.id;
    await docRef.set({
      name:         playlistData.name,
      createdBy:    req.user.userId,
      ownerName:    req.user.displayName || 'Pulse User',
      members:      [req.user.userId],
      songs:        [],
      visibility:   'Public',
      importedFrom: 'spotify',
      createdAt:    FieldValue.serverTimestamp(),
      lastUpdated:  FieldValue.serverTimestamp(),
    });

    // 3. Send initial metadata so frontend can set up UI
    send({ type: 'start', playlistId, total });

    // 4. Process every track — stream a progress event after each one
    let succeeded = 0;
    for (let i = 0; i < total; i++) {
      const track = playlistData.tracks[i];
      const ytMatch = await resolveYTSong(track);

      if (ytMatch?.videoId) {
        const mergedTrack = {
          ...track,
          videoId: ytMatch.videoId,
          cover: track.cover || ytMatch.thumbnail || '',
        };
        await appendSongToPlaylist(playlistId, mergedTrack);
        succeeded++;
      }

      // Emit real progress after every single song attempt
      send({ type: 'progress', current: i + 1, total, succeeded });
    }

    logger.info('import_spotify_stream_done', { playlistId, total, succeeded });
    send({ type: 'done', playlistId, succeeded, total });
    res.end();
  } catch (e) {
    logger.error('import_spotify_stream_failed', { error: e.message });
    sendError(e.message || 'Import failed.');
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
    const ytmData = await metadataService.getPlaylist(id, { full: true });

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
  importSpotifyPreview,
  importSpotify,
  importYTMusic
};
