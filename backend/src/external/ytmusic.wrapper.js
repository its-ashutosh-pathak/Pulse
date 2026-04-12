/**
 * ytmusic.wrapper.js — Pure JavaScript YouTube Music metadata engine.
 * Replaces the Python Flask sidecar (pulse_api.py) entirely.
 *
 * Uses youtubei.js (already a project dependency) to talk directly to
 * the YouTube Music InnerTube API. No Python required.
 *
 * Covers all endpoints the Python sidecar previously handled:
 *   getHome()             - Home feed sections
 *   search(q, type)       - Songs, albums, playlists, artists (or all at once)
 *   getSuggestions(q)     - Search autocomplete
 *   getArtist(browseId)   - Artist page (top songs, albums, singles)
 *   getPlaylist(id)       - Playlist or Album by ID
 *   getWatchNext(videoId) - Radio / related tracks queue
 *   getLyrics(videoId)    - YTMusic built-in lyrics (synced)
 *   resolve(id)           - Resolve a radioId/playlistId to a videoId
 */

const { getInstance } = require('./innertube.singleton');
const logger = require('../utils/logger');
const { validateTrack, validateBatch } = require('../utils/schemaValidator');

// ── Thumbnail helpers ─────────────────────────────────────────────────────────

function extractBestThumb(src) {
  if (!src) return '';

  let candidates = [];

  if (Array.isArray(src)) {
    candidates = src;
  } else if (typeof src === 'object' && Array.isArray(src.contents)) {
    candidates = src.contents;
  } else if (typeof src === 'object' && src.url) {
    return String(src.url).replace('http://', 'https://');
  } else if (typeof src === 'string' && src.startsWith('http')) {
    return src.replace('http://', 'https://');
  }

  if (!candidates.length) return '';

  // Prefer square thumbnails at highest resolution
  const squares = candidates.filter(t => t?.width && t?.height && t.width === t.height);
  const pool = squares.length ? squares : candidates;

  // Pick the largest
  const best = pool.reduce((prev, curr) => {
    const prevSize = (prev?.width || 0) * (prev?.height || 0);
    const currSize = (curr?.width || 0) * (curr?.height || 0);
    return currSize > prevSize ? curr : prev;
  }, pool[0]);

  return String(best?.url || candidates[candidates.length - 1]?.url || '').replace('http://', 'https://');
}

// Legacy alias used internally
const extractThumb = extractBestThumb;

/**
 * Try multiple paths to find a thumbnail on an item.
 */
function getThumb(item) {
  if (!item) return '';
  return (
    extractBestThumb(item.thumbnail) ||
    extractBestThumb(item.thumbnails) ||
    extractBestThumb(item.header?.thumbnail) ||
    extractBestThumb(item.header?.thumbnails) ||
    ''
  );
}


// ── Artist text helpers ───────────────────────────────────────────────────────

function parseArtists(artists) {
  if (!artists) return 'Unknown';
  if (typeof artists === 'string') return artists;
  if (!Array.isArray(artists) || !artists.length) return 'Unknown';
  const first = artists[0];
  if (typeof first === 'string') return first;
  return String(first?.name || first?.text || 'Unknown');
}

// ── ID extraction ─────────────────────────────────────────────────────────────

function getVideoId(item) {
  return String(item?.id || item?.video_id || item?.videoId || '');
}

function getBrowseId(item) {
  // browseId, channel_id, etc.
  const id = item?.browseId || item?.browse_id || item?.channel_id || '';
  return String(id || '');
}

function getPlaylistId(item) {
  return String(item?.playlistId || item?.playlist_id || '');
}

// ── Type inference ────────────────────────────────────────────────────────────

function inferType(item) {
  const raw = String(item?.item_type || item?.type || item?.resultType || '').toLowerCase();
  if (raw.includes('album')) return 'ALBUM';
  if (raw.includes('playlist')) return 'PLAYLIST';
  if (raw.includes('artist')) return 'ARTIST';
  if (raw.includes('single')) return 'SINGLE';
  return 'SONG';
}

// ── Normalizers ───────────────────────────────────────────────────────────────

