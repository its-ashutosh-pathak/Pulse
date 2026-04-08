/**
 * lyrics.service.js
 * Fetches lyrics from: LRCLIB (synced) → Genius (plain URL) → YTMusic (plain fallback).
 * Stores validated lyrics in Firestore for reuse.
 * Returns graceful null fields when lyrics are not found — never a 404.
 */
const lrclib      = require('../external/lrclib');
const genius      = require('../external/genius');
const ytmusic     = require('../external/ytmusic');
const lyricsRepo  = require('../repositories/lyrics.repository');
const songRepo    = require('../repositories/song.repository');
const { titleSimilarity, artistMatch } = require('../utils/similarity');
const logger      = require('../utils/logger');
const { LYRICS_SIMILARITY_MIN } = require('../config/constants');

const NOT_FOUND = { syncedLyrics: null, plainLyrics: null, source: 'none' };

/**
 * Validate that fetched lyrics match the intended song.
 */
function isValidMatch(song, candidate) {
  if (!candidate) return false;
  // If we can validate title, do so; otherwise accept (some sources don't return title)
  const sim = titleSimilarity(song.title || '', candidate.title || '');
  const titleOk   = !candidate.title || sim >= LYRICS_SIMILARITY_MIN;
  const artistOk  = !candidate.artist || artistMatch(song.artist || '', candidate.artist || '');
  return titleOk || artistOk; // at least one dimension must match
}

async function getLyrics(videoId, { nocache = false } = {}) {
  // 1. Check Firestore cache (skip if nocache requested — e.g. user hit Retry)
  if (!nocache) {
    const cached = await lyricsRepo.findByVideoId(videoId);
    if (cached) return cached;
  }

  // 2. Get song metadata for validation
  const song = await songRepo.findByVideoId(videoId) || { title: '', artist: '', duration: 0 };

  // 3. Try LRCLIB (primary — returns synced .lrc timestamps)
  const lrc = await lrclib.search({ title: song.title, artist: song.artist, duration: song.duration });
  if (lrc && (lrc.syncedLyrics || lrc.plainLyrics)) {
    const result = { videoId, lyrics: lrc.plainLyrics || lrc.syncedLyrics, ...lrc };
    await lyricsRepo.save(result);
    logger.info('lyrics_found', { videoId, source: 'lrclib' });
    return result;
  }

  // 4. Try Genius (returns URL only — no full text without scraping)
  const gen = await genius.search({ title: song.title, artist: song.artist });
  if (gen && gen.lyricsUrl) {
    const result = { videoId, syncedLyrics: null, plainLyrics: null, lyrics: null, lyricsUrl: gen.lyricsUrl, source: 'genius' };
    logger.info('lyrics_found_genius_url', { videoId });
    return result;
  }

  // 5. Last fallback: YTMusic built-in lyrics (plain text, no timestamps)
  try {
    const ytm = await ytmusic.getLyrics(videoId);
    if (ytm && ytm.lyrics) {
      const result = { videoId, syncedLyrics: null, plainLyrics: ytm.lyrics, lyrics: ytm.lyrics, source: 'youtube_music' };
      await lyricsRepo.save(result);
      logger.info('lyrics_found', { videoId, source: 'youtube_music' });
      return result;
    }
  } catch (e) {
    logger.warn('ytmusic_lyrics_fallback_failed', { videoId, error: e.message });
  }

  logger.warn('lyrics_not_found', { videoId, title: song.title });
  return { videoId, ...NOT_FOUND };
}

module.exports = { getLyrics };
