const admin = require('firebase-admin');
const env   = require('./env');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert({
      projectId:   env.FIREBASE_PROJECT_ID,
      clientEmail: env.FIREBASE_CLIENT_EMAIL,
      privateKey:  env.FIREBASE_PRIVATE_KEY,
    }),
  });
}

const db   = admin.firestore();
const auth = admin.auth();

// Firestore settings — disable deprecated warning
db.settings({ ignoreUndefinedProperties: true });

module.exports = { admin, db, auth };
