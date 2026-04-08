/**
 * getHighResThumb — safely upgrades a YouTube/Google thumbnail URL to higher resolution.
 * Designed to be non-destructive: if parsing fails, returns the original URL.
 */
export const getHighResThumb = (url, size = 500) => {
  if (!url || typeof url !== 'string') return '';

  // Force HTTPS
  url = url.replace('http://', 'https://');

  try {
    // Handle lh3.googleusercontent.com / ggpht.com (YouTube Music art)
    // These use a param-based sizing system like =w226-h226-l90-rj
    if (url.includes('lh3.googleusercontent.com') || url.includes('ggpht.com')) {
      // Replace the sizing params (w, h) at the end of the URL
      // but ONLY if they look like the standard =wNNN-hNNN pattern
      // Strip -lNNN (dimension limiter that causes zoom glitches)
      let newUrl = url;

      // Replace =wXXX-hXXX... pattern (the = prefix variant)
      newUrl = newUrl.replace(/=w\d+-h\d+(-[a-z0-9-]+)?/, `=w${size}-h${size}-rj`);

      // Also handle -sXXX standalone size
      if (newUrl === url) {
        newUrl = newUrl.replace(/([=-])s\d+(-[a-z0-9]+)*$/, `$1s${size}`);
      }

      // Strip harmful -lNNN limiters and clean up double dashes
      newUrl = newUrl.replace(/-l\d+/g, '').replace(/--+/g, '-');

      return newUrl;
    }

    // Handle i.ytimg.com thumbnails (YouTube video thumbs)
    // maxresdefault is great but often missing; hqdefault has black bars; mqdefault is clean
    if (url.includes('i.ytimg.com')) {
      if (url.includes('maxresdefault')) return url;
      if (url.includes('hqdefault')) return url.replace('hqdefault', 'mqdefault');
      return url;
    }

    // Handle YouTube Music thumbnails with /vi/ path (older format)
    if (url.includes('ytimg.com') && url.includes('/vi/')) {
      return url.replace(/\/(default|mqdefault|hqdefault|sddefault)\.jpg/, '/hqdefault.jpg');
    }

  } catch {
    // If any parsing fails, return original
  }

  return url;
};
