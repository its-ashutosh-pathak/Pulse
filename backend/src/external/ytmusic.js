/**
 * ytmusic.js — Public interface for YouTube Music metadata.
 * Now backed by the pure-Node ytmusic.wrapper.js — no Python sidecar required.
 * All call sites in services are unchanged; only this shim changes.
 */
const wrapper = require('./ytmusic.wrapper');

module.exports = {
  getHome:        ()            => wrapper.getHome(),
  search:         (q, type)    => wrapper.search(q, type),
  getSuggestions: (q)          => wrapper.getSuggestions(q),
  getArtist:      (browseId)   => wrapper.getArtist(browseId),
  getLyrics:      (videoId)    => wrapper.getLyrics(videoId),
  getWatchNext:   (videoId)    => wrapper.getWatchNext(videoId),
  getPlaylist:    (playlistId) => wrapper.getPlaylist(playlistId),
  resolve:        (id)         => wrapper.resolve(id),
};
