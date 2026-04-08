import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAudio } from '../context/AudioContext';
import {
  ArrowUpDown, ArrowUp, ArrowDown, LayoutGrid, List,
  Play, Trash2, Folder, Music2, Shuffle, WifiOff, ArrowLeft,
  Search, ChevronRight, MoreVertical, Pencil, Music, X, Save
} from 'lucide-react';
import {
  getAllOfflinePlaylists,
  removeDownload,
  getAudioObjectURL,
  renameOfflinePlaylist,
  deleteOfflinePlaylist,
} from '../utils/downloadManager';
import { getHighResThumb } from '../utils';
import './Library.css';
import './PlaylistView.css';
import './Downloads.css';

// ── Sort helpers ────────────────────────────────────────────────────────────

const SORT_OPTIONS = [
  { key: 'recent', label: 'Recently Added' },
  { key: 'alpha', label: 'Alphabetical' },
];

function sortPlaylists(list, sortKey, sortOrder) {
  return [...list].sort((a, b) => {
    if (sortKey === 'alpha') {
      const nameA = a.id === '__downloads__' ? 'Downloads' : (a.name || '');
      const nameB = b.id === '__downloads__' ? 'Downloads' : (b.name || '');
      const cmp = nameA.localeCompare(nameB);
      return sortOrder === 'desc' ? cmp : -cmp;
    } else {
      // 'recent': global downloads first, then by creation time
      if (a.id === '__downloads__') return -1;
      if (b.id === '__downloads__') return 1;
      const cmp = (b.createdAt || 0) - (a.createdAt || 0);
      return sortOrder === 'asc' ? cmp : -cmp;
    }
  });
}

function sortTracks(list, sortKey, sortOrder) {
  return [...list].sort((a, b) => {
    if (sortKey === 'alpha') {
      const cmp = (a.title || '').localeCompare(b.title || '');
      return sortOrder === 'desc' ? cmp : -cmp;
    } else {
      const cmp = (b.downloadedAt || 0) - (a.downloadedAt || 0);
      return sortOrder === 'asc' ? cmp : -cmp;
    }
  });
}

// ── Main Component ──────────────────────────────────────────────────────────

