const metaSvc = require('../services/metadata.service');
const streamSvc = require('../services/stream.service');
const lyricsSvc = require('../services/lyrics.service');
const recSvc = require('../services/recommendation.service');
const prefetchSvc = require('../services/prefetch.service');
const settingsRepo = require('../repositories/settings.repository');
const { successBody } = require('../utils/errorResponse');
const { createError } = require('../utils/errorResponse');

async function home(req, res, next) {
  try {
    const data = await metaSvc.getHome();
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function search(req, res, next) {
  try {
    const { q, type } = req.query;
    if (!q) return res.json(successBody(type === 'all' ? { songs: [], albums: [], playlists: [], artists: [] } : []));
    const result = type === 'all'
      ? await metaSvc.searchAll(q)
      : await metaSvc.searchSongs(q);
    res.json(successBody(result));
  } catch (e) { next(e); }
}

async function suggestions(req, res, next) {
  try {
    const { q } = req.query;
    const result = q ? await metaSvc.getSuggestions(q) : [];
    res.json(successBody(result));
  } catch (e) { next(e); }
}

async function artist(req, res, next) {
  try {
    const data = await metaSvc.getArtist(req.params.browseId);
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function ytPlaylist(req, res, next) {
  try {
    const full = req.query.full === 'true';
    const data = await metaSvc.getPlaylist(req.params.id, { full });
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function play(req, res, next) {
  try {
    const { videoId } = req.params;
    const forceRefresh = req.query.refresh === 'true';
    const nextIds = req.query.next ? req.query.next.split(',').filter(Boolean) : [];

    // Read user quality settings
    const settings = req.user
      ? await settingsRepo.get(req.user.userId)
      : { streamingQuality: 'auto', dataSaverMode: false };

    const quality = settings.dataSaverMode ? 'low' : (settings.streamingQuality || 'auto');
    const dataSaver = Boolean(settings.dataSaverMode);

    const streamData = await streamSvc.getStreamUrl(videoId, { quality, forceRefresh });

    // Background prefetch — never blocks
    prefetchSvc.prefetchNext(nextIds, quality, dataSaver);

    res.json(successBody({
      ...streamData,
      dataSaverActive: dataSaver,
      expiresAt: Date.now() + (6 * 60 * 60 * 1000),
    }));
  } catch (e) { next(e); }
}

async function lyrics(req, res, next) {
  try {
    const nocache = req.query.nocache === '1';
    const data = await lyricsSvc.getLyrics(req.params.videoId, { nocache });
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function recommendations(req, res, next) {
  try {
    const userId = req.user?.userId;
    const data = await recSvc.getRecommendations(req.params.videoId, userId);
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function watchNext(req, res, next) {
  try {
    const data = await metaSvc.getWatchNext(req.params.videoId);
    res.json(successBody(data));
  } catch (e) { next(e); }
}

async function resolveId(req, res, next) {
  try {
    const data = await metaSvc.resolveId(req.params.id);
    res.json(successBody(data));
  } catch (e) { next(e); }
}

// Resolve an artist name to a browseId by doing a targeted artist search
async function resolveArtist(req, res, next) {
  try {
    const { name } = req.query;
    if (!name) return res.json(successBody({ browseId: null }));
    const data = await metaSvc.searchAll(name);
    const first = (data.artists || [])[0];
    res.json(successBody({ browseId: first?.browseId || first?.id || null, name: first?.title || name }));
  } catch (e) { next(e); }
}

// Find top album browseId matching a song title + artist query
async function albumSearch(req, res, next) {
  try {
    const { q } = req.query;
    if (!q) return res.json(successBody({ browseId: null }));
    const data = await metaSvc.searchAll(q);
    // Only return MPRE-prefixed IDs — those are true YTMusic album IDs
    const album = (data.albums || []).find(a => (a.browseId || a.id)?.startsWith('MPRE'));
    res.json(successBody({
      browseId: album?.browseId || album?.id || null,
      title: album?.title || null
    }));
  } catch (e) { next(e); }
}
/**
 * streamProxy — pipes the YouTube audio stream through the backend to the browser.
 * This is required because YouTube CDN URLs are IP-locked: yt-dlp fetches on the
 * server IP, so the URL is only valid from that same IP. Returning it raw to the
 * browser causes a 403 → NotSupportedError. Proxying solves this.
 */
async function streamProxy(req, res, next) {
  try {
    const { videoId } = req.params;
    const forceRefresh = req.query.refresh === 'true';

    const settings = req.user
      ? await settingsRepo.get(req.user.userId)
      : { streamingQuality: 'auto', dataSaverMode: false };

    const quality = settings.dataSaverMode ? 'low' : (settings.streamingQuality || 'auto');
    const streamData = await streamSvc.getStreamUrl(videoId, { quality, forceRefresh });
    const streamUrl = streamData?.url;
    if (!streamUrl) return next(createError(404, 'STREAM_NOT_FOUND', 'Cannot find stream'));

    const axios = require('axios');

    // Support range requests for seeking
    const rangeHeader = req.headers['range'];
    const axiosConfig = {
      method: 'get',
      url: streamUrl,
      responseType: 'stream',
      headers: {
        // Must match the signature used during extraction (ytdlp/innertube)
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0',
        'Referer': 'https://www.youtube.com/',
        ...(rangeHeader ? { Range: rangeHeader } : {}),
      },
      timeout: 30000,
    };

    const upstream = await axios(axiosConfig);

    // Forward key headers from YouTube so browser knows what it's getting
    const forwardHeaders = ['content-type', 'content-length', 'content-range', 'accept-ranges'];
    forwardHeaders.forEach(h => {
      if (upstream.headers[h]) res.setHeader(h, upstream.headers[h]);
    });
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Cache-Control', 'no-store');

    // Use 206 Partial Content if upstream returned it (for seeking support)
    res.status(rangeHeader ? (upstream.status === 206 ? 206 : 200) : 200);

    // Catch asynchronous stream errors so Node.js doesn't crash (returning 502)
    upstream.data.on('error', (err) => {
      console.error('[StreamProxy] Upstream error:', err.message);
      if (!res.headersSent) res.status(500).end();
    });

    res.on('error', (err) => {
      console.error('[StreamProxy] Response stream error:', err.message);
      upstream.data.destroy();
    });

    upstream.data.pipe(res);

    // Clean up if client disconnects early
    req.on('close', () => upstream.data.destroy());
  } catch (e) {
    next(e);
  }
}

async function downloadOffline(req, res, next) {
  try {
    const { videoId } = req.params;
    const streamData = await streamSvc.getStreamUrl(videoId, { quality: 'auto', forceRefresh: false });
    const streamUrl = streamData?.url || streamData?.streamUrl;
    if (!streamUrl) return next(createError(404, 'STREAM_NOT_FOUND', 'Cannot find stream'));

    const axios = require('axios');
    const response = await axios({
      method: 'get',
      url: streamUrl,
      responseType: 'stream',
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0',
        'Referer': 'https://www.youtube.com/',
      }
    });

    res.setHeader('Content-Type', response.headers['content-type'] || 'audio/webm');
    res.setHeader('Content-Disposition', `attachment; filename="${videoId}.webm"`);
    res.setHeader('Access-Control-Allow-Origin', '*'); // explicitly allow cross origin

    response.data.on('error', (err) => {
      console.error('[DownloadOffline] Upstream error:', err.message);
      if (!res.headersSent) res.status(500).end();
    });

    res.on('error', (err) => {
      console.error('[DownloadOffline] Response stream error:', err.message);
      response.data.destroy();
    });

    response.data.pipe(res);

    req.on('close', () => response.data.destroy());
  } catch (e) { next(e); }
}

module.exports = { home, search, suggestions, artist, ytPlaylist, play, streamProxy, lyrics, recommendations, watchNext, resolveId, resolveArtist, albumSearch, downloadOffline };
