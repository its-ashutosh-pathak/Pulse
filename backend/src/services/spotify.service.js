/**
 * spotify.service.js
 * Unified module for Spotify Client Credentials flow, token management,
 * and paginated playlist fetching.
 */
const axios = require('axios');
const http = require('http');
const https = require('https');
const env = require('../config/env');
const logger = require('../utils/logger');
const { createError } = require('../utils/errorResponse');

const SPOTIFY_API = 'https://api.spotify.com/v1';

let _spotifyToken = null;
let _tokenExpiresAt = 0;

/**
 * Validates and retrieves the active Spotify Token.
 */
async function getSpotifyToken(forceRefresh = false) {
  if (!forceRefresh && _spotifyToken && Date.now() < _tokenExpiresAt) {
    return _spotifyToken;
  }

  if (!env.SPOTIFY_CLIENT_ID || !env.SPOTIFY_CLIENT_SECRET) {
    throw createError(
      503,
      'SPOTIFY_NOT_CONFIGURED',
      'Spotify credentials missing in .env'
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
    // Buffer by 60 seconds to ensure token doesn't expire exactly in-flight
    _tokenExpiresAt = Date.now() + (res.data.expires_in - 60) * 1000;
    return _spotifyToken;
  } catch (e) {
    const status = e.response?.status;
    if (status === 400 || status === 401) {
      throw createError(503, 'SPOTIFY_AUTH_FAILED', 'Invalid Spotify credentials in .env.');
    }
    throw createError(502, 'SPOTIFY_TOKEN_ERROR', `Failed to get Spotify token: ${e.message}`);
  }
}

/**
 * Internal method: fetch resource, handles 401 retry automatically.
 */
async function fetchSpotifyAPI(url, params = {}) {
  let token = await getSpotifyToken(false);
  
  const makeRequest = (t) => axios.get(url, {
    headers: { Authorization: `Bearer ${t}` },
    params,
    timeout: 15000
  });

  try {
    const res = await makeRequest(token);
    return res.data;
  } catch (error) {
    if (error.response?.status === 401) {
      // Force refresh on 401 and retry once
      logger.info('spotify_token_expired_retrying');
      token = await getSpotifyToken(true);
      const retryRes = await makeRequest(token);
      return retryRes.data;
    }
    
    // Bubble up specifically for 403 / 404 / 429 processing
    throw error;
  }
}

/**
 * Scrapes the Spotify Embed Widget (__NEXT_DATA__) to extract playlist metadata anonymously.
 * Bypasses all Developer API rate limits and quotas, but is strictly capped to the first 100 tracks.
 * Used as: (1) quick metadata preview, (2) last-resort fallback for track import.
 */
function scrapeSpotifyEmbed(playlistId) {
  return new Promise((resolve, reject) => {
    https.get(`https://open.spotify.com/embed/playlist/${playlistId}`, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          if (!data.includes('__NEXT_DATA__')) {
            throw new Error('Could not find internal data module');
          }
          const str = data.split('<script id="__NEXT_DATA__" type="application/json">')[1].split('</script>')[0];
          const json = JSON.parse(str);
          const entity = json.props.pageProps.state.data.entity;
          
          if (!entity || !entity.name) throw new Error('Invalid scraped data');
          
          const tracks = (entity.trackList || []).map(t => ({
            spotifyId: t.id || t.uri,
            title: t.title || 'Unknown',
            artist: t.subtitle || 'Unknown',
            duration: Math.round((t.duration || 0) / 1000)
          }));

          resolve({
            name: entity.name,
            total: entity.trackCount || tracks.length,
            tracks
          });
        } catch (e) {
          reject(e);
        }
      });
    }).on('error', reject);
  });
}

/**
 * Tier 2 Fallback: Extract an anonymous access token from Spotify's web player page.
 * When you visit a public playlist on open.spotify.com, the HTML contains an
 * embedded accessToken in one of the script tags. This token works with the
 * standard Web API for public data (no developer credentials needed).
 *
 * @returns {string|null} Anonymous Bearer token, or null if extraction fails.
 */
async function getAnonymousToken(playlistId) {
  try {
    const res = await axios.get(`https://open.spotify.com/playlist/${playlistId}`, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'identity', // avoid compressed response for easy parsing
      },
      timeout: 12000,
      maxRedirects: 5,
    });

    const html = typeof res.data === 'string' ? res.data : '';

    // Strategy 1: Look for "accessToken":"..." in script tags
    const tokenMatch = html.match(/"accessToken"\s*:\s*"([A-Za-z0-9_\-\.]+)"/);
    if (tokenMatch?.[1]) {
      logger.info('spotify_anon_token_extracted', { method: 'page_regex' });
      return tokenMatch[1];
    }

    // Strategy 2: Look for session data in __NEXT_DATA__ or similar
    const sessionMatch = html.match(/"token"\s*:\s*"([A-Za-z0-9_\-\.]+)"/);
    if (sessionMatch?.[1] && sessionMatch[1].length > 50) {
      logger.info('spotify_anon_token_extracted', { method: 'session_regex' });
      return sessionMatch[1];
    }

    logger.warn('spotify_anon_token_not_found', { playlistId, htmlLength: html.length });
    return null;
  } catch (e) {
    logger.warn('spotify_anon_token_fetch_failed', { playlistId, error: e.message });
    return null;
  }
}