/**
 * Normalize any search/home item to Pulse's standard shape.
 */
function normItem(item) {
  if (!item) return null;

  // Skip dividers, ads, and unknown types
  const skip = String(item?.type || '').toLowerCase();
  if (skip.includes('divider') || skip.includes('ad')) return null;

  const videoId = getVideoId(item);
  const browseId = getBrowseId(item);

  // Primary id: prefer videoId (11 chars) then browseId
  const id = (videoId && videoId.length === 11) ? videoId : (browseId || videoId || '');
  if (!id) return null;

  const type = inferType(item);

  // ── Robust artist extraction ────────────────────────────────────────────────
  // Home feed items may carry artist info in many different fields depending on
  // the section type. Try each path in order of reliability.
  let artist = parseArtists(item.artists);
  if (!artist || artist === 'Unknown') {
    artist = String(item.author?.name || '');
  }
  if (!artist) {
    // Flex-column: second column usually holds "Artist • Album" or just "Artist"
    const col = item.flex_columns?.[1]?.title?.runs?.[0]?.text || '';
    if (col) artist = col;
  }
  if (!artist) {
    // subtitle runs are used in some card types
    const subRuns = item.subtitle?.runs || item.secondaryText?.runs || [];
    const artistRun = subRuns.find(r => r?.endpoint?.browseEndpoint || r?.text);
    if (artistRun?.text) artist = artistRun.text;
  }
  if (!artist) {
    // Last resort: flatten all subtitle runs text
    const subText = (item.subtitle?.text || item.secondaryText?.text || '').trim();
    if (subText) artist = subText.split('\u2022')[0].trim();
  }
  if (!artist) artist = 'Unknown';

  return {
    id,
    videoId,
    browseId,
    playlistId: getPlaylistId(item),
    albumBrowseId: String(
      item.album?.id || item.album?.browseId || item.album?.browse_id ||
      item.albumBrowseId || item.album_browse_id ||
      // Some items carry album endpoint in flex_columns
      item.flex_columns?.[2]?.title?.runs?.[0]?.endpoint?.browseEndpoint?.browseId ||
      ''
    ),
    artistBrowseId: String(item.artists?.[0]?.id || item.artists?.[0]?.browseId || ''),
    title: String(item.title || item.name || 'Unknown'),
    artist,
    album: String(item.album?.name || item.album || ''),
    thumbnail: getThumb(item),
    type,
    duration: item.duration?.seconds ?? (typeof item.duration === 'number' ? item.duration : 0),
    year: String(item.year || item.description || ''),
    itemCount: String(item.item_count || item.itemCount || ''),
  };
}

/**
 * Normalize a track inside a playlist or album.
 * Returns null for tracks without a videoId (e.g., unavailable tracks).
 */
function normTrack(track, albumTitle = '', albumThumb = '') {
  if (!track) return null;
  const videoId = getVideoId(track);
  if (!videoId || videoId.length !== 11) {
    // FIX #3: Log skipped tracks with diagnostic info instead of silent null
    logger.warn('norm_track_skip', {
      reason: 'invalid videoId',
      videoId: videoId || 'empty',
      hasTitle: Boolean(track.title || track.name),
      raw: JSON.stringify(track).slice(0, 200),
    });
    return null;
  }

  return {
    id: videoId,
    videoId,
    title: String(track.title || track.name || 'Unknown'),
    artist: parseArtists(track.artists) || 'Unknown',
    album: String(track.album?.name || albumTitle || ''),
    thumbnail: getThumb(track) || albumThumb,
    duration: track.duration?.seconds ?? (typeof track.duration === 'number' ? track.duration : 0),
    type: 'SONG',
  };
}

/**
 * Flatten section.contents | section.items into a flat array.
 * Handles nested shelves (some home-feed sections have sub-items).
 */
function flattenSection(section) {
  const raw = section?.contents || section?.items || [];
  const out = [];
  for (const item of raw) {
    // Shelf inside shelf — go one level deep
    if (item?.contents || item?.items) {
      out.push(...(item.contents || item.items || []));
    } else {
      out.push(item);
    }
  }
  return out;
}

