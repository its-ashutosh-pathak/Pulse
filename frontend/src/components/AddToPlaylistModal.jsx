import React, { useState } from 'react';
import { Music, Check, ArrowRight } from 'lucide-react';
import { usePlaylists } from '../context/PlaylistContext';
import { getHighResThumb } from '../utils';

export default function AddToPlaylistModal({ song, onClose }) {
  const { playlists, addSongToPlaylist } = usePlaylists();
  const [addedStatus, setAddedStatus] = useState(null);

  if (!song) return null;

  const handleAddToPlaylist = async (playlistId) => {
    await addSongToPlaylist(playlistId, song);
    setAddedStatus(playlistId);
    setTimeout(() => {
      setAddedStatus(null);
      if (onClose) onClose();
    }, 1200);
  };

  const thumb = getHighResThumb(song.thumbnail || song.cover || song.artworkUrl || '', 200);

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="standard-modal glass" onClick={e => e.stopPropagation()}>
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
        <p style={{ margin: '0 0 20px 0', fontSize: '14px', color: 'var(--text-secondary)' }}>Select a playlist below</p>
        <div className="add-playlist-list" style={{ maxHeight: '300px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '8px', marginBottom: '20px' }}>
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
          {playlists.length === 0 && <p className="empty-add-msg" style={{ textAlign: 'center', color: 'var(--text-secondary)', fontSize: '14px', margin: '20px 0' }}>No Playlists yet. Create one in Library first!</p>}
        </div>
        <button className="cancel-pill" style={{ width: '100%', padding: '12px', borderRadius: '50px', background: 'rgba(255,255,255,0.1)', color: 'white', border: 'none', cursor: 'pointer', fontWeight: 600 }} onClick={onClose}>Cancel</button>
      </div>
    </div>
  );
}
