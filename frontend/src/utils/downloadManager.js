/**
 * downloadManager.js — Pulse Offline Download System
 *
 * Uses IndexedDB (via a thin wrapper) to store:
 *   - Song audio blobs (objectStore: 'songs')
 *   - Per-song metadata (objectStore: 'tracks')
 *   - Playlist references (objectStore: 'playlists')
 *
 * Two playlist slots are always maintained:
 *   1. "Downloads"  (id: '__downloads__') — every downloaded song goes here
 *   2. Per-source   (id: `__pl__${playlist.id}`) — songs downloaded from a playlist
 */

const DB_NAME = 'PulseOffline';
const DB_VERSION = 1;

// ── IndexedDB bootstrap ───────────────────────────────────────────────────────

let _db = null;

function openDB() {
  if (_db) return Promise.resolve(_db);
  return new Promise((resolve, reject) => {
    const req = indexedDB.open(DB_NAME, DB_VERSION);
    req.onupgradeneeded = (e) => {
      const db = e.target.result;
      if (!db.objectStoreNames.contains('tracks')) {
        db.createObjectStore('tracks', { keyPath: 'videoId' });
      }
      if (!db.objectStoreNames.contains('audio')) {
        db.createObjectStore('audio', { keyPath: 'videoId' });
      }
      if (!db.objectStoreNames.contains('playlists')) {
        db.createObjectStore('playlists', { keyPath: 'id' });
      }
    };
    req.onsuccess = (e) => { _db = e.target.result; resolve(_db); };
    req.onerror = (e) => reject(e.target.error);
  });
}

function idbGet(store, key) {
  return openDB().then(db => new Promise((res, rej) => {
    const tx = db.transaction(store, 'readonly');
    const req = tx.objectStore(store).get(key);
    req.onsuccess = () => res(req.result);
    req.onerror = () => rej(req.error);
  }));
}

function idbPut(store, value) {
  return openDB().then(db => new Promise((res, rej) => {
    const tx = db.transaction(store, 'readwrite');
    const req = tx.objectStore(store).put(value);
    req.onsuccess = () => res(req.result);
    req.onerror = () => rej(req.error);
  }));
}

function idbGetAll(store) {
  return openDB().then(db => new Promise((res, rej) => {
    const tx = db.transaction(store, 'readonly');
    const req = tx.objectStore(store).getAll();
    req.onsuccess = () => res(req.result);
    req.onerror = () => rej(req.error);
  }));
}

function idbDelete(store, key) {
  return openDB().then(db => new Promise((res, rej) => {
    const tx = db.transaction(store, 'readwrite');
    const req = tx.objectStore(store).delete(key);
    req.onsuccess = () => res();
    req.onerror = () => rej(req.error);
  }));
}

// ── Playlist helpers ──────────────────────────────────────────────────────────

const GLOBAL_DL_ID = '__downloads__';

async function getOrCreatePlaylist(id, name) {
  const existing = await idbGet('playlists', id);
  if (existing) return existing;
  const pl = { id, name, createdAt: Date.now(), tracks: [] };
  await idbPut('playlists', pl);
  return pl;
}

export async function addTrackToPlaylist(playlistId, playlistName, videoId) {
  const pl = await getOrCreatePlaylist(playlistId, playlistName);
  if (!pl.tracks.includes(videoId)) {
    pl.tracks.push(videoId);
    await idbPut('playlists', pl);
  }
}

const downloadEvents = new EventTarget();
export const activeDownloads = new Map(); // videoId -> progress (0 to 1)

export function subscribeToDownload(videoId, callback) {
  const handler = (e) => {
    if (e.detail.videoId === videoId) callback(e.detail.progress, e.detail.status);
  };
  downloadEvents.addEventListener('download', handler);
  callback(activeDownloads.get(videoId) || 0, activeDownloads.has(videoId) ? 'downloading' : 'idle');
  return () => downloadEvents.removeEventListener('download', handler);
}

function emitDl(videoId, progress, status) {
  if (status === 'downloading') activeDownloads.set(videoId, progress);
  else activeDownloads.delete(videoId);
  downloadEvents.dispatchEvent(new CustomEvent('download', { detail: { videoId, progress, status } }));
}

/**
 * Download a single song.
 * @param {Object} song            - Standard Pulse song object
 * @param {Object|null} [contextPlaylist] - Optional: { id, name } of the playlist this song came from
 * @param {string} [authToken]     - Firebase ID token for authenticated API calls
 */
export async function downloadSong(song, contextPlaylist = null, authToken = '') {
  const videoId = song?.videoId || song?.id;
  if (!videoId) throw new Error('Missing videoId');

  emitDl(videoId, 0, 'downloading');

  try {
    const headers = authToken ? { Authorization: `Bearer ${authToken}` } : {};
    const audioRes = await fetch(`http://localhost:5000/api/download/${videoId}`, { headers });
    if (!audioRes.ok) throw new Error(`Could not download stream (${audioRes.status})`);

    // Read stream chunks for progress
    const contentLength = +audioRes.headers.get('Content-Length') || +audioRes.headers.get('content-length') || 0;
    const reader = audioRes.body.getReader();
    let receivedLength = 0;
    const chunks = [];

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      chunks.push(value);
      receivedLength += value.length;
      if (contentLength) {
        emitDl(videoId, receivedLength / contentLength, 'downloading');
      } else {
        // fake progress if no content length (rare)
        emitDl(videoId, Math.min(0.9, (receivedLength / 5000000)), 'downloading');
      }
    }

    const audioBlob = new Blob(chunks, { type: audioRes.headers.get('Content-Type') || 'audio/webm' });

    // 3. Persist audio blob
    await idbPut('audio', { videoId, blob: audioBlob, mimeType: audioBlob.type, downloadedAt: Date.now() });

    // 4. Persist track metadata (strip blob-heavy fields, keep lightweight meta)
    const trackMeta = {
      videoId,
      title: song.title || 'Unknown',
      artist: song.artist || 'Unknown',
      album: song.album || '',
      thumbnail: song.thumbnail || song.cover || '',
      cover: song.cover || song.thumbnail || '',
      duration: song.duration || 0,
      downloadedAt: Date.now(),
    };
    await idbPut('tracks', trackMeta);

    // 5. Add to global "Downloads" playlist
    await addTrackToPlaylist(GLOBAL_DL_ID, 'Downloads', videoId);

    // 6. If downloaded from a playlist, add to that playlist's offline folder too
    if (contextPlaylist?.id) {
      const plId = `__pl__${contextPlaylist.id}`;
      const plName = contextPlaylist.name || 'Playlist';
      await addTrackToPlaylist(plId, plName, videoId);
    }

    emitDl(videoId, 1, 'done');
    return trackMeta;
  } catch (err) {
    emitDl(videoId, 0, 'error');
    throw err;
  }
}

/**
 * Check whether a song is already downloaded.
 * @param {string} videoId
 * @returns {Promise<boolean>}
 */
export async function isDownloaded(videoId) {
  const entry = await idbGet('audio', videoId);
  return Boolean(entry);
}

/**
 * Get a Set of all downloaded video IDs for fast batch lookup.
 * @returns {Promise<Set<string>>}
 */
export async function getDownloadedVideoIds() {
  const tracks = await idbGetAll('tracks');
  return new Set(tracks.map(t => t.videoId));
}

/**
 * Get all downloaded tracks (metadata only, no blobs).
 * @returns {Promise<Object[]>}
 */
export async function getAllDownloadedTracks() {
  return idbGetAll('tracks');
}

/**
 * Get all offline playlists (including the global "Downloads" folder).
 * Hydrates each playlist with its track metadata.
 * @returns {Promise<Object[]>}
 */
export async function getAllOfflinePlaylists() {
  const [playlists, tracks] = await Promise.all([
    idbGetAll('playlists'),
    idbGetAll('tracks'),
  ]);

  const trackMap = {};
  tracks.forEach(t => { trackMap[t.videoId] = t; });

  return playlists.map(pl => ({
    ...pl,
    tracks: (pl.tracks || []).map(id => trackMap[id]).filter(Boolean),
  }));
}

/**
 * Get a single offline playlist by its real playlist id.
 * Pass the raw playlist ID (not the __pl__ prefixed version).
 */
export async function getOfflinePlaylist(playlistId) {
  const id = `__pl__${playlistId}`;
  const pl = await idbGet('playlists', id);
  if (!pl) return null;
  const tracks = await idbGetAll('tracks');
  const trackMap = {};
  tracks.forEach(t => { trackMap[t.videoId] = t; });
  return {
    ...pl,
    tracks: (pl.tracks || []).map(vid => trackMap[vid]).filter(Boolean),
  };
}

/**
 * Get the global Downloads playlist.
 */
export async function getDownloadsPlaylist() {
  const pl = await idbGet('playlists', GLOBAL_DL_ID);
  if (!pl) return { id: GLOBAL_DL_ID, name: 'Downloads', tracks: [] };
  const tracks = await idbGetAll('tracks');
  const trackMap = {};
  tracks.forEach(t => { trackMap[t.videoId] = t; });
  return {
    ...pl,
    tracks: (pl.tracks || []).map(vid => trackMap[vid]).filter(Boolean),
  };
}

/**
 * Get an object URL for a downloaded song's audio blob.
 * The caller is responsible for revoking the URL via URL.revokeObjectURL().
 */
export async function getAudioObjectURL(videoId) {
  const entry = await idbGet('audio', videoId);
  if (!entry?.blob) throw new Error('Song not downloaded');
  return URL.createObjectURL(entry.blob);
}

/**
 * Remove a downloaded song everywhere.
 */
export async function removeDownload(videoId) {
  await idbDelete('audio', videoId);
  await idbDelete('tracks', videoId);

  // Remove from every playlist that contains it
  const playlists = await idbGetAll('playlists');
  await Promise.all(playlists.map(async (pl) => {
    if (pl.tracks?.includes(videoId)) {
      pl.tracks = pl.tracks.filter(id => id !== videoId);
      await idbPut('playlists', pl);
    }
  }));
}

/**
 * Rename an offline playlist.
 * @param {string} playlistId  - IDB key (e.g. '__pl__abc123')
 * @param {string} newName     - New display name
 */
export async function renameOfflinePlaylist(playlistId, newName) {
  const pl = await idbGet('playlists', playlistId);
  if (!pl) return;
  await idbPut('playlists', { ...pl, name: newName });
}

/**
 * Delete an entire offline playlist folder (songs themselves are NOT removed,
 * only the playlist reference — they still exist in the global Downloads folder).
 * @param {string} playlistId  - IDB key (e.g. '__pl__abc123')
 */
export async function deleteOfflinePlaylist(playlistId) {
  await idbDelete('playlists', playlistId);
}

/**
 * Update the track list of an offline playlist (e.g., after removing songs via Edit Songs modal).
 * Pass the full playlist IDB id (e.g. '__pl__abc123' or '__downloads__') and the
 * new tracks array (array of track metadata objects — their videoIds are extracted).
 * @param {string} playlistId  - IDB key
 * @param {Object[]} tracks    - New array of track metadata objects
 */
export async function updateOfflinePlaylistTracks(playlistId, tracks) {
  const pl = await idbGet('playlists', playlistId);
  if (!pl) return;
  const videoIds = tracks.map(t => t.videoId).filter(Boolean);
  await idbPut('playlists', { ...pl, tracks: videoIds });
}
