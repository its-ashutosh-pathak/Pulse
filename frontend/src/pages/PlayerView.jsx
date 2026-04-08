import React, { useState, useEffect, useRef } from 'react';
import {
  ChevronDown, Play, Pause, SkipBack, SkipForward, Shuffle, Repeat, Repeat1,
  Heart, Music2, MoreVertical
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useAudio } from '../context/AudioContext';
import { usePlaylists } from '../context/PlaylistContext';
import { useAuth } from '../context/AuthContext';
import { getHighResThumb } from '../utils';
import SongActionMenu from '../components/SongActionMenu';
import AddToPlaylistModal from '../components/AddToPlaylistModal';
import DownloadOverlay from '../components/DownloadOverlay';
import './PlayerView.css';

const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export default function PlayerView() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const {
    currentSong, isPlaying, isLoading, togglePlay, progress, duration,
    playNext, playPrev, seek, isShuffled, toggleShuffle,
    repeatMode, toggleRepeat, addToQueue, queue, playSong
  } = useAudio();
  const { toggleLike, isLiked, playlists, removeSongFromPlaylist, addSongToPlaylist } = usePlaylists();

  const [showLyrics, setShowLyrics] = useState(false);
  const [lyrics, setLyrics] = useState(null);
  const [lyricsState, setLyricsState] = useState('idle');
  const lyricsScrollRef = useRef(null);
  const [showMenu, setShowMenu] = useState(false);
  const [activeQueueMenuId, setActiveQueueMenuId] = useState(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [selectedSong, setSelectedSong] = useState(null);

  // Swipe tracking for lyrics toggle
  const touchStartRef = useRef(null);

  // Context for playlist owner check
  const currentPlaylist = playlists.find(p => p.id === currentSong?._contextId);
  const isOwner = currentPlaylist?.createdBy === user?.uid;

  const handleTouchStart = (e) => {
    const t = e.touches[0];
    touchStartRef.current = { x: t.clientX, y: t.clientY };
  };

  const handleTouchEnd = (e) => {
    if (!touchStartRef.current) return;
    const t = e.changedTouches[0];
    const dx = Math.abs(t.clientX - touchStartRef.current.x);
    const dy = Math.abs(t.clientY - touchStartRef.current.y);
    if (dx > 50 || dy > 50) {
      setShowLyrics(s => !s);
    }
    touchStartRef.current = null;
  };

  const formatTime = (seconds) => {
    if (!seconds || isNaN(seconds)) return '0:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const progressPercent = duration > 0 ? (progress / duration) * 100 : 0;

  // Find active lyric index
  const activeLineIndex = React.useMemo(() => {
    if (!lyrics?.parsedLines || lyricsState !== 'loaded') return -1;
    // Search backwards to find the current active line
    for (let i = lyrics.parsedLines.length - 1; i >= 0; i--) {
      const line = lyrics.parsedLines[i];
      if (line.time !== null && progress >= line.time) {
        return i;
      }
    }
    return -1;
  }, [progress, lyrics, lyricsState]);

  // Auto-scroll lyrics
  useEffect(() => {
    if (activeLineIndex >= 0 && lyricsScrollRef.current) {
      const container = lyricsScrollRef.current;
      const activeEl = container.children[activeLineIndex];
      if (activeEl) {
        // Calculate offset to center the active line
        const offset = activeEl.offsetTop - (container.clientHeight / 2) + (activeEl.clientHeight / 2);
        container.scrollTo({ top: offset, behavior: 'smooth' });
      }
    }
  }, [activeLineIndex, showLyrics]);

  // Fetch lyrics when song changes (or lyricsKey bumped for retry)
  useEffect(() => {
    if (!currentSong?.videoId) { setLyrics(null); setLyricsState('idle'); return; }
    if (!user) return;
    setLyrics(null);
    setLyricsState('loading');

    user.getIdToken().then(token => {
      const url = `${API}/api/lyrics/${currentSong.videoId}`;
      fetch(url, {
        headers: { Authorization: `Bearer ${token}` }
      })
        .then(r => r.json())
        .then(json => {
          if (!json?.success) { setLyricsState('error'); return; }
          const data = json.data;
          const rawText = data?.syncedLyrics || data?.plainLyrics || data?.lyrics || null;

          if (rawText) {
            let parsedLines = [];
            if (data?.syncedLyrics || rawText.match(/\[\d+:\d+\.\d+\]/)) {
              // Synced LRC format — parse timestamps
              rawText.split('\n').forEach((line, idx) => {
                const match = line.match(/\[(\d+):(\d+\.\d+)\](.*)/);
                if (match) {
                  const time = parseInt(match[1], 10) * 60 + parseFloat(match[2]);
                  const text = match[3].trim();
                  parsedLines.push({ id: idx, time, text, isEmpty: text === '' });
                } else {
                  const text = line.trim();
                  parsedLines.push({ id: idx, time: null, text, isEmpty: text === '' });
                }
              });
            } else {
              // Plain text — strip any leftover brackets, split lines
              const stripped = rawText.replace(/\[\d+:\d+\.\d+\]/g, '');
              parsedLines = stripped.split('\n').map((line, idx) => {
                const text = line.trim();
                return { id: idx, time: null, text, isEmpty: text === '' };
              });
            }
            setLyrics({ ...data, parsedLines });
            setLyricsState('loaded');
          } else if (data?.lyricsUrl) {
            setLyrics({ ...data });
            setLyricsState('url-only');
          } else {
            setLyricsState('not-found');
          }
        })
        .catch(() => setLyricsState('error'));
    }).catch(() => setLyricsState('error'));
  }, [currentSong?.videoId, user]);

  const handleScrubberClick = (e) => {
    const bar = e.currentTarget;
    const rect = bar.getBoundingClientRect();
    const clickX = e.clientX - rect.left;
    const ratio = Math.max(0, Math.min(1, clickX / rect.width));
    seek(ratio * duration);
  };

  const handleScrubberDrag = (e) => {
    e.preventDefault();
    const bar = e.currentTarget;
    const rect = bar.getBoundingClientRect();
    const move = (me) => {
      const x = Math.max(0, Math.min(me.clientX - rect.left, rect.width));
      seek((x / rect.width) * duration);
    };
    const up = () => {
      window.removeEventListener('mousemove', move);
      window.removeEventListener('mouseup', up);
      window.removeEventListener('touchmove', move);
      window.removeEventListener('touchend', up);
    };
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseup', up);
    window.addEventListener('touchmove', move);
    window.addEventListener('touchend', up);
  };

  if (!currentSong) {
    return (
      <div className="fullscreen-player no-song">
        <header className="player-header">
          <button className="nav-back-btn hover-scale" onClick={() => navigate(-1)}>
            <ChevronDown size={32} color="white" />
          </button>
        </header>
        <div className="no-song-content">
          <h2>No music playing</h2>
          <p>Pick a vibe from your library or home</p>
          <button className="back-home-btn glass" onClick={() => navigate('/')}>Go Home</button>
        </div>
      </div>
    );
  }

  return (
    <div
      className="fullscreen-player glass"
      onClick={() => { setShowMenu(false); setActiveQueueMenuId(null); }}
    >
      <div
        className="player-bg-tint"
        style={{ backgroundImage: `url(${getHighResThumb(currentSong.thumbnail || currentSong.cover, 400)})` }}
      />
      <div className="player-bg-overlay" />

      <header className="player-header">
        <button className="nav-back-btn hover-scale" onClick={() => navigate(-1)}>
          <ChevronDown size={32} color="white" />
        </button>
        <div className="now-playing-label">
          <p className="pulse-header-title">PULSE</p>
          <a
            href="https://itsashutoshpathak.vercel.app/"
            target="_blank"
            rel="noopener noreferrer"
            className="header-credit-link"
          >
            Made with ❤️ by <span className="accent-name">Ashutosh Pathak</span>
          </a>
        </div>
      </header>

      <div
        className={`flip-container ${showLyrics ? 'flipped' : ''}`}
        onClick={() => setShowLyrics(s => !s)}
        onTouchStart={handleTouchStart}
        onTouchEnd={handleTouchEnd}
      >
        <div className="flipper">
          <div className="front">
            <div style={{ position: 'relative', width: '100%', height: '100%' }}>
              <img
                src={getHighResThumb(currentSong.thumbnail || currentSong.cover) || 'data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs='}
                alt={currentSong.title}
                className={`album-art-large ${isLoading ? 'art-loading' : ''}`}
                style={{ width: '100%', height: '100%', display: 'block' }}
              />
              <DownloadOverlay videoId={currentSong.videoId || currentSong.id} />
            </div>
            {lyricsState === 'loaded' && !showLyrics && (
              <div className="lyrics-hint">
                <Music2 size={12} /> Tap for lyrics
              </div>
            )}
          </div>
          <div className="back glass">
            {lyricsState === 'loading' && (
              <div className="lyrics-loading">
                <div className="universal-ring" />
              </div>
            )}
            {lyricsState === 'loaded' && lyrics?.parsedLines && (
              <div className="lyrics-scroller" ref={lyricsScrollRef}>
                {lyrics.parsedLines.map((line, i) => (
                  <p
                    key={line.id}
                    className={`lyric-line ${line.isEmpty ? 'lyric-spacer' : ''} ${i === activeLineIndex ? 'active' : ''}`}
                  >
                    {line.text || '\u00a0'}
                  </p>
                ))}
                <div className="lyrics-footer">
                  {lyrics.source && <p className="lyrics-source">{lyrics.source}</p>}
                </div>
              </div>
            )}
            {lyricsState === 'url-only' && lyrics?.lyricsUrl && (
              <div className="lyrics-unavailable">
                <Music2 size={32} strokeWidth={1.5} />
                <p>Full lyrics on Genius</p>
                <a href={lyrics.lyricsUrl} target="_blank" rel="noopener noreferrer" className="lyrics-genius-link">Open Genius ↗</a>
              </div>
            )}
            {(lyricsState === 'error' || lyricsState === 'not-found') && (
              <div className="lyrics-unavailable">
                <Music2 size={32} strokeWidth={1.5} />
                <p>Lyrics unavailable</p>
                <span>for this track</span>
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="player-info-container">
        <div className="song-text">
          <div className="title-row">
            <div className="title-stack marquee-container">
              <h2 className="accent">
                <span className="animate-marquee always-scroll">
                  {currentSong.title} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {currentSong.title} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </span>
              </h2>
              <p>{currentSong.artist}</p>
            </div>
            <div className="title-actions" style={{ position: 'relative' }}>
              <button className="heart-btn hover-scale" onClick={() => toggleLike(currentSong)}>
                <Heart
                  size={24}
                  color={isLiked(currentSong.id) ? 'var(--accent-cyan)' : 'white'}
                  fill={isLiked(currentSong.id) ? 'var(--accent-cyan)' : 'transparent'}
                />
              </button>
              <button
                className="song-options-btn hover-scale"
                onClick={(e) => { e.stopPropagation(); setShowMenu(v => !v); }}
              >
                <MoreVertical size={24} color="white" />
              </button>

              {showMenu && (
                <div
                  style={{ position: 'absolute', right: 0, top: '40px', zIndex: 1000 }}
                  onClick={e => e.stopPropagation()}
                >
                  <SongActionMenu
                    song={currentSong}
                    showRemove={isOwner}
                    onClose={() => setShowMenu(false)}
                    onAction={async (action, s) => {
                      if (action === 'QUEUE') addToQueue(s);
                      if (action === 'PLAYLIST') {
                        setSelectedSong(s);
                        setShowAddModal(true);
                      }
                      if (action === 'REMOVE' && isOwner) {
                        const idx = currentPlaylist.songs.findIndex(t => t.id === s.id || t.videoId === s.videoId);
                        if (idx >= 0) await removeSongFromPlaylist(currentPlaylist.id, idx);
                      }
                    }}
                  />
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      <div className="scrubber-container">
        <div
          className="progress-bar"
          onClick={handleScrubberClick}
          onMouseDown={handleScrubberDrag}
          style={{ cursor: 'pointer' }}
        >
          <div className="progress-fill" style={{ width: `${progressPercent}%` }}>
            <div className="scrubber-thumb" />
          </div>
        </div>
        <div className="time-labels">
          <span>{formatTime(progress)}</span>
          <span>{formatTime(duration)}</span>
        </div>
      </div>

      <div className="main-controls">
        <button className="hover-scale" onClick={toggleShuffle}>
          <Shuffle size={24} color={isShuffled ? 'var(--accent-cyan)' : '#AAAAAA'} />
        </button>
        <button className="hover-scale" onClick={playPrev}>
          <SkipBack size={26} color="white" />
        </button>
        <button className={`play-circle-main hover-scale ${isLoading ? 'loading' : ''}`} onClick={togglePlay}>
          {isLoading
            ? <div className="spin-ring" style={{ width: 28, height: 28, borderWidth: 3, borderColor: 'rgba(0, 240, 255, 0.2)', borderTopColor: 'var(--accent-cyan)' }} />
            : isPlaying
              ? <Pause size={48} fill="white" color="white" strokeWidth={1.5} />
              : <Play size={48} fill="white" color="white" strokeWidth={1.5} />
          }
        </button>
        <button className="hover-scale" onClick={playNext}>
          <SkipForward size={26} color="white" />
        </button>
        <button className="hover-scale" onClick={toggleRepeat}>
          {repeatMode === 'one' ? (
            <Repeat1 size={24} color="var(--accent-cyan)" />
          ) : (
            <Repeat size={24} color={repeatMode === 'all' ? 'var(--accent-cyan)' : '#AAAAAA'} />
          )}
        </button>
      </div>

      <div className="up-next-section">
        <h3 className="up-next-title">Up Next</h3>
        <div className="up-next-list">
          {queue.length === 0 ? (
            <p className="queue-empty">No tracks in queue</p>
          ) : (
            queue.slice(0, 10).map((s, i) => (
              <div
                key={`${s.id}-${i}`}
                className={`queue-row hover-scale ${activeQueueMenuId === i ? 'active-z' : ''}`}
                onClick={() => playSong(s)}
              >
                <div className="queue-thumb-wrap">
                  <img
                    src={getHighResThumb(s.thumbnail || s.cover || '', 200)}
                    alt=""
                    onError={e => { e.target.style.display = 'none'; }}
                  />
                  <DownloadOverlay videoId={s.videoId || s.id} />
                </div>
                <div className="queue-info">
                  <p className="song-title">{s.title}</p>
                  <p className="song-artist">{s.artist}</p>
                </div>
                <div
                  style={{ position: 'relative', flexShrink: 0, zIndex: activeQueueMenuId === i ? 1001 : 'auto' }}
                  onClick={e => e.stopPropagation()}
                >
                  <button
                    className="options-dots-btn"
                    onClick={e => { e.stopPropagation(); setActiveQueueMenuId(activeQueueMenuId === i ? null : i); }}
                  >
                    <MoreVertical size={16} />
                  </button>
                  {activeQueueMenuId === i && (
                    <>
                      <div
                        className="dropdown-overlay"
                        style={{ zIndex: 1000 }}
                        onClick={e => { e.stopPropagation(); setActiveQueueMenuId(null); }}
                      />
                      <SongActionMenu
                        song={s}
                        onAction={(action, track) => {
                          if (action === 'QUEUE') addToQueue(track);
                          if (action === 'PLAYLIST') {
                            setSelectedSong(track);
                            setShowAddModal(true);
                          }
                        }}
                        onClose={() => setActiveQueueMenuId(null)}
                      />
                    </>
                  )}
                </div>
              </div>
            ))
          )}
        </div>
      </div>

      {showAddModal && selectedSong && (
        <AddToPlaylistModal song={selectedSong} onClose={() => setShowAddModal(false)} />
      )}
    </div>
  );
}
