const { createError } = require('./errorResponse');

/**
 * Validate user profile creation (called after Firebase Auth signup).
 */
function profileCreate({ name }) {
  if (!name || !name.trim()) {
    throw createError(400, 'VALIDATION_ERROR', 'Name is required');
  }
  if (name.trim().length > 100) {
    throw createError(400, 'VALIDATION_ERROR', 'Name must be 100 characters or less');
  }
}

/**
 * Validate a track before adding to playlist or stats write.
 */
function track({ videoId, title, artist, duration }) {
  if (!videoId || !videoId.trim()) {
    throw createError(400, 'INVALID_VIDEO_ID', 'videoId is required');
  }
  if (!title || !title.trim()) {
    throw createError(400, 'VALIDATION_ERROR', 'title is required');
  }
  if (!artist || !artist.trim()) {
    throw createError(400, 'VALIDATION_ERROR', 'artist is required');
  }
  if (duration !== undefined && (typeof duration !== 'number' || duration <= 0)) {
    throw createError(400, 'VALIDATION_ERROR', 'duration must be a positive number');
  }
}

/**
 * Validate playlist creation body.
 */
function playlist({ name }) {
  if (!name || !name.trim()) {
    throw createError(400, 'INVALID_PLAYLIST_NAME', 'Playlist name is required');
  }
  if (name.trim().length > 100) {
    throw createError(400, 'INVALID_PLAYLIST_NAME', 'Playlist name must be 100 characters or less');
  }
}

/**
 * Validate reorder payload.
 */
function reorder(tracks) {
  if (!Array.isArray(tracks) || tracks.length === 0) {
    throw createError(400, 'INVALID_ORDER', 'tracks array is required');
  }
  tracks.forEach((t, i) => {
    if (!t.trackId) {
      throw createError(400, 'INVALID_ORDER', `tracks[${i}].trackId is required`);
    }
    if (typeof t.newOrder !== 'number') {
      throw createError(400, 'INVALID_ORDER', `tracks[${i}].newOrder must be a number`);
    }
  });
}

/**
 * Validate stats play event.
 */
function statsPlay({ videoId, secondsListened, date }) {
  if (!videoId || !videoId.trim()) {
    throw createError(400, 'INVALID_VIDEO_ID', 'videoId is required');
  }
  if (typeof secondsListened !== 'number' || secondsListened < 0) {
    throw createError(400, 'INVALID_SECONDS', 'secondsListened must be a non-negative number');
  }
  if (!date || !/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    throw createError(400, 'VALIDATION_ERROR', 'date must be in YYYY-MM-DD format');
  }
}

/**
 * Validate stats period query param.
 */
function statsPeriod(period) {
  const valid = ['day', 'week', 'month', 'year', 'lifetime'];
  if (!valid.includes(period)) {
    throw createError(400, 'INVALID_PERIOD', `period must be one of: ${valid.join(', ')}`);
  }
}

/**
 * Validate settings update body.
 */
function settings(body) {
  const qualityValues = ['auto', 'low', 'medium', 'high', 'lossless'];
  const downloadValues = ['low', 'medium', 'high', 'lossless'];

  if (body.streamingQuality !== undefined && !qualityValues.includes(body.streamingQuality)) {
    throw createError(400, 'INVALID_QUALITY', `streamingQuality must be one of: ${qualityValues.join(', ')}`);
  }
  if (body.downloadQuality !== undefined && !downloadValues.includes(body.downloadQuality)) {
    throw createError(400, 'INVALID_QUALITY', `downloadQuality must be one of: ${downloadValues.join(', ')}`);
  }
  if (body.dataSaverMode !== undefined && typeof body.dataSaverMode !== 'boolean') {
    throw createError(400, 'VALIDATION_ERROR', 'dataSaverMode must be a boolean');
  }
  if (
    body.crossfadeDuration !== undefined &&
    (typeof body.crossfadeDuration !== 'number' || body.crossfadeDuration < 0 || body.crossfadeDuration > 12)
  ) {
    throw createError(400, 'VALIDATION_ERROR', 'crossfadeDuration must be a number between 0 and 12');
  }
}

/**
 * Validate collaborators array.
 */
function collaborators({ userIds }) {
  if (!Array.isArray(userIds) || userIds.length === 0) {
    throw createError(400, 'VALIDATION_ERROR', 'userIds array is required');
  }
  userIds.forEach((id, i) => {
    if (typeof id !== 'string' || !id.trim()) {
      throw createError(400, 'VALIDATION_ERROR', `userIds[${i}] must be a non-empty string`);
    }
  });
}

module.exports = {
  profileCreate,
  track,
  playlist,
  reorder,
  statsPlay,
  statsPeriod,
  settings,
  collaborators,
};
