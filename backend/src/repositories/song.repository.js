const { db } = require('../config/firebase');
const { FieldValue } = require('firebase-admin/firestore');

const COL = 'songs';

async function findByVideoId(videoId) {
  const doc = await db.collection(COL).doc(videoId).get();
  return doc.exists ? doc.data() : null;
}

/**
 * Upsert a song document. Uses merge so existing fields aren't overwritten.
 */
async function upsert(songData) {
  await db.collection(COL).doc(songData.videoId).set(
    { ...songData, cachedAt: new Date() },
    { merge: true }
  );
}

async function markUnavailable(videoId) {
  await db.collection(COL).doc(videoId).update({
    isAvailable: false,
    updatedAt:   new Date(),
  });
}

/**
 * Query songs by artist for duplicate detection.
 * Returns up to 10 songs by this artist for in-process similarity check.
 */
async function findByArtist(artist) {
  const snap = await db
    .collection(COL)
    .where('artist', '==', artist)
    .limit(10)
    .get();
  return snap.docs.map((d) => d.data());
}

module.exports = { findByVideoId, upsert, markUnavailable, findByArtist };
