const { db }         = require('../config/firebase');
const { FieldValue } = require('firebase-admin/firestore');

function historyCol(userId) {
  return db.collection('users').doc(userId).collection('history');
}

/**
 * Upsert a history entry — increment playCount and update playedAt.
 */
async function upsert(userId, videoId) {
  const ref = historyCol(userId).doc(videoId);
  await db.runTransaction(async (t) => {
    const doc = await t.get(ref);
    if (doc.exists) {
      t.update(ref, {
        playedAt:   new Date(),
        playCount:  FieldValue.increment(1),
      });
    } else {
      t.set(ref, {
        videoId,
        playedAt:   new Date(),
        playCount:  1,
        lastRecommendedAt: null,
      });
    }
  });
}

/**
 * Get recent history sorted by playedAt descending.
 */
async function getRecent(userId, limit = 50) {
  const snap = await historyCol(userId)
    .orderBy('playedAt', 'desc')
    .limit(limit)
    .get();
  return snap.docs.map((d) => d.data());
}

module.exports = { upsert, getRecent };
