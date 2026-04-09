/**
 * ImportPlaylist.jsx
 * Mobile-first bottom sheet for importing public playlists from:
 *   - YouTube Music  → preview flow (was already working)
 *   - Spotify        → single-shot backend POST (hybrid sync/async)
 *
 * On confirm: creates a Firestore playlist identical to any manually created playlist.
 */
import React, { useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { X, Link2, Music2, CheckCircle2, AlertCircle, Loader2, ArrowRight } from 'lucide-react';
import { usePlaylists } from '../context/PlaylistContext';
import { useAuth } from '../context/AuthContext';
import './ImportPlaylist.css';

const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';

// ── URL parsing ───────────────────────────────────────────────────────────────

function extractYTPlaylistId(raw) {
  const text = (raw || '').trim();
  try {
    const u = new URL(text);
    const list = u.searchParams.get('list');
    if (list) return list;
    const m = u.pathname.match(/\/(PL|VL|RD|OL|MPRE)[A-Za-z0-9_-]+/);
    if (m) return m[0].slice(1);
  } catch { }
  if (/^(PL|VL|RD|OL|MPRE)[A-Za-z0-9_-]+$/.test(text)) return text;
  return null;
}

function extractSpotifyPlaylistId(raw) {
  const text = (raw || '').trim();
  const uriMatch = text.match(/^spotify:playlist:([A-Za-z0-9]+)/);
  if (uriMatch) return uriMatch[1];
  try {
    const u = new URL(text);
    const m = u.pathname.match(/\/playlist\/([A-Za-z0-9]+)/);
    if (m) return m[1];
  } catch { }
  if (/^[A-Za-z0-9]{22}$/.test(text)) return text;
  return null;
}

// ── Component ─────────────────────────────────────────────────────────────────

export default function ImportPlaylist({ onClose, initialTab = 'ytm' }) {
  const { user } = useAuth();
  const { addSongToPlaylist } = usePlaylists();
  const navigate = useNavigate();

  const [tab, setTab] = useState(initialTab);
  const [url, setUrl] = useState('');
  const [phase, setPhase] = useState('idle');   // idle | fetching | preview | importing | done | error
  const [preview, setPreview] = useState(null);  // { name, total, tracks[] }
  const [progress, setProgress] = useState(0);
  const [errorMsg, setErrorMsg] = useState('');
  const [importedPlaylistId, setImportedPlaylistId] = useState(null);

  const reset = () => {
    setUrl('');
    setPhase('idle');
    setPreview(null);
    setProgress(0);
    setErrorMsg('');
    setImportedPlaylistId(null);
  };

  // ── Step 1: preview ───────────────────────────────────────────────────────
  const handleFetch = useCallback(async () => {
    setPhase('fetching');
    setErrorMsg('');
    try {
      if (tab === 'ytm') {
        // YTMusic: restore original preview flow (was working fine)
        const id = extractYTPlaylistId(url);
        if (!id) throw new Error('Could not find a YouTube / YouTube Music playlist ID in that URL.');

        const r = await fetch(`${API}/api/playlist/${id}`);
        const json = await r.json();
        if (!json.success || !json.data) throw new Error('Playlist not found or is private.');

        const data = json.data;
        const tracks = (data.songs || data.tracks || data.content || [])
          .map(s => ({
            videoId: s.videoId || s.id,
            title: s.title || s.name || '',
            artist: s.artist || (s.artists || []).map(a => a.name).join(', ') || '',
            thumbnail: s.thumbnail || s.cover || '',
            duration: s.duration || 0,
          }))
          .filter(s => s.videoId && s.videoId.length === 11);

        setPreview({ name: data.name || data.title || 'Imported Playlist', total: tracks.length, tracks });
        setPhase('preview');

      } else {
        // Spotify: Step 1 — lightweight preview (name + total only)
        const id = extractSpotifyPlaylistId(url);
        if (!id) throw new Error('Could not find a Spotify playlist ID in that URL.');

        const r = await fetch(`${API}/api/import/spotify/preview?url=${encodeURIComponent(url)}`);
        const json = await r.json();
        if (!r.ok || !json.success) throw new Error(json.message || 'Playlist not found or is private.');

        setPreview({ name: json.data.name, total: json.data.total, tracks: [] });
        setPhase('preview');
      }
    } catch (e) {
      setErrorMsg(e.message || 'Something went wrong — check the URL and try again.');
      setPhase('error');
    }
  }, [tab, url, user]);

  const handleImport = useCallback(async () => {
    if (!preview || !user) return;
    setPhase('importing');
    setProgress(0);
    try {
      if (tab === 'spotify') {
        // Spotify: fire backend POST (hybrid sync/async)
        const token = await user.getIdToken();
        const r = await fetch(`${API}/api/import/spotify`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
          },
          body: JSON.stringify({ url }),
        });
        const json = await r.json();
        if (!r.ok || !json.success) throw new Error(json.message || 'Import failed.');
        setImportedPlaylistId(json.data.playlistId);
        setPhase('done');
        return;
      }
      const { addDoc, collection, serverTimestamp } = await import('firebase/firestore');
      const { db } = await import('../firebase');

      const docRef = await addDoc(collection(db, 'playlists'), {
        name: preview.name,
        createdBy: user.uid,
        ownerName: user.displayName || 'Pulse User',
        members: [user.uid],
        songs: [],
        visibility: 'Public',
        importedFrom: 'youtube_music',
        createdAt: serverTimestamp(),
        lastUpdated: serverTimestamp(),
      });
      const playlistId = docRef.id;

      const total = preview.tracks.length;
      for (let i = 0; i < total; i++) {
        const track = preview.tracks[i];
        await addSongToPlaylist(playlistId, track);
        setProgress(Math.round(((i + 1) / total) * 100));
      }

      setImportedPlaylistId(playlistId);
      setPhase('done');
    } catch (e) {
      setErrorMsg(e.message || 'Import failed — please try again.');
      setPhase('error');
    }
  }, [preview, tab, url, user, addSongToPlaylist]);

  // ── Render ────────────────────────────────────────────────────────────────
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
                onClick={handleFetch}
              >
                Preview Playlist <ArrowRight size={16} />
              </button>
            </>
          )}

          {/* FETCHING */}
          {phase === 'fetching' && (
            <div className="import-loading">
              <Loader2 size={36} className="import-spin" />
              <p>Fetching playlist…<br /><span style={{ fontSize: 12, opacity: 0.5 }}>This may take a few seconds</span></p>
            </div>
          )}

          {/* PREVIEW (YTM only) — show name + track count + Add to Library button */}
          {phase === 'preview' && preview && (
            <>
              <div className="import-preview-row">
                <div className="import-preview-info glass">
                  <Music2 size={22} className="import-preview-icon" />
                  <div>
                    <h3>{preview.name}</h3>
                    <p>{preview.total} track{preview.total !== 1 ? 's' : ''}</p>
                    {tab === 'spotify' && <span className="import-match-note">Will be matched on YouTube Music</span>}
                  </div>
                </div>
                <button className="import-save-btn" onClick={handleImport}>
                  Save to<br />Library
                </button>
              </div>

              <button className="import-back-wide" onClick={reset}>
                Back
              </button>
            </>
          )}

          {/* IMPORTING */}
          {phase === 'importing' && (
            <div className="import-loading">
              <Loader2 size={36} className="import-spin" />
              <p>
                {tab === 'spotify'
                  ? 'Matching songs on YouTube Music…'
                  : `Saving… ${progress}%`}
              </p>
              {tab === 'ytm' && (
                <div className="import-progress-wrap">
                  <div className="import-progress-fill" style={{ width: `${progress}%` }} />
                </div>
              )}
            </div>
          )}

          {/* DONE */}
          {phase === 'done' && (
            <div className="import-loading">
              <CheckCircle2 size={52} className="import-done-icon" />
              <p style={{ fontWeight: 700, fontSize: 16, color: 'var(--text-primary)' }}>
                Saved to your Library!
              </p>
              {importedPlaylistId && (
                <button
                  className="import-action-btn"
                  onClick={() => { navigate(`/playlist/${importedPlaylistId}`); onClose(); }}
                  style={{ marginTop: 8 }}
                >
                  View Playlist
                </button>
              )}
              <button className="import-action-btn" onClick={onClose} style={{ marginTop: 4 }}>
                Done
              </button>
            </div>
          )}

        </div>
      </div>
    </div>
  );
}
