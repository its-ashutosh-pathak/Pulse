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
    try {
      const { Innertube, UniversalCache, Parser } = await import('youtubei.js');

      // Suppress noisy InnertubeError warnings for unknown parser nodes
      if (Parser && typeof Parser.setParserErrorHandler === 'function') {
        Parser.setParserErrorHandler((err) => {
          if (err?.message?.includes('not found')) return;
          console.warn('[youtubei.js parser]', err?.message || err);
        });
      }

      const cookieManager = require('../utils/cookieManager');
      const cookieStr = typeof cookieManager.getCookieString === 'function' ? cookieManager.getCookieString() : undefined;

      // Use clean standard Web client for Housekeeping/Search (most stable)
      _instance = await Innertube.create({
        cache: null,
        generate_session_locally: true,
        cookie: cookieStr
      });
      return _instance;
    } catch (e) {
      _initPromise = null; // Self-healing: clear on fail so we can retry fresh
      throw e;
    }
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