/**
 * Flatten youtubei.js search result into a flat list of raw items.
 * Handles MusicShelf, ImmersiveCardShelf, and plain arrays.
 */
function flattenSearchResult(res) {
  const out = [];
  // Top-level may be an array or an object with .contents
  const top = Array.isArray(res) ? res : (res?.contents || res?.items || []);
  for (const node of top) {
    // MusicShelf wrapper
    if (node?.contents?.length) {
      out.push(...node.contents);
    } else if (node?.items?.length) {
      out.push(...node.items);
    } else if (node?.type && !String(node.type).toLowerCase().includes('shelf')) {
      // It's already a leaf item
      out.push(node);
    }
  }
  // If nothing unpacked, just return the raw top-level items as-is
  return out.length ? out : top;
}

/**
 * Normalize a MusicResponsiveListItem (playlist/song/artist from search) 
 * into Pulse's standard shape. These items have a different shape than home feed items.
 */
function normSearchItem(item) {
  if (!item) return null;
  const type = String(item.type || '').toLowerCase();
  if (type.includes('divider') || type.includes('ad') || type.includes('header')) return null;

  // Extract id — could be video_id (11 chars) or a playlist/browse id
  const videoId = String(item.id || item.video_id || item.videoId || '');
  const browseId = String(item.browseId || item.browse_id || '');
  const playlistId = String(item.playlistId || item.playlist_id || '');

  // At least one id must exist
  const id = videoId || browseId || playlistId;
  if (!id) return null;

  // Title: can be string or a Text object with .text
  const title = typeof item.title === 'string'
    ? item.title
    : (item.title?.text || item.name?.text || item.name || 'Unknown');

  // Artist: from flex columns or artists array
  let artist = 'Unknown';
  if (item.artists?.length) artist = parseArtists(item.artists);
  else if (item.author?.name) artist = item.author.name;
  else if (item.flex_columns?.length >= 2) {
    const col = item.flex_columns[1]?.title?.runs?.[0]?.text;
    if (col) artist = col;
  }

  const inferredType = (() => {
    if (videoId && videoId.length === 11) return 'SONG';
    if (browseId.startsWith('UC') || browseId.startsWith('AC')) return 'ARTIST';
    if (playlistId || browseId.startsWith('MPR') || id.startsWith('VLP')) return 'PLAYLIST';
    return 'SONG';
  })();

  return {
    id,
    videoId,
    browseId,
    playlistId,
    title: String(title),
    artist,
    album: '',
    thumbnail: getThumb(item),
    type: inferredType,
    duration: 0,
    year: '',
    itemCount: '',
  };
}

// ── Public API ────────────────────────────────────────────────────────────────

/**
 * Get YTMusic home feed sections.
 * Always returns at least 10 rows with up to 20 items each.
 * Organic home feed is supplemented with curated search-based sections.
 */
