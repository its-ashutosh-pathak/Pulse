/**
 * Normalizes any song/track from any source into the standard Pulse format.
 */

function sanitizeThumb(url) {
  if (!url || typeof url !== 'string') return '';
  return url.replace('http://', 'https://');
}

/**
 * Normalize a raw ytmusicapi track (from Python sidecar) into Pulse song format.
 */
function normalizeSong(raw) {
  const videoId = raw.videoId || raw.id || '';
  const thumbUrl = sanitizeThumb(
    raw.thumbnail || raw.cover || raw.artworkUrl || ''
  );
  return {
    videoId,
    id:          videoId,                 // alias
    title:       raw.title   || 'Unknown',
    artist:      raw.artist  || raw.author || 'Unknown',
    album:       raw.album   || '',
    thumbnail:   thumbUrl,                 // canonical field
    cover:       thumbUrl,                 // legacy alias kept for compatibility
    duration:    raw.duration || 0,
    spotifyId:   raw.spotifyId || null,
    isAvailable: raw.isAvailable !== false,
    browseId:    raw.browseId   || '',
    playlistId:  raw.playlistId || '',
    albumBrowseId:  raw.albumBrowseId  || '',
    artistBrowseId: raw.artistBrowseId || '',
    type:        raw.type       || 'SONG',
  };
}

/**
 * Build the artistKey (safe Firestore document ID from artist name).
 * Lowercase, spaces → underscores, strip special chars.
 */
function toArtistKey(artist) {
  return (artist || 'unknown')
    .toLowerCase()
    .replace(/\s+/g, '_')
    .replace(/[^a-z0-9_]/g, '')
    .slice(0, 100);
}

/**
 * Default user settings object — returned when no Firestore doc exists yet.
 */
function defaultSettings() {
  return {
    streamingQuality:     'auto',
    downloadQuality:      'high',
    dataSaverMode:        false,
    crossfadeDuration:    0,
    normalizationEnabled: true,
    explicitContent:      true,
    language:             'en',
  };
}

module.exports = { normalizeSong, sanitizeThumb, toArtistKey, defaultSettings };
