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
            total: tracks.length, // Max 100
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
 * Fetches the entire playlist including Name, Total Count, and beautifully parsed tracks.
 */
async function getFullPlaylist(id) {
  let playlistName = 'Imported Spotify Playlist';
  let totalTracksCount = 0;
  
  // 1. Fetch Metadata Configuration
  try {
    const meta = await fetchSpotifyAPI(`${SPOTIFY_API}/playlists/${id}`, {
      fields: 'name,tracks.total,public,collaborative'
    });
    
    playlistName = meta.name || playlistName;
    totalTracksCount = meta.tracks?.total || 0;
    
    // Hard block if explicit block is detected
    if (meta.public === false && !meta.collaborative) {
       throw createError(
         403, 
         'SPOTIFY_FORBIDDEN', 
         'Playlist belongs to a private user account. Make it public on Spotify first.'
       );
    }
  } catch (metaErr) {
    const status = metaErr.response?.status;
    const spotifyMsg = metaErr.response?.data?.error?.message || '';
    
    if (metaErr.statusCode === 403) throw metaErr; // Re-throw our custom error above
    if (status === 404) throw createError(404, 'NOT_FOUND', 'Playlist not found. Verify the URL is correct.');
    if (status === 429) throw createError(429, 'SPOTIFY_RATE_LIMITED', 'Spotify rate limit. Wait 30s and retry.');
    if (status === 403 && spotifyMsg.toLowerCase().includes('premium')) {
      throw createError(503, 'SPOTIFY_QUOTA_EXCEEDED', 'Spotify API quota exceeded. Check developer limits.');
    }
    
    // We allow other silent 403 errors to pass and let Tracks endpoint attempt next
  }

  // 2. Fetch tracks through pagination
  const tracks = [];
  let offset = 0;
  const limit = 50;

  while (true) {
    try {
      const pageData = await fetchSpotifyAPI(`${SPOTIFY_API}/playlists/${id}/tracks`, {
        limit, offset,
        fields: 'next,items(track(id,name,duration_ms,artists))',
        market: 'US'
      });
      
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
      
      // Artificial delay to prevent burst rate-limits from banning credentials
      await new Promise(r => setTimeout(r, 250));
      
    } catch (pageErr) {
      const status = pageErr.response?.status;
      
      // If we fail on the very first page due to strict API limits/bans, immediately use Fallback
      if (offset === 0 && (status === 403 || status === 401 || status === 429)) {
         logger.warn('spotify_api_quota_banned_using_fallback', { id, status });
         try {
           const fallbackData = await scrapeSpotifyEmbed(id);
           return {
             name: playlistName,
             total: fallbackData.tracks.length,
             tracks: fallbackData.tracks
           };
         } catch (fallbackErr) {
           throw createError(403, 'SPOTIFY_FORBIDDEN', 'API Blocked and Fallback scraper failed. Playlist may be private.');
         }
      }
      
      // If we made it partly through but failed midway, warn but return what we got
      logger.warn('spotify_tracks_page_failed_mid_loop', { id, offset, status });
      break;
    }
  }

  if (tracks.length === 0) {
    throw createError(404, 'EMPTY_PLAYLIST', 'This playlist is empty or the tracks are hidden.');
  }

  return {
    name: playlistName,
    total: tracks.length, // use actual fetched length
    tracks
  };
}

module.exports = {
  getSpotifyToken,
  getPlaylistMeta,
  getFullPlaylist
};
