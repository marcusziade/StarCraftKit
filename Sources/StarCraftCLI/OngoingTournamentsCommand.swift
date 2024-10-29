import Foundation
import StarCraftKit

struct OngoingTournamentsCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Fetch ongoing tournaments"
    }
    
    func execute() async throws {
        let response = try await api.allTournaments()
        let ongoing = response.ongoingTournaments
        print("\(ANSIColor.protoss)Ongoing Tournaments: \(ongoing.count)\(ANSIColor.reset)")
    }
}
