import XCTest
@testable import StarCraftKit

final class CachePolicyTests: XCTestCase {
    func testCachePolicyEquality() {
        XCTAssertEqual(CachePolicy.noCache, CachePolicy.noCache)
        XCTAssertEqual(CachePolicy.useCache(ttl: 300), CachePolicy.useCache(ttl: 300))
        XCTAssertEqual(CachePolicy.cacheForever, CachePolicy.cacheForever)
        
        XCTAssertNotEqual(CachePolicy.noCache, CachePolicy.cacheForever)
        XCTAssertNotEqual(CachePolicy.useCache(ttl: 300), CachePolicy.useCache(ttl: 600))
    }
}