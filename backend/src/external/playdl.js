const play = require('play-dl');
const logger = require('../utils/logger');

async function extract(videoId, quality = 'auto') {
  try {
    const url = `https://www.youtube.com/watch?v=${videoId}`;
    const info = await play.video_info(url);
    
    // Filter to audio-only formats
    const audioFormats = info.format.filter(f => f.mimeType && f.mimeType.startsWith('audio/'));
    
    if (audioFormats.length === 0) {
      throw new Error('No audio formats found');
    }

    // Sort descending by bitrate
    audioFormats.sort((a, b) => (b.bitrate || 0) - (a.bitrate || 0));

    let best;
    if (quality === 'low') {
      best = audioFormats[audioFormats.length - 1]; // lowest
    } else if (quality === 'high' || quality === 'lossless') {
      // Prioritize opus for high
      const opus = audioFormats.filter(f => f.mimeType.includes('opus'));
      best = opus.length > 0 ? opus[0] : audioFormats[0];
    } else {
      // auto / medium - target first format natively ~128kbps or fallback
      best = audioFormats.reduce((prev, curr) => 
        Math.abs((curr.bitrate || 0) - 128000) < Math.abs((prev.bitrate || 0) - 128000) ? curr : prev
      );
    }

    if (!best || !best.url) {
      throw new Error('Best format has no URL');
    }

    logger.info('playdl_extracted', { videoId, quality, bitrate: best.bitrate });

    return {
      url: best.url,
      mimeType: best.mimeType || 'audio/webm',
      bitrate: best.bitrate || 0,
      source: 'playdl'
    };
  } catch (e) {
    logger.error('playdl_failed', { videoId, error: e.message });
    throw e;
  }
}

module.exports = { extract };
