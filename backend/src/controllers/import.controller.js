/**
 * import.controller.js
 * Handles playlist import from Spotify.
 *
 * Strategy (two-layer fallback):
 *   1. Try Spotify Web API (Client Credentials) — works for most public playlists
 *   2. If API returns 403 (collaborative/API-restricted playlists), scrape
 *      open.spotify.com/playlist/{id} and extract tracks from JSON-LD tags.
 *      This is a legitimate fallback since the page is publicly accessible.
 */
const axios = require('axios');
const { successBody, createError } = require('../utils/errorResponse');
const env = require('../config/env');
const logger = require('../utils/logger');

const SPOTIFY_API = 'https://api.spotify.com/v1';

// ── Spotify token cache ────────────────────────────────────────────────────────
let _spotifyToken = null;
let _tokenExpiresAt = 0;

async function getSpotifyToken() {
  if (_spotifyToken && Date.now() < _tokenExpiresAt) return _spotifyToken;

  if (!env.SPOTIFY_CLIENT_ID || !env.SPOTIFY_CLIENT_SECRET) {
    throw createError(
      503,
      'SPOTIFY_NOT_CONFIGURED',
      'Spotify import is not configured. Add SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET to your .env file.'
    );
  }

  const credentials = Buffer.from(
    `${env.SPOTIFY_CLIENT_ID}:${env.SPOTIFY_CLIENT_SECRET}`
  ).toString('base64');

  try {
    const res = await axios.post(
      'https://accounts.spotify.com/api/token',
      'grant_type=client_credentials',
      {
        headers: {
          Authorization: `Basic ${credentials}`,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        timeout: 10000,
      }
    );

    _spotifyToken = res.data.access_token;
    _tokenExpiresAt = Date.now() + (res.data.expires_in - 60) * 1000;
    return _spotifyToken;
  } catch (e) {
    const status = e.response?.status;
    if (status === 400 || status === 401) {
      throw createError(503, 'SPOTIFY_AUTH_FAILED', 'Spotify credentials invalid. Check SPOTIFY_CLIENT_ID / SPOTIFY_CLIENT_SECRET in .env.');
    }
    throw createError(502, 'SPOTIFY_TOKEN_ERROR', `Failed to get Spotify token: ${e.message}`);
  }
}

// ── Fallback: scrape Spotify web page for JSON-LD track data ──────────────────
// Spotify's web player embeds structured data (JSON-LD) server-side for SEO.
// This is public — no auth needed — and works for any publicly viewable playlist.
async function scrapeSpotifyPlaylist(id) {
  try {
    logger.info('spotify_scrape_fallback', { id });
    const res = await axios.get(`https://open.spotify.com/playlist/${id}`, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'no-cache',
      },
      timeout: 20000,
    });

    const html = typeof res.data === 'string' ? res.data : '';
    if (!html) return null;

    // Extract <script type="application/ld+json"> blocks
    const ldBlocks = [];
    const ldRegex = /<script type="application\/ld\+json">([\s\S]*?)<\/script>/g;
    let m;
    while ((m = ldRegex.exec(html)) !== null) {
      try { ldBlocks.push(JSON.parse(m[1])); } catch { /* skip malformed */ }
    }

    // Find the MusicPlaylist block
    const ld = ldBlocks.find(b => b && b['@type'] === 'MusicPlaylist');
    if (!ld) {
      logger.warn('spotify_scrape_no_ld_json', { id });
      return null;
    }

    const tracks = (ld.track || []).map(t => {
      // Extract Spotify track ID from URL like https://open.spotify.com/track/4iV5W9uYEdYUVa79Axb7Rh
      const trackIdMatch = (t.url || '').match(/\/track\/([A-Za-z0-9]+)/);
      const spotifyId = trackIdMatch ? trackIdMatch[1] : null;

      // Parse ISO 8601 duration e.g. "PT3M42S" → seconds
      let duration = 0;
      if (t.duration) {
        const d = t.duration.match(/PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/);
        if (d) duration = (parseInt(d[1] || 0) * 3600) + (parseInt(d[2] || 0) * 60) + parseInt(d[3] || 0);
      }

      const artistName = Array.isArray(t.byArtist)
        ? t.byArtist.map(a => a.name).join(', ')
        : (t.byArtist?.name || '');

      return { spotifyId, title: t.name || '', artist: artistName, duration };
    }).filter(t => t.title); // skip nameless items

    if (tracks.length === 0) return null;

    return {
      name: ld.name || 'Imported Playlist',
      total: ld.numTracks || tracks.length,
      tracks,
    };
  } catch (e) {
    logger.warn('spotify_scrape_failed', { id, error: e.message });
    return null;
  }
}

/**
 * GET /api/import/spotify?id=<playlistId>
 *
 * 1) Spotify API (Client Credentials) — fast, full pagination
 * 2) Web scrape fallback — for API-restricted playlists (collaborative, etc.)
 */
