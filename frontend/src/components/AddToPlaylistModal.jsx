import React, { useState } from 'react';
import { Music, Check, ArrowRight, Plus, X } from 'lucide-react';
import { usePlaylists } from '../context/PlaylistContext';
import { getHighResThumb } from '../utils';

export default function AddToPlaylistModal({ song, onClose }) {
  const { playlists, addSongToPlaylist, createPlaylist } = usePlaylists();
  const [addedStatus, setAddedStatus] = useState(null);
  const [showCreate, setShowCreate] = useState(false);
  const [newName, setNewName] = useState('');
  const [creating, setCreating] = useState(false);

  if (!song) return null;

  const handleAddToPlaylist = async (playlistId) => {
    await addSongToPlaylist(playlistId, song);
    setAddedStatus(playlistId);
    setTimeout(() => {
      setAddedStatus(null);
      if (onClose) onClose();
    }, 1200);
  };

  const handleCreate = async (e) => {
    e.preventDefault();
    if (!newName.trim()) return;
    setCreating(true);
    try {
      const newId = await createPlaylist(newName.trim());
      if (newId) {
        // Add the song to the newly created playlist immediately
        await addSongToPlaylist(newId, song);
        setAddedStatus(newId);
        setTimeout(() => {
          setAddedStatus(null);
          if (onClose) onClose();
        }, 1200);
      } else {
        // createPlaylist may not return ID — just close after creating
        setNewName('');
        setShowCreate(false);
      }
    } finally {
      setCreating(false);
    }
  };

  const thumb = getHighResThumb(song.thumbnail || song.cover || song.artworkUrl || '', 200);

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="standard-modal glass" onClick={e => e.stopPropagation()}>
        {/* Song info header */}
        <div className="add-modal-header-info" style={{ display: 'flex', alignItems: 'center', gap: '15px', marginBottom: '20px' }}>
          <img
            src={thumb}
            alt=""
            style={{ width: '50px', height: '50px', borderRadius: '8px', objectFit: 'cover' }}
            onError={e => { e.target.style.display = 'none'; }}
          />
          <div>
            <p style={{ margin: 0, fontWeight: 600, fontSize: '15px', color: 'white' }}>{song.title}</p>
            <span style={{ margin: 0, fontSize: '13px', color: 'var(--text-secondary)' }}>{song.artist}</span>
          </div>
        </div>

        <h3 style={{ margin: '0 0 10px 0', fontSize: '18px', color: 'white' }}>Add to Playlist</h3>
        <p style={{ margin: '0 0 16px 0', fontSize: '14px', color: 'var(--text-secondary)' }}>Select a playlist below</p>

        {/* Playlist List */}
        <div className="add-playlist-list" style={{ maxHeight: '240px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '8px', marginBottom: '12px' }}>
          {playlists.map(pl => (
            <button key={pl.id}
              className={`add-to-pl-btn ${addedStatus === pl.id ? 'added' : ''}`}
              onClick={() => handleAddToPlaylist(pl.id)}
              disabled={addedStatus !== null}
            >
              <Music size={15} className="pl-icon" />
              <span>{pl.name}</span>
              {addedStatus === pl.id
                ? <Check size={15} color="var(--accent-cyan)" className="pl-check" />
                : <ArrowRight size={14} className="arrow-hint" />}
            </button>
          ))}
          {playlists.length === 0 && (
            <p style={{ textAlign: 'center', color: 'var(--text-secondary)', fontSize: '14px', margin: '10px 0' }}>
              No playlists yet — create one below!
            </p>
          )}
        </div>

        {/* Create New Playlist inline form */}
        {showCreate ? (
          <form onSubmit={handleCreate} style={{
            display: 'flex', gap: '8px', marginBottom: '12px',
            width: '100%', minWidth: 0, boxSizing: 'border-box'
          }}>
            <input
              autoFocus
              type="text"
              placeholder="Playlist name…"
              value={newName}
              onChange={e => setNewName(e.target.value)}
              style={{
                flex: 1, minWidth: 0, padding: '10px 14px', borderRadius: '12px',
                background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)',
                color: 'white', fontSize: '14px', outline: 'none', boxSizing: 'border-box',
              }}
              disabled={creating}
            />
            <button type="submit" disabled={creating || !newName.trim()}
              style={{
                padding: '10px 16px', borderRadius: '12px',
                background: 'var(--accent-gradient)', color: '#050505',
                fontWeight: 700, fontSize: '13px', cursor: 'pointer', border: 'none',
                opacity: (!newName.trim() || creating) ? 0.5 : 1,
              }}
            >
              {creating ? '…' : 'Create'}
            </button>
          </form>
        ) : (
          <button
            onClick={() => setShowCreate(true)}
            style={{
              width: '100%', padding: '11px', borderRadius: '12px', marginBottom: '12px',
              background: 'rgba(255,255,255,0.05)', border: '1px dashed rgba(255,255,255,0.15)',
              color: 'var(--accent-cyan)', fontWeight: 600, fontSize: '14px',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px',
              cursor: 'pointer',
            }}
          >
            <Plus size={16} /> Create New Playlist
          </button>
        )}

        <button className="cancel-pill"
          style={{ width: '100%', padding: '12px', borderRadius: '50px', background: 'rgba(255,255,255,0.1)', color: 'white', border: 'none', cursor: 'pointer', fontWeight: 600 }}
          onClick={onClose}
        >
          Cancel
        </button>
      </div>
    </div>
  );
}
