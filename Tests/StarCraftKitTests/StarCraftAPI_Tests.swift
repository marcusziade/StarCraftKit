import XCTest

@testable import StarCraftKit

final class StarCraftAPI_Tests: XCTestCase {

    func testAllPlayers() async throws {
        guard let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            fatalError("PANDA_TOKEN environment variable not set")
        }
        let api = StarCraftAPI(token: token)
        let response = try await api.allPlayers()
        XCTAssertFalse(response.players.isEmpty)

        let player = response.players.first!
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
        let response = try await api.allMatches()
        XCTAssertFalse(response.matches.isEmpty)

        let match = response.matches.first!
        XCTAssertNotNil(match.id)
    }
    
    func testAllTournaments() async throws {
        guard let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            fatalError("PANDA_TOKEN environment variable not set")
        }
        let api = StarCraftAPI(token: token)
        let response = try await api.allTournaments()
        XCTAssertFalse(response.tournaments.isEmpty)

        let tournament = response.tournaments.first!
        XCTAssertNotNil(tournament.id)
        XCTAssertNotNil(tournament.name)
    }
}
