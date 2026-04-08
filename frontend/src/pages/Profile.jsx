import React, { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useAudio } from '../context/AudioContext';
import { LogOut, User as UserIcon, Camera, Loader2, Clock, PlayCircle, Mic2, TrendingUp, Headphones } from 'lucide-react';
import { getHighResThumb } from '../utils';
import './Profile.css';

const API = 'http://localhost:5000';

export default function Profile() {
  const navigate = useNavigate();
  const { playSong } = useAudio();
  const { user, updateUserProfile, uploadProfilePhoto, logout } = useAuth();

  const [isEditing, setIsEditing] = useState(false);
  const [tempName, setTempName] = useState('');
  const [isSaving, setIsSaving] = useState(false);
  const [isUploading, setIsUploading] = useState(false);
  const [activeTimeframe, setActiveTimeframe] = useState('month');

  // Stats States
  const [summary, setSummary] = useState({ totalMs: 0, totalPlays: 0 });
  const [dailyAvgMinutes, setDailyAvgMinutes] = useState(0);
  const [lifetimeMs, setLifetimeMs] = useState(0);
  const [topSongs, setTopSongs] = useState([]);
  const [topArtists, setTopArtists] = useState([]);
  const [dailyHistory, setDailyHistory] = useState([]);

  const fileInputRef = useRef(null);

  // Sync temp name when user data arrives
  useEffect(() => {
    if (user?.displayName) setTempName(user.displayName);
  }, [user]);

  // EFFECT: Fetch lifetime stats once
  useEffect(() => {
    if (!user) return;
    let isMounted = true;
    const fetchLifetime = async () => {
      try {
        const token = await user.getIdToken();
        const headers = { Authorization: `Bearer ${token}` };
        const res = await fetch(`${API}/stats/listening?period=lifetime`, { headers });
        const data = await res.json();
        if (isMounted && data.success && data.data) {
          setLifetimeMs((data.data.totalSeconds || 0) * 1000);
        }
      } catch { }
    };
    fetchLifetime();
    return () => { isMounted = false; };
  }, [user]);

  // EFFECT: Fetch stats via backend API (re-fetch when timeframe changes)
  useEffect(() => {
    if (!user) return;
    let isMounted = true;

    const fetchStats = async () => {
      try {
        const token = await user.getIdToken();
        const headers = { Authorization: `Bearer ${token}` };
        const period = activeTimeframe === 'day' ? 'day'
          : activeTimeframe === 'week' ? 'week'
            : activeTimeframe === 'month' ? 'month' : 'year';

        const [listenRes, songsRes, artistsRes] = await Promise.all([
          fetch(`${API}/stats/listening?period=${period}`, { headers }),
          fetch(`${API}/stats/top-songs?limit=15`, { headers }),
          fetch(`${API}/stats/top-artists?limit=10`, { headers })
        ]);

        const listenData = await listenRes.json();
        const songsData = await songsRes.json();
        const artistsData = await artistsRes.json();

        if (isMounted) {
          if (listenData.success && listenData.data) {
            const d = listenData.data || {};
            const totalMs = (d.totalSeconds || 0) * 1000;
            const history = (d.days || []).map(row => ({
              date: row.date,
              ms: (row.totalSeconds || 0) * 1000
            }));
            setSummary({ totalMs, totalPlays: 0 });
            setDailyAvgMinutes(d.dailyAverageMinutes || 0);
            setDailyHistory(history);
          }

          if (songsData && songsData.success) {
            let songs = Array.isArray(songsData.data) ? songsData.data : [];
            // Rank by playCount descending (most repeated first)
            songs = [...songs].sort((a, b) => (b.playCount || 0) - (a.playCount || 0)).slice(0, 10);

            // Enrichment for missing art
            if (songs.some(s => !s.thumbnail && !s.cover)) {
              const enriched = await Promise.allSettled(
                songs.map(async (s) => {
                  if (s.thumbnail || s.cover) return s;
                  try {
                    const searchRes = await fetch(`${API}/api/search?q=${encodeURIComponent(s.title + ' ' + s.artist)}&type=songs`, { headers });
                    const searchJson = await searchRes.json();
                    const firstMatch = searchJson?.data?.[0];
                    if (firstMatch) {
                      return { ...s, thumbnail: firstMatch.thumbnail, cover: firstMatch.thumbnail };
                    }
                    return s;
                  } catch (err) { return s; }
                })
              );
              songs = enriched.map(res => res.status === 'fulfilled' ? res.value : res.reason);
            }
            if (isMounted) setTopSongs(songs);
          }

          if (artistsData && artistsData.success) {
            let artists = Array.isArray(artistsData.data) ? artistsData.data : [];
            // Enrich artist photos — ALWAYS fetch proper artist photo (not using cover from stats
            // which may be a song cover). Use localStorage cache to avoid 429 rate limits.
            const enrichedArtists = [];
            for (let i = 0; i < artists.length; i++) {
              const a = artists[i];
              const name = a.artist || a.name || '';

              // Skip if name is invalid or 'Unknown'
              if (!name || name === 'Unknown') {
                enrichedArtists.push(a);
                continue;
              }

              // Check localStorage cache first (persistent cache)
              const cacheKey = `pulse_artist_v4_${name.toLowerCase().replace(/\s+/g, '_')}`;
              const cached = localStorage.getItem(cacheKey);
              if (cached) {
                enrichedArtists.push({ ...a, thumbnail: cached, cover: cached });
                continue;
              }

              // Stagger calls 650ms apart to be very safe against 429
              await new Promise(r => setTimeout(r, i === 0 ? 0 : 650));
              try {
                // 1. Resolve artist name to browseId
                const resolveRes = await fetch(`${API}/api/artist-resolve?name=${encodeURIComponent(name)}`);
                if (!resolveRes.ok && resolveRes.status === 429) {
                  console.warn('Artist search rate limited (429)');
                  for (let j = i; j < artists.length; j++) enrichedArtists.push(artists[j]);
                  break;
                }
                const resolveJson = await resolveRes.json();
                const bid = resolveJson?.data?.browseId;
                
                if (bid) {
                  // 2. Fetch the actual high-res artist info
                  const artistRes = await fetch(`${API}/api/artist/${bid}`);
                  const artistJson = await artistRes.json();
                  const trueThumb = artistJson?.data?.thumbnail;
                  
                  if (trueThumb) {
                    localStorage.setItem(cacheKey, trueThumb);
                    enrichedArtists.push({ ...a, thumbnail: trueThumb, cover: trueThumb });
                    continue;
                  }
                }
                enrichedArtists.push(a);
              } catch { enrichedArtists.push(a); }
            }
            if (isMounted) setTopArtists(enrichedArtists);
          }
        }
      } catch (err) {
        console.error('Failed to load profile stats:', err);
      }
    };

    fetchStats();
    return () => { isMounted = false; };
  }, [user, activeTimeframe]);

  const handleSaveName = async () => {
    if (!tempName.trim()) return;
    setIsSaving(true);
    try {
      await updateUserProfile({ displayName: tempName });
      setIsEditing(false);
    } catch (err) {
      console.error(err);
    } finally {
      setIsSaving(false);
    }
  };

  const handlePhotoUpload = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setIsUploading(true);
    try {
      await uploadProfilePhoto(file);
    } catch (err) {
      console.error(err);
    } finally {
      setIsUploading(false);
    }
  };

  const formatTime = (ms) => {
    if (!ms || isNaN(ms)) return "0m";
    const minutes = Math.floor(ms / 60000);
    const hours = Math.floor(minutes / 60);
    if (hours > 0) return `${hours}h ${minutes % 60}m`;
    return `${minutes}m`;
  };

  const initials = user?.displayName?.split(' ').map(n => n[0]).join('').toUpperCase() || 'P';

  return (
    <div className="profile-container">
      <header className="profile-header">
        <div className="profile-avatar-large glass">
          {user?.photoURL ? <img src={user.photoURL} alt="" loading="lazy" /> : <span>{initials}</span>}
        </div>
        <h1 className="profile-name">{user?.displayName || 'Pulse User'}</h1>
        <p className="profile-email">{user?.email}</p>
      </header>

      {/* STATS DASHBOARD */}
      <section className="stats-dashboard">
        <div className="timeframe-picker glass">
          <button className={activeTimeframe === 'day' ? 'active' : ''} onClick={() => setActiveTimeframe('day')}>Day</button>
          <button className={activeTimeframe === 'week' ? 'active' : ''} onClick={() => setActiveTimeframe('week')}>Week</button>
          <button className={activeTimeframe === 'month' ? 'active' : ''} onClick={() => setActiveTimeframe('month')}>Month</button>
          <button className={activeTimeframe === 'year' ? 'active' : ''} onClick={() => setActiveTimeframe('year')}>Year</button>
        </div>

        <div className="main-stats-row">
          <div className="stat-card-large glass">
            <span className="stat-label"><Clock size={16} /> LISTENING TIME</span>
            <div className="stat-value">{formatTime(summary.totalMs)}</div>
            <p className="stat-sub">{activeTimeframe === 'day' ? 'Today' : activeTimeframe === 'week' ? 'This week' : activeTimeframe === 'month' ? 'This month' : 'This year'}</p>
          </div>
          <div className="stat-card-small glass">
            <span className="stat-label"><TrendingUp size={16} /> DAILY AVG</span>
            <div className="stat-value-mid">{dailyAvgMinutes > 0 ? `${dailyAvgMinutes}m` : '—'}</div>
            <p className="stat-sub">Per day</p>
          </div>
        </div>

        {/* Lifetime Listening Block */}
        <div className="lifetime-stats-row">
          <div className="stat-card-wide glass">
            <span className="stat-label"><Headphones size={16} /> LIFETIME LISTENING</span>
            <div className="stat-value">{formatTime(lifetimeMs)}</div>
            <p className="stat-sub">Total time listened to music on Pulse</p>
          </div>
        </div>
      </section>

      <div className="dashboard-lists">
        <section className="top-list-section">
          <h3><PlayCircle size={18} style={{ opacity: 0.9 }} /> Your Top Songs</h3>
          <div className="horizontal-scroll">
            {topSongs.slice(0, 10).map((s, i) => (
              <div key={s.videoId || i} className="top-song-card glass hover-scale"
                onClick={() => {
                  const thumb = s.thumbnail || s.cover || '';
                  playSong({ ...s, id: s.videoId, thumbnail: thumb, cover: thumb });
                }}
              >
                <div className="rank">#{i + 1}</div>
                <div className="top-song-art-wrap">
                  <img
                    src={getHighResThumb(s.thumbnail || s.cover, 200)}
                    alt=""
                    loading="lazy"
                    decoding="async"
                    onError={e => { e.target.style.src = 'https://via.placeholder.com/200?text=No+Art'; }}
                  />
                </div>
                <div className="song-meta">
                  <h4>{s.title}</h4>
                  <p>{s.artist}</p>
                  <span className="plays">{s.playCount || 0} plays</span>
                </div>
              </div>
            ))}
            {topSongs.length === 0 && <p className="empty-msg">Listening history will appear here.</p>}
          </div>
        </section>

        <section className="top-list-section">
          <h3><Mic2 size={18} style={{ opacity: 0.9 }} /> Your Top Artists</h3>
          <div className="horizontal-scroll">
            {topArtists.slice(0, 10).map((a, i) => {
              const displayName = a.artist || a.name || 'Unknown';
              const artistInitials = displayName[0]?.toUpperCase() || '?';
              const thumb = a.thumbnail || a.cover;
              return (
                <div key={i} className="artist-card glass hover-scale"
                  onClick={() => {
                    fetch(`${API}/api/artist-resolve?name=${encodeURIComponent(displayName)}`)
                      .then(r => r.json())
                      .then(json => {
                        const bid = json?.data?.browseId;
                        if (bid) navigate(`/artist/${bid}`);
                      })
                      .catch(() => { });
                  }}
                >
                  <div className="rank">#{i + 1}</div>
                  <div className="artist-avatar-square">
                    {thumb
                      ? <img
                        src={getHighResThumb(thumb, 400)}
                        alt=""
                        loading="lazy"
                        decoding="async"
                        onError={e => { e.target.style.display = 'none'; }}
                      />
                      : <span>{artistInitials}</span>
                    }
                  </div>
                  <div className="artist-meta">
                    <h4>{displayName}</h4>
                    <p>{formatTime((a.totalSeconds || 0) * 1000)}</p>
                  </div>
                </div>
              );
            })}
            {topArtists.length === 0 && <p className="empty-msg">Your favorite artists will appear here.</p>}
          </div>
        </section>
      </div>

      <div className="profile-menu">
        <button className="profile-menu-item glass hover-scale" onClick={() => setIsEditing(true)}>
          <UserIcon size={18} />
          <span>Edit Profile</span>
        </button>
        <button className="profile-menu-item logout-btn glass" onClick={logout}><LogOut size={18} /><span>Sign Out</span></button>
      </div>

      {isEditing && (
        <div className="modal-overlay" onClick={() => !isSaving && !isUploading && setIsEditing(false)}>
          <div className="edit-profile-card glass" onClick={e => e.stopPropagation()}>
            <header className="edit-modal-header">
              <h2>Edit Profile</h2>
            </header>

            <div className="edit-avatar-section">
              <div className="profile-avatar-large edit-mode glass" onClick={() => fileInputRef.current?.click()}>
                {isUploading ? <Loader2 className="animate-spin" /> : user?.photoURL ? <img src={user.photoURL} alt="" /> : <span>{initials}</span>}
                <div className="camera-overlay"><Camera size={24} /></div>
              </div>
              <input type="file" ref={fileInputRef} onChange={handlePhotoUpload} style={{ display: 'none' }} />
            </div>

            <div className="edit-form-field">
              <label>DISPLAY NAME</label>
              <input
                type="text"
                value={tempName}
                onChange={(e) => setTempName(e.target.value)}
                className="glass"
                placeholder="Your Name"
                disabled={isSaving}
              />
            </div>

            <div className="edit-modal-actions">
              <button className="save-btn glass" onClick={handleSaveName} disabled={isSaving}>
                {isSaving ? <Loader2 className="animate-spin" size={16} /> : 'Save Changes'}
              </button>
              <button className="cancel-pill glass" onClick={() => setIsEditing(false)} disabled={isSaving || isUploading}>
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      <footer className="brand-footer">
        <div className="footer-logo-wrap">
          <img src="/logo.png" alt="Pulse" className="brand-footer-logo" />
        </div>
        <h2>Pulse</h2>
        <p>Version 1.0.0</p>
        <p className="made-by">
          Made with ❤️ by <a href="https://itsashutoshpathak.vercel.app/" target="_blank" rel="noopener noreferrer">
            Ashutosh Pathak
          </a>
        </p>
      </footer>
    </div>
  );
}
