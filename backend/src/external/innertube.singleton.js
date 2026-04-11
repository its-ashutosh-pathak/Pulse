/**
 * innertube.singleton.js — Single shared Innertube instance.
 * Used by BOTH:
 *   - innertube.js  (stream URL extraction)
 *   - ytmusic.wrapper.js  (music metadata: home, search, artist, etc.)
 * Creating Innertube.create() is expensive (~500ms), so we share one instance.
 */

let _instance = null;
let _initPromise = null;

/**
 * Lazily create and return the shared Innertube instance.
 * Concurrent callers share the same in-flight promise — only one creation.
 */
async function getInstance() {
  if (_instance) return _instance;
  if (_initPromise) return _initPromise;

  _initPromise = (async () => {
    const { Innertube } = await import('youtubei.js');
    const cookieManager = require('../utils/cookieManager');
    const cookieFile = cookieManager.getRandomCookieFile();
    let cookieContent = '';
    
    if (cookieFile) {
      const fs = require('fs');
      cookieContent = fs.readFileSync(cookieFile, 'utf-8');
    }

    _instance = await Innertube.create({
      cache: null,
      generate_session_locally: true,
      ...(cookieContent ? { cookie: cookieContent } : {}),
    });
    return _instance;
  })();

  return _initPromise;
}

/**
 * Warm up the instance at server startup so the first real request is fast.
 * Call this from index.js but don't await in the critical path.
 */
function warmUp() {
  getInstance().catch(() => {}); // fire and forget
}

module.exports = { getInstance, warmUp };