async function importSpotify(req, res, next) {
  try {
    const { id } = req.query;
    if (!id) return next(createError(400, 'MISSING_ID', 'Spotify playlist ID is required'));

    // Validate ID format (Spotify IDs are base-62, ~22 chars)
    if (id.length < 10 || id.length > 30 || /[^A-Za-z0-9]/.test(id)) {
      return next(createError(400, 'INVALID_ID',
        `"${id}" is not a valid Spotify playlist ID. Please paste the full playlist URL (e.g. https://open.spotify.com/playlist/…).`
      ));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // LAYER 1: Spotify Web API
    // ─────────────────────────────────────────────────────────────────────────
    let apiAccessAllowed = true;

    try {
      const token = await getSpotifyToken();

      // 1a. Metadata (non-fatal on 403 — many public playlists return 403 here)
      let playlistName = 'Imported Playlist';
      let totalTracks = 0;

      try {
        const metaRes = await axios.get(`${SPOTIFY_API}/playlists/${id}`, {
          headers: { Authorization: `Bearer ${token}` },
          params: { fields: 'name,tracks.total,public,collaborative' },
          timeout: 10000,
        });
        const meta = metaRes.data;
        playlistName = meta.name || playlistName;
        totalTracks = meta.tracks?.total || 0;

        // Hard block only if explicitly private AND not collaborative
        if (meta.public === false && !meta.collaborative) {
          apiAccessAllowed = false;
        }
      } catch (metaErr) {
        const s = metaErr.response?.status;
        const spotifyMsg = metaErr.response?.data?.error?.message || '';
        if (s === 404) return next(createError(404, 'NOT_FOUND', 'Playlist not found. Check the URL.'));
        if (s === 401) { _spotifyToken = null; return next(createError(503, 'SPOTIFY_AUTH_FAILED', 'Spotify auth failed. Try again.')); }
        if (s === 429) return next(createError(429, 'SPOTIFY_RATE_LIMITED', 'Spotify rate limit. Wait 30s and retry.'));
        if (s === 403 && spotifyMsg.toLowerCase().includes('premium')) {
          // Spotify quota exceeded — user needs to update credentials
          return next(createError(503, 'SPOTIFY_QUOTA_EXCEEDED',
            'The Spotify API quota has been exceeded. Please go to developer.spotify.com → your app → Settings → and generate new Client ID & Secret, then update SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET in the backend .env file.'
          ));
        }
        // Other 403 or network error on metadata → continue, try tracks
        logger.info('spotify_meta_err_trying_tracks', { id, status: s, msg: spotifyMsg });
      }

      // 1b. Tracks (paginated) — only if access might be allowed
      if (apiAccessAllowed) {
        const tracks = [];
        let offset = 0;
        const limit = 50;

        while (true) {
          let pageData;
          try {
            const pageRes = await axios.get(`${SPOTIFY_API}/playlists/${id}/tracks`, {
              params: {
                limit, offset,
                fields: 'next,items(track(id,name,duration_ms,artists))',
                market: 'US', // helps with region-restricted content
              },
              headers: { Authorization: `Bearer ${token}` },
              timeout: 15000,
            });
            pageData = pageRes.data;
          } catch (e) {
            const s = e.response?.status;
            const sMsg = e.response?.data?.error?.message || '';
            if (s === 403 && sMsg.toLowerCase().includes('premium')) {
              return next(createError(503, 'SPOTIFY_QUOTA_EXCEEDED',
                'Spotify API quota exceeded. Visit developer.spotify.com → your app → Settings → regenerate Client ID & Secret, then update SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET in the backend .env file.'
              ));
            }
            if (offset === 0 && (s === 403 || s === 401)) {
              // API is blocked — fall through to scrape layer
              logger.info('spotify_tracks_403_falling_to_scrape', { id, status: s, msg: sMsg });
              apiAccessAllowed = false;
              break;
            }
            logger.warn('spotify_tracks_page_failed', { id, offset, status: s });
            break;
          }

          for (const item of pageData.items || []) {
            const t = item.track;
            if (!t || t.id === null) continue;
            tracks.push({
              spotifyId: t.id,
              title: t.name,
              artist: (t.artists || []).map(a => a.name).join(', '),
              duration: Math.round((t.duration_ms || 0) / 1000),
            });
          }

          if (!pageData.next) break;
          offset += limit;
        }

        if (apiAccessAllowed && tracks.length > 0) {
          return res.json(successBody({ name: playlistName, total: totalTracks || tracks.length, tracks }));
        }
      }
    } catch (tokenErr) {
      // Token fetch failed — skip to scrape layer
      logger.warn('spotify_token_failed_falling_to_scrape', { id, error: tokenErr.message });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // LAYER 2: Web scrape fallback (open.spotify.com JSON-LD)
    // Used when API returns 403 (collaborative/API-restricted but page is public)
    // ─────────────────────────────────────────────────────────────────────────
    const scraped = await scrapeSpotifyPlaylist(id);
    if (scraped && scraped.tracks.length > 0) {
      logger.info('spotify_scrape_success', { id, tracks: scraped.tracks.length });
      return res.json(successBody(scraped));
    }

    // Both layers failed — playlist is genuinely inaccessible
    return next(createError(
      403,
      'SPOTIFY_FORBIDDEN',
      'Cannot access this playlist. It appears to be private. In Spotify: open the playlist → ⋯ (three dots) → Make public, then retry. ' +
      'If it is already public, try opening it in a web browser first to confirm it loads.'
    ));

  } catch (e) {
    logger.warn('spotify_import_failed', { error: e.message });
    next(e);
  }
}

module.exports = { importSpotify };