async function getHome() {
  const yt = await getInstance();
  const feed = await yt.music.getHomeFeed();

  const out = [];
  // ── Organic home feed ────────────────────────────────────────────────────────
  for (const section of (feed.sections || [])) {
    const title = String(section.header?.title || section.title || 'Recommended');
    const items = flattenSection(section).map(normItem).filter(Boolean).slice(0, 20);
    if (items.length) out.push({ title, items });
  }

  logger.info('ytmusic_home', { organicSections: out.length });

  // ── Always supplement to reach 10 rows ──────────────────────────────────────
  const supplementQueries = [
    { title: 'Global Top Playlists', q: 'top songs global', type: 'playlist' },
    { title: 'Bollywood Hits', q: 'bollywood hits 2024', type: 'playlist' },
    { title: 'Trending Now', q: 'trending music 2024', type: 'song' },
    { title: 'Popular Artists', q: 'popular artists india', type: 'artist' },
    { title: 'Pop Hits', q: 'pop music hits 2024', type: 'playlist' },
    { title: 'Chill Vibes', q: 'chill lofi vibes', type: 'playlist' },
    { title: 'Workout & Gym', q: 'workout gym hits', type: 'playlist' },
    { title: 'Romantic Tunes', q: 'romantic songs hindi', type: 'playlist' },
    { title: 'Party Bangers', q: 'party songs dance hits', type: 'playlist' },
    { title: 'Top Hip-Hop', q: 'hip hop rap 2024', type: 'playlist' },
  ];

  const needed = Math.max(0, 10 - out.length);
  if (needed > 0) {
    // Run all supplement searches in parallel
    const queriesToRun = supplementQueries.slice(0, Math.max(needed + 3, 8));
    const settled = await Promise.allSettled(
      queriesToRun.map(({ q }) => yt.music.search(q, { type: 'song' }))
    );

    for (let i = 0; i < settled.length && out.length < 10; i++) {
      if (settled[i].status !== 'fulfilled') {
        logger.warn('home_supplement_failed', { q: queriesToRun[i].q, reason: settled[i].reason?.message });
        continue;
      }
      const { title } = queriesToRun[i];
      const res = settled[i].value;

      // Try normItem first (organic shape), then normSearchItem (search shape)
      const raw = flattenSearchResult(res);
      let items = raw.map(normItem).filter(Boolean).slice(0, 20);
      if (!items.length) items = raw.map(normSearchItem).filter(Boolean).slice(0, 20);

      if (items.length >= 3) {
        out.push({ title, items });
        logger.info('home_supplement_added', { title, count: items.length });
      } else {
        logger.warn('home_supplement_empty', { title, rawCount: raw.length });
      }
    }
  }

  logger.info('ytmusic_home_final', { totalSections: out.length });

  // FIX #3: Validate output quality for monitoring
  for (const section of out) {
    validateBatch(section.items, `home:${section.title}`);
  }

  return out;
}

/**
 * Search YouTube Music.
 * type = 'songs' | 'albums' | 'playlists' | 'artists' | 'all'
 * When type='songs' returns flat array; when type='all' returns { songs, albums, playlists, artists }.
 */
async function search(q, type = 'songs') {
  const yt = await getInstance();

  if (type === 'all') {
    const [sRes, alRes, plRes, arRes] = await Promise.all([
      yt.music.search(q, { type: 'song' }).catch(() => null),
      yt.music.search(q, { type: 'album' }).catch(() => null),
      yt.music.search(q, { type: 'playlist' }).catch(() => null),
      yt.music.search(q, { type: 'artist' }).catch(() => null),
    ]);

    return {
      songs: extractSearchItems(sRes).slice(0, 15),
      albums: extractSearchItems(alRes).slice(0, 8),
      playlists: extractSearchItems(plRes).slice(0, 8),
      artists: extractSearchItems(arRes).slice(0, 8),
    };
  }

  const ytTypeMap = {
    songs: 'song',
    albums: 'album',
    playlists: 'playlist',
    artists: 'artist',
  };
  const ytType = ytTypeMap[type] || 'song';
  const results = await yt.music.search(q, { type: ytType });
  const items = extractSearchItems(results).slice(0, 20);
  // FIX #3: Validate search results for monitoring
  validateBatch(items, `search:${type}:${q.slice(0, 30)}`);
  return items;
}

function extractSearchItems(results) {
  if (!results) return [];
  const items = [];

  // Try sections-based extraction first (standard search result structure)
  if (results.sections?.length) {
    for (const section of results.sections) {
      for (const item of flattenSection(section)) {
        const n = normItem(item) || normSearchItem(item);
        if (n) items.push(n);
      }
    }
  }

  // Fallback: try flattenSearchResult (handles MusicShelf wrapper)
  if (!items.length) {
    const raw = flattenSearchResult(results);
    for (const item of raw) {
      const n = normItem(item) || normSearchItem(item);
      if (n) items.push(n);
    }
  }

  return items;
}

/**
 * Get search autocomplete suggestions.
 * Returns: string[]
 */
async function getSuggestions(q) {
  const yt = await getInstance();
  try {
    const raw = await yt.music.getSearchSuggestions(q);
    return (raw || [])
      .map((s) => {
        if (typeof s === 'string') return s;
        return String(s?.text || s?.suggestion || '');
      })
      .filter(Boolean)
      .slice(0, 10);
  } catch (e) {
    logger.warn('ytmusic_suggestions_failed', { q, error: e.message });
    return [];
  }
}

