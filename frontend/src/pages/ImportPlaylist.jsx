/**
 * ImportPlaylist.jsx
 * Mobile-first bottom sheet for importing public playlists from:
 *   - YouTube Music
 *   - Spotify
 * 
 * Uses the Hybrid Backend API to prevent browser hangs.
 */
import React, { useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { X, Link2, Music2, CheckCircle2, AlertCircle, Loader2, ArrowRight } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import './ImportPlaylist.css';

const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export default function ImportPlaylist({ onClose, initialTab = 'ytm' }) {
  const { user } = useAuth();
  const navigate = useNavigate();

  const [tab, setTab] = useState(initialTab);
  const [url, setUrl] = useState('');
  const [phase, setPhase] = useState('idle');   // idle | importing | done | error
  const [errorMsg, setErrorMsg] = useState('');
  const [result, setResult] = useState(null);   // { status, playlistId }

  const reset = () => {
    setUrl('');
    setPhase('idle');
    setErrorMsg('');
    setResult(null);
  };

  const handleImport = useCallback(async () => {
    if (!url.trim() || !user) return;
    
    setPhase('importing');
    setErrorMsg('');
    
    try {
      const endpoint = tab === 'ytm' ? '/api/import/ytmusic' : '/api/import/spotify';
      
      const token = await user.getIdToken();
      
      const r = await fetch(`${API}${endpoint}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ url })
      });
      
      const json = await r.json();
      
      if (!r.ok || !json.success) {
        throw new Error(json.message || 'Import failed. Verify the URL and try again.');
      }
      
      setResult(json.data);
      setPhase('done');
      
    } catch (e) {
      setErrorMsg(e.message || 'Network error — please check your connection and try again.');
      setPhase('error');
    }
  }, [tab, url, user]);

  const viewPlaylist = () => {
    if (result?.playlistId) {
       navigate(`/playlist/${result.playlistId}`);
    }
    onClose();
  };

  return (
    <div className="import-overlay" onClick={onClose}>
      <div className="import-sheet glass" onClick={e => e.stopPropagation()}>

        {/* Header */}
        <div className="import-header">
          <h2>Import Playlist</h2>
          <button className="import-close" onClick={onClose}><X size={18} /></button>
        </div>

        {/* Tabs */}
        <div className="import-tabs">
          <button
            className={`import-tab ${tab === 'ytm' ? 'active' : ''}`}
            onClick={() => { setTab('ytm'); reset(); }}
          >
            <img src="https://upload.wikimedia.org/wikipedia/commons/6/6a/Youtube_Music_icon.svg" alt="YT Music" />
            YouTube Music
          </button>
          <button
            className={`import-tab ${tab === 'spotify' ? 'active' : ''}`}
            onClick={() => { setTab('spotify'); reset(); }}
          >
            <img src="https://www.vectorlogo.zone/logos/spotify/spotify-icon.svg" alt="Spotify" />
            Spotify
          </button>
        </div>

        {/* Body */}
        <div className="import-body">

          {/* IDLE / ERROR — URL input */}
          {(phase === 'idle' || phase === 'error') && (
            <>
              <p className="import-hint">
                {tab === 'ytm'
                  ? 'Paste a public YouTube/YouTube Music playlist URL'
                  : 'Paste a public Spotify playlist URL'}
              </p>

              <div className="import-url-card">
                <Link2 size={16} className="import-url-icon" />
                <input
                  className="import-url-input"
                  type="url"
                  inputMode="url"
                  placeholder={tab === 'ytm'
                    ? 'https://music.youtube.com/playlist?list=PL…'
                    : 'https://open.spotify.com/playlist/…'}
                  value={url}
                  onChange={e => { setUrl(e.target.value); if (phase === 'error') { setPhase('idle'); setErrorMsg(''); } }}
                  autoFocus
                />
              </div>

              {phase === 'error' && (
                <div className="import-error">
                  <AlertCircle size={14} />
                  <span>{errorMsg}</span>
                </div>
              )}

              <button
                className="import-action-btn"
                disabled={!url.trim()}
                onClick={handleImport}
              >
                Start Import Process <ArrowRight size={16} />
              </button>
            </>
          )}

          {/* IMPORTING */}
          {phase === 'importing' && (
            <div className="import-loading">
              <Loader2 size={36} className="import-spin" />
              <p>Extracting & saving playlist...<br />
                <span style={{ fontSize: 12, opacity: 0.5 }}>This may take a few seconds</span>
              </p>
            </div>
          )}

          {/* DONE */}
          {phase === 'done' && (
            <div className="import-loading">
              <CheckCircle2 size={52} className="import-done-icon" />
              <p style={{ fontWeight: 700, fontSize: 16, color: 'var(--text-primary)' }}>
                {result?.status === 'processing' 
                   ? 'Import started in background!' 
                   : 'Playlist perfectly imported!'}
              </p>
              
              {result?.status === 'processing' && (
                  <p style={{ fontSize: 13, opacity: 0.7, marginTop: 6, marginBottom: 16 }}>
                      Because the playlist is massive, we are processing the rest of the tracks in the background. 
                      You can close this safely!
                  </p>
              )}
              
              <button className="import-action-btn" onClick={viewPlaylist} style={{ marginTop: result?.status === 'processing' ? 0 : 16 }}>
                View Playlist
              </button>
            </div>
          )}

        </div>
      </div>
    </div>
  );
}
