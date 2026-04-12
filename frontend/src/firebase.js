import { initializeApp } from 'firebase/app';
import { getAuth, GoogleAuthProvider } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';


const firebaseConfig = {
  apiKey: "AIzaSyCW3ZLU8bm0-Btkea3Ek853IkcI397_16U",
  authDomain: "pulse-by-ap.firebaseapp.com",
  projectId: "pulse-by-ap",
  storageBucket: "pulse-by-ap.firebasestorage.app",
  messagingSenderId: "360258546308",
  appId: "1:360258546308:web:b10475e0248eab6a0af0d1",
  measurementId: "G-3K6Y13B6RX"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);

export const googleProvider = new GoogleAuthProvider();
