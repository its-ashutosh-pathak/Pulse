const { db }          = require('../config/firebase');
const { createError } = require('../utils/errorResponse');

const COL = 'users';

async function findById(userId) {
  const doc = await db.collection(COL).doc(userId).get();
  if (!doc.exists) return null;
  const data = doc.data();
  delete data.passwordHash; // safety — should never be stored but just in case
  return data;
}

async function findByEmail(email) {
  const snap = await db.collection(COL).where('email', '==', email).limit(1).get();
  if (snap.empty) return null;
  const data = snap.docs[0].data();
  delete data.passwordHash;
  return data;
}

async function create(userData) {
  await db.collection(COL).doc(userData.userId).set(userData);
  return userData;
}

async function update(userId, updates) {
  await db.collection(COL).doc(userId).update({
    ...updates,
    updatedAt: new Date(),
  });
}

module.exports = { findById, findByEmail, create, update };