/**
 * Tier 2 Fallback: Use an anonymous token to paginate through ALL tracks
 * in a public playlist via the standard Spotify Web API.
 * Falls back to scrapeSpotifyEmbed if token extraction fails.
 */
async function scrapeWithAnonymousToken(playlistId) {
  const token = await getAnonymousToken(playlistId);
  if (!token) {
    throw new Error('Anonymous token extraction failed');
  }

  let playlistName = 'Spotify Playlist';
  // Try to get playlist name with the anonymous token
  try {
    const meta = await axios.get(`${SPOTIFY_API}/playlists/${playlistId}`, {
      headers: { Authorization: `Bearer ${token}` },
      params: { fields: 'name,tracks.total' },
      timeout: 8000,
    });
    playlistName = meta.data?.name || playlistName;
  } catch (_) { /* name is optional — continue without it */ }

  // Paginate through all tracks
  const tracks = [];
  let offset = 0;
  const limit = 50;
  const MAX_TRACKS = 10000; // Safety cap

  while (offset < MAX_TRACKS) {
    try {
      const res = await axios.get(`${SPOTIFY_API}/playlists/${playlistId}/tracks`, {
        headers: { Authorization: `Bearer ${token}` },
        params: {
          limit,
          offset,
          fields: 'next,total,items(track(id,name,duration_ms,artists))',
          market: 'US',
        },
        timeout: 10000,
      });

      for (const item of res.data.items || []) {
        const t = item.track;
        if (!t || t.id === null || !t.name) continue;
        tracks.push({
          spotifyId: t.id,
          title: t.name,
          artist: (t.artists || []).map(a => a.name).join(', '),
          duration: Math.round((t.duration_ms || 0) / 1000),
        });
      }

      if (!res.data.next) break;
      offset += limit;
      await new Promise(r => setTimeout(r, 200)); // rate-limit courtesy
    } catch (e) {
      logger.warn('spotify_anon_page_failed', { playlistId, offset, error: e.message });
      break; // Return what we got so far
    }
  }

  if (tracks.length === 0) {
    throw new Error('Anonymous token returned no tracks');
  }

  logger.info('spotify_anon_scrape_success', { playlistId, tracksFound: tracks.length });
  return {
    name: playlistName,
    total: tracks.length,
    tracks,
  };
}

/**
 * Lightweight preview fetch — only name + total track count.
 * Used for the preview card step before the user confirms the import.
 */
async function getPlaylistMeta(id) {
  try {
    const meta = await fetchSpotifyAPI(`${SPOTIFY_API}/playlists/${id}`, {
      fields: 'name,tracks.total,public,collaborative'
    });

    if (meta.public === false && !meta.collaborative) {
      throw createError(403, 'SPOTIFY_FORBIDDEN', 'This playlist is private. Open it in Spotify → ⋯ → Make public, then retry.');
    }

    return {
      name:  meta.name  || 'Spotify Playlist',
      total: meta.tracks?.total || 0,
    };
  } catch (e) {
    const status = e.response?.status;
    const msg    = e.response?.data?.error?.message || '';
    if (e.statusCode === 403) throw e;
    if (status === 404) throw createError(404, 'NOT_FOUND', 'Playlist not found. Check the URL.');
    if (status === 429) throw createError(429, 'SPOTIFY_RATE_LIMITED', 'Spotify rate limit hit. Wait 30s and retry.');
    if (status === 403 && msg.toLowerCase().includes('premium'))
      throw createError(503, 'SPOTIFY_QUOTA_EXCEEDED', 'Spotify API quota exceeded.');
    
    // If we get an auth/quota error, try the fallback
    if (status === 401 || status === 403 || status === 429) {
      logger.warn('spotify_api_blocked_using_fallback_preview', { id, status });
      try {
        const fallback = await scrapeSpotifyEmbed(id);
        return { name: fallback.name, total: fallback.total };
      } catch (fallbackErr) {
        throw createError(403, 'SPOTIFY_FORBIDDEN', 'Cannot access this playlist. It may be private.');
      }
    }
    throw createError(502, 'SPOTIFY_META_ERROR', `Failed to fetch playlist info: ${e.message}`);
  }
}

/**
 * Helper: sleep for ms milliseconds.
 */
function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}

