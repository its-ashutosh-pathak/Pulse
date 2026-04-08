const { db } = require('../config/firebase');

const COL = 'lyrics';

async function findByVideoId(videoId) {
  const doc = await db.collection(COL).doc(videoId).get();
  return doc.exists ? doc.data() : null;
}

async function save(lyricsData) {
  await db.collection(COL).doc(lyricsData.videoId).set({
    ...lyricsData,
    cachedAt: new Date(),
  });
}

module.exports = { findByVideoId, save };
