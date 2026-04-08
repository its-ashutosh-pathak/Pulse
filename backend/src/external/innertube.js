/**
 * innertube.js — Audio stream URL extraction using youtubei.js.
 * Fallback #2 after yt-dlp. No binary required — pure Node.js.
 * Tries IOS → ANDROID → WEB client types in order.
 *
 * Now uses the shared singleton from innertube.singleton.js so the
 * Innertube instance is created exactly once and shared with ytmusic.wrapper.
 */
const { getInstance } = require('./innertube.singleton');
const logger = require('../utils/logger');

function pickBestAudio(formats, quality) {
  const audioOnly = formats.filter((f) => f.mime_type?.startsWith('audio/'));
  if (!audioOnly.length) return null;

  if (quality === 'low') {
    audioOnly.sort((a, b) => (a.bitrate || 0) - (b.bitrate || 0));
  } else if (quality === 'high' || quality === 'lossless') {
    audioOnly.sort((a, b) => (b.bitrate || 0) - (a.bitrate || 0));
  } else {
    // auto / medium — target ~128 kbps
    audioOnly.sort(
      (a, b) =>
        Math.abs((a.bitrate || 0) - 128_000) -
        Math.abs((b.bitrate || 0) - 128_000)
    );
  }
  return audioOnly[0];
}

async function extract(videoId, quality = 'auto') {
  const yt = await getInstance();

  for (const clientType of ['IOS', 'ANDROID', 'WEB']) {
    try {
      const info    = await yt.getBasicInfo(videoId, clientType);
      const formats = info.streaming_data?.adaptive_formats || [];
      const best    = pickBestAudio(formats, quality);
      if (!best) continue;

      const streamUrl =
        best.url ||
        (best.decipher ? best.decipher(yt.session.player) : null);

      if (streamUrl) {
        logger.info('innertube_extracted', { videoId, clientType, bitrate: best.bitrate });
        return { url: streamUrl, bitrate: best.bitrate, mimeType: best.mime_type, source: 'innertube' };
      }
    } catch (e) {
      logger.warn('innertube_client_failed', { videoId, clientType, error: e.message });
    }
  }

  throw new Error('innertube: all client types failed');
}

module.exports = { extract };
