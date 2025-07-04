import XCTest
@testable import StarCraftKitCLI

final class UIEnhancementsTests: XCTestCase {
    
    // MARK: - Country Flag Tests
    
    func testCountryFlagKnownCountries() {
        XCTAssertEqual(CountryFlag.flag(for: "Korea"), "🇰🇷")
        XCTAssertEqual(CountryFlag.flag(for: "South Korea"), "🇰🇷")
        XCTAssertEqual(CountryFlag.flag(for: "KR"), "🇰🇷")
        XCTAssertEqual(CountryFlag.flag(for: "United States"), "🇺🇸")
        XCTAssertEqual(CountryFlag.flag(for: "USA"), "🇺🇸")
        XCTAssertEqual(CountryFlag.flag(for: "Germany"), "🇩🇪")
        XCTAssertEqual(CountryFlag.flag(for: "Finland"), "🇫🇮")
        XCTAssertEqual(CountryFlag.flag(for: "Canada"), "🇨🇦")
    }
    
    func testCountryFlagUnknownCountry() {
        XCTAssertEqual(CountryFlag.flag(for: "Unknown Country"), "🌍")
        XCTAssertEqual(CountryFlag.flag(for: "XYZ"), "🌍")
    }
    
    func testCountryFlagNilCountry() {
        XCTAssertEqual(CountryFlag.flag(for: nil), "🌍")
    }
    
    // MARK: - Color Tests
    
    func testColorFormatting() {
        let text = "Hello"
        
        // Test that colored strings contain ANSI codes
        XCTAssertTrue(text.red.contains("\u{001B}[31m"))
        XCTAssertTrue(text.red.contains("\u{001B}[0m"))
        
        XCTAssertTrue(text.green.contains("\u{001B}[32m"))
        XCTAssertTrue(text.yellow.contains("\u{001B}[33m"))
        XCTAssertTrue(text.blue.contains("\u{001B}[34m"))
        
        // Test bold
        XCTAssertTrue(text.bold().contains("\u{001B}[1m"))
    }
    
    // MARK: - Time Formatting Tests
    
    func testRelativeTimeFuture() {
        let now = Date()
        
        // Test seconds - use range to handle timing differences
        let in30Seconds = now.addingTimeInterval(30)
        let relativeTime30s = in30Seconds.relativeTime
        XCTAssertTrue(relativeTime30s == "in 30s" || relativeTime30s == "in 29s")
        
        // Test minutes - use range to handle timing differences
        let in5Minutes = now.addingTimeInterval(5 * 60)
        let relativeTime5m = in5Minutes.relativeTime
        XCTAssertTrue(relativeTime5m == "in 5m" || relativeTime5m == "in 4m")
        
        // Test hours - use range to handle timing differences
        let in2Hours = now.addingTimeInterval(2 * 3600)
        let relativeTime2h = in2Hours.relativeTime
        XCTAssertTrue(relativeTime2h == "in 2h" || relativeTime2h == "in 1h")
        
        // Test days - use range to handle timing differences
        let in3Days = now.addingTimeInterval(3 * 86400)
        let relativeTime3d = in3Days.relativeTime
        XCTAssertTrue(relativeTime3d == "in 3d" || relativeTime3d == "in 2d")
    }
    
    func testRelativeTimePast() {
        let now = Date()
        
        // Test seconds
        let ago30Seconds = now.addingTimeInterval(-30)
        XCTAssertEqual(ago30Seconds.relativeTime, "30s ago")
        
        // Test minutes
        let ago5Minutes = now.addingTimeInterval(-5 * 60)
        XCTAssertEqual(ago5Minutes.relativeTime, "5m ago")
        
        // Test hours
        let ago2Hours = now.addingTimeInterval(-2 * 3600)
        XCTAssertEqual(ago2Hours.relativeTime, "2h ago")
        
        // Test days
        let ago3Days = now.addingTimeInterval(-3 * 86400)
        XCTAssertEqual(ago3Days.relativeTime, "3d ago")
    }
    
    func testDateFormatting() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let testDate = formatter.date(from: "2024-01-15 14:30:00")!
        
