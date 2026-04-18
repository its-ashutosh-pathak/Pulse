import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ChevronDown, Play, Disc, Music2, MoreVertical } from 'lucide-react';
import { usePlaylists } from '../context/PlaylistContext';
import { useAudio } from '../context/AudioContext';
import { getHighResThumb } from '../utils';
import SongActionMenu from '../components/SongActionMenu';
import AddToPlaylistModal from '../components/AddToPlaylistModal';
import './ArtistView.css';

const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export default function ArtistView() {
  const { id }    = useParams();
  const navigate  = useNavigate();
  const { playSong, addToQueue, currentSong } = useAudio();
  const { playlists, addSongToPlaylist } = usePlaylists();

  const [artist, setArtist]   = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError]     = useState(false);

  const [activeMenuId, setActiveMenuId] = useState(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [selectedSong, setSelectedSong] = useState(null);
  const [addedStatus, setAddedStatus]   = useState(null);

  const handleAction = (action, song) => {
    setActiveMenuId(null);
    if (action === 'QUEUE') { addToQueue(song); return; }
    if (action === 'PLAYLIST') { setSelectedSong(song); setShowAddModal(true); setAddedStatus(null); return; }
    if (action === 'ALBUM') {
      const albumId = song.albumBrowseId || song.albumId;
      if (albumId && albumId.length > 11) { navigate(`/playlist/${albumId}`); return; }
      else if (song.album) navigate(`/search?q=${encodeURIComponent(song.album)}`);
      return;
    }
    if (action === 'ARTIST') {
      const artistId = song.artistBrowseId || (
        song.browseId?.startsWith('UC') || song.browseId?.startsWith('AC')
          ? song.browseId : null
      );
      if (artistId) { navigate(`/artist/${artistId}`); return; }
      const artistName = song.artist || song.title;
      if (!artistName) return;
      fetch(`${API}/api/artist-resolve?name=${encodeURIComponent(artistName)}`)
        .then(r => r.json())
        .then(json => {
          const bid = json?.data?.browseId;
          if (bid) navigate(`/artist/${bid}`);
          else navigate(`/search?q=${encodeURIComponent(artistName)}`);
        })
        .catch(() => navigate(`/search?q=${encodeURIComponent(artistName)}`));
    }
  };

  const handleAddToPlaylist = async (playlistId) => {
    if (!selectedSong) return;
    await addSongToPlaylist(playlistId, selectedSong);
    setAddedStatus(playlistId);
    setTimeout(() => { setShowAddModal(false); setSelectedSong(null); setAddedStatus(null); }, 1200);
  };

  // Close menus on outside click
  useEffect(() => {
    const close = () => setActiveMenuId(null);
    window.addEventListener('click', close);
    return () => window.removeEventListener('click', close);
  }, []);

  useEffect(() => {
    if (!id) return;
    setLoading(true);
    setError(false);
    fetch(`${API}/api/artist/${id}`)
      .then(r => r.json())
      .then(json => {
        if (!json || !json.success) throw new Error(json?.message || 'Error');
        setArtist(json.data);
      })
      .catch(() => setError(true))
      .finally(() => setLoading(false));
  }, [id]);

  const playAll = () => {
    if (!artist?.topSongs?.length) return;
    const [first, ...rest] = artist.topSongs;
    playSong(first);
    rest.forEach(s => addToQueue(s));
  };

  if (loading) return (
    <div className="artist-view">
      <header className="artist-back-btn">
        <button onClick={() => navigate(-1)}><ChevronDown size={28} /></button>
      </header>
      <div className="artist-loading">
        <div className="universal-ring" />
      </div>
    </div>
  );

  if (error || !artist) return (
    <div className="artist-view">
      <header className="artist-back-btn">
        <button onClick={() => navigate(-1)}><ChevronDown size={28} /></button>
      </header>
      <div className="artist-error">
        <Music2 size={48} strokeWidth={1.2} />
        <p>Couldn't load artist</p>
        <button onClick={() => navigate(-1)}>Go Back</button>
      </div>
    </div>
  );

  return (
    <div className="artist-view">
      {/* Hero Banner */}
      <div className="artist-hero">
        {artist.thumbnail
          ? <img src={getHighResThumb(artist.thumbnail, 800)} alt={artist.name} className="artist-hero-img" />
          : <div className="artist-hero-placeholder" />
        }
        <div className="artist-hero-overlay" />

        <button className="artist-back-fab hover-scale" onClick={() => navigate(-1)}>
          <ChevronDown size={24} />
        </button>

        <div className="artist-hero-info">
          {artist.subscribers && (
            <span className="artist-subscribers">{artist.subscribers} subscribers</span>
          )}
          <h1 className="artist-name">{artist.name}</h1>
          <button className="artist-play-all hover-scale" onClick={playAll}>
            <Play size={18} fill="currentColor" /> Play All
          </button>
        </div>
      </div>

      <div className="artist-body">
        {/* Bio */}
        {artist.description && (
          <section className="artist-section">
            <h2 className="artist-section-title">About</h2>
            <p className="artist-bio">{artist.description}</p>
          </section>
        )}

        {/* Top Songs */}
        {artist.topSongs?.length > 0 && (
          <section className="artist-section">
            <h2 className="artist-section-title">Popular</h2>
            <div className="artist-song-list">
              {artist.topSongs.slice(0, 5).map((song, i) => {
                const isNowPlaying = currentSong?.id === song.id;
                return (
                  <div
                    key={song.id || i}
                    className={`artist-song-row ${isNowPlaying ? 'now-playing' : ''}`}
                    onClick={() => playSong(song)}
                  >
                    <span className="artist-song-rank">
                      {isNowPlaying
                        ? <div className="playing-bars"><span/><span/><span/></div>
                        : i + 1
                      }
                    </span>
                    <div className="artist-song-thumb">
                      <img src={getHighResThumb(song.thumbnail)} alt="" />
                    </div>
                    <div className="artist-song-meta">
                      <p className={isNowPlaying ? 'accent' : ''}>{song.title}</p>
                      <span>{song.album || song.artist}</span>
                    </div>
                    <div className="action-wrapper" style={{ position: 'relative' }}>
                      <button className="action-menu-trigger" onClick={e => { e.stopPropagation(); setActiveMenuId(activeMenuId === (song.id || i) ? null : (song.id || i)); }}>
                        <MoreVertical size={18} />
                      </button>
                      {activeMenuId === (song.id || i) && (
                        <SongActionMenu song={song} onAction={handleAction} onClose={() => setActiveMenuId(null)} />
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
            {artist.songsBrowseId && (
              <div className="artist-view-more-container" style={{ display: 'flex', justifyContent: 'center', marginTop: '16px' }}>
                <button 
                  className="artist-view-more-btn" 
                  onClick={() => navigate(`/playlist/${artist.songsBrowseId}`)}
                  style={{ background: 'rgba(255,255,255,0.1)', border: 'none', color: '#fff', padding: '8px 24px', borderRadius: '30px', fontSize: '13px', cursor: 'pointer', transition: 'background 0.2s' }}
                  onMouseEnter={e => e.target.style.background = 'rgba(255,255,255,0.2)'}
                  onMouseLeave={e => e.target.style.background = 'rgba(255,255,255,0.1)'}
                >
                  View all
                </button>
              </div>
            )}
          </section>
        )}

        {/* Albums */}
        {artist.albums?.length > 0 && (
          <section className="artist-section">
            <h2 className="artist-section-title">Albums</h2>
            <div className="artist-albums-scroll">
              {artist.albums.map((album, i) => (
                <div key={i} className="artist-album-card hover-scale"
                  onClick={() => navigate(`/playlist/${album.browseId}`)}>
                  <div className="artist-album-art">
                    <img src={getHighResThumb(album.thumbnail, 400)} alt="" />
                    <div className="artist-album-overlay"><Disc size={18} /></div>
                  </div>
                  <p className="artist-album-title">{album.title}</p>
                  <span className="artist-album-year">{album.year || ''}</span>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Singles */}
        {artist.singles?.length > 0 && (
          <section className="artist-section">
            <h2 className="artist-section-title">Singles & EPs</h2>
            <div className="artist-albums-scroll">
              {artist.singles.map((single, i) => (
                <div key={i} className="artist-album-card hover-scale"
                  onClick={() => navigate(`/playlist/${single.browseId}`)}>
                  <div className="artist-album-art">
                    <img src={getHighResThumb(single.thumbnail, 400)} alt="" />
                    <div className="artist-album-overlay"><Disc size={18} /></div>
                  </div>
                  <p className="artist-album-title">{single.title}</p>
                  <span className="artist-album-year">{single.year || ''}</span>
                </div>
              ))}
            </div>
          </section>
        )}
      </div>

      {showAddModal && (
        <AddToPlaylistModal
          playlists={playlists}
          onClose={() => { setShowAddModal(false); setSelectedSong(null); setAddedStatus(null); }}
          onAdd={handleAddToPlaylist}
          addedStatus={addedStatus}
        />
      )}
    </div>
  );
}
