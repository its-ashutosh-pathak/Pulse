const { db }         = require('../config/firebase');
const { FieldValue } = require('firebase-admin/firestore');

const COL = 'playlists';

async function findById(playlistId) {
  const doc = await db.collection(COL).doc(playlistId).get();
  return doc.exists ? doc.data() : null;
}

/**
 * Get all non-deleted playlists owned by or shared with a user.
 */
async function findByOwner(userId) {
  const snap = await db
    .collection(COL)
    .where('ownerId', '==', userId)
    .where('deletedAt', '==', null)
    .orderBy('createdAt', 'desc')
    .get();
  return snap.docs.map((d) => d.data());
}

/**
 * Get the Liked Songs system playlist for a user.
 */
async function findLikedSongs(userId) {
  const snap = await db
    .collection(COL)
    .where('ownerId', '==', userId)
    .where('systemType', '==', 'liked_songs')
    .limit(1)
    .get();
  return snap.empty ? null : snap.docs[0].data();
}

async function create(playlistData) {
  await db.collection(COL).doc(playlistData.playlistId).set(playlistData);
  return playlistData;
}

async function update(playlistId, updates) {
  await db.collection(COL).doc(playlistId).update({
    ...updates,
    updatedAt: new Date(),
  });
}

async function softDelete(playlistId) {
  await db.collection(COL).doc(playlistId).update({
    deletedAt: new Date(),
    updatedAt: new Date(),
  });
}

async function addCollaborator(playlistId, userId) {
  await db.collection(COL).doc(playlistId).update({
    collaborators: FieldValue.arrayUnion(userId),
    updatedAt:     new Date(),
  });
}

async function removeCollaborator(playlistId, userId) {
  await db.collection(COL).doc(playlistId).update({
    collaborators: FieldValue.arrayRemove(userId),
    updatedAt:     new Date(),
  });
}

module.exports = {
  findById,
  findByOwner,
  findLikedSongs,
  create,
  update,
  softDelete,
  addCollaborator,
  removeCollaborator,
};
