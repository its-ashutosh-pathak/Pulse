import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, ArrowUpDown, ArrowUp, ArrowDown, Trash2, Users, LayoutGrid, List, MoreVertical, Edit2, X, Save, Music, Download } from 'lucide-react';
import { usePlaylists } from '../context/PlaylistContext';
import { getHighResThumb } from '../utils';
import ImportPlaylist from './ImportPlaylist';
import './Library.css';

const SORT_OPTIONS = [
  { key: 'recent', label: 'Recent' },
  { key: 'alpha', label: 'A-Z' },
];

export default function Library() {
  const navigate = useNavigate();
  const { playlists, ytPlaylists, createPlaylist, deletePlaylist, updatePlaylist, loading } = usePlaylists();

  const allPlaylists = [...playlists, ...ytPlaylists];

  // Settings
  const [sortKey, setSortKey] = useState(() => localStorage.getItem('pulse_lib_sort_key') || 'recent');
  const [sortOrder, setSortOrder] = useState(() => localStorage.getItem('pulse_lib_sort_order') || 'desc');
  const [viewMode, setViewMode] = useState(() => localStorage.getItem('pulse_lib_view_mode') || 'list');
  const [showDropdown, setShowDropdown] = useState(false);

  // Advanced Menu States
  const [activeMenuId, setActiveMenuId] = useState(null);
  const [showRenameModal, setShowRenameModal] = useState(false);
  const [showEditSongsModal, setShowEditSongsModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [editingPlaylist, setEditingPlaylist] = useState(null);
  const [renameValue, setRenameValue] = useState('');
  const [showImport, setShowImport] = useState(false);
  const [importTab, setImportTab] = useState('ytm'); // pre-select which tab opens

  // Persist settings
  React.useEffect(() => {
    localStorage.setItem('pulse_lib_sort_key', sortKey);
    localStorage.setItem('pulse_lib_sort_order', sortOrder);
    localStorage.setItem('pulse_lib_view_mode', viewMode);
  }, [sortKey, sortOrder, viewMode]);

  // Custom Create Modal
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showAddOptions, setShowAddOptions] = useState(false);
  const [newPlaylistName, setNewPlaylistName] = useState('');

  const currentLabel = SORT_OPTIONS.find(o => o.key === sortKey)?.label;

  const sorted = [...allPlaylists]
    .filter(pl => {
      // Liked Songs: hide when empty, never delete
      if (pl.name === 'Liked Songs' && pl.createdBy === playlists.find(p => p.id === pl.id)?.createdBy) {
        return (pl.songs?.length || 0) > 0;
      }
      if (pl.type === 'YTM') return (pl.songCount || 0) > 0;
      return (pl.songs?.length || 0) > 0;
    })
    .sort((a, b) => {
    if (sortKey === 'alpha') {
      const cmp = (a.name || '').localeCompare(b.name || '');
      return sortOrder === 'desc' ? cmp : -cmp;
    } else {
      const timeA = a.createdAt?.seconds || 0;
      const timeB = b.createdAt?.seconds || 0;
      const cmp = timeB - timeA;
      return sortOrder === 'asc' ? cmp : -cmp;
    }
  });

  // Auto-delete empty playlists from Firestore (except Liked Songs — that's just hidden)
  React.useEffect(() => {
    if (loading || allPlaylists.length === 0) return;
    const timer = setTimeout(() => {
      allPlaylists.forEach(pl => {
        if (pl.type === 'YTM') return; // skip YTM playlists
        const isEmpty = (pl.songs?.length || 0) === 0;
        const isLiked = pl.name === 'Liked Songs';
        if (isEmpty && !isLiked) {
          deletePlaylist(pl.id);
        }
      });
    }, 2000); // 2s grace period so import-created playlists aren't immediately deleted
    return () => clearTimeout(timer);
  }, [allPlaylists, loading]);


  const handleSortClick = (key) => {
    if (sortKey === key) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortKey(key);
      setSortOrder('desc');
    }
  };

  const handleConfirmCreate = async (e) => {
    e.preventDefault();
    if (newPlaylistName.trim()) {
      createPlaylist(newPlaylistName.trim()); // Fire and forget so modal closes instantly
      setNewPlaylistName('');
      setShowCreateModal(false);
    }
  };

  const openMenu = (e, playlist) => {
    e.stopPropagation();
    setActiveMenuId(activeMenuId === playlist.id ? null : playlist.id);
    setEditingPlaylist(playlist);
  };

  // Actions
  const handleRename = async (e) => {
    e.preventDefault();
    if (renameValue.trim() && editingPlaylist) {
      await updatePlaylist(editingPlaylist.id, { name: renameValue.trim() });
      setShowRenameModal(false);
      setRenameValue('');
    }
  };

  const handleRemoveSongInEdit = (index) => {
    const updated = { ...editingPlaylist };
    updated.songs.splice(index, 1);
    setEditingPlaylist(updated);
  };

  const handleSaveSongEdits = async () => {
    if (editingPlaylist) {
      await updatePlaylist(editingPlaylist.id, { songs: editingPlaylist.songs });
      setShowEditSongsModal(false);
    }
  };

  if (loading) {
    return <div className="library-container"><p style={{ padding: '20px', color: 'var(--text-secondary)' }}>Syncing your Pulse...</p></div>;
  }

  return (
    <div className="library-container" onClick={() => { setShowDropdown(false); setActiveMenuId(null); }}>
      <header className="library-header">
        {/* Global Context Menu Overlay */}
        {activeMenuId && (
          <div
            className="dropdown-overlay"
            style={{ zIndex: 1000 }}
            onClick={(e) => { e.stopPropagation(); setActiveMenuId(null); }}
          />
        )}
        <div className="lib-header-top">
          <h1>Library</h1>
          <div className="lib-header-actions">
            <div className="sort-wrapper">
              <button
                className="sort-btn hover-scale"
                onClick={(e) => { e.stopPropagation(); setShowDropdown(!showDropdown); }}
              >
                <ArrowUpDown size={14} />
                <span>{currentLabel}</span>
                {sortOrder === 'asc' ? <ArrowUp size={12} /> : <ArrowDown size={12} />}
              </button>

              {showDropdown && (
                <>
                  <div className="dropdown-overlay" onClick={() => setShowDropdown(false)} />
                  <div className="sort-dropdown glass" onClick={e => e.stopPropagation()}>
                    {SORT_OPTIONS.map(opt => (
                      <button
                        key={opt.key}
                        className={`sort-option ${sortKey === opt.key ? 'active' : ''}`}
                        onClick={() => handleSortClick(opt.key)}
                      >
                        <span>{opt.label}</span>
                        {sortKey === opt.key && (sortOrder === 'asc' ? <ArrowUp size={14} /> : <ArrowDown size={14} />)}
                      </button>
                    ))}
                  </div>
                </>
              )}
            </div>

            {/* Downloads icon button — Grey, no glow, placed between Sort & ViewMode */}
            <button
              className="lib-downloads-btn hover-scale"
              title="Downloads"
              onClick={() => navigate('/downloads')}
            >
              <Download size={18} />
            </button>

            <button
              className="view-mode-btn hover-scale"
              onClick={() => setViewMode(viewMode === 'list' ? 'grid' : 'list')}
            >
              {viewMode === 'list' ? <LayoutGrid size={18} /> : <List size={18} />}
            </button>
          </div>
        </div>
      </header>

      <div className={`library-content ${viewMode}-view`}>
        {sorted.length === 0 ? (
          <div className="empty-state">
            <p>Your library is empty.</p>
            <span>Tap "Add" to start your first Pulse.</span>
          </div>
        ) : (
          sorted.map(pl => (
            <div
              key={pl.id}
              className={`lib-playlist-row hover-scale ${activeMenuId === pl.id ? 'active-z' : ''}`}
              onClick={() => navigate(`/playlist/${pl.id}`)}
              style={{ position: 'relative' }}
            >
              <div className="lib-cover skeleton">
                {pl.type === 'YTM' ? (
                  <img src={getHighResThumb(pl.thumbnail, 400) || null} alt="" />
                ) : (pl.songs?.length >= 4 && pl.id !== 'liked-songs') ? (
                  <div className="lib-cover-quad">
                    {pl.songs.slice(0, 4).map((s, idx) => (
                      <img key={idx} src={getHighResThumb(s.thumbnail, 200) || null} alt="" />
                    ))}
                  </div>
                ) : (
                  pl.songs?.length > 0 && <img src={getHighResThumb(pl.songs[0].thumbnail, 400) || null} alt="" />
                )}
              </div>
              <div className="lib-info">
                <h4>{pl.name}</h4>
                <p>
                  {pl.type === 'YTM' ? `${pl.songCount} Songs` : `${pl.songs?.length || 0} Songs`}
                  • {pl.type === 'YTM' ? 'YouTube Music' : pl.visibility}
                </p>
                {viewMode === 'list' && (pl.members?.length > 1 || pl.type === 'YTM') && (
                  <div className="collaborator-badge">
                    {pl.type === 'YTM' ? <Music size={12} /> : <Users size={12} />}
                    <span>{pl.type === 'YTM' ? 'YT Library' : 'Collaborative'}</span>
                  </div>
                )}
              </div>

              <button
                className="options-dots-btn"
                onClick={(e) => openMenu(e, pl)}
              >
                <MoreVertical size={18} />
              </button>

              {/* Individual Playlist Menu */}
              {activeMenuId === pl.id && (
                <div className="playlist-context-menu glass" style={{ zIndex: 1001 }} onClick={e => e.stopPropagation()}>
                  <button onClick={(e) => { e.stopPropagation(); setShowRenameModal(true); setRenameValue(pl.name); setActiveMenuId(null); }}>
                    <Edit2 size={14} /> Rename
                  </button>
                  <button onClick={(e) => { e.stopPropagation(); setShowEditSongsModal(true); setActiveMenuId(null); }}>
                    <Music size={14} /> Edit Songs
                  </button>
                  <button className="del-opt" onClick={(e) => { e.stopPropagation(); setShowDeleteModal(true); setActiveMenuId(null); }}>
                    <Trash2 size={14} /> Delete
                  </button>
                </div>
              )}
            </div>
          ))
        )}
      </div>

      {/* FAB — restored text */}
      <button
        className={`fab-create hover-scale ${showAddOptions ? 'active' : ''}`}
        onClick={() => setShowAddOptions(!showAddOptions)}
      >
        <Plus size={20} color="#050505" strokeWidth={3} style={{ transform: showAddOptions ? 'rotate(45deg)' : 'none', transition: 'transform 0.3s' }} />
        <span>Add</span>
      </button>

      {/* ADD OPTIONS MENU */}
      {showAddOptions && (
        <div className="modal-overlay" onClick={() => setShowAddOptions(false)}>
          <div className="add-options-card glass" onClick={e => e.stopPropagation()}>
            <header className="add-options-header">
              <h3>Add to Library</h3>
              <p>Choose how you want to expand your Pulse</p>
            </header>

            <div className="add-options-list">
              <button
                className="add-option-item glass hover-scale"
                onClick={() => { setShowAddOptions(false); setShowCreateModal(true); }}
              >
                <div className="option-icon-box"><Plus size={20} /></div>
                <div className="option-text">
                  <h4>Create Playlist</h4>
                  <span>Start from scratch</span>
                </div>
              </button>

              <button
                className="add-option-item glass hover-scale"
                onClick={() => { setImportTab('ytm'); setShowImport(true); setShowAddOptions(false); }}
              >
                <div className="option-icon-box brand">
                  <img src="https://upload.wikimedia.org/wikipedia/commons/6/6a/Youtube_Music_icon.svg" alt="YT Music" className="brand-logo-bw" />
                </div>
                <div className="option-text">
                  <h4>Import from YT Music</h4>
                  <span>Sync your existing library</span>
                </div>
              </button>

              <button
                className="add-option-item glass hover-scale"
                onClick={() => { setImportTab('spotify'); setShowImport(true); setShowAddOptions(false); }}
              >
                <div className="option-icon-box brand">
                  <img src="https://www.vectorlogo.zone/logos/spotify/spotify-icon.svg" alt="Spotify" className="brand-logo-bw" />
                </div>
                <div className="option-text">
                  <h4>Import from Spotify</h4>
                  <span>Migrate your playlists</span>
                </div>
              </button>
            </div>

            <button className="cancel-pill" onClick={() => setShowAddOptions(false)}>Close</button>
          </div>
        </div>
      )}

      {/* RENAME MODAL */}
      {showRenameModal && (
        <div className="modal-overlay" onClick={() => setShowRenameModal(false)}>
          <div className="standard-modal glass" onClick={e => e.stopPropagation()}>
            <h3>Rename Pulse</h3>
            <p>Enter a new name for your playlist.</p>
            <form onSubmit={handleRename}>
              <input
                autoFocus
                className="standard-input"
                type="text"
                value={renameValue}
                onChange={(e) => setRenameValue(e.target.value)}
              />
              <div className="modal-actions-unified">
                <button type="button" className="cancel-pill" onClick={() => setShowRenameModal(false)}>Cancel</button>
                <button type="submit" className="confirm-pill">Rename</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* DELETE CONFIRMATION MODAL */}
      {showDeleteModal && editingPlaylist && (
        <div className="modal-overlay" onClick={() => setShowDeleteModal(false)}>
          <div className="standard-modal glass" onClick={e => e.stopPropagation()}>
            <div className="trash-icon-unified">
              <Trash2 size={32} color="#ff4d4d" />
            </div>
            <h3>Delete Pulse?</h3>
            <p>
              Are you sure you want to delete <strong>"{editingPlaylist.name}"</strong>? This pulse will be lost forever.
            </p>
            <div className="modal-actions-unified">
              <button className="cancel-pill" onClick={() => setShowDeleteModal(false)}>Cancel</button>
              <button
                className="confirm-pill delete-variant"
                onClick={async () => { await deletePlaylist(editingPlaylist.id); setShowDeleteModal(false); }}
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      )}
      {/* EDIT SONGS MODAL */}
      {showEditSongsModal && editingPlaylist && (
        <div className="modal-overlay" onClick={() => setShowEditSongsModal(false)}>
          <div className="edit-songs-card glass" onClick={e => e.stopPropagation()}>
            <div className="edit-songs-header">
              <h3>Edit {editingPlaylist.name}</h3>
              <button onClick={handleSaveSongEdits} className="save-all-btn"><Save size={18} /> Save</button>
            </div>
            <div className="edit-songs-list">
              {editingPlaylist.songs.map((s, idx) => (
                <div key={idx} className="edit-song-item">
                  <img src={getHighResThumb(s.thumbnail, 200) || null} alt="" />
                  <div className="s-info">
                    <p>{s.title}</p>
                    <span>{s.artist}</span>
                  </div>
                  <button onClick={() => handleRemoveSongInEdit(idx)}><X size={16} /></button>
                </div>
              ))}
              {editingPlaylist.songs.length === 0 && <p className="empty-edit">No songs left.</p>}
            </div>
          </div>
        </div>
      )}

      {/* CREATE MODAL */}
      {showCreateModal && (
        <div className="modal-overlay" onClick={() => setShowCreateModal(false)}>
          <form className="standard-modal glass" onClick={e => e.stopPropagation()} onSubmit={handleConfirmCreate}>
            <h3>New Playlist</h3>
            <p>What should we call your new playlist?</p>
            <input
              autoFocus
              className="standard-input"
              type="text"
              placeholder="e.g. Midnight Rides"
              value={newPlaylistName}
              onChange={(e) => setNewPlaylistName(e.target.value)}
            />
            <div className="modal-actions-unified">
              <button type="button" className="cancel-pill" onClick={() => setShowCreateModal(false)}>Cancel</button>
              <button type="submit" className="confirm-pill">Create</button>
            </div>
          </form>
        </div>
      )}
      {/* IMPORT PLAYLIST MODAL */}
      {showImport && (
        <ImportPlaylist
          initialTab={importTab}
          onClose={() => setShowImport(false)}
        />
      )}

    </div>
  );
}
