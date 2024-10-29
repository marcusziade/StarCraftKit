import Foundation
import StarCraftKit

struct ActivePlayersCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Fetch active players"
    }
    
    func execute() async throws {
        let response = try await api.allPlayers().activePlayers
        print("\(ANSIColor.terran)Active Players:\(ANSIColor.reset)")
        response.forEach { player in
            print("\(ANSIColor.neon)➤\(ANSIColor.reset) \(player.name)")
        }
    }
}
