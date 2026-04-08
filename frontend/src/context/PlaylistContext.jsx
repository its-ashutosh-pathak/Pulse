import React, { createContext, useContext, useEffect, useState } from 'react';
import {
  collection,
  query,
  where,
  onSnapshot,
  addDoc,
  updateDoc,
  deleteDoc,
  doc,
  getDoc,
  serverTimestamp,
  arrayUnion
} from 'firebase/firestore';
import { db } from '../firebase';
import { useAuth } from './AuthContext';
import { isDownloaded, addTrackToPlaylist, activeDownloads } from '../utils/downloadManager';

const PlaylistContext = createContext(null);

export function PlaylistProvider({ children }) {
  const { user } = useAuth();
  const [playlists, setPlaylists] = useState([]);
  const [ytPlaylists, setYtPlaylists] = useState([]);
  const [loading, setLoading] = useState(true);

  // Sync playlists from Firestore where current user is owner OR collaborator
  useEffect(() => {
    if (!user) {
      setPlaylists([]);
      setYtPlaylists([]);
      setLoading(false);
      return;
    }

    const q = query(
      collection(db, 'playlists'),
      where('members', 'array-contains', user.uid)
    );

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const p = snapshot.docs
        .map(doc => ({ id: doc.id, ...doc.data(), type: 'PULSE' }))
        // Sort client-side: newest first (avoids needing a Firestore composite index)
        .sort((a, b) => {
          const tA = a.createdAt?.toMillis?.() || 0;
          const tB = b.createdAt?.toMillis?.() || 0;
          return tB - tA;
        });
      setPlaylists(p);
      setLoading(false);
    }, (error) => {
      console.error("Playlist Sync Error:", error);
      setLoading(false);
    });

    // Fetch Real YouTube Playlists (unauthenticated — public only)
    const fetchYTPlaylists = async () => {
      // In the new architecture, we rely completely on Firestore for playlists.
      // We will leave ytPlaylists empty to avoid mixing external libraries.
      setYtPlaylists([]);
    };

    fetchYTPlaylists();

    return unsubscribe;
  }, [user]);

  // Create a new playlist
  const createPlaylist = async (name = 'New Playlist') => {
    if (!user) return;
    try {
      await addDoc(collection(db, 'playlists'), {
        name,
        createdBy: user.uid,
        ownerName: user.displayName || 'Pulse User',
        members: [user.uid],
        songs: [],
        visibility: 'Public',
        createdAt: serverTimestamp(),
        lastUpdated: serverTimestamp()
      });
    } catch (e) {
      console.error("Create Playlist Error:", e);
    }
  };

  // Add a song to a playlist
  const addSongToPlaylist = async (playlistId, song) => {
    if (!user) return;
    try {
      const ref = doc(db, 'playlists', playlistId);
      await updateDoc(ref, {
        songs: arrayUnion({
          ...song,
          addedByUid: user.uid,
          addedByName: user.displayName || 'Member'
        }),
        lastUpdated: serverTimestamp()
      });

      // Edge Case Fix: If the song is already downloaded locally,
      // automatically sync it to the playlist's offline IndexedDB folder too.
      const videoId = song.videoId || song.id;
      if (videoId) {
        const locallySaved = await isDownloaded(videoId);
        const isDownloading = activeDownloads?.has(videoId);
        if (locallySaved || isDownloading) {
          // First try local state; if not found (e.g. just created) fetch from Firestore
          let plName = playlists.find(p => p.id === playlistId)?.name;
          if (!plName) {
            try {
              const snap = await getDoc(doc(db, 'playlists', playlistId));
              plName = snap.exists() ? snap.data().name : null;
            } catch {}
          }
          await addTrackToPlaylist(`__pl__${playlistId}`, plName || 'Playlist', videoId);
        }
      }
    } catch (e) {
      console.error("Add Song Error:", e);
    }
  };

  // Copy a playlist (creates an independent copy owned by current user)
  const copyPlaylist = async (playlistId, sourceSongs, sourceName) => {
    if (!user) return null;
    try {
      // Create the new playlist doc
      const docRef = await addDoc(collection(db, 'playlists'), {
        name: sourceName || 'Playlist',
        createdBy: user.uid,
        ownerName: user.displayName || 'Pulse User',
        members: [user.uid],
        songs: [],
        visibility: 'Public',
        createdAt: serverTimestamp(),
        lastUpdated: serverTimestamp(),
      });
      // Write all songs at once via updateDoc
      await updateDoc(doc(db, 'playlists', docRef.id), {
        songs: (sourceSongs || []).map(s => ({
          ...s,
          addedByUid: user.uid,
          addedByName: user.displayName || 'Pulse User',
        })),
        lastUpdated: serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      console.error('Copy Playlist Error:', e);
      return null;
    }
  };

  // Remove a song from a playlist
  const removeSongFromPlaylist = async (playlistId, songIndex) => {
    try {
      const p = playlists.find(x => x.id === playlistId);
      if (!p) return;
      const newSongs = [...p.songs];
      newSongs.splice(songIndex, 1);
      await updateDoc(doc(db, 'playlists', playlistId), {
        songs: newSongs,
        lastUpdated: serverTimestamp()
      });
    } catch (e) {
      console.error("Remove Song Error:", e);
    }
  };

  // General Update (Rename, replace entire song list, etc.)
  const updatePlaylist = async (playlistId, updates) => {
    try {
      const ref = doc(db, 'playlists', playlistId);
      await updateDoc(ref, {
        ...updates,
        lastUpdated: serverTimestamp()
      });
    } catch (e) {
      console.error("Update Playlist Error:", e);
    }
  };

  // Delete a playlist
  const deletePlaylist = async (playlistId) => {
    try {
      await deleteDoc(doc(db, 'playlists', playlistId));
    } catch (e) {
      console.error("Delete Playlist Error:", e);
    }
  };

  // Liked Songs logic
  const getLikedPlaylist = () => {
    return playlists.find(p => p.name === 'Liked Songs' && p.createdBy === user?.uid);
  };

  const isLiked = (songId) => {
    if (!songId) return false;
    const liked = getLikedPlaylist();
    if (!liked) return false;
    return liked.songs.some(s => s.id === songId || s.videoId === songId);
  };

  const toggleLike = async (song) => {
    if (!user) return;
    let liked = getLikedPlaylist();
    
    // Create it if it doesn't exist
    if (!liked) {
      try {
        const docRef = await addDoc(collection(db, 'playlists'), {
          name: 'Liked Songs',
          createdBy: user.uid,
          ownerName: user.displayName || 'Pulse User',
          members: [user.uid],
          songs: [],
          visibility: 'Private',
          createdAt: serverTimestamp(),
          lastUpdated: serverTimestamp()
        });
        liked = { id: docRef.id, songs: [] }; // optimistic local structure until snapshot updates
      } catch (e) {
        console.error("Failed to create Liked Songs playlist", e);
        return;
      }
    }

    const index = liked.songs.findIndex(s => s.id === song?.id || s.videoId === song?.id);
    if (index >= 0) {
      // Unlike (Remove)
      await removeSongFromPlaylist(liked.id, index);
    } else {
      // Like (Add)
      await addSongToPlaylist(liked.id, song);
    }
  };

  return (
    <PlaylistContext.Provider value={{
      playlists,
      ytPlaylists,
      loading,
      createPlaylist,
      addSongToPlaylist,
      copyPlaylist,
      removeSongFromPlaylist,
      deletePlaylist,
      updatePlaylist,
      toggleLike,
      isLiked
    }}>
      {children}
    </PlaylistContext.Provider>

  );
}

export const usePlaylists = () => useContext(PlaylistContext);
