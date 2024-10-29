import Foundation
import StarCraftKit

// Command to show match statistics
struct MatchStatsCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Show detailed match statistics"
    }
    
    func execute() async throws {
        let response = try await api.allMatches()
        let matches = response.matches.filter { $0.detailedStats }
        
        print("\(ANSIColor.protoss)Match Statistics:\(ANSIColor.reset)\n")
        
        for match in matches {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Match:\(ANSIColor.reset)        \(match.name)")
            print("\(ANSIColor.terran)Type:\(ANSIColor.reset)         \(match.matchType)")
            print("\(ANSIColor.terran)Status:\(ANSIColor.reset)       \(match.status)")
            
            if let scheduled = match.scheduledAt {
                print("\(ANSIColor.terran)Scheduled:\(ANSIColor.reset)    \(DateFormatter.prettyFormatter.string(from: scheduled))")
            }
            
            if let games = match.games {
                print("\n\(ANSIColor.zerg)Games:\(ANSIColor.reset)")
                for game in games {
                    print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) Game \(game.position)")
                    print("    Status: \(game.status)")
                    if let length = game.length {
                        print("    Length: \(length) seconds")
                    }
                    if let winner = game.winner {
                        print("    Winner ID: \(winner.id ?? -1)")
                    }
                }
            }
            
            if let results = match.results {
                print("\n\(ANSIColor.zerg)Results:\(ANSIColor.reset)")
                for result in results {
                    print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) Player \(result.playerId): \(result.score) points")
                }
            }
            print()
        }
    }
}