/**
 * Fetches the entire playlist including Name, Total Count, and beautifully parsed tracks.
 * Three-tier fallback:
 *   Tier 1: Client Credentials API (paginated, with retry+backoff on 429)
 *   Tier 2: Anonymous token scraper (paginated, no credentials needed)
 *   Tier 3: Embed page scraper (100 tracks max, last resort)
 */
async function getFullPlaylist(id) {
  let playlistName = 'Imported Spotify Playlist';
  let totalTracksCount = 0;
  
  // ── Tier 1: Client Credentials API (with retry + exponential backoff) ──────
  try {
    // 1. Fetch Metadata Configuration
    const meta = await fetchSpotifyAPI(`${SPOTIFY_API}/playlists/${id}`, {
      fields: 'name,tracks.total,public,collaborative'
    });
    
    playlistName = meta.name || playlistName;
    totalTracksCount = meta.tracks?.total || 0;
    
    if (meta.public === false && !meta.collaborative) {
       throw createError(
         403, 
         'SPOTIFY_FORBIDDEN', 
         'Playlist belongs to a private user account. Make it public on Spotify first.'
       );
    }

    // 2. Fetch tracks through pagination with retry + exponential backoff
    const tracks = [];
    let offset = 0;
    const limit = 50;

    while (true) {
      let retries = 0;
      const MAX_RETRIES = 3;
      let pageData = null;

      while (retries <= MAX_RETRIES) {
        try {
          pageData = await fetchSpotifyAPI(`${SPOTIFY_API}/playlists/${id}/tracks`, {
            limit, offset,
            fields: 'next,items(track(id,name,duration_ms,artists))',
            market: 'US'
          });
          break; // Success — exit retry loop
        } catch (pageErr) {
          const status = pageErr.response?.status;

          if (status === 429 && retries < MAX_RETRIES) {
            // Exponential backoff: 1s, 2s, 4s
            const backoffMs = Math.pow(2, retries) * 1000;
            logger.warn('spotify_429_retrying', { id, offset, retries, backoffMs });
            await sleep(backoffMs);
            retries++;
            continue;
          }

          // Non-429 error on first page → fall to Tier 2
          if (offset === 0) {
            throw pageErr; // Will be caught by outer try-catch → Tier 2
          }

          // Mid-pagination failure → return what we got so far
          logger.warn('spotify_tracks_page_failed_mid', { id, offset, status, tracks: tracks.length });
          pageData = null;
          break;
        }
      }

      if (!pageData) break; // Retries exhausted or mid-pagination failure

      for (const item of pageData.items || []) {
        const t = item.track;
        if (!t || t.id === null || !t.name) continue;
        
        tracks.push({
          spotifyId: t.id,
          title: t.name,
          artist: (t.artists || []).map(a => a.name).join(', '),
          duration: Math.round((t.duration_ms || 0) / 1000),
        });
      }

      if (!pageData.next) break;
      offset += limit;
      await sleep(250); // Rate-limit courtesy
    }

    if (tracks.length > 0) {
      logger.info('spotify_api_full_playlist', { id, tracks: tracks.length });
      return {
        name: playlistName,
        total: tracks.length,
        tracks
      };
    }

    // API returned 0 tracks → fall to Tier 2
    throw new Error('API returned 0 tracks');
  } catch (tier1Err) {
    const status = tier1Err.response?.status || tier1Err.statusCode;
    logger.warn('spotify_tier1_failed', { id, status, error: tier1Err.message });

    // Re-throw hard blocks (private playlists)
    if (tier1Err.statusCode === 403 && tier1Err.code === 'SPOTIFY_FORBIDDEN') throw tier1Err;
    if (status === 404) throw createError(404, 'NOT_FOUND', 'Playlist not found.');
  }

  // ── Tier 2: Anonymous Token Scraper (paginated, no credentials needed) ─────
  try {
    logger.info('spotify_trying_tier2_anon', { id });
    const anonResult = await scrapeWithAnonymousToken(id);
    if (anonResult.tracks.length > 0) {
      return {
        name: anonResult.name || playlistName,
        total: anonResult.tracks.length,
        tracks: anonResult.tracks,
      };
    }
  } catch (tier2Err) {
    logger.warn('spotify_tier2_failed', { id, error: tier2Err.message });
  }

  // ── Tier 3: Embed Scraper (100 tracks max, last resort) ────────────────────
  try {
    logger.warn('spotify_using_tier3_embed_fallback', { id });
    const fallbackData = await scrapeSpotifyEmbed(id);
    return {
      name: fallbackData.name || playlistName,
      total: fallbackData.tracks.length,
      tracks: fallbackData.tracks
    };
  } catch (tier3Err) {
    logger.error('spotify_all_tiers_failed', { id, error: tier3Err.message });
    throw createError(403, 'SPOTIFY_FORBIDDEN', 'All extraction methods failed. Playlist may be private.');
  }
}

module.exports = {
  getSpotifyToken,
  getPlaylistMeta,
  getFullPlaylist
};

