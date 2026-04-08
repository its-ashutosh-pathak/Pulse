import React, { createContext, useContext, useEffect, useState } from 'react';
import { onAuthStateChanged, signInWithPopup, signOut, createUserWithEmailAndPassword, signInWithEmailAndPassword, updateProfile } from 'firebase/auth';
import { doc, setDoc, getDoc, serverTimestamp, increment, collection, setDoc as setDocAlt, updateDoc } from 'firebase/firestore';
import { ref, uploadBytes, getDownloadURL } from 'firebase/storage';
import { auth, db, storage, googleProvider } from '../firebase';

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

  const updateUserProfile = async (displayName, photoURL) => {
    if (!auth.currentUser) return;
    
    await updateProfile(auth.currentUser, { displayName, photoURL });
    const userRef = doc(db, 'users', auth.currentUser.uid);
    await setDoc(userRef, { displayName, photoURL, lastUpdated: serverTimestamp() }, { merge: true });
    setUser({ ...auth.currentUser });
  };

  const uploadProfilePhoto = async (file) => {
    if (!auth.currentUser || !file) return;

    try {
      // 1. Create Storage Reference
      const fileRef = ref(storage, `profile_pics/${auth.currentUser.uid}`);
      
      // 2. Upload Bytes
      await uploadBytes(fileRef, file);
      
      // 3. Get Download URL
      const photoURL = await getDownloadURL(fileRef);
      
      // 4. Update Profile with new URL
      await updateUserProfile(auth.currentUser.displayName, photoURL);
      return photoURL;
    } catch (error) {
      console.error("AuthContext: Upload Error:", error);
      throw error; // Let Profile.jsx handle the UI alert/reset
    }
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
      
      await fetch('http://localhost:5000/stats/play', {
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
    <AuthContext.Provider value={{ user, loading, loginWithGoogle, loginWithEmail, signupWithEmail, updateUserProfile, uploadProfilePhoto, updatePlaybackStats, logout }}>
      {!loading && children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
