import XCTest

@testable import StarCraftKit

final class StarCraftAPI_Tests: XCTestCase {

    func testAllPlayers() async throws {
        guard let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            fatalError("PANDA_TOKEN environment variable not set")
        }
        let api = StarCraftAPI(token: token)
        let players = try await api.allPlayers()
        XCTAssertFalse(players.isEmpty)

        let player = players.first!
        XCTAssertNotNil(player.id)
        XCTAssertNotNil(player.firstName)
        XCTAssertNotNil(player.lastName)
        XCTAssertNotNil(player.name)
    }

    func testAllMatches() async throws {
        guard let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            fatalError("PANDA_TOKEN environment variable not set")
        }
        let api = StarCraftAPI(token: token)
        let matches = try await api.allMatches()
        XCTAssertFalse(matches.isEmpty)

        let match = matches.first!
        XCTAssertNotNil(match.id)
    }
    
    func testAllTournaments() async throws {
        guard let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            fatalError("PANDA_TOKEN environment variable not set")
        }
        let api = StarCraftAPI(token: token)
        let tournaments = try await api.allTournaments()
        XCTAssertFalse(tournaments.isEmpty)

        let tournament = tournaments.first!
        XCTAssertNotNil(tournament.id)
        XCTAssertNotNil(tournament.name)
    }
}
