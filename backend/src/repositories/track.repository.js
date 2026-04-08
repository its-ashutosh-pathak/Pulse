const { db }         = require('../config/firebase');
const { FieldValue } = require('firebase-admin/firestore');

function tracksCol(playlistId) {
  return db.collection('playlists').doc(playlistId).collection('tracks');
}

/**
 * Paginated track listing ordered by float order field.
 */
async function findByPlaylist(playlistId, { cursor, limit = 50 } = {}) {
  let query = tracksCol(playlistId).orderBy('order').limit(limit);
  if (cursor) query = query.startAfter(cursor);
  const snap = await query.get();
  return snap.docs.map((d) => d.data());
}

/**
 * Check if a videoId already exists in a playlist (for deduplication).
 */
async function findByVideoId(playlistId, videoId) {
  const snap = await tracksCol(playlistId)
    .where('videoId', '==', videoId)
    .limit(1)
    .get();
  return snap.empty ? null : snap.docs[0].data();
}

/**
 * Get all tracks (for copy/reorder operations).
 */
async function getAll(playlistId) {
  const snap = await tracksCol(playlistId).orderBy('order').get();
  return snap.docs.map((d) => d.data());
}

/**
 * Get the current maximum order value in a playlist.
 */
async function getMaxOrder(playlistId) {
  const snap = await tracksCol(playlistId)
    .orderBy('order', 'desc')
    .limit(1)
    .get();
  if (snap.empty) return 0;
  return snap.docs[0].data().order || 0;
}

async function create(playlistId, trackData) {
  await tracksCol(playlistId).doc(trackData.trackId).set(trackData);
  return trackData;
}

async function deleteTrack(playlistId, trackId) {
  await tracksCol(playlistId).doc(trackId).delete();
}

async function deleteByVideoId(playlistId, videoId) {
  const snap = await tracksCol(playlistId)
    .where('videoId', '==', videoId)
    .limit(1)
    .get();
  if (!snap.empty) {
    await snap.docs[0].ref.delete();
  }
}

/**
 * Update the order of multiple tracks in a Firestore transaction.
 */
async function batchUpdateOrder(playlistId, updates) {
  // updates = [{ trackId, newOrder }, ...]
  const batch = db.batch();
  for (const { trackId, newOrder } of updates) {
    batch.update(tracksCol(playlistId).doc(trackId), { order: newOrder });
  }
  await batch.commit();
}

module.exports = {
  findByPlaylist,
  findByVideoId,
  getAll,
  getMaxOrder,
  create,
  deleteTrack,
  deleteByVideoId,
  batchUpdateOrder,
};
