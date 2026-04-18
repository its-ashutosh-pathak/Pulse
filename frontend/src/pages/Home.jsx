import React, { useState, useEffect, useRef, useCallback } from 'react';
import { useAuth } from '../context/AuthContext';
import { usePlaylists } from '../context/PlaylistContext';
import { useAudio } from '../context/AudioContext';
import { useNavigate } from 'react-router-dom';
import { Play, MoreVertical, ListMusic } from 'lucide-react';
import { getHighResThumb } from '../utils';
import logo from '../assets/logo.png';
import SongActionMenu from '../components/SongActionMenu';
import './Home.css';

// ── SongCard ────────────────────────────────────────────────
function SongCard({ song, onPlay, isPlaying, onMenu }) {
  return (
    <div
      className={`yt-song-card glass ${isPlaying ? 'yt-song-card--playing' : ''}`}
      onClick={() => onPlay(song)}
    >
      <div className="yt-song-card__art-wrap">
        <img
          src={getHighResThumb(song.thumbnail, 500)}
          alt={song.title}
          className="yt-song-card__art"
          loading="lazy"
          onError={e => { e.target.style.opacity = 0; }}
        />
        <div className="yt-song-card__play-overlay">
          {isPlaying ? (
            <div className="playing-bars">
              <span /><span /><span />
            </div>
          ) : (
            <Play size={22} fill="white" color="white" />
          )}
        </div>
      </div>
      <div className="yt-song-card__info">
        <p className={`yt-song-card__title ${isPlaying ? 'accent' : ''}`}>{song.title}</p>
        <p className="yt-song-card__artist">{song.artist}</p>
      </div>
    </div>
  );
}