        // Set expected format
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        XCTAssertEqual(testDate.timeOnly, timeFormatter.string(from: testDate))
        XCTAssertEqual(testDate.dateOnly, dateFormatter.string(from: testDate))
    }
    
    func testIsToday() {
        let now = Date()
        XCTAssertTrue(now.isToday)
        
        let yesterday = now.addingTimeInterval(-86400)
        XCTAssertFalse(yesterday.isToday)
        
        let tomorrow = now.addingTimeInterval(86400)
        XCTAssertFalse(tomorrow.isToday)
    }
    
    func testIsTomorrow() {
        let now = Date()
        XCTAssertFalse(now.isTomorrow)
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: now))!
        XCTAssertTrue(tomorrow.isTomorrow)
    }
    
    // MARK: - Match Status Tests
    
    func testMatchStatusFormatting() {
        let running = String.matchStatus("running")
        XCTAssertTrue(running.contains("LIVE"))
        XCTAssertTrue(running.contains("●"))
        
        let notStarted = String.matchStatus("not_started")
        XCTAssertTrue(notStarted.contains("Upcoming"))
        XCTAssertTrue(notStarted.contains("◯"))
        
        let finished = String.matchStatus("finished")
        XCTAssertTrue(finished.contains("Finished"))
        XCTAssertTrue(finished.contains("✓"))
    }
    
    // MARK: - Table Formatter Tests
    
    func testTableDivider() {
        let divider = TableFormatter.divider(50)
        XCTAssertEqual(divider.count, 50)
        XCTAssertTrue(divider.allSatisfy { $0 == "─" })
    }
    
    func testTableHeader() {
        let header = TableFormatter.header("TEST", width: 20)
        XCTAssertTrue(header.contains("TEST"))
        XCTAssertTrue(header.contains("┌"))
        XCTAssertTrue(header.contains("┐"))
    }
    
    func testTableFooter() {
        let footer = TableFormatter.footer(width: 20)
        XCTAssertEqual(footer.count, 20)
        XCTAssertTrue(footer.hasPrefix("└"))
        XCTAssertTrue(footer.hasSuffix("┘"))
    }
    
    func testTableTruncate() {
        let short = TableFormatter.truncate("Hello", to: 10)
        XCTAssertEqual(short, "Hello     ")
        XCTAssertEqual(short.count, 10)
        
        let long = TableFormatter.truncate("This is a very long string", to: 10)
        XCTAssertEqual(long, "This is...")
        XCTAssertEqual(long.count, 10)
    }
    
    // MARK: - Progress Bar Tests
    
    func testProgressBar() {
        let empty = ProgressBar.create(current: 0, total: 10, width: 10)
        XCTAssertEqual(empty, "[░░░░░░░░░░] 0%")
        
        let half = ProgressBar.create(current: 5, total: 10, width: 10)
        XCTAssertEqual(half, "[█████░░░░░] 50%")
        
        let full = ProgressBar.create(current: 10, total: 10, width: 10)
        XCTAssertEqual(full, "[██████████] 100%")
        
        let zeroTotal = ProgressBar.create(current: 0, total: 0, width: 10)
        XCTAssertEqual(zeroTotal, "")
    }
    
    // MARK: - Race Icon Tests
    
    func testRaceIcons() {
        XCTAssertEqual(RaceIcon.icon(for: "terran"), "T")
        XCTAssertEqual(RaceIcon.icon(for: "Terran"), "T")
        XCTAssertEqual(RaceIcon.icon(for: "protoss"), "P")
        XCTAssertEqual(RaceIcon.icon(for: "zerg"), "Z")
        XCTAssertEqual(RaceIcon.icon(for: "random"), "R")
        XCTAssertEqual(RaceIcon.icon(for: "unknown"), "?")
        XCTAssertEqual(RaceIcon.icon(for: nil), "?")
    }
    
    // MARK: - Prize Pool Tests
    
    func testPrizePoolFormatting() {
        let small = 1000.formattedPrize
        XCTAssertTrue(small.contains("1"))
        XCTAssertTrue(small.contains("000"))
        
        let large = 100000.formattedPrize
        XCTAssertTrue(large.contains("100"))
        XCTAssertTrue(large.contains("000"))
    }
    
    // MARK: - Stream Formatter Tests
    
    func testStreamFormatting() {
        let twitch = StreamFormatter.formatStreamLink("https://twitch.tv/example")
        XCTAssertTrue(twitch.contains("Twitch"))
        XCTAssertTrue(twitch.contains("📺"))
        
        let youtube = StreamFormatter.formatStreamLink("https://youtube.com/watch?v=123")
        XCTAssertTrue(youtube.contains("YouTube"))
        XCTAssertTrue(youtube.contains("📺"))
        
        let youtubeShort = StreamFormatter.formatStreamLink("https://youtu.be/123")
        XCTAssertTrue(youtubeShort.contains("YouTube"))
        
        let other = StreamFormatter.formatStreamLink("https://example.com/stream")
        XCTAssertTrue(other.contains("Stream"))
        XCTAssertTrue(other.contains("📺"))
        
        let noStream = StreamFormatter.formatStreamLink(nil)
        XCTAssertEqual(noStream, "No stream")
    }
}