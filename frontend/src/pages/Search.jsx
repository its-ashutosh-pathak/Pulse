import React, { useState, useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import {
  Search as SearchIcon, X, MoreVertical, Music,
  Check, ArrowRight, Play, Disc, Radio
} from 'lucide-react';
import { usePlaylists } from '../context/PlaylistContext';
import { useAudio } from '../context/AudioContext';
import { getHighResThumb } from '../utils';
import SongActionMenu from '../components/SongActionMenu';
import AddToPlaylistModal from '../components/AddToPlaylistModal';
import DownloadOverlay from '../components/DownloadOverlay';
import './Search.css';

const API = 'http://localhost:5000';

const getThumb = (item, size = 200) =>
  getHighResThumb(item?.thumbnail || item?.cover || item?.artworkUrl || '', size);

export default function Search() {
  const { playlists, addSongToPlaylist } = usePlaylists();
  const { playSong, currentSong, addToQueue } = useAudio();
  const navigate = useNavigate();
  const location = useLocation();

  const [query, setQuery]               = useState('');
  const [results, setResults]           = useState({ songs: [], albums: [], playlists: [], artists: [] });
  const [isSearching, setIsSearching]   = useState(false);
  const [history, setHistory]           = useState(() => JSON.parse(localStorage.getItem('pulse_search_history') || '[]'));
  const [suggestions, setSuggestions]   = useState([]);
  const [showSugg, setShowSugg]         = useState(false);
  const [activeMenuId, setActiveMenuId] = useState(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [selectedSong, setSelectedSong] = useState(null);
  const [addedStatus, setAddedStatus]   = useState(null);
  const inputRef = useRef(null);

  // Sync URL query param
  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const q = params.get('q');
    if (q) setQuery(q);
  }, [location.search]);

  useEffect(() => {
    localStorage.setItem('pulse_search_history', JSON.stringify(history));
  }, [history]);

  // Close menus on outside click
  useEffect(() => {
    const close = () => setActiveMenuId(null);
    window.addEventListener('click', close);
    return () => window.removeEventListener('click', close);
  }, []);

  // Suggestions + Debounced search
  useEffect(() => {
    if (!query.trim()) {
      setResults({ songs: [], albums: [], playlists: [], artists: [] });
      setSuggestions([]);
      setIsSearching(false);
      return;
    }

    setIsSearching(true);
    setShowSugg(true);

    const suggTimer = setTimeout(() => {
      fetch(`${API}/api/suggestions?q=${encodeURIComponent(query)}`)
        .then(r => r.json())
        .then(json => setSuggestions(json?.success && Array.isArray(json.data) ? json.data.slice(0, 8) : []))
        .catch(() => setSuggestions([]));
    }, 200);

    const timer = setTimeout(async () => {
      try {
        setShowSugg(false);
        const res  = await fetch(`${API}/api/search?q=${encodeURIComponent(query)}&type=all`);
        const json = await res.json();
        const data = json.data || {};
        setResults({
          songs:     Array.isArray(data.songs)     ? data.songs     : [],
          albums:    Array.isArray(data.albums)    ? data.albums    : [],
          playlists: Array.isArray(data.playlists) ? data.playlists : [],
          artists:   Array.isArray(data.artists)   ? data.artists   : [],
        });
      } catch {
        setResults({ songs: [], albums: [], playlists: [], artists: [] });
      } finally {
        setIsSearching(false);
      }
    }, 550);

    return () => { clearTimeout(timer); clearTimeout(suggTimer); };
  }, [query]);

  const hasResults = results.songs.length + results.albums.length + results.playlists.length + results.artists.length > 0;
  const topResult  = results.songs[0] || results.albums[0] || results.playlists[0] || null;

  // ── Play handler ──────────────────────────────────────────────────────────
  const handlePlay = (item) => {
    if (!item) return;
    const type = item.type || '';
    if (['PLAYLIST','ALBUM','YTM_PLAYLIST','YTM_ALBUM'].includes(type)) {
      const cid = item.browseId || item.id;
      if (cid) navigate(`/playlist/${cid}`);
      return;
    }
    if (type === 'ARTIST') {
      const aid = item.browseId || item.id;
      if (aid) navigate(`/artist/${aid}`);
      return;
    }
    const vid = item.videoId || item.id || '';
    if (vid.length === 11) {
      playSong(item);
      setHistory(prev => [item, ...prev.filter(s => (s.videoId || s.id) !== vid)].slice(0, 10));
    } else if (item.browseId) {
      navigate(`/playlist/${item.browseId}`);
    }
  };

  // ── Unified action dispatcher (used by SongActionMenu) ────────────────────
  const handleAction = (action, song) => {
    setActiveMenuId(null);

    if (action === 'QUEUE') {
      addToQueue(song);
      return;
    }
    if (action === 'PLAYLIST') {
      setSelectedSong(song);
      setShowAddModal(true);
      setAddedStatus(null);
      return;
    }
    if (action === 'ALBUM') {
      const albumId = song.albumBrowseId || song.albumId; // strictly look for album IDs
      if (albumId && albumId.length > 11) { navigate(`/playlist/${albumId}`); return; }
      if (song.album) setQuery(song.album);
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
          else setQuery(artistName);
        })
        .catch(() => setQuery(artistName));
    }
  };

  const toggleMenu = (e, id) => { e.stopPropagation(); setActiveMenuId(activeMenuId === id ? null : id); };

  const handleAddToPlaylist = async (playlistId) => {
    if (!selectedSong) return;
    await addSongToPlaylist(playlistId, selectedSong);
    setAddedStatus(playlistId);
    setTimeout(() => { setShowAddModal(false); setSelectedSong(null); setAddedStatus(null); }, 1200);
  };

  return (
    <div className="search-container">

      {/* ── Search Bar ── */}
      <header className="search-header">
        <div className="search-bar-wrapper glass" style={{ position: 'relative' }}>
          <SearchIcon size={18} className="search-icon-dim" />
          <input
            ref={inputRef}
            type="text"
            placeholder="Songs, artists, albums, playlists…"
            value={query}
            onChange={e => { setQuery(e.target.value); setShowSugg(true); }}
            onFocus={() => query && setShowSugg(true)}
            autoFocus
          />
          {query && <X size={18} className="clear-icon" onClick={() => { setQuery(''); setSuggestions([]); }} />}
        </div>

        {/* Suggestions dropdown */}
        {showSugg && suggestions.length > 0 && query && (
          <div className="suggestions-dropdown glass">
            {suggestions.map((s, i) => (
              <button key={i} className="suggestion-item"
                onClick={() => { setQuery(s); setSuggestions([]); setShowSugg(false); }}>
                <SearchIcon size={14} className="sugg-icon" />
                <span>{s}</span>
              </button>
            ))}
          </div>
        )}
      </header>

      <div className="search-content">

        {/* ── NO QUERY: Recent Searches ── */}
        {!query && (
          <div className="recent-searches">
            <div className="history-header">
              <h3>Recent Searches</h3>
              {history.length > 0 && <button onClick={() => setHistory([])}>Clear all</button>}
            </div>
            {history.length > 0 ? history.map((song, i) => (
              <div key={i}
                className={`history-row ${currentSong?.id === (song.videoId || song.id) ? 'now-playing' : ''}`}
                onClick={() => handlePlay(song)}>
                <div className="history-thumb-wrap">
                  <img 
                    src={getThumb(song)} 
                    alt="" 
                    className="history-thumb"
                    loading="lazy"
                    decoding="async"
                    onError={e => { e.target.style.display = 'none'; }} 
                  />
                  <DownloadOverlay videoId={song.videoId || song.id} />
                  {currentSong?.id === (song.videoId || song.id) && (
                    <div className="playing-overlay"><div className="playing-bars"><span/><span/><span/></div></div>
                  )}
                </div>
                <div className="history-info">
                  <p className={currentSong?.id === (song.videoId || song.id) ? 'accent' : ''}>{song.title}</p>
                  <span>{song.artist}</span>
                </div>
                <div className="action-wrapper" style={{ position: 'relative' }}>
                  <button className="action-menu-trigger" onClick={e => toggleMenu(e, `h-${i}`)}>
                    <MoreVertical size={18} />
                  </button>
                  {activeMenuId === `h-${i}` && (
                    <SongActionMenu song={song} onAction={handleAction} onClose={() => setActiveMenuId(null)} />
                  )}
                </div>
              </div>
            )) : (
              <div className="search-empty-state">
                <SearchIcon size={36} strokeWidth={1.5} />
                <p>Your recent searches appear here</p>
              </div>
            )}
          </div>
        )}

        {/* ── LOADING skeletons ── */}
        {query && isSearching && (
          <div className="search-skeletons">
            {[1,2,3,4,5,6].map(i => (
              <div key={i} className="skeleton-song-row">
                <div className="skeleton skeleton-sq" />
                <div className="skeleton-lines">
                  <div className="skeleton skeleton-ln-lg" />
                  <div className="skeleton skeleton-ln-sm" />
                </div>
              </div>
            ))}
          </div>
        )}

        {/* ── RESULTS ── */}
        {query && !isSearching && hasResults && (
          <div className="ytm-results">

            {/* Top Result */}
            {topResult && (
              <section className="ytm-section">
                <h2 className="ytm-label">Top result</h2>
                <div className="top-result-card glass">
                  <img 
                    src={getThumb(topResult, 800)} 
                    alt="" 
                    className="top-result-art"
                    loading="lazy"
                    decoding="async"
                    onError={e => { e.target.style.display = 'none'; }} 
                  />
                  <div className="top-result-body">
                    <div className="top-result-text" onClick={() => handlePlay(topResult)} style={{ cursor: 'pointer' }}>
                      <h3>{topResult.title}</h3>
                      <p>{topResult.artist}{topResult.album ? ` · ${topResult.album}` : ''}</p>
                    </div>
                    <button className="top-result-play hover-scale"
                      onClick={e => { e.stopPropagation(); handlePlay(topResult); }}>
                      <Play size={20} fill="currentColor" />
                    </button>
                  </div>
                </div>
              </section>
            )}

            {/* Songs */}
            {results.songs.length > 0 && (
              <section className="ytm-section">
                <h2 className="ytm-label">Songs</h2>
                <div className="ytm-songs">
                  {results.songs.map((song, i) => (
                    <div key={`${song.id}-${i}`}
                      className={`ytm-song-row ${currentSong?.id === (song.videoId || song.id) ? 'now-playing' : ''}`}
                      onClick={() => handlePlay(song)}>
                      <div className="ytm-song-left">
                        <div className="ytm-thumb-wrap">
                          <img 
                            src={getThumb(song)} 
                            alt=""
                            loading="lazy"
                            decoding="async"
                            onError={e => { e.target.style.display = 'none'; }} 
                          />
                          <DownloadOverlay videoId={song.videoId || song.id} />
                          {currentSong?.id === (song.videoId || song.id) && (
                            <div className="playing-overlay"><div className="playing-bars"><span/><span/><span/></div></div>
                          )}
                        </div>
                        <div className="ytm-song-meta">
                          <p className={`ytm-song-title ${currentSong?.id === (song.videoId || song.id) ? 'accent' : ''}`}>{song.title}</p>
                          <p className="ytm-song-artist">{song.artist}</p>
                        </div>
                      </div>
                      <div className="action-wrapper" style={{ position: 'relative' }}>
                        <button className="action-menu-trigger" onClick={e => toggleMenu(e, `s-${song.id}-${i}`)}>
                          <MoreVertical size={18} />
                        </button>
                        {activeMenuId === `s-${song.id}-${i}` && (
                          <SongActionMenu song={song} onAction={handleAction} onClose={() => setActiveMenuId(null)} />
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </section>
            )}

            {/* Artists */}
            {results.artists.length > 0 && (
              <section className="ytm-section">
                <h2 className="ytm-label">Artists</h2>
                <div className="ytm-artists-scroll">
                  {results.artists.map((artist, i) => {
                    const artistId = artist.browseId || artist.id;
                    const artistName = artist.title || artist.name || 'Artist';
                    return (
                      <div key={i} className="ytm-artist-chip hover-scale"
                        onClick={() => artistId && navigate(`/artist/${artistId}`)}>
                        <div className="ytm-artist-avatar">
                          {getThumb(artist, 400) && (
                            <img 
                              src={getThumb(artist, 400)} 
                              alt=""
                              loading="lazy"
                              decoding="async"
                              onError={e => { e.target.style.display = 'none'; }} 
                            />
                          )}
                          <span>{artistName[0]?.toUpperCase()}</span>
                        </div>
                        <p>{artistName}</p>
                        <span>Artist</span>
                      </div>
                    );
                  })}
                </div>
              </section>
            )}

            {/* Albums */}
            {results.albums.length > 0 && (
              <section className="ytm-section">
                <h2 className="ytm-label">Albums</h2>
                <div className="sr-grid-scroll">
                  {results.albums.map((album, i) => (
                    <div key={i} className="sr-collection-card hover-scale"
                      onClick={() => navigate(`/playlist/${album.browseId || album.id}`)}>
                      <div className="sr-collection-art">
                        <img src={getThumb(album, 400)} alt=""
                          onError={e => { e.target.style.display = 'none'; }} />
                        <div className="sr-collection-overlay"><Disc size={20} /></div>
                      </div>
                      <p className="sr-collection-title">{album.title}</p>
                      <span className="sr-collection-sub">{album.artist}{album.year ? ` · ${album.year}` : ''}</span>
                    </div>
                  ))}
                </div>
              </section>
            )}

            {/* Playlists */}
            {results.playlists.length > 0 && (
              <section className="ytm-section">
                <h2 className="ytm-label">Playlists</h2>
                <div className="sr-grid-scroll">
                  {results.playlists.map((pl, i) => (
                    <div key={i} className="sr-collection-card hover-scale"
                      onClick={() => navigate(`/playlist/${pl.browseId || pl.id}`)}>
                      <div className="sr-collection-art">
                        <img 
                          src={getThumb(pl, 400)} 
                          alt=""
                          loading="lazy"
                          decoding="async"
                          onError={e => { e.target.style.display = 'none'; }} 
                        />
                        <div className="sr-collection-overlay"><Radio size={20} /></div>
                      </div>
                      <p className="sr-collection-title">{pl.title}</p>
                      <span className="sr-collection-sub">{pl.artist || pl.itemCount || ''}</span>
                    </div>
                  ))}
                </div>
              </section>
            )}

          </div>
        )}

        {/* ── NO RESULTS ── */}
        {query && !isSearching && !hasResults && (
          <div className="search-empty-state">
            <Music size={36} strokeWidth={1.5} />
            <p>No results for "{query}"</p>
            <span>Try different keywords</span>
          </div>
        )}
      </div>

      {/* ── Add to Playlist Modal ── */}
      {showAddModal && selectedSong && (
        <AddToPlaylistModal song={selectedSong} onClose={() => setShowAddModal(false)} />
      )}
    </div>
  );
}
