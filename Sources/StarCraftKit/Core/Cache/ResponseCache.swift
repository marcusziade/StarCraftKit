import Foundation
import Logging

/// Thread-safe response cache using actors
public actor ResponseCache {
    private struct CacheEntry {
        let data: Data
        let headers: [String: String]
        let expiryDate: Date
        
        var isExpired: Bool {
            Date() > expiryDate
        }
    }
    
    private var cache: [String: CacheEntry] = [:]
    private let maxCacheSize: Int
    private let logger: Logger
    
    /// Statistics
    private var hitCount = 0
    private var missCount = 0
    
    public init(
        maxCacheSize: Int = 100,
        logger: Logger = Logger(label: "StarCraftKit.ResponseCache")
    ) {
        self.maxCacheSize = maxCacheSize
        self.logger = logger
    }
    
    /// Get cached response
    public func get<T: Decodable>(
        for key: String,
        type: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> (data: T, headers: [String: String])? {
        guard let entry = cache[key], !entry.isExpired else {
            missCount += 1
            logger.debug("Cache miss for key: \(key)")
            return nil
        }
        
        do {
            let decodedData = try decoder.decode(T.self, from: entry.data)
            hitCount += 1
            logger.debug("Cache hit for key: \(key)")
            return (decodedData, entry.headers)
        } catch {
            logger.error("Failed to decode cached data: \(error)")
            cache.removeValue(forKey: key)
            throw APIError.cacheError(underlying: error)
        }
    }
    
    /// Store response in cache
    public func set<T: Encodable>(
        _ data: T,
        headers: [String: String],
        for key: String,
        ttl: TimeInterval,
        encoder: JSONEncoder = JSONEncoder()
    ) async throws {
        do {
            let encodedData = try encoder.encode(data)
            let expiryDate = Date().addingTimeInterval(ttl)
            
            cache[key] = CacheEntry(
                data: encodedData,
                headers: headers,
                expiryDate: expiryDate
            )
            
            logger.debug("Cached response for key: \(key), TTL: \(ttl)s")
            
            await evictIfNeeded()
        } catch {
            logger.error("Failed to encode data for caching: \(error)")
            throw APIError.cacheError(underlying: error)
        }
    }
    
    /// Clear expired entries
    public func clearExpired() async {
        let before = cache.count
        cache = cache.filter { !$0.value.isExpired }
        let removed = before - cache.count
        
        if removed > 0 {
            logger.info("Removed \(removed) expired cache entries")
        }
    }
    
    /// Clear all cache entries
    public func clearAll() async {
        cache.removeAll()
        logger.info("Cleared all cache entries")
    }
    
    /// Get cache statistics
    public func getStatistics() -> CacheStatistics {
        CacheStatistics(
            hitCount: hitCount,
            missCount: missCount,
            currentSize: cache.count,
            hitRate: hitCount > 0 ? Double(hitCount) / Double(hitCount + missCount) : 0
        )
    }
    
    private func evictIfNeeded() async {
        guard cache.count > maxCacheSize else { return }
        
        let sortedEntries = cache.sorted { $0.value.expiryDate < $1.value.expiryDate }
        let entriesToRemove = sortedEntries.prefix(cache.count - maxCacheSize)
        
        for (key, _) in entriesToRemove {
            cache.removeValue(forKey: key)
        }
        
        logger.debug("Evicted \(entriesToRemove.count) cache entries")
    }
}

/// Cache statistics
public struct CacheStatistics: Sendable {
    public let hitCount: Int
    public let missCount: Int
    public let currentSize: Int
    public let hitRate: Double
}