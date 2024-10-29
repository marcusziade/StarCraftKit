import Foundation
import StarCraftKit

// Command to show player activity
struct PlayerActivityCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Show recent player activity"
    }
    
    func execute() async throws {
        let players = try await api.allPlayers()
        let matches = try await api.allMatches()
        
        // Get recently active players
        let recentPlayers = players.recentlyModifiedPlayers.prefix(10)
        
        print("\(ANSIColor.protoss)Recent Player Activity:\(ANSIColor.reset)\n")
        
        for player in recentPlayers {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Player:\(ANSIColor.reset)       \(player.name)")
            if let nationality = player.nationality {
                print("\(ANSIColor.terran)Nationality:\(ANSIColor.reset)  \(nationality)")
            }
            print("\(ANSIColor.terran)Last Update:\(ANSIColor.reset)  \(DateFormatter.prettyFormatter.string(from: player.modifiedAt))")
            
            // Find recent matches for this player
            let playerMatches = matches.matchesBy(playerId: player.id)
                .filter { $0.endAt?.timeIntervalSinceNow ?? 0 > -7 * 24 * 3600 } // Last 7 days
                .sorted { ($0.endAt ?? Date.distantPast) > ($1.endAt ?? Date.distantPast) }
            
            if !playerMatches.isEmpty {
                print("\n\(ANSIColor.zerg)Recent Matches:\(ANSIColor.reset)")
                for match in playerMatches {
                    print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) \(match.name)")
                    print("    Status: \(match.status)")
                    if let endAt = match.endAt {
                        print("    Ended: \(DateFormatter.prettyFormatter.string(from: endAt))")
                    }
                }
            }
            print()
        }
    }
}
