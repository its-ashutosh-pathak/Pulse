const fs = require('fs');
const path = require('path');
const logger = require('./logger');
const os = require('os');

let cookieFiles = [];
let rawCookieString = null;

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
    // Replace literal '\n' strings and strip ONLY surrounding quotes
    let rawContent = process.env[key]
      .replace(/\\n/g, '\n')
      .replace(/^"|"$/g, ''); 

    // Repair HF secret tab-to-space conversion for yt-dlp
    // Netscape format: domain, flag, path, secure, expiration, name, value
    // separated by tabs.
    rawContent = rawContent.split('\n').map(line => {
      if (line.startsWith('#') || !line.trim()) return line;
      // match 6 whitespace separated tokens, then capture the rest of the line
      const parts = line.match(/^\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.+)$/);
      if (parts) {
        return parts.slice(1, 8).join('\t');
      }
      return line;
    }).join('\n');

    if (!rawContent.includes('.youtube.com')) {
      logger.warn('cookie_manager', { msg: `Ignoring ${key} — does not appear to contain youtube.com cookies.` });
      return;
    }

    try {
      const filePath = path.join(os.tmpdir(), `${key.toLowerCase()}.txt`);
      let finalContent = rawContent;
      if (!finalContent.startsWith('# Netscape HTTP Cookie File')) {
        finalContent = `# Netscape HTTP Cookie File\n${finalContent}`;
      }

      fs.writeFileSync(filePath, finalContent, { encoding: 'utf-8' });
      cookieFiles.push(filePath);
      logger.info('cookie_manager', { msg: `Loaded cookie from ${key}` });

      // Generate HTTP cookie header string for APIs like youtubei.js
      if (!rawCookieString) {
        const cookies = [];
        finalContent.split('\n').forEach(line => {
          if (line.startsWith('#') || !line.trim()) return;
          const parts = line.split('\t');
          if (parts.length >= 7) {
            cookies.push(`${parts[5]}=${parts[6].trim()}`);
          }
        });
        if (cookies.length > 0) {
          rawCookieString = cookies.join('; ');
        }
      }
      
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

function getCookieString() {
  return rawCookieString;
}

module.exports = { init, getRandomCookieFile, getCookieString };
