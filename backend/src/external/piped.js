/**
 * piped.js — Extracts audio stream URLs from Piped API instances.
 * Primary stream source (tier 1) — zero server bandwidth, CDN-hosted.
 * Tries multiple instances in order of reliability.
 */
const axios    = require('axios');
const { PIPED_INSTANCES } = require('../config/constants');
const logger   = require('../utils/logger');

function pickBestAudio(audioStreams, quality) {
  if (!audioStreams || !audioStreams.length) return null;

  switch (quality) {
    case 'low':
      return audioStreams.sort((a, b) => (a.bitrate || 0) - (b.bitrate || 0))[0];

    case 'high':
    case 'lossless': {
      const opus = audioStreams.filter((s) => s.mimeType?.includes('opus'));
      return (opus.length > 0 ? opus : audioStreams)
        .sort((a, b) => (b.bitrate || 0) - (a.bitrate || 0))[0];
    }

    default: // auto / medium — target ~128kbps
      return audioStreams.reduce((prev, curr) =>
        Math.abs((curr.bitrate || 0) - 128_000) <
        Math.abs((prev.bitrate || 0) - 128_000)
          ? curr
          : prev
      );
  }
}

async function extract(videoId, quality = 'auto') {
  let lastError = null;

  for (const instance of PIPED_INSTANCES) {
    try {
      const res = await axios.get(`${instance}/streams/${videoId}`, {
        timeout: 8000,
        headers: { 'User-Agent': 'Mozilla/5.0' },
      });

      const audioStreams = res.data?.audioStreams || [];
      if (!audioStreams.length) continue;

      const best = pickBestAudio(audioStreams, quality);
      if (!best?.url) continue;

      logger.info('piped_extracted', { videoId, instance, bitrate: best.bitrate });
      return {
        url:      best.url,
        mimeType: best.mimeType || 'audio/webm',
        bitrate:  best.bitrate  || 0,
        source:   'piped',
        instance,
      };
    } catch (e) {
      logger.warn('piped_instance_failed', { videoId, instance, error: e.message });
      lastError = e;
    }
  }

  throw new Error(`Piped: all instances failed. Last: ${lastError?.message}`);
}

module.exports = { extract };
