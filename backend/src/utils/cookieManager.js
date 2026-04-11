const fs = require('fs');
const path = require('path');
const logger = require('./logger');
const os = require('os');

let cookieFiles = [];

/**
 * Scans environment variables for any starting with YOUTUBE_COOKIE_
 * Writes their contents (Netscape formatted) to temp files for yt-dlp to use.
 */
function init() {
  const cookieVars = Object.keys(process.env).filter(k => k.startsWith('YOUTUBE_COOKIE_'));

  if (cookieVars.length === 0) {
    logger.info('cookie_manager', { msg: 'No YOUTUBE_COOKIE_ variables found. Running without cookies.' });
    return;
  }

  cookieVars.forEach((key) => {
    // Replace literal '\n' strings and strip potential surrounding quotes
    const rawContent = process.env[key]
      .replace(/\\n/g, '\n')
      .replace(/"/g, ''); // strip any accidental surrounding quotes

    // Only accept basic heuristic that it looks like Netscape cookie file
    if (!rawContent.includes('.youtube.com')) {
      logger.warn('cookie_manager', { msg: `Ignoring ${key} — does not appear to contain youtube.com cookies.` });
      return;
    }

    try {
      const filePath = path.join(os.tmpdir(), `${key.toLowerCase()}.txt`);
      // yt-dlp expects standard Netscape format. If it doesn't have the header, prepend it.
      let finalContent = rawContent;
      if (!finalContent.startsWith('# Netscape HTTP Cookie File')) {
        finalContent = `# Netscape HTTP Cookie File\n${finalContent}`;
      }

      fs.writeFileSync(filePath, finalContent, { encoding: 'utf-8' });
      cookieFiles.push(filePath);
      logger.info('cookie_manager', { msg: `Loaded cookie from ${key}` });
    } catch (e) {
      logger.error('cookie_manager_error', { key, error: e.message });
    }
  });

  logger.info('cookie_manager', { loaded: cookieFiles.length, msg: 'Cookies loaded and ready for rotation' });
}

function getRandomCookieFile() {
  if (cookieFiles.length === 0) return null;
  const idx = Math.floor(Math.random() * cookieFiles.length);
  return cookieFiles[idx];
}

module.exports = { init, getRandomCookieFile };
