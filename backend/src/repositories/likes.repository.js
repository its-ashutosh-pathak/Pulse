const { db } = require('../config/firebase');

function likesCol(userId) {
  return db.collection('users').doc(userId).collection('likes');
}

async function like(userId, videoId) {
  await likesCol(userId).doc(videoId).set({ videoId, likedAt: new Date() });
}

async function unlike(userId, videoId) {
  await likesCol(userId).doc(videoId).delete();
}

async function isLiked(userId, videoId) {
  const doc = await likesCol(userId).doc(videoId).get();
  return doc.exists;
}

async function getLikedIds(userId) {
  const snap = await likesCol(userId).orderBy('likedAt', 'desc').get();
  return snap.docs.map((d) => d.data().videoId);
}

module.exports = { like, unlike, isLiked, getLikedIds };