/**
 * Get a full artist page.
 * Returns: { browseId, name, description, thumbnail, subscribers, topSongs, albums, singles }
 */
async function getArtist(browseId) {
  const yt = await getInstance();
  const data = await yt.music.getArtist(browseId);
  const header = data.header;

  const name = String(header?.title || header?.name || 'Artist');
  const description = String(header?.description || '');
  const subscribers = String(header?.subscribers || '');
  const thumb = getThumb(header) || getThumb({ thumbnail: header?.thumbnail?.contents });

  let topSongs = [];
  let albums = [];
  let singles = [];

  for (const section of (data.sections || [])) {
    const sTitle = String(
      section.header?.title ||
      section.title ||
      ''
    ).toLowerCase();

    const contents = flattenSection(section);

    if (sTitle.includes('song') || sTitle.includes('popular') || sTitle.includes('track')) {
      topSongs = contents.map((t) => normTrack(t)).filter(Boolean).slice(0, 10);

    } else if (sTitle.includes('album')) {
      albums = contents.map((a) => ({
        browseId: getBrowseId(a),
        title: String(a.title || a.name || ''),
        year: String(a.year || a.description || ''),
        thumbnail: getThumb(a),
        type: 'ALBUM',
      })).filter((a) => a.browseId).slice(0, 10);

    } else if (sTitle.includes('single') || sTitle.includes('ep')) {
      singles = contents.map((s) => ({
        browseId: getBrowseId(s),
        title: String(s.title || s.name || ''),
        year: String(s.year || s.description || ''),
        thumbnail: getThumb(s),
        type: 'SINGLE',
      })).filter((s) => s.browseId).slice(0, 6);
    }
  }

  logger.info('ytmusic_artist', { browseId, name });
  return { browseId, name, description, thumbnail: thumb, subscribers, topSongs, albums, singles };
}

/**
 * Get a YTMusic playlist or album by ID.
 * Pass full=true to paginate through all continuation pages (used by import).
 * Default returns first page only (fast, used by preview).
 * Returns: { id, name, description, thumbnail, type, tracks[] }
 */
