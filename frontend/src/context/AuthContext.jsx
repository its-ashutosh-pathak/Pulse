import React, { createContext, useContext, useEffect, useState } from 'react';
import { onAuthStateChanged, signInWithPopup, signOut, createUserWithEmailAndPassword, signInWithEmailAndPassword, updateProfile } from 'firebase/auth';
import { doc, setDoc, getDoc, serverTimestamp } from 'firebase/firestore';
import { auth, db, googleProvider } from '../firebase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      try {
        if (firebaseUser) {
          // Attempt to sync Firestore profile, but don't block auth if it fails
          try {
            const ref = doc(db, 'users', firebaseUser.uid);
            const snap = await getDoc(ref);
            if (!snap.exists()) {
              await setDoc(ref, {
                uid: firebaseUser.uid,
                displayName: firebaseUser.displayName || 'Pulse User',
                email: firebaseUser.email,
                photoURL: firebaseUser.photoURL || null,
                createdAt: serverTimestamp(),
              });
            } else {
              const data = snap.data();
              if (data.photoURL && data.photoURL !== firebaseUser.photoURL) {
                Object.defineProperty(firebaseUser, 'photoURL', { value: data.photoURL, writable: true, configurable: true, enumerable: true });
              }
              if (data.displayName && data.displayName !== firebaseUser.displayName) {
                Object.defineProperty(firebaseUser, 'displayName', { value: data.displayName, writable: true, configurable: true, enumerable: true });
              }
            }
          } catch (firestoreError) {
            console.error("Firestore Profile Sync Error:", firestoreError);
          }
          setUser(firebaseUser);
        } else {
          setUser(null);
        }
      } catch (authError) {
        console.error("Auth State Error:", authError);
      } finally {
        setLoading(false);
      }
    });
    return unsubscribe;
  }, []);

  const loginWithGoogle = () => signInWithPopup(auth, googleProvider);

  const loginWithEmail = (email, password) =>
    signInWithEmailAndPassword(auth, email, password);

  const signupWithEmail = async (email, password, displayName) => {
    const result = await createUserWithEmailAndPassword(auth, email, password);
    await updateProfile(result.user, { displayName });
    return result;
  };

  const updateUserProfile = async (updates) => {
    if (!auth.currentUser) return;

    const cleanUpdates = Object.fromEntries(Object.entries(updates).filter(([_, v]) => v !== undefined));

    // Avoid "auth/invalid-profile-attribute" for large base64 images
    const authUpdates = { ...cleanUpdates };
    if (authUpdates.photoURL && authUpdates.photoURL.startsWith('data:image')) {
      delete authUpdates.photoURL;
    }

    if (Object.keys(authUpdates).length > 0) {
      await updateProfile(auth.currentUser, authUpdates);
    }

    const userRef = doc(db, 'users', auth.currentUser.uid);
    await setDoc(userRef, { ...cleanUpdates, lastUpdated: serverTimestamp() }, { merge: true });

    // Refresh local user state safely
    const nextUser = Object.assign(Object.create(Object.getPrototypeOf(auth.currentUser)), auth.currentUser);
    if (cleanUpdates.photoURL) {
      Object.defineProperty(nextUser, 'photoURL', { value: cleanUpdates.photoURL, writable: true, configurable: true, enumerable: true });
    }
    if (cleanUpdates.displayName) {
      Object.defineProperty(nextUser, 'displayName', { value: cleanUpdates.displayName, writable: true, configurable: true, enumerable: true });
    }
    setUser(nextUser);
  };



  const updatePlaybackStats = async (song, milliseconds) => {
    if (!auth.currentUser || !song) return;
    try {
      const token = await auth.currentUser.getIdToken();

      const payload = {
        videoId: song.id || song.videoId,
        secondsListened: Math.round(milliseconds / 1000),
        date: new Date().toISOString().split('T')[0],
        title: song.title,
        artist: song.artist,
        cover: song.thumbnail || song.cover || song.artworkUrl || ''
      };

      await fetch(`${import.meta.env.VITE_API_URL || 'http://localhost:5000'}/stats/play`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(payload)
      });
    } catch (err) {
      console.error("Failed to update playback stats:", err);
    }
  };

  const logout = () => signOut(auth);

  return (
    <AuthContext.Provider value={{ user, loading, loginWithGoogle, loginWithEmail, signupWithEmail, updateUserProfile, updatePlaybackStats, logout }}>
      {!loading && children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
