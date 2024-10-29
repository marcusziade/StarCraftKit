import Foundation
import StarCraftKit

struct LiveTournamentsCommand: Command {
    let api: StarCraftAPI

    var description: String {
        return "Fetch tournaments with live support"
    }

    func execute() async throws {
        let response = try await api.allTournaments()
        let liveSupported = response.liveSupportedTournaments
        print("\(ANSIColor.protoss)Live Supported Tournaments: \(liveSupported.count)\(ANSIColor.reset)")
    }
}
