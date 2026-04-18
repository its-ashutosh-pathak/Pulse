/**
 * musicService.js — Client-side YouTube Music API wrapper
 * Designed to decouple the frontend from a monolithic backend by directly querying
 * YouTube Music's InnerTube endpoints via a lightweight CORS proxy.
 */

const PROXY_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

const WEB_CLIENT_CONTEXT = {
  client: {
    clientName: 'WEB_REMIX',
    clientVersion: '1.20240410.01.00',
    gl: 'US',
    hl: 'en',
  }
};

/**
 * Base dispatcher for sending proxy requests 
 */
async function sendProxyRequest(endpoint, payload) {
  try {
    const res = await fetch(`${PROXY_URL}/api/innertube/proxy/${endpoint}?key=QUICK_PROXY`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        context: WEB_CLIENT_CONTEXT,
        ...payload
      })
    });

    if (!res.ok) throw new Error(`Proxy error: ${res.status}`);
    return await res.json();
  } catch (err) {
    console.error(`[musicService] ${endpoint} failed:`, err);
    throw err;
  }
}

/**
 * Fetch search suggestions for the searchbar
 */
export async function getSuggestions(query) {
  if (!query) return [];
  try {
    const data = await sendProxyRequest('music/get_search_suggestions', { input: query });
    const contents = data?.contents?.[0]?.searchSuggestionsSectionRenderer?.contents || [];
    
    return contents.map(c => {
      if (c.searchSuggestionRenderer) {
        return c.searchSuggestionRenderer.suggestion.runs.map(r => r.text).join('');
      } else if (c.historySuggestionRenderer) {
        return c.historySuggestionRenderer.suggestion.runs.map(r => r.text).join('');
      }
      return null;
    }).filter(Boolean);
  } catch (e) {
    console.warn('[musicService] getSuggestions failed:', e.message);
    return [];
  }
}

/**
 * Perform a generic song search
 */
export async function searchSongs(query) {
  const data = await sendProxyRequest('search', { query, params: 'EgWKAQIIAWoMEAMQBBAJEA4QChAF' }); // params targets standard song filter
  // This is a stub showing where parsing logic goes, usually parsing the YouTube JSON grid
  return { songs: [] }; // Implementation detail: traverse sectionListRenderer
}

/**
 * Retrieve a stream extraction from the backend stream proxy. 
 * (Cannot be client-side due to YouTube PO_Token bot protection)
 */
export async function getStreamUrl(videoId) {
  // We still use backend yt-dlp because deciphering signatures in-browser is broken by PO_Tokens
  return `${PROXY_URL}/api/stream/${videoId}`;
}

export default {
  getSuggestions,
  searchSongs,
  getStreamUrl
};
