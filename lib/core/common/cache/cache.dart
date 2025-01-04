class CacheManager {
  static final Map<String, dynamic> _cache = {};

  // Cache method
  static void cache(String key, dynamic value) {
    _cache[key] = value;
  }

  // Retrieve from cache
  static dynamic getCache(String key) {
    return _cache[key];
  }

  // Clear a specific cache item
  static void clearCache(String key) {
    _cache.remove(key);
  }

  // Clear all cache
  static void clearAllCache() {
    _cache.clear();
  }
}
