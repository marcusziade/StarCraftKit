import XCTest
@testable import StarCraftKit

final class RetryConfigurationTests: XCTestCase {
    func testDefaultConfiguration() {
        let config = RetryConfiguration.default
        
        XCTAssertEqual(config.maxAttempts, 3)
        XCTAssertEqual(config.initialDelay, 1.0)
        XCTAssertEqual(config.maxDelay, 60.0)
        XCTAssertEqual(config.backoffMultiplier, 2.0)
        XCTAssertEqual(config.jitterRange, 0.8...1.2)
    }
    
    func testAggressiveConfiguration() {
        let config = RetryConfiguration.aggressive
        
        XCTAssertEqual(config.maxAttempts, 5)
        XCTAssertEqual(config.initialDelay, 0.5)
        XCTAssertEqual(config.maxDelay, 30.0)
        XCTAssertEqual(config.backoffMultiplier, 1.5)
    }
    
    func testConservativeConfiguration() {
        let config = RetryConfiguration.conservative
        
        XCTAssertEqual(config.maxAttempts, 2)
        XCTAssertEqual(config.initialDelay, 2.0)
        XCTAssertEqual(config.maxDelay, 10.0)
        XCTAssertEqual(config.backoffMultiplier, 2.0)
    }
    
    func testCustomConfiguration() {
        let config = RetryConfiguration(
            maxAttempts: 10,
            initialDelay: 0.1,
            maxDelay: 120.0,
            backoffMultiplier: 3.0,
            jitterRange: 0.5...1.5
        )
        
        XCTAssertEqual(config.maxAttempts, 10)
        XCTAssertEqual(config.initialDelay, 0.1)
        XCTAssertEqual(config.maxDelay, 120.0)
        XCTAssertEqual(config.backoffMultiplier, 3.0)
        XCTAssertEqual(config.jitterRange, 0.5...1.5)
    }
}