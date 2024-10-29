import Foundation
import StarCraftKit

// Command to show player details
struct PlayerDetailsCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Show active players with detailed information"
    }
    
    func execute() async throws {
        let response = try await api.allPlayers()
        let players = response.activePlayers.sorted { $0.name < $1.name }
        
        print("\(ANSIColor.protoss)Active Players:\(ANSIColor.reset)\n")
        
        for player in players {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Name:\(ANSIColor.reset)         \(player.name)")
            if let firstName = player.firstName, let lastName = player.lastName {
                print("\(ANSIColor.terran)Full Name:\(ANSIColor.reset)    \(firstName) \(lastName)")
            }
            if let age = player.age {
                print("\(ANSIColor.terran)Age:\(ANSIColor.reset)          \(age)")
            }
            if let nationality = player.nationality {
                print("\(ANSIColor.terran)Nationality:\(ANSIColor.reset)  \(nationality)")
            }
            if let role = player.role {
                print("\(ANSIColor.terran)Role:\(ANSIColor.reset)         \(role)")
            }
            if let currentGame = player.currentVideogame {
                print("\(ANSIColor.terran)Current Game:\(ANSIColor.reset) \(currentGame.name)")
            }
            print("\(ANSIColor.terran)Last Update:\(ANSIColor.reset)  \(DateFormatter.prettyFormatter.string(from: player.modifiedAt))")
            print()
        }
    }
}