export default function Downloads() {
  const { playSong, replaceQueue, currentSong } = useAudio();

  const [playlists, setPlaylists] = useState([]);
  const [activeFolder, setActiveFolder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [deletingId, setDeletingId] = useState(null);

  // ── Playlist action menu ──────────────────────────────────────────────────
  const [menuOpenId, setMenuOpenId] = useState(null); // id of playlist whose menu is open
  const menuRef = useRef(null);

  // Close the playlist context menu when clicking anywhere outside
  useEffect(() => {
    if (!menuOpenId) return;
    const handleOutsideClick = () => setMenuOpenId(null);
    document.addEventListener('click', handleOutsideClick);
    return () => document.removeEventListener('click', handleOutsideClick);
  }, [menuOpenId]);

  const [renameTarget, setRenameTarget] = useState(null); // { id, name }
  const [renameVal, setRenameVal] = useState('');
  const renameInputRef = useRef(null);

  // ── Edit Songs modal ───────────────────────────────────────────────────────
  const [editSongsTarget, setEditSongsTarget] = useState(null); // playlist object being edited

  const handleEditSongsRemove = (idx) => {
    setEditSongsTarget(prev => {
      const updated = { ...prev, tracks: [...prev.tracks] };
      updated.tracks.splice(idx, 1);
      return updated;
    });
  };

  const handleEditSongsSave = async () => {
    if (!editSongsTarget) return;
    const { updateOfflinePlaylistTracks } = await import('../utils/downloadManager');
    await updateOfflinePlaylistTracks(editSongsTarget.id, editSongsTarget.tracks);
    const all = await getAllOfflinePlaylists();
    setPlaylists(all);
    if (activeFolder?.id === editSongsTarget.id) {
      setActiveFolder(all.find(p => p.id === editSongsTarget.id) || null);
    }
    setEditSongsTarget(null);
  };

  useEffect(() => {
    if (renameTarget) setTimeout(() => renameInputRef.current?.focus(), 50);
  }, [renameTarget]);

  // ── Root view state (mirrors Library) ────────────────────────────────────
  const [rootSortKey, setRootSortKey] = useState(() => localStorage.getItem('pulse_dl_sort_key') || 'recent');
  const [rootSortOrder, setRootSortOrder] = useState(() => localStorage.getItem('pulse_dl_sort_order') || 'desc');
  const [rootViewMode, setRootViewMode] = useState(() => localStorage.getItem('pulse_dl_view_mode') || 'list');
  const [rootDropdown, setRootDropdown] = useState(false);

  // ── Folder view state (mirrors PlaylistView) ──────────────────────────────
  const [trackFilter, setTrackFilter] = useState('');
  const [trackSortKey, setTrackSortKey] = useState('recent');
  const [trackSortOrder, setTrackSortOrder] = useState('desc');
  const [trackDropdown, setTrackDropdown] = useState(false);

  // Persist root settings
  useEffect(() => {
    localStorage.setItem('pulse_dl_sort_key', rootSortKey);
    localStorage.setItem('pulse_dl_sort_order', rootSortOrder);
    localStorage.setItem('pulse_dl_view_mode', rootViewMode);
  }, [rootSortKey, rootSortOrder, rootViewMode]);

  // Load playlists from IndexedDB
  const load = async () => {
    setLoading(true);
    const all = await getAllOfflinePlaylists();
    setPlaylists(all);
    setLoading(false);
  };
  useEffect(() => { load(); }, []);

  // Reset folder-level state when opening a new folder
  const openFolder = (pl) => {
    setMenuOpenId(null); // close any open context menu first
    setActiveFolder(pl);
    setTrackFilter('');
    setTrackSortKey('recent');
    setTrackSortOrder('desc');
    setTrackDropdown(false);
  };

  // ── Helpers ────────────────────────────────────────────────────────────────

  const playOfflineSong = async (song, queue = []) => {
    try {
      const url = await getAudioObjectURL(song.videoId);
      const offlineSong = { ...song, id: song.videoId, streamUrl: url, offline: true };
      playSong(offlineSong, url);
      if (queue.length > 0) {
        (async () => {
          const enriched = await Promise.allSettled(
            queue.map(async s => {
              try {
                const u = await getAudioObjectURL(s.videoId);
                return { ...s, id: s.videoId, streamUrl: u, offline: true };
              } catch { return { ...s, id: s.videoId }; }
            })
          );
          replaceQueue(enriched.map(r => r.status === 'fulfilled' ? r.value : r.reason));
        })();
      }
    } catch (err) {
      console.error('Offline playback error:', err);
    }
  };

  const handleDelete = async (e, videoId) => {
    e.stopPropagation();
    setDeletingId(videoId);
    await removeDownload(videoId);
    // Refresh and update activeFolder in-place
    const all = await getAllOfflinePlaylists();
    setPlaylists(all);
    if (activeFolder) {
      const refreshed = all.find(p => p.id === activeFolder.id);
      setActiveFolder(refreshed || null);
    }
    setDeletingId(null);
  };

  const handleRenamePlaylist = async () => {
    if (!renameTarget || !renameVal.trim()) return;
    await renameOfflinePlaylist(renameTarget.id, renameVal.trim());
    setRenameTarget(null);
    setRenameVal('');
    const all = await getAllOfflinePlaylists();
    setPlaylists(all);
    if (activeFolder?.id === renameTarget.id) {
      setActiveFolder(all.find(p => p.id === renameTarget.id) || null);
    }
  };

  const handleDeletePlaylist = async (pl) => {
    setMenuOpenId(null);
    await deleteOfflinePlaylist(pl.id);
    const all = await getAllOfflinePlaylists();
    setPlaylists(all);
    if (activeFolder?.id === pl.id) setActiveFolder(null);
  };

  const handleShuffle = async (tracks) => {
    if (!tracks.length) return;
    const shuffled = [...tracks].sort(() => Math.random() - 0.5);
    playOfflineSong(shuffled[0], shuffled.slice(1));
  };

  const handleRootSort = (key) => {
    if (rootSortKey === key) setRootSortOrder(o => o === 'asc' ? 'desc' : 'asc');
    else { setRootSortKey(key); setRootSortOrder('desc'); }
  };

  const handleTrackSort = (key) => {
    if (trackSortKey === key) setTrackSortOrder(o => o === 'asc' ? 'desc' : 'asc');
    else { setTrackSortKey(key); setTrackSortOrder('desc'); }
  };

  // ── Derived data ───────────────────────────────────────────────────────────

  const sortedPlaylists = sortPlaylists(playlists, rootSortKey, rootSortOrder);

  const folderTracks = activeFolder?.tracks || [];
  const filteredTracks = trackFilter
    ? folderTracks.filter(t =>
      t.title?.toLowerCase().includes(trackFilter.toLowerCase()) ||
      t.artist?.toLowerCase().includes(trackFilter.toLowerCase())
    )
    : folderTracks;
  const sortedTracks = sortTracks(filteredTracks, trackSortKey, trackSortOrder);

  const totalMinutes = Math.round(folderTracks.length * 3.5);
  const hours = Math.floor(totalMinutes / 60);
  const mins = totalMinutes % 60;

  const rootSortLabel = SORT_OPTIONS.find(o => o.key === rootSortKey)?.label;
  const trackSortLabel = SORT_OPTIONS.find(o => o.key === trackSortKey)?.label;

  // ── Root view ────────────────────────────────────────────────────────────

  const renderRootView = () => {
    if (!sortedPlaylists.length) {
      return (
        <div className="dl-empty">
          <WifiOff size={48} className="dl-empty-icon" />
          <h3>No downloads yet</h3>
          <p>Tap <strong>⋮</strong> on any song and choose <strong>Download</strong> to save it for offline listening.</p>
        </div>
      );
    }

    return (
      <div className={`library-content ${rootViewMode}-view`}>
        {sortedPlaylists.map(pl => {
          const thumbs = pl.tracks.slice(0, 4);
          const dispName = pl.id === '__downloads__' ? 'Downloads' : pl.name;
          return (
            <div
              key={pl.id}
              className={`lib-playlist-row hover-scale ${menuOpenId === pl.id ? 'active-z' : ''}`}
              onClick={() => openFolder(pl)}
              style={{ position: 'relative' }}
            >
              {/* Cover art */}
              <div className="lib-cover skeleton">
                {thumbs.length >= 4 ? (
                  <div className="lib-cover-quad">
                    {thumbs.map((t, i) => (
                      <img key={i} src={getHighResThumb(t.thumbnail, 300) || null} alt="" />
                    ))}
                  </div>
                ) : thumbs[0] ? (
                  <img src={getHighResThumb(thumbs[0].thumbnail, 400) || null} alt="" />
                ) : (
                  <div className="dl-art-placeholder"><Folder size={22} /></div>
                )}
              </div>

              {/* Info */}
              <div className="lib-info">
                <h4>{dispName}</h4>
                <p>{pl.tracks.length} {pl.tracks.length === 1 ? 'song' : 'songs'} • Offline</p>
              </div>

              {/* Right side: 3-dot for user playlists, chevron for system folders */}
              {(pl.id === '__downloads__' || dispName === 'Liked Songs') ? (
                <ChevronRight size={16} style={{ color: 'var(--text-secondary)', opacity: 0.4, flexShrink: 0, marginLeft: 'auto' }} />
              ) : (
                <>
                  <button
                    className="options-dots-btn"
                    onClick={e => { e.stopPropagation(); setMenuOpenId(v => v === pl.id ? null : pl.id); }}
                  >
                    <MoreVertical size={18} />
                  </button>

                  {menuOpenId === pl.id && (
                    <>
                      <div className="playlist-context-menu" style={{ zIndex: 1001 }} onClick={e => e.stopPropagation()}>
                        <button onClick={() => {
                          setMenuOpenId(null);
                          setRenameTarget({ id: pl.id, name: dispName });
                          setRenameVal(dispName);
                        }}>
                          <Pencil size={14} /> Rename
                        </button>
                        <button onClick={() => {
                          setMenuOpenId(null);
                          setEditSongsTarget({ ...pl });
                        }}>
                          <Music size={14} /> Edit Songs
                        </button>
                        <button className="del-opt" onClick={() => handleDeletePlaylist(pl)}>
                          <Trash2 size={14} /> Delete Folder
                        </button>
                      </div>
                    </>
                  )}
                </>
              )}
            </div>
          );
        })}
      </div>
    );
  };

  // ── Folder view ────────────────────────────────────────────────────────────

  const renderFolderView = () => {
    const thumbs = folderTracks.slice(0, 4);
    const dispName = activeFolder.id === '__downloads__' ? 'Downloads' : activeFolder.name;

    return (
      <div className="dl-track-view" onClick={() => setTrackDropdown(false)}>
        {/* Search bar — like PlaylistView */}
        <div className="playlist-top-search-bar">
          <div className="back-row">
            <button className="back-btn-top" onClick={() => setActiveFolder(null)}>
              <ArrowLeft size={24} />
            </button>
          </div>
          <div className="track-find-wrapper glass-search">
            <Search size={16} />
            <input
              type="text"
              placeholder="Find in playlist"
              value={trackFilter}
              onChange={e => setTrackFilter(e.target.value)}
            />
          </div>
        </div>

        {/* Playlist header */}
        <div className="playlist-header-left">
          <div className="header-flex-row">
            <div className="playlist-cover-large skeleton">
              {thumbs.length >= 4 ? (
                <div className="playlist-cover-quad">
                  {thumbs.map((t, i) => (
                    <img key={i} src={getHighResThumb(t.thumbnail, 300) || null} alt="" />
                  ))}
                </div>
              ) : thumbs[0] ? (
                <img src={getHighResThumb(thumbs[0].thumbnail, 400) || null} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
              ) : (
                <div className="dl-art-placeholder" style={{ height: '100%' }}><Folder size={32} /></div>
              )}
            </div>

            <div className="playlist-details-left">
              <h1 className="small-name">{dispName}</h1>
              <div className="collab-row">
                <WifiOff size={12} color="var(--accent-cyan)" />
                <span className="collab-text">Offline</span>
              </div>
              <div className="playlist-stats-row">
                <Music2 size={14} />
                <span>
                  {folderTracks.length} songs
                  {hours > 0 ? ` • ${hours}h ${mins}min` : ` • ${mins}min`}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Action row */}
        <div className="playlist-actions-row">
          {/* Sort */}
          <div className="sort-wrapper-p">
            <button
              className="action-icon-btn sort-dynamic"
              onClick={e => { e.stopPropagation(); setTrackDropdown(v => !v); }}
            >
              <ArrowUpDown size={18} />
              <span>{trackSortKey === 'alpha' ? 'A-Z' : 'Recent'}</span>
              {trackSortOrder === 'asc' ? <ArrowUp size={12} /> : <ArrowDown size={12} />}
            </button>
            {trackDropdown && (
              <div className="sort-dropdown-p glass" onClick={e => e.stopPropagation()}>
                {SORT_OPTIONS.map(({ key, label }) => (
                  <button key={key} className={`sort-option ${trackSortKey === key ? 'active' : ''}`} onClick={() => handleTrackSort(key)}>
                    <span>{label}</span>
                    {trackSortKey === key && (trackSortOrder === 'asc' ? <ArrowUp size={14} /> : <ArrowDown size={14} />)}
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Shuffle */}
          <button className="action-icon-btn" onClick={() => handleShuffle(folderTracks)}>
            <Shuffle size={20} />
          </button>

          {/* Play All */}
          <button
            className="play-all-btn-big"
            onClick={() => folderTracks.length && playOfflineSong(folderTracks[0], folderTracks.slice(1))}
          >
            <Play size={20} fill="currentColor" />
          </button>
        </div>

        {/* Track list */}
        <div className="song-list-container">
          {sortedTracks.length === 0 && (
            <div className="empty-playlist">
              <Music2 size={40} color="var(--text-secondary)" opacity="0.3" />
              <p>{trackFilter ? 'No matches found.' : 'This folder is empty.'}</p>
            </div>
          )}
          {sortedTracks.map((track, i) => {
            const isActive = currentSong?.id === track.videoId || currentSong?.videoId === track.videoId;
            return (
              <div
                key={track.videoId}
                className={`song-row-v2 ${isActive ? 'now-playing' : ''}`}
                onClick={() => playOfflineSong(track, sortedTracks.slice(i + 1))}
              >
                <div className="track-num">
                  <span className={`track-num-text ${isActive ? 'accent' : ''}`}>{i + 1}</span>
                </div>

                <div className="song-main">
                  <div className="song-thumb-wrap">
                    <img src={getHighResThumb(track.thumbnail, 200) || null} alt="" className="song-thumb-tiny" loading="lazy" />
                    {isActive && (
                      <div className="playing-overlay">
                        <div className="playing-bars"><span /><span /><span /></div>
                      </div>
                    )}
                  </div>
                  <div className="song-info">
                    <h4 className={isActive ? 'accent' : ''}>{track.title}</h4>
                    <p>{track.artist}</p>
                  </div>
                </div>

                <div className="action-wrapper">
                  <button
                    className={`dl-delete-btn action-icon-btn ${deletingId === track.videoId ? 'deleting' : ''}`}
                    onClick={e => handleDelete(e, track.videoId)}
                    disabled={!!deletingId}
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    );
  };

  // ── Render ─────────────────────────────────────────────────────────────────

  // When in folder view, hide the root header (use back button + folder header instead)
  return (
    <div
      className="library-container"
      onClick={() => { setRootDropdown(false); setTrackDropdown(false); setMenuOpenId(null); }}
    >
      {/* ── Library-style header (root only) ── */}
      {!activeFolder && (
        <header className="library-header">
          <div className="lib-header-top">
            <h1>Downloads</h1>

            <div className="lib-header-actions">
              {/* Sort button — identical to Library */}
              <div className="sort-wrapper">
                <button
                  className="sort-btn hover-scale"
                  onClick={e => { e.stopPropagation(); setRootDropdown(v => !v); }}
                >
                  <ArrowUpDown size={14} />
                  <span>{rootSortLabel}</span>
                  {rootSortOrder === 'asc' ? <ArrowUp size={12} /> : <ArrowDown size={12} />}
                </button>

                {rootDropdown && (
                  <>
                    <div className="dropdown-overlay" onClick={() => setRootDropdown(false)} />
                    <div className="sort-dropdown glass" onClick={e => e.stopPropagation()}>
                      {SORT_OPTIONS.map(opt => (
                        <button
                          key={opt.key}
                          className={`sort-option ${rootSortKey === opt.key ? 'active' : ''}`}
                          onClick={() => handleRootSort(opt.key)}
                        >
                          <span>{opt.label}</span>
                          {rootSortKey === opt.key && (rootSortOrder === 'asc' ? <ArrowUp size={14} /> : <ArrowDown size={14} />)}
                        </button>
                      ))}
                    </div>
                  </>
                )}
              </div>

              {/* Grid / List toggle — identical to Library */}
              <button
                className="view-mode-btn hover-scale"
                onClick={() => setRootViewMode(v => v === 'list' ? 'grid' : 'list')}
              >
                {rootViewMode === 'list' ? <LayoutGrid size={18} /> : <List size={18} />}
              </button>
            </div>
          </div>
        </header>
      )}

      {/* Offline indicator */}
      {!navigator.onLine && (
        <div className="dl-offline-banner glass">
          <WifiOff size={14} />
          <span>You're offline — playing from downloads</span>
        </div>
      )}

      {/* Content */}
      <div className="dl-content">
        {loading ? (
          <div className="dl-loading">
            <div className="universal-ring" />
          </div>
        ) : activeFolder ? renderFolderView() : renderRootView()}
      </div>

      {/* ── Rename modal ── */}
      {renameTarget && (
        <div className="modal-overlay" onClick={() => setRenameTarget(null)}>
          <div className="standard-modal glass" onClick={e => e.stopPropagation()}>
            <h3>Rename Folder</h3>
            <p>Enter a new name for this offline playlist</p>
            <input
              ref={renameInputRef}
              className="standard-input"
              value={renameVal}
              onChange={e => setRenameVal(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter') handleRenamePlaylist(); if (e.key === 'Escape') setRenameTarget(null); }}
              maxLength={60}
              placeholder="Playlist name"
            />
            <div className="modal-btn-row">
              <button className="modal-cancel-btn" onClick={() => setRenameTarget(null)}>Cancel</button>
              <button className="modal-confirm-btn" onClick={handleRenamePlaylist} disabled={!renameVal.trim()}>Save</button>
            </div>
          </div>
        </div>
      )}

      {/* ── Edit Songs modal ── */}
      {editSongsTarget && (
        <div className="modal-overlay" onClick={() => setEditSongsTarget(null)}>
          <div className="edit-songs-card glass" onClick={e => e.stopPropagation()}>
            <div className="edit-songs-header">
              <h3>Edit {editSongsTarget.id === '__downloads__' ? 'Downloads' : editSongsTarget.name}</h3>
              <button onClick={handleEditSongsSave} className="save-all-btn"><Save size={18} /> Save</button>
            </div>
            <div className="edit-songs-list">
              {editSongsTarget.tracks.map((s, idx) => (
                <div key={idx} className="edit-song-item">
                  <img src={getHighResThumb(s.thumbnail, 200) || null} alt="" />
                  <div className="s-info">
                    <p>{s.title}</p>
                    <span>{s.artist}</span>
                  </div>
                  <button onClick={() => handleEditSongsRemove(idx)}><X size={16} /></button>
                </div>
              ))}
              {editSongsTarget.tracks.length === 0 && <p className="empty-edit">No songs left.</p>}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

