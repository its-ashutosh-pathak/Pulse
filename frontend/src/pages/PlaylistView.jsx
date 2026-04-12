import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Play, Share2, Trash2, ArrowLeft, Search, Music, Globe, Shuffle, Download, ArrowUpDown, ArrowUp, ArrowDown, Check, Loader, MoreVertical, PlusSquare, ArrowRight, ListMusic, User, Disc } from 'lucide-react';
import { getHighResThumb } from '../utils';
import { downloadSong, isDownloaded, getDownloadedVideoIds } from '../utils/downloadManager';

import { usePlaylists } from '../context/PlaylistContext';
import { useAuth } from '../context/AuthContext';
import { useAudio } from '../context/AudioContext';
import { doc, getDoc } from 'firebase/firestore';
import { db } from '../firebase';
import SongActionMenu from '../components/SongActionMenu';
import AddToPlaylistModal from '../components/AddToPlaylistModal';
import DownloadOverlay from '../components/DownloadOverlay';
import './PlaylistView.css';

export default function PlaylistView() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const { playlists, addSongToPlaylist, removeSongFromPlaylist, copyPlaylist, updateLastPlayed } = usePlaylists();
  const { playSong, addToQueue, setQueue, currentSong, isShuffled, toggleShuffle, replaceQueue } = useAudio();

  // Firestore playlist state
  const [playlist, setPlaylist] = useState(null);
  const [creator, setCreator] = useState(null);
  const [isCopied, setIsCopied] = useState(false);
  const [isCopying, setIsCopying] = useState(false);
  const [copyDone, setCopyDone] = useState(false);

  // YTM playlist state (when not a Firestore playlist)
  const [ytmPlaylist, setYtmPlaylist] = useState(null);
  const [ytmLoading, setYtmLoading] = useState(false);
  const [ytmError, setYtmError] = useState(false);

  const [trackFilter, setTrackFilter] = useState('');
  const [sortKey, setSortKey] = useState(() => localStorage.getItem('pulse_playlist_sort_key') || 'recent');
  const [sortOrder, setSortOrder] = useState(() => localStorage.getItem('pulse_playlist_sort_order') || 'desc');
  const [showSortDropdown, setShowSortDropdown] = useState(false);
  const [downloading, setDownloading] = useState(false);
  const [downloadProgress, setDownloadProgress] = useState(null);

  // Modal and Action Menu State
  const [activeMenuId, setActiveMenuId] = useState(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [selectedSong, setSelectedSong] = useState(null);
  const [addedStatus, setAddedStatus] = useState(null);

  useEffect(() => {
    const close = () => setActiveMenuId(null);
    window.addEventListener('click', close);
    return () => window.removeEventListener('click', close);
  }, []);

  useEffect(() => {
    localStorage.setItem('pulse_playlist_sort_key', sortKey);
    localStorage.setItem('pulse_playlist_sort_order', sortOrder);
  }, [sortKey, sortOrder]);

  // 1. Try Firestore first
  useEffect(() => {
    const found = playlists.find(p => p.id === id);
    if (found) {
      setPlaylist(found);
      setYtmPlaylist(null);
    }
  }, [id, playlists]);

  // 2. If not in Firestore, fetch from YTM API (playlist/album)
  useEffect(() => {
    if (playlist) return; // Already found in Firestore
    if (!id) return;

    // STRICT GUARD: Do not query the YTM API with local Firestore IDs
    const isYTMPrefix = ['VL', 'PL', 'RD', 'OL', 'MPRE'].some(prefix => id.startsWith(prefix));
    if (!isYTMPrefix) return;

    setYtmLoading(true);
    setYtmError(false);

    // FIX #8: Pass full=true to fetch ALL tracks (continuation tokens)
    fetch(`${import.meta.env.VITE_API_URL || 'http://localhost:5000'}/api/playlist/${id}?full=true`)
      .then(r => r.json())
      .then(json => {
        if (!json || !json.success) { setYtmError(true); return; }
        setYtmPlaylist(json.data);
      })
      .catch(() => setYtmError(true))
      .finally(() => setYtmLoading(false));
  }, [id, playlist]);

  // Fetch playlist creator from Firestore (for Firestore playlists only)
  useEffect(() => {
    if (!playlist?.createdBy) return;
    if (playlist.createdBy === user?.uid) {
      setCreator({ displayName: user.displayName, photoURL: user.photoURL });
      return;
    }
    getDoc(doc(db, 'users', playlist.createdBy))
      .then(snap => { if (snap.exists()) setCreator(snap.data()); })
      .catch(err => console.error('Failed to sync creator profile:', err));
  }, [playlist, user]);

  const isOwner = playlist?.createdBy === user?.uid;

  const getInitials = (name) => {
    if (!name) return 'P';
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  };

  const handleShare = () => {
    navigator.clipboard.writeText(window.location.href);
    setIsCopied(true);
    setTimeout(() => setIsCopied(false), 2000);
  };

  const handleDownload = async () => {
    const songs = sourceSongs;
    if (!songs.length) return;
    setDownloading(true);
    const playlistRef = { id, name: sourceName };
    try {
      const authToken = user ? await user.getIdToken() : '';
      // Get all already-downloaded IDs upfront for O(1) lookup
      const downloadedIds = await getDownloadedVideoIds();
      const toDownload = songs.filter(s => !downloadedIds.has(s.videoId || s.id));
      const alreadyCount = songs.length - toDownload.length;
      
      if (toDownload.length === 0) {
        setDownloadProgress(`All ${songs.length} songs already downloaded!`);
        setTimeout(() => setDownloadProgress(null), 2500);
        setDownloading(false);
        return;
      }

      if (alreadyCount > 0) {
        setDownloadProgress(`${alreadyCount} already saved. Downloading ${toDownload.length} new tracks...`);
      } else {
        setDownloadProgress(`Downloading ${toDownload.length} tracks...`);
      }
      setTimeout(() => setDownloadProgress(null), 2500);

      for (let i = 0; i < toDownload.length; i++) {
        const song = toDownload[i];
        try {
          await downloadSong(song, playlistRef, authToken);
        } catch (err) {
          console.warn('Skipping failed download:', song.title, err.message);
        }
        // Small gap between downloads to avoid overloading the server
        await new Promise(r => setTimeout(r, 500));
      }
      setDownloadProgress(`Done! ${toDownload.length} songs saved.`);
      setTimeout(() => setDownloadProgress(null), 2000);
    } catch (err) {
      console.error('Playlist download error:', err);
    } finally {
      setDownloading(false);
    }
  };

  const handleSortClick = (key) => {
    if (sortKey === key) setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    else { setSortKey(key); setSortOrder('desc'); }
  };

  const handleOpenAddModal = (song) => { setSelectedSong(song); setShowAddModal(true); setAddedStatus(null); setActiveMenuId(null); };
  const toggleMenu = (e, menuId) => { e.stopPropagation(); setActiveMenuId(activeMenuId === menuId ? null : menuId); };

  const handleAction = (action, song, index) => {
    setActiveMenuId(null);
    if (action === 'PLAYLIST') handleOpenAddModal(song);
    else if (action === 'QUEUE') addToQueue(song);
    else if (action === 'REMOVE') removeSongFromPlaylist(id, index);
    else if (action === 'ARTIST') {
      const aid = song.artistBrowseId || (song.browseId?.startsWith('UC') ? song.browseId : null);
      if (aid) navigate(`/artist/${aid}`);
      else navigate(`/search?q=${encodeURIComponent(song.artist)}`);
    }
    else if (action === 'ALBUM') {
      // FIX #7: Only navigate to IDs with MPRE prefix (actual YTMusic album IDs).
      // The old check (albumId.length > 11) was matching Firestore doc IDs,
      // which caused "Go to Album" to re-open the current playlist.
      const albumId = [song.albumBrowseId, song.albumId, song.album?.browseId, song.album?.id]
        .find(id => id && String(id).startsWith('MPRE'));
      if (albumId) {
        navigate(`/playlist/${albumId}`);
      } else {
        // Fallback: search by album name
        const albumName = song.album || song.title || '';
        navigate(`/search?q=${encodeURIComponent(albumName)}`);
      }
    }
  };

  const handleAddToPlaylist = async (playlistId) => {
    if (!selectedSong) return;
    await addSongToPlaylist(playlistId, selectedSong);
    setAddedStatus(playlistId);
    setTimeout(() => { setShowAddModal(false); setSelectedSong(null); setAddedStatus(null); }, 1200);
  };

  // ── Loading / Error States ──────────────────────────────────────────────────



  if (!playlist && ytmError) {
    return (
      <div className="playlist-view" style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
        <p style={{ color: 'var(--text-secondary)' }}>Couldn't load this playlist.</p>
        <button onClick={() => navigate(-1)} style={{ marginTop: 12, color: 'var(--accent-cyan)' }}>← Go back</button>
      </div>
    );
  }

  // Source of truth: Firestore playlist OR YTM API playlist
  const isYTM = !!ytmPlaylist && !playlist;
  const sourceName = isYTM ? ytmPlaylist.name : playlist?.name || '';
  const sourceSongs = isYTM
    ? (ytmPlaylist.tracks || [])
    : (playlist?.songs || []);
  const sourceThumbnail = getHighResThumb(isYTM ? ytmPlaylist.thumbnail : '');

  // Copy handler — placed here so sourceSongs/sourceName are in scope
  const handleCopyPlaylist = async () => {
    if (!user || isCopying) return;
    setIsCopying(true);
    const newId = await copyPlaylist(null, sourceSongs, sourceName);
    setIsCopying(false);
    if (newId) {
      setCopyDone(true);
      setTimeout(() => setCopyDone(false), 2500);
    }
  };

  // ── Song filtering + sorting ───────────────────────────────────────────────

  let songsToRender = sourceSongs.map((s, i) => ({
    ...s,
    _ogIndex: i,
    _contextId: id,
    _contextTitle: sourceName
  }));

  if (trackFilter) {
    songsToRender = songsToRender.filter(s =>
      s.title?.toLowerCase().includes(trackFilter.toLowerCase()) ||
      s.artist?.toLowerCase().includes(trackFilter.toLowerCase())
    );
  }

  // Alpha / Recent strict sorting (NO random UI jumping here)
  songsToRender.sort((a, b) => {
    if (sortKey === 'alpha') {
      const cmp = (a.title || '').localeCompare(b.title || '');
      // Down arrow (desc) = A-Z. Up arrow (asc) = Z-A
      return sortOrder === 'desc' ? cmp : -cmp;
    } else {
      const timeA = a.addedAt || a._ogIndex || 0;
      const timeB = b.addedAt || b._ogIndex || 0;
      const cmp = timeB - timeA; // Most recent at top
      // Up arrow (asc) = Most recent top. Down arrow (desc) = Most recent bottom
      return sortOrder === 'asc' ? cmp : -cmp;
    }
  });

  const totalMinutes = sourceSongs.length * 3.5;
  const hours = Math.floor(totalMinutes / 60);
  const mins = Math.round(totalMinutes % 60);

  const renderCover = () => {
    // YTM playlist: use their high-res thumbnail
    if (isYTM && sourceThumbnail) {
      return <img src={getHighResThumb(sourceThumbnail, 800)} alt={sourceName} className="playlist-cover-large" style={{ borderRadius: 12, objectFit: 'cover' }} />;
    }
    // Firestore playlist: quad grid or single
    if (sourceSongs.length >= 4) {
      return (
        <div className="playlist-cover-quad">
          {sourceSongs.slice(0, 4).map((s, i) => <img key={i} src={getHighResThumb(s.thumbnail) || null} alt="" />)}
        </div>
      );
    }
    return (
      <div className="playlist-cover-large skeleton">
        {sourceSongs.length > 0 && <img src={getHighResThumb(sourceSongs[0].thumbnail) || null} alt="" />}
      </div>
    );
  };

  return (
    <div className="playlist-view" onClick={() => setShowSortDropdown(false)}>

      {/* Top bar */}
      <header className="playlist-top-search-bar">
        <div className="back-row">
          <button className="back-btn-top" onClick={() => navigate(-1)}><ArrowLeft size={24} /></button>
        </div>
        <div className="track-find-wrapper glass-search">
          <Search size={16} />
          <input
            type="text"
            placeholder="Find on this page"
            value={trackFilter}
            onChange={(e) => setTrackFilter(e.target.value)}
          />
        </div>
      </header>

      {/* Header info */}
      <div className="playlist-header-left">
        <div className="header-flex-row">
          {renderCover()}
          <div className="playlist-details-left">
            <h1 className="small-name">{sourceName}</h1>

            {/* YTM badge */}
            {isYTM && (
              <div className="collab-row">
                <div className="mini-avatar glass">
                  <img src="https://upload.wikimedia.org/wikipedia/commons/6/6a/Youtube_Music_icon.svg" alt="YTM" style={{ width: '100%', height: '100%', objectFit: 'contain', padding: 3 }} />
                </div>
                <span className="collab-text">YouTube Music · {ytmPlaylist.type === 'YTM_ALBUM' ? 'Album' : 'Playlist'}</span>
              </div>
            )}

            {/* Firestore playlist info */}
            {!isYTM && (
              <div className="collab-row">
                <div className="avatar-stack">
                  <div className="mini-avatar glass">
                    {creator?.photoURL
                      ? <img src={creator.photoURL} alt="" />
                      : <span className="mini-initials">{getInitials(creator?.displayName || playlist?.ownerName)}</span>
                    }
                  </div>
                </div>
                <span className="collab-text">
                  {creator?.displayName || playlist?.ownerName}
                </span>
              </div>
            )}

            <div className="playlist-stats-row">
              <Globe size={14} />
              <span>{sourceSongs.length} songs • {hours > 0 ? `${hours}h ` : ''}{mins}min</span>
            </div>
          </div>
        </div>
      </div>

      {/* Action buttons */}
      <div className="playlist-actions-row">
        {/* Sort */}
        <div className="sort-wrapper-p">
          <button
            className="action-icon-btn sort-dynamic"
            onClick={(e) => { e.stopPropagation(); setShowSortDropdown(!showSortDropdown); }}
          >
            <ArrowUpDown size={18} />
            <span>{sortKey === 'alpha' ? 'A-Z' : 'Recent'}</span>
            {sortOrder === 'asc' ? <ArrowUp size={12} /> : <ArrowDown size={12} />}
          </button>
          {showSortDropdown && (
            <div className="sort-dropdown-p glass" onClick={e => e.stopPropagation()}>
              {[['recent', 'Recently Added'], ['alpha', 'Alphabetical']].map(([key, label]) => (
                <button key={key} className={`sort-option ${sortKey === key ? 'active' : ''}`} onClick={() => handleSortClick(key)}>
                  <span>{label}</span>
                  {sortKey === key && (sortOrder === 'asc' ? <ArrowUp size={14} /> : <ArrowDown size={14} />)}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Download */}
        <button className={`action-icon-btn ${downloading ? 'pulse-anim' : ''}`} onClick={handleDownload}>
          <Download size={20} />
        </button>

        {/* Share */}
        <button className="action-icon-btn" onClick={handleShare}>
          <Share2 size={18} />
        </button>

        {/* Copy Playlist (non-owners only) */}
        {!isOwner && user && (
          <button
            className={`action-icon-btn ${isCopying ? 'pulse-anim' : ''}`}
            onClick={handleCopyPlaylist}
            title="Save a copy to your Library"
          >
            {copyDone
              ? <Check size={18} color="var(--accent-cyan)" />
              : <PlusSquare size={18} />}
          </button>
        )}

        {/* Global Shuffle */}
        <button className={`action-icon-btn ${isShuffled ? 'active' : ''}`} onClick={toggleShuffle}>
          <Shuffle size={20} color={isShuffled ? 'var(--accent-cyan)' : 'white'} />
        </button>

        {/* Play All */}
        <button
          className="play-all-btn-big"
          onClick={() => {
            if (!songsToRender.length) return;
            playSong(songsToRender[0]);
            replaceQueue(songsToRender.slice(1));
            // FIX #12: Update lastPlayedAt for Firestore playlists
            if (!isYTM && id) updateLastPlayed(id);
          }}
        >
          <Play size={20} fill="currentColor" />
        </button>
      </div>

      {/* Toasts */}
      {/* Download progress toast */}
      {downloadProgress && (
        <div className="download-toast glass">
          <span>{downloadProgress}</span>
        </div>
      )}

      {isCopied && (
        <div className="download-toast glass">
          <Check size={16} color="var(--accent-cyan)" />
          <span>Link copied!</span>
        </div>
      )}

      {copyDone && (
        <div className="download-toast glass">
          <Check size={16} color="var(--accent-cyan)" />
          <span>Saved to your Library!</span>
        </div>
      )}

      {/* Song list */}
      <div className="song-list-container">
        {songsToRender.length > 0 ? (
          songsToRender.map((song, i) => {
            const isActive = currentSong?.id === (song.videoId || song.id);
            return (
              <div
                key={`${song.id || song.videoId}-${i}`}
                className={`song-row-v2 ${isActive ? 'now-playing' : ''}`}
                onClick={() => {
                  playSong(song);
                  // Grab the rest of the generated playlist strictly sequentially
                  const remainingSongs = songsToRender.slice(i + 1);
                  replaceQueue(remainingSongs);
                  // FIX #12: Update lastPlayedAt for Firestore playlists (debounced)
                  if (!isYTM && id) updateLastPlayed(id);
                }}
              >
                {/* Track number strictly displays the serial number */}
                <div className="track-num">
                  <span className={`track-num-text ${isActive ? 'accent' : ''}`}>{i + 1}</span>
                </div>

                <div className="song-main">
                  <div className="song-thumb-wrap">
                    <img src={getHighResThumb(song.thumbnail) || null} alt="" className="song-thumb-tiny" loading="lazy" decoding="async" />
                    <DownloadOverlay videoId={song.videoId || song.id} />
                    {isActive && (
                      <div className="playing-overlay">
                        <div className="playing-bars"><span /><span /><span /></div>
                      </div>
                    )}
                  </div>
                  <div className="song-info">
                    <h4 className={isActive ? 'accent' : ''}>{song.title}</h4>
                    <p>{song.artist}{song.album ? ` · ${song.album}` : ''}</p>
                  </div>
                </div>

                <div className="action-wrapper">
                  <button className="action-icon-btn" onClick={e => toggleMenu(e, `s-${i}`)}>
                    <MoreVertical size={18} />
                  </button>
                  {activeMenuId === `s-${i}` && (
                    <SongActionMenu
                      song={song}
                      onAction={(action, s) => handleAction(action, s, i)}
                      onClose={() => setActiveMenuId(null)}
                      showRemove={!isYTM && isOwner}
                    />
                  )}
                </div>
              </div>
            );
          })
        ) : (
          <div className="empty-playlist">
            <Music size={40} color="var(--text-secondary)" opacity="0.3" />
            <p>{trackFilter ? 'No matches found.' : isYTM ? 'No tracks in this playlist.' : 'No songs yet.'}</p>
          </div>
        )}
      </div>

      {/* Add to Playlist Modal */}
      {showAddModal && selectedSong && (
        <AddToPlaylistModal song={selectedSong} onClose={() => setShowAddModal(false)} />
      )}
    </div>
  );
}
