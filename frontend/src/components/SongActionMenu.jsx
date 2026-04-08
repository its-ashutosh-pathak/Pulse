/**
 * SongActionMenu — unified three-dot action menu used everywhere in Pulse.
 *
 * Props:
 *   song        — the song object
 *   onAction    — callback(action, song) where action is one of:
 *                 'QUEUE' | 'PLAYLIST' | 'REMOVE' | 'DOWNLOAD'
 *   showRemove  — bool, show "Remove from Playlist" at the bottom (only for owned/collab playlists)
 *   onClose     — optional, called when menu should close (for parent state)
 *   contextPlaylist — optional playlist object if this song is being viewed inside a playlist
 */
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ListMusic, PlusSquare, Disc, User, Trash2, Loader2, Download, CheckCircle2 } from 'lucide-react';
import { getHighResThumb } from '../utils';
import { downloadSong, isDownloaded } from '../utils/downloadManager';
import { useAuth } from '../context/AuthContext';
import './SongActionMenu.css';

const API = 'http://localhost:5000';

export default function SongActionMenu({ song, onAction, showRemove = false, onClose, contextPlaylist = null }) {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [loadingAction, setLoadingAction] = useState(null);
  const [downloadState, setDownloadState] = useState('idle'); // 'idle' | 'checking' | 'already' | 'downloading' | 'done' | 'error'

  // Check if already downloaded on mount
  useEffect(() => {
    const videoId = song?.videoId || song?.id;
    if (!videoId) return;
    setDownloadState('checking');
    isDownloaded(videoId).then(already => {
      setDownloadState(already ? 'already' : 'idle');
    }).catch(() => setDownloadState('idle'));
  }, [song]);

  if (!song) return null;

  const handle = async (e, action) => {
    e.stopPropagation();

    // These actions are delegated back to the parent because they alter application state or open modals.
    if (action === 'QUEUE' || action === 'PLAYLIST' || action === 'REMOVE') {
      onAction?.(action, song);
      if (onClose) onClose();
      return;
    }

    // ── DOWNLOAD ─────────────────────────────────────────────────────────────
    if (action === 'DOWNLOAD') {
      // Guard: don't re-download
      const videoId = song?.videoId || song?.id;
      const alreadyDone = await isDownloaded(videoId);
      if (alreadyDone) {
        setDownloadState('already');
        return;
      }
      setDownloadState('downloading');
      try {
        const authToken = user ? await user.getIdToken() : '';
        await downloadSong(song, contextPlaylist, authToken);
        setDownloadState('done');
        onAction?.('DOWNLOAD', song);
        setTimeout(() => {
          if (onClose) onClose();
        }, 900);
      } catch (err) {
        console.error('Download failed:', err);
        setDownloadState('error');
        setTimeout(() => setDownloadState('idle'), 2000);
      }
      return;
    }

    // --- SELF-CONTAINED NAVIGATION LOGIC ---
    // This allows "Go to Album" and "Go to Artist" to behave identically across the entire app
    // without requiring identical copy-pasted `handleAction` definitions everywhere.

    if (action === 'ALBUM') {
      setLoadingAction('ALBUM');
      // Prefer cached browseId on the song object (MPRE prefix = YTMusic album)
      const cachedId = song.albumBrowseId?.startsWith('MPRE') ? song.albumBrowseId
        : song.albumId?.startsWith('MPRE') ? song.albumId
          : null;
      if (cachedId) {
        navigate(`/playlist/${cachedId}`);
        if (onClose) onClose();
        return;
      }

      // No cached ID — ask the dedicated album search endpoint
      const q = `${song.album || song.title} ${song.artist || ''}`.trim();
      try {
        const r = await fetch(`${API}/api/album-search?q=${encodeURIComponent(q)}`);
        const json = await r.json();
        const bid = json?.data?.browseId;
        if (bid?.startsWith('MPRE')) {
          navigate(`/playlist/${bid}`);
        } else {
          // Nothing found — drop user to search
          navigate(`/search?q=${encodeURIComponent(song.album || song.title)}`);
        }
      } catch {
        navigate(`/search?q=${encodeURIComponent(song.album || song.title)}`);
      }
      if (onClose) onClose();
      return;
    }

    if (action === 'ARTIST') {
      setLoadingAction('ARTIST');
      const artistId = song.artistBrowseId || (song.browseId?.startsWith('UC') || song.browseId?.startsWith('AC') ? song.browseId : null);
      if (artistId) {
        navigate(`/artist/${artistId}`);
        if (onClose) onClose();
        return;
      }

      // If missing browseId, resolve using targeted endpoint
      const artistName = song.artist || song.title;
      try {
        const r = await fetch(`${API}/api/artist-resolve?name=${encodeURIComponent(artistName)}`);
        const json = await r.json();
        const bid = json?.data?.browseId;
        if (bid) navigate(`/artist/${bid}`);
        else navigate(`/search?q=${encodeURIComponent(artistName)}`);
      } catch (err) {
        navigate(`/search?q=${encodeURIComponent(artistName)}`);
      }
      if (onClose) onClose();
      return;
    }
  };

  const thumb = getHighResThumb(
    song?.thumbnail || song?.cover || song?.artworkUrl || '',
    200
  );

  return (
    <div className="pam-sheet" onClick={e => e.stopPropagation()}>
      <div className="pam-track-info">
        <div className="pam-thumb-wrap">
          {thumb && (
            <img
              src={thumb}
              alt=""
              onError={e => { e.target.style.display = 'none'; }}
            />
          )}
        </div>
        <div className="pam-track-text">
          <p className="pam-title">{song.title || 'Unknown'}</p>
          <span className="pam-artist">{song.artist || ''}</span>
        </div>
      </div>

      <div className="pam-divider" />

      <button className="pam-item" onClick={e => handle(e, 'QUEUE')}>
        <ListMusic size={17} />
        <span>Add to Queue</span>
      </button>

      <button className="pam-item" onClick={e => handle(e, 'PLAYLIST')}>
        <PlusSquare size={17} />
        <span>Add to Playlist</span>
      </button>

      <button className="pam-item" onClick={e => handle(e, 'ALBUM')} disabled={loadingAction === 'ALBUM'}>
        {loadingAction === 'ALBUM' ? <Loader2 size={17} className="animate-spin" /> : <Disc size={17} />}
        <span>{loadingAction === 'ALBUM' ? 'Finding...' : 'Go to Album'}</span>
      </button>

      <button className="pam-item" onClick={e => handle(e, 'ARTIST')} disabled={loadingAction === 'ARTIST'}>
        {loadingAction === 'ARTIST' ? <Loader2 size={17} className="animate-spin" /> : <User size={17} />}
        <span>{loadingAction === 'ARTIST' ? 'Finding...' : 'Go to Artist'}</span>
      </button>

      <div className="pam-divider" />

      <button
        className={`pam-item pam-download ${downloadState === 'done' || downloadState === 'already' ? 'pam-download--done' : ''} ${downloadState === 'error' ? 'pam-download--error' : ''}`}
        onClick={e => handle(e, 'DOWNLOAD')}
        disabled={downloadState === 'downloading' || downloadState === 'done' || downloadState === 'already' || downloadState === 'checking'}
      >
        {(downloadState === 'downloading' || downloadState === 'checking') && <Loader2 size={17} className="animate-spin" />}
        {(downloadState === 'done' || downloadState === 'already') && <CheckCircle2 size={17} />}
        {downloadState === 'idle' && <Download size={17} />}
        {downloadState === 'error' && <Download size={17} />}
        <span>
          {downloadState === 'checking' ? 'Checking...' :
            downloadState === 'downloading' ? 'Downloading...' :
              downloadState === 'done' ? 'Downloaded!' :
                downloadState === 'already' ? 'Already downloaded' :
                  downloadState === 'error' ? 'Download failed' :
                    'Download'}
        </span>
      </button>

      {showRemove && (
        <>
          <div className="pam-divider" />
          <button className="pam-item pam-danger" onClick={e => handle(e, 'REMOVE')}>
            <Trash2 size={17} />
            <span>Remove from Playlist</span>
          </button>
        </>
      )}
    </div>
  );
}