async function getPlaylist(playlistId, { full = false } = {}) {
  const yt = await getInstance();

  // ── Try as playlist ───────────────────────────────────────────────────────
  try {
    let res = await yt.music.getPlaylist(playlistId);
    const header = res.header;

    // Collect first page of tracks
    let allTracks = (res.contents || res.items || []).map(normTrack).filter(Boolean);

    // Only paginate when explicitly requested (import path) to keep preview fast
    if (full) {
      const MAX_PAGES = 200; // Safety: 200 pages × ~100 tracks = 20,000 tracks max
      let page = 0;
      // Check both `has_continuation` and the raw `continuation` token —
      // different youtubei.js versions expose the flag differently.
      while (page < MAX_PAGES && (res.has_continuation || res.continuation)) {
        try {
          // Small delay between pages to avoid YouTube rate limiting
          if (page > 0) await new Promise(r => setTimeout(r, 200));
          res = await res.getContinuation();
          const moreTracks = (res.contents || res.items || []).map(normTrack).filter(Boolean);
          if (moreTracks.length === 0) {
            logger.info('ytmusic_playlist_continuation_empty', { playlistId, page, totalSoFar: allTracks.length });
            break; // No more tracks — stop
          }
          allTracks = allTracks.concat(moreTracks);
          page++;
          logger.info('ytmusic_playlist_page', { playlistId, page, fetched: moreTracks.length, totalSoFar: allTracks.length });
        } catch (contErr) {
          logger.warn('ytmusic_playlist_continuation_failed', { playlistId, page, fetched: allTracks.length, error: contErr.message });
          break;
        }
      }
      if (page >= MAX_PAGES) {
        logger.warn('ytmusic_playlist_max_pages', { playlistId, pages: page, tracks: allTracks.length });
      }
    }

    if (allTracks.length) {
      // Extract total track count from header metadata (available without pagination).
      // This lets the preview show the real total even when only the first page is fetched.
      // Extract total from multiple possible locations in the header.
      // subtitle can be a Text object or a plain string; String() normalizes both.
      // Match the number immediately before "song" or "track" to avoid grabbing year/duration numbers.
      const subtitleStr = String(header?.subtitle?.text || header?.subtitle || '');
      const songCountMatch = subtitleStr.match(/(\d[\d,]*)\s*(?:song|track|video)/i);
      const headerTotal = parseInt((songCountMatch?.[1] || '').replace(/,/g, ''), 10)
        || parseInt(header?.song_count, 10)
        || parseInt(header?.item_count, 10)
        || parseInt(header?.total_items, 10)
        || 0;
      logger.info('ytmusic_playlist', { playlistId, trackCount: allTracks.length, headerTotal, full });
      return {
        id: playlistId,
        name: String(header?.title || 'Playlist'),
        description: String(header?.description || ''),
        thumbnail: getThumb(header),
        type: 'YTM_PLAYLIST',
        totalTracks: headerTotal || allTracks.length,
        tracks: allTracks,
      };
    }
  } catch (e) {
    logger.warn('ytmusic_playlist_failed', { playlistId, error: e.message });
  }

  // ── Try as album ──────────────────────────────────────────────────────────
  try {
    const res = await yt.music.getAlbum(playlistId);
    const header = res.header;
    const albumTitle = String(header?.title || 'Album');
    const albumThumb = getThumb(header);
    const tracks = (res.contents || res.items || [])
      .map((t) => normTrack(t, albumTitle, albumThumb))
      .filter(Boolean);

    if (tracks.length) {
      logger.info('ytmusic_album', { playlistId, trackCount: tracks.length });
      return {
        id: playlistId,
        name: albumTitle,
        description: String(header?.description || ''),
        thumbnail: albumThumb,
        type: 'YTM_ALBUM',
        tracks,
      };
    }
  } catch (e) {
    logger.warn('ytmusic_album_failed', { playlistId, error: e.message });
  }

  throw new Error(`Cannot resolve ${playlistId} as playlist or album`);
}

/**
 * Get radio / up-next queue for a videoId.
 * Returns: NormTrack[] (first item = current song, we skip it)
 */
async function getWatchNext(videoId) {
  const yt = await getInstance();
  try {
    const upNext = await yt.music.getUpNext(videoId);
    const tracks = upNext?.contents || upNext?.items || [];
    // Skip index 0 (the currently playing song)
    return tracks.slice(1).map((t) => normTrack(t)).filter(Boolean);
  } catch (e) {
    logger.warn('ytmusic_watch_next_failed', { videoId, error: e.message });
    return [];
  }
}

/**
 * Get built-in YouTube Music lyrics for a videoId.
 * Returns: { lyrics: string|null, source: string }
 * This supplements the lrclib/musixmatch chain in lyrics.service.js.
 */
async function getLyrics(videoId) {
  const yt = await getInstance();
  try {
    const upNext = await yt.music.getUpNext(videoId);
    const token = upNext?.lyrics_browse_id;
    if (!token) return { lyrics: null, source: null };
    const res = await yt.getLyrics(token);
    return {
      lyrics: String(res?.text || '').trim() || null,
      source: 'youtube_music',
    };
  } catch (e) {
    logger.warn('ytmusic_lyrics_failed', { videoId, error: e.message });
    return { lyrics: null, source: null };
  }
}

/**
 * Resolve a radioId / playlistId / albumId to its first videoId.
 * Used by the streaming engine to handle non-video IDs.
 */
async function resolve(id) {
  try {
    const playlist = await getPlaylist(id);
    const first = playlist.tracks?.[0]?.videoId;
    if (first) return { videoId: first };
  } catch { }
  // Unable to resolve — return as-is and let the stream engine handle it
  return { videoId: id };
}

module.exports = { getHome, search, getSuggestions, getArtist, getPlaylist, getWatchNext, getLyrics, resolve };
