/**
 * SongActionMenu — unified three-dot action menu used everywhere in Pulse.
 *
 * Props:
 *   song        — the song object
 *   onAction    — callback(action, song) where action is one of:
 *                 'QUEUE' | 'REMOVE'
 *   showRemove  — bool, show "Remove from Playlist" at the bottom
 *   onClose     — optional, called when menu should close
 *   contextPlaylist — optional playlist object if this song is being viewed inside a playlist
 *
 * "Add to Playlist" is now handled internally — opens AddToPlaylistModal directly.
 */
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ListMusic, PlusSquare, Disc, User, Trash2, Loader2, Download, CheckCircle2 } from 'lucide-react';
import { getHighResThumb } from '../utils';
import { downloadSong, isDownloaded } from '../utils/downloadManager';
import { useAuth } from '../context/AuthContext';
import AddToPlaylistModal from './AddToPlaylistModal';
import './SongActionMenu.css';

const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export default function SongActionMenu({ song, onAction, showRemove = false, onClose, contextPlaylist = null }) {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [loadingAction, setLoadingAction] = useState(null);
  const [downloadState, setDownloadState] = useState('idle'); // 'idle' | 'checking' | 'already' | 'downloading' | 'done' | 'error'
  const [showPlaylistModal, setShowPlaylistModal] = useState(false);

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

    // Delegate queue/remove back to parent
    if (action === 'QUEUE' || action === 'REMOVE') {
      onAction?.(action, song);
      if (onClose) onClose();
      return;
    }

    // 'PLAYLIST' is handled internally — open the modal
    if (action === 'PLAYLIST') {
      setShowPlaylistModal(true);
      return;
    }

    // ── DOWNLOAD ─────────────────────────────────────────────────────────────
    if (action === 'DOWNLOAD') {
      const videoId = song?.videoId || song?.id;
      const alreadyDone = await isDownloaded(videoId);
      if (alreadyDone) { setDownloadState('already'); return; }
      setDownloadState('downloading');
      try {
        const authToken = user ? await user.getIdToken() : '';
        await downloadSong(song, contextPlaylist, authToken);
        setDownloadState('done');
        onAction?.('DOWNLOAD', song);
        setTimeout(() => { if (onClose) onClose(); }, 900);
      } catch (err) {
        console.error('Download failed:', err);
        setDownloadState('error');
        setTimeout(() => setDownloadState('idle'), 2000);
      }
      return;
    }

    // ── ALBUM ─────────────────────────────────────────────────────────────────
    if (action === 'ALBUM') {
      setLoadingAction('ALBUM');
      // 1. Check cached album browse ID — must start with MPRE (YouTube Music album)
      const cachedId = [song.albumBrowseId, song.albumId, song.album?.browseId, song.album?.id]
        .find(id => id && String(id).startsWith('MPRE'));
      if (cachedId) {
        navigate(`/playlist/${cachedId}`);
        setLoadingAction(null);
        if (onClose) onClose();
        return;
      }
      // 2. Search using "album <title> <artist>" — much more specific than just the title.
      //    Prefix "album" biases YouTube Music search toward album results, not playlists.
      const albumName = song.album || song.title || '';
      const artist = song.artist || '';
      if (!albumName) {
        navigate(`/search?q=${encodeURIComponent(song.title || '')}`);
        setLoadingAction(null);
        if (onClose) onClose();
        return;
      }
      try {
        // Try with full "album title artist" first, then fallback to title only
        let bid = null;
        const queries = [
          `album ${albumName} ${artist}`.trim(),
          albumName,
        ];
        for (const q of queries) {
          const r = await fetch(`${API}/api/album-search?q=${encodeURIComponent(q)}`);
          const json = await r.json();
          const candidate = json?.data?.browseId;
          if (candidate?.startsWith('MPRE')) { bid = candidate; break; }
        }
        if (bid) {
          navigate(`/playlist/${bid}`);
        } else {
          // No album found — search so user can pick manually
          navigate(`/search?q=${encodeURIComponent(`${albumName} ${artist}`.trim())}`);
        }
      } catch {
        navigate(`/search?q=${encodeURIComponent(albumName)}`);
      }
      setLoadingAction(null);
      if (onClose) onClose();
      return;
    }

    // ── ARTIST ────────────────────────────────────────────────────────────────
    if (action === 'ARTIST') {
      setLoadingAction('ARTIST');
      const artistId = song.artistBrowseId || (song.browseId?.startsWith('UC') || song.browseId?.startsWith('AC') ? song.browseId : null);
      if (artistId) {
        navigate(`/artist/${artistId}`);
        if (onClose) onClose();
        return;
      }
      const artistName = song.artist || song.title;
      try {
        const r = await fetch(`${API}/api/artist-resolve?name=${encodeURIComponent(artistName)}`);
        const json = await r.json();
        const bid = json?.data?.browseId;
        if (bid) navigate(`/artist/${bid}`);
        else navigate(`/search?q=${encodeURIComponent(artistName)}`);
      } catch {
        navigate(`/search?q=${encodeURIComponent(artistName)}`);
      }
      if (onClose) onClose();
      return;
    }
  };

  const thumb = getHighResThumb(song?.thumbnail || song?.cover || song?.artworkUrl || '', 200);

  return (
    <>
      <div className="pam-sheet" onClick={e => e.stopPropagation()}>
        <div className="pam-track-info">
          <div className="pam-thumb-wrap">
            {thumb && (
              <img src={thumb} alt="" onError={e => { e.target.style.display = 'none'; }} />
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

      {/* Add-to-playlist modal — sibling to the sheet so it's not clipped */}
      {showPlaylistModal && (
        <AddToPlaylistModal
          song={song}
          onClose={() => {
            setShowPlaylistModal(false);
            if (onClose) onClose();
          }}
        />
      )}
    </>
  );
}
