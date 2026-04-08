const { db }         = require('../config/firebase');
const { FieldValue } = require('firebase-admin/firestore');

function statsDoc(userId, date) {
  return db.collection('users').doc(userId).collection('listeningStats').doc(date);
}

function songStatDoc(userId, videoId) {
  return db.collection('users').doc(userId).collection('songStats').doc(videoId);
}

function artistStatDoc(userId, artistKey) {
  return db.collection('users').doc(userId).collection('artistStats').doc(artistKey);
}

/**
 * Record a listening event atomically.
 * Uses FieldValue.increment — no read needed, safe for concurrent writes.
 */
async function recordPlay(userId, { videoId, secondsListened, date, title, artist, cover, artistKey }) {
  const batch = db.batch();

  // Daily listening bucket
  batch.set(statsDoc(userId, date), {
    date,
    totalSeconds: FieldValue.increment(secondsListened),
    updatedAt:    new Date(),
  }, { merge: true });

  // Per-song stats
  batch.set(songStatDoc(userId, videoId), {
    videoId,
    title:        title  || '',
    artist:       artist || '',
    cover:        cover  || '',
    totalSeconds: FieldValue.increment(secondsListened),
    playCount:    FieldValue.increment(1),
    lastPlayedAt: new Date(),
  }, { merge: true });

  // Per-artist stats
  batch.set(artistStatDoc(userId, artistKey), {
    artistKey,
    artist:       artist || '',
    totalSeconds: FieldValue.increment(secondsListened),
    playCount:    FieldValue.increment(1),
    lastPlayedAt: new Date(),
  }, { merge: true });

  await batch.commit();
}

/**
 * Get daily listening stats for a list of dates.
 */
async function getByDates(userId, dates) {
  if (!dates.length) return [];
  // Firestore IN query supports up to 30 values; chunk if needed
  const CHUNK = 30;
  const results = [];
  for (let i = 0; i < dates.length; i += CHUNK) {
    const chunk = dates.slice(i, i + CHUNK);
    const snap  = await db
      .collection('users').doc(userId)
      .collection('listeningStats')
      .where('date', 'in', chunk)
      .get();
    snap.docs.forEach((d) => results.push(d.data()));
  }
  return results;
}

/**
 * Get all daily listening docs (for lifetime stats). Paginates internally.
 */
async function getAll(userId) {
  const snap = await db
    .collection('users').doc(userId)
    .collection('listeningStats')
    .orderBy('date', 'asc')
    .get();
  return snap.docs.map((d) => d.data());
}

/**
 * Get top songs by play count (number of times the user played the song).
 */
async function getTopSongs(userId, limit = 10) {
  const snap = await db
    .collection('users').doc(userId)
    .collection('songStats')
    .orderBy('playCount', 'desc')
    .limit(limit)
    .get();
  return snap.docs.map((d) => d.data());
}

/**
 * Get top artists by total listen time.
 */
async function getTopArtists(userId, limit = 10) {
  const snap = await db
    .collection('users').doc(userId)
    .collection('artistStats')
    .orderBy('totalSeconds', 'desc')
    .limit(limit)
    .get();
  return snap.docs.map((d) => d.data());
}

module.exports = { recordPlay, getByDates, getAll, getTopSongs, getTopArtists };
