/**
 * ytdlp.js — Spawns yt-dlp subprocess to extract audio stream URLs.
 * Enforces a global rate of ~1.5 extractions/sec to avoid hammering YouTube.
 */
const { exec }    = require('child_process');
const { promisify } = require('util');
const env         = require('../config/env');
const { EXTRACT_DELAY_MS } = require('../config/constants');
const logger      = require('../utils/logger');

const execAsync = promisify(exec);
const YTDLP     = env.YTDLP_PATH || 'yt-dlp';

// Global extraction rate throttle
let lastExtractTime = 0;

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/**
 * Maps Pulse quality setting to yt-dlp format selector.
 */
function qualityToFormat(quality) {
  switch (quality) {
    case 'low':     return 'bestaudio[abr<=64][ext=webm]/bestaudio[abr<=64]/bestaudio/best';
    case 'medium':  return 'bestaudio[abr<=128][ext=webm]/bestaudio[abr<=128]/bestaudio/best';
    case 'high':    return 'bestaudio[abr>=160][ext=webm]/bestaudio[ext=webm]/bestaudio/best';
    case 'lossless':return 'bestaudio/best';
    default:        return 'bestaudio[ext=webm]/bestaudio/best'; // auto
  }
}

/**
 * Extract a direct stream URL for a YouTube videoId using yt-dlp.
 * Returns { url, mimeType, source }.
 */
async function extract(videoId, quality = 'auto') {
  // Throttle: wait if needed
  const now  = Date.now();
  const wait = EXTRACT_DELAY_MS - (now - lastExtractTime);
  if (wait > 0) await sleep(wait);
  lastExtractTime = Date.now();

  const format = qualityToFormat(quality);
  const url    = `https://www.youtube.com/watch?v=${videoId}`;
  const cmd = [
    YTDLP,
    `-f "${format}"`,
    '-g',
    '--no-playlist',
    '--no-warnings',
    '--no-check-certificates',
    `"${url}"`
  ].join(' ');

  logger.info('ytdlp_extract', { videoId, quality });

  try {
    const { stdout, stderr } = await execAsync(cmd, { timeout: 45_000 });
    const streamUrl  = stdout.trim().split('\n')[0];
    if (!streamUrl) throw new Error('yt-dlp returned empty URL');
    return { url: streamUrl, mimeType: 'audio/webm', source: 'ytdlp' };
  } catch (e) {
    logger.error('ytdlp_failed', { videoId, error: e.message });
    throw new Error(`yt-dlp failed: ${e.message}`);
  }
}

module.exports = { extract };
