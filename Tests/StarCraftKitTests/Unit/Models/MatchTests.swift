import XCTest
@testable import StarCraftKit

final class MatchTests: XCTestCase {
    func testMatchStatus() {
        let pendingMatch = createMatch(status: .notStarted)
        XCTAssertTrue(pendingMatch.isPending)
        XCTAssertFalse(pendingMatch.isLive)
        XCTAssertFalse(pendingMatch.hasEnded)
        
        let liveMatch = createMatch(status: .running)
        XCTAssertFalse(liveMatch.isPending)
        XCTAssertTrue(liveMatch.isLive)
        XCTAssertFalse(liveMatch.hasEnded)
        
        let finishedMatch = createMatch(status: .finished)
        XCTAssertFalse(finishedMatch.isPending)
        XCTAssertFalse(finishedMatch.isLive)
        XCTAssertTrue(finishedMatch.hasEnded)
    }
    
    func testMatchDuration() {
        let beginDate = Date(timeIntervalSince1970: 1000)
        let endDate = Date(timeIntervalSince1970: 4600) // 1 hour later
        
        let matchWithDuration = Match(
            id: 1,
            name: "Test Match",
            slug: "test-match",
            status: .finished,
            tournamentID: 1,
            serieID: 1,
            beginAt: beginDate,
            endAt: endDate,
            numberOfGames: 3,
            games: [],
            opponents: [],
            results: [],
            winner: nil,
            winnerID: nil,
            live: nil,
            streams: [],
            modifiedAt: Date()
        )
        
        XCTAssertEqual(matchWithDuration.duration, 3600) // 1 hour in seconds
        
        let matchWithoutEndTime = createMatch(status: .running, beginAt: beginDate, endAt: nil)
        XCTAssertNil(matchWithoutEndTime.duration)
        
        let matchWithoutBeginTime = createMatch(status: .notStarted, beginAt: nil, endAt: nil)
        XCTAssertNil(matchWithoutBeginTime.duration)
    }
    
    func testMatchStatusEnum() {
        XCTAssertEqual(MatchStatus.notStarted.rawValue, "not_started")
        XCTAssertEqual(MatchStatus.running.rawValue, "running")
        XCTAssertEqual(MatchStatus.finished.rawValue, "finished")
    }
    
    // Helper function to create test matches
    private func createMatch(
        status: MatchStatus,
        beginAt: Date? = Date(),
        endAt: Date? = nil
    ) -> Match {
        Match(
            id: 1,
            name: "Test Match",
            slug: "test-match",
            status: status,
            tournamentID: 1,
            serieID: 1,
            beginAt: beginAt,
            endAt: endAt,
            numberOfGames: 3,
            games: [],
            opponents: [],
            results: [],
            winner: nil,
            winnerID: nil,
            live: nil,
            streams: [],
            modifiedAt: Date()
        )
    }
}