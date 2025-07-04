import XCTest
@testable import StarCraftKitCLI

final class ExtensionsTests: XCTestCase {
    
    // MARK: - Duration Formatting Tests
    
    func testFormattedDuration() {
        // Test minutes only
        XCTAssertEqual(300.formattedDuration, "5m 00s")
        XCTAssertEqual(1800.formattedDuration, "30m 00s")
        XCTAssertEqual(3540.formattedDuration, "59m 00s")
        
        // Test hours and minutes
        XCTAssertEqual(3600.formattedDuration, "1h 00m")
        XCTAssertEqual(3660.formattedDuration, "1h 01m")
        XCTAssertEqual(7200.formattedDuration, "2h 00m")
        XCTAssertEqual(7830.formattedDuration, "2h 10m")
        
        // Test edge cases
        XCTAssertEqual(0.formattedDuration, "0s")
        XCTAssertEqual(59.formattedDuration, "59s")
        XCTAssertEqual(60.formattedDuration, "1m 00s")
    }
    
    // MARK: - Array Safe Subscript Tests
    
    func testSafeSubscript() {
        let array = [1, 2, 3, 4, 5]
        
        // Valid indices
        XCTAssertEqual(array[safe: 0], 1)
        XCTAssertEqual(array[safe: 2], 3)
        XCTAssertEqual(array[safe: 4], 5)
        
        // Invalid indices
        XCTAssertNil(array[safe: -1])
        XCTAssertNil(array[safe: 5])
        XCTAssertNil(array[safe: 100])
        
        // Empty array
        let empty: [Int] = []
        XCTAssertNil(empty[safe: 0])
    }
    
    
    // MARK: - Date Formatting Tests
    
    func testDateFormattedString() {
        let date = Date(timeIntervalSince1970: 1705320000) // 2024-01-15 12:00:00 UTC
        let formatted = date.formattedString
        
        // Just check that it's not empty and contains some expected patterns
        XCTAssertFalse(formatted.isEmpty)
        XCTAssertTrue(formatted.contains("24") || formatted.contains("2024")) // Year
    }
    
    func testIntFormattedString() {
        XCTAssertEqual(1000.formattedString, "1,000")
        XCTAssertEqual(1000000.formattedString, "1,000,000")
        XCTAssertEqual(123.formattedString, "123")
        XCTAssertEqual(0.formattedString, "0")
        XCTAssertEqual((-1000).formattedString, "-1,000")
    }
}