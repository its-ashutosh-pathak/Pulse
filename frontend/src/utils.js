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
    if (url.includes('googleusercontent.com') || url.includes('ggpht.com')) {
      if (url.includes('=w') && url.includes('-c')) return url;
      let newUrl = url.replace(/([=])w\d+-h\d+/, `$1w${size}-h${size}`);
      if (newUrl === url) {
        newUrl = url.replace(/([=])s\d+/, `$1s${size}`);
      }
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
