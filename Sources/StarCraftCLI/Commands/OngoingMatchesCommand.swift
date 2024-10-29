import Foundation
import StarCraftKit

struct OngoingMatchesCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Fetch ongoing matches"
    }
    
    func execute() async throws {
        let response = try await api.allMatches()
        let ongoingMatches = response.ongoingMatches
        print("\(ANSIColor.zerg)Ongoing Matches: \(ongoingMatches.count)\(ANSIColor.reset)")
    }
}