// ── Skeleton ────────────────────────────────────────────────
function SectionSkeleton() {
  return (
    <section className="home-section">
      <div className="skeleton-label" />
      <div className="horizontal-grid-scroll">
        {[1, 2, 3, 4, 5].map(i => (
          <div key={i} className="yt-song-card">
            <div className="yt-song-card__art-wrap skeleton" />
            <div className="yt-song-card__info">
              <div className="skeleton" style={{ height: 12, borderRadius: 4, marginBottom: 6, width: '80%' }} />
              <div className="skeleton" style={{ height: 10, borderRadius: 4, width: '55%' }} />
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

// ── Lazy Section (only renders cards when in viewport) ──────
function LazySection({ section, onPlay, isCardPlaying, onMenu }) {
  const ref = useRef(null);
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    if (!ref.current) return;
    const observer = new IntersectionObserver(
      ([entry]) => { if (entry.isIntersecting) { setVisible(true); observer.disconnect(); } },
      { rootMargin: '200px' }   // start loading 200px before section enters view
    );
    observer.observe(ref.current);
    return () => observer.disconnect();
  }, []);

  return (
    <section className="home-section" ref={ref}>
      <div className="section-header-row">
        <h2 className="section-title">{section.title}</h2>
      </div>
      <div className="horizontal-grid-scroll">
        {visible
          ? section.items.map((song, i) => (
              <SongCard
                key={`${song.id}-${i}`}
                song={song}
                onPlay={onPlay}
                isPlaying={isCardPlaying(song)}
                onMenu={onMenu}
              />
            ))
          : [1, 2, 3, 4, 5].map(i => (
              <div key={i} className="yt-song-card">
                <div className="yt-song-card__art-wrap skeleton" />
                <div className="yt-song-card__info">
                  <div className="skeleton" style={{ height: 12, borderRadius: 4, marginBottom: 6, width: '80%' }} />
                  <div className="skeleton" style={{ height: 10, borderRadius: 4, width: '55%' }} />
                </div>
              </div>
            ))
        }
      </div>
    </section>
  );
}

// ── Main Component ───────────────────────────────────────────
export default function Home() {
  const { user } = useAuth();
  const { playlists } = usePlaylists();
  const { playSong, currentSong, addToQueue, replaceQueue } = useAudio();
  const navigate = useNavigate();

  const [sections, setSections] = useState([]);
  const [loadingHome, setLoadingHome] = useState(true);
  const [homeError, setHomeError] = useState(false);
  const [menuSong, setMenuSong] = useState(null);
  const [menuPos, setMenuPos] = useState({ x: 0, y: 0 });

  const firstName = user?.displayName?.split(' ')[0] || 'Member';
  const hour = new Date().getHours();
  let wish = 'Good evening,';
  if (hour < 12) wish = 'Good morning,';
  else if (hour < 18) wish = 'Good afternoon,';

  // Fetch all 10 home sections from backend
  useEffect(() => {
    setLoadingHome(true);
    setHomeError(false);
    fetch(`${import.meta.env.VITE_API_URL || 'http://localhost:5000'}/api/home`)
      .then(res => res.json())
      .then(json => {
        if (json && json.success && Array.isArray(json.data) && json.data.length > 0) {
          setSections(json.data);
        } else {
          setHomeError(true);
        }
      })
      .catch(() => setHomeError(true))
      .finally(() => setLoadingHome(false));
  }, []);

  // Close context menu on outside click
  useEffect(() => {
    const close = () => setMenuSong(null);
    window.addEventListener('click', close);
    return () => window.removeEventListener('click', close);
  }, []);

  const handlePlay = async (song) => {
    const videoId = song.videoId || '';
    if (videoId.length === 11) {
      replaceQueue([]);
      playSong(song);
    } else if (song.type === 'SINGLE') {
      const collectionId = song.playlistId || song.browseId || song.id;
      if (!collectionId) return;
      try {
        const res = await fetch(`${import.meta.env.VITE_API_URL || 'http://localhost:5000'}/api/playlist/${collectionId}`);
        const data = await res.json();
        const tracks = data.tracks || [];
        if (tracks.length > 0) {
          playSong(tracks[0]);
          if (tracks.length > 1) replaceQueue(tracks.slice(1));
        }
      } catch (err) {
        console.error('Failed to load Single:', err);
      }
    } else {
      const collectionId = song.playlistId || song.browseId || song.id;
      if (collectionId) navigate(`/playlist/${collectionId}`);
    }
  };

  const handleMenuTrigger = (e, song) => {
    e.stopPropagation();
    const rect = e.currentTarget.getBoundingClientRect();
    setMenuPos({ x: rect.left, y: rect.bottom + 6 });
    setMenuSong(song);
  };

  const isCardPlaying = useCallback((song) => {
    if (!currentSong) return false;
    if (currentSong.id === song.id || currentSong.videoId === song.videoId) return true;
    if (song.type !== 'SONG' || song.id?.length > 11) {
      const collectionId = song.playlistId || song.browseId || song.id;
      if (currentSong._contextId === collectionId) return true;
      if (currentSong._contextTitle === (song.title || song.name)) return true;
      if (currentSong.album && currentSong.album === song.title) return true;
      if (currentSong.title === song.title && currentSong.artist?.includes(song.artist)) return true;
    }
    return false;
  }, [currentSong]);

  return (
    <div className="home-container">
      {/* ── Header ── */}
      <header className="home-header">
        <div className="greeting">
          <p className="wish-time">{wish}</p>
          <h1>{firstName}</h1>
        </div>
        <img src={logo} alt="Pulse Logo" className="pulse-logo hover-scale" />
      </header>

      {/* ── Recent Playlists ── */}
      {playlists.length > 0 && (
        <section className="home-section">
          <h2 className="section-title">Recent Playlists</h2>
          <div className="playlists-grid">
            {playlists.slice(0, 6).map(pl => (
              <div
                key={pl.id}
                className="playlist-h-card glass hover-scale"
                onClick={() => navigate(`/playlist/${pl.id}`)}
              >
                <div className="playlist-h-art">
                  {pl.songs?.length >= 4 ? (
                    <div className="art-grid">
                      {pl.songs.slice(0, 4).map((s, idx) => (
                        <img key={idx} src={getHighResThumb(s.thumbnail, 400) || null} alt="" />
                      ))}
                    </div>
                  ) : pl.songs?.length > 0 ? (
                    <img src={getHighResThumb(pl.songs[0].thumbnail, 400) || null} alt="" className="art-single" />
                  ) : (
                    <div className="art-empty" />
                  )}
                </div>
                <div className="playlist-h-info">
                  <span>{pl.name}</span>
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* ── YT Music Home Sections (lazy-loaded) ── */}
      {loadingHome ? (
        <>
          <SectionSkeleton />
          <SectionSkeleton />
          <SectionSkeleton />
        </>
      ) : homeError ? (
        <div className="home-error-state">
          <p>Couldn't load music feed.</p>
          <button onClick={() => window.location.reload()}>Retry</button>
        </div>
      ) : (
        sections.map((section, si) => (
          <LazySection
            key={si}
            section={section}
            onPlay={handlePlay}
            isCardPlaying={isCardPlaying}
            onMenu={handleMenuTrigger}
          />
        ))
      )}

      {/* ── Floating Context Menu ── */}
      {menuSong && (
        <div
          className="home-context-menu-wrapper"
          style={{ position: 'absolute', top: menuPos.y, left: Math.min(menuPos.x, window.innerWidth - 200), zIndex: 1000 }}
          onClick={e => e.stopPropagation()}
        >
          <SongActionMenu 
            song={menuSong} 
            onClose={() => setMenuSong(null)}
            onAction={async (action, song) => {
              setMenuSong(null);
              if (action === 'QUEUE') addToQueue(song);
              if (action === 'PLAYLIST') {
                // handle add to playlist (show modal, which we need to implement or just trigger)
              }
            }}
          />
        </div>
      )}
    </div>
  );
}
