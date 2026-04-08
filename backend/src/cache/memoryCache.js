/**
 * Shared in-memory cache using a Map.
 * Single instance (module singleton) shared across all services.
 * Cache is cleared on process restart — acceptable for this scale.
 */
class MemoryCache {
  constructor() {
    this._store = new Map();
  }

  /**
   * Store a value with a TTL in milliseconds.
   */
  set(key, value, ttlMs) {
    this._store.set(key, {
      value,
      expiry: Date.now() + ttlMs,
    });
  }

  /**
   * Retrieve a value. Returns null if missing or expired.
   */
  get(key) {
    const entry = this._store.get(key);
    if (!entry) return null;
    if (Date.now() > entry.expiry) {
      this._store.delete(key);
      return null;
    }
    return entry.value;
  }

  /**
   * Remove a specific key.
   */
  delete(key) {
    this._store.delete(key);
  }

  /**
   * Check if a key exists and is not expired.
   */
  has(key) {
    return this.get(key) !== null;
  }

  /**
   * Number of entries (including potentially expired ones not yet pruned).
   */
  get size() {
    return this._store.size;
  }
}

module.exports = new MemoryCache(); // singleton
