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
  
  // Base yt-dlp arguments
  const args = [
    // Use a high-compatibility Edge signature to match our proxy (better cookie compatibility than Android spoofing on Cloud IPs)
    '--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0"',
    // Try best audio, but fall back to ANY format that has audio if things get desperate
    `-f "${format}/bestaudio/best"`,
    '-g',
    '--no-playlist',
    '--no-warnings',
    '--no-check-certificates',
    // Allow yt-dlp to negotiate client types naturally (Web/Android/etc) while staying within the UA signature
    '--extractor-args "youtube:player_client=web,android"'
  ];

  // If cookies are provided by the user via .env, rotate through them
  const cookieManager = require('../utils/cookieManager');
  const cookieFile = cookieManager.getRandomCookieFile();
  if (cookieFile) {
    args.push(`--cookies "${cookieFile}"`);
  }

  args.push(`"${url}"`);
  const cmd = `${YTDLP} ${args.join(' ')}`;

  logger.info('ytdlp_extract', { videoId, quality, hasCookies: !!cookieFile });

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
