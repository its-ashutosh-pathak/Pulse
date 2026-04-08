import React from 'react';
import { Play, Pause, SkipForward, SkipBack, Heart } from 'lucide-react';
import { useAudio } from '../context/AudioContext';
import { usePlaylists } from '../context/PlaylistContext';
import { useNavigate } from 'react-router-dom';
import { getHighResThumb } from '../utils';
import DownloadOverlay from './DownloadOverlay';
import './Player.css';

export default function Player() {
  const { currentSong, isPlaying, isLoading, togglePlay, progress, duration, playNext, playPrev } = useAudio();
  const { toggleLike, isLiked } = usePlaylists();
  const navigate = useNavigate();

  const progressPercent = (progress / duration) * 100 || 0;

  if (!currentSong) {
    return null;
  }

  return (
    <div className="player-container glass" onClick={() => navigate('/player')}>
      <div className="player-track-info">
        <div className="cover-art">
          {(getHighResThumb(currentSong.thumbnail || currentSong.cover || currentSong.artworkUrl, 400)) ? (
            <img
              src={getHighResThumb(currentSong.thumbnail || currentSong.cover || currentSong.artworkUrl, 400)}
              alt={currentSong.title}
              onError={e => { e.target.style.display = 'none'; }}
            />
          ) : (
            <div style={{ width: '100%', height: '100%', background: 'rgba(255,255,255,0.07)', borderRadius: '8px' }} />
          )}
          <DownloadOverlay videoId={currentSong.videoId || currentSong.id} />
        </div>
        <div className="track-details">
          <h4 className="track-title">
            <span className="animate-marquee always-scroll">
              {currentSong.title} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {currentSong.title} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </span>
          </h4>
          <p className="track-artist">{currentSong.artist}</p>
        </div>
      </div>

      <div className="player-controls" onClick={(e) => e.stopPropagation()}>
        <button className="heart-btn hover-scale" onClick={() => toggleLike(currentSong)}>
          <Heart 
            size={24} 
            color={isLiked(currentSong.id) ? 'var(--accent-cyan)' : 'white'} 
            fill={isLiked(currentSong.id) ? 'var(--accent-cyan)' : 'transparent'} 
          />
        </button>
        <button className="hover-scale" onClick={playPrev}><SkipBack size={22} color="white" /></button>
        <button className={`play-btn-pulse hover-scale ${isLoading ? 'loading' : ''}`} onClick={togglePlay}>
          {isLoading ? <div className="spin-ring" style={{ width: 14, height: 14, borderWidth: 2, borderColor: 'rgba(0, 240, 255, 0.2)', borderTopColor: 'var(--accent-cyan)' }} /> : (isPlaying ? <Pause size={22} fill="white" color="white" /> : <Play size={22} fill="white" color="white" />)}
        </button>
        <button className="hover-scale" onClick={playNext}><SkipForward size={22} color="white" /></button>
      </div>


      {/* ACCENT TRACKING LINE */}
      <div className="player-lining">
        <div className="lining-fill" style={{ width: `${progressPercent}%` }}></div>
      </div>
    </div>
  );
}
