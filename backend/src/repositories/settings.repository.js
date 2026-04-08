const { db }           = require('../config/firebase');
const { defaultSettings } = require('../utils/normalize');

function prefsDoc(userId) {
  return db.collection('users').doc(userId).collection('settings').doc('preferences');
}

async function get(userId) {
  const doc = await prefsDoc(userId).get();
  if (!doc.exists) return defaultSettings();
  return { ...defaultSettings(), ...doc.data() };
}

async function update(userId, updates) {
  await prefsDoc(userId).set(
    { ...updates, updatedAt: new Date() },
    { merge: true }
  );
  return get(userId);
}

module.exports = { get, update };
