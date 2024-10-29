import Foundation
import StarCraftKit

// Command to show game statistics
struct GameStatsCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Show detailed game statistics"
    }
    
    func execute() async throws {
        let matches = try await api.allMatches()
        let games = matches.matches.flatMap { $0.games ?? [] }
        
        print("\(ANSIColor.protoss)Game Statistics:\(ANSIColor.reset)\n")
        
        // Group games by status
        let gamesByStatus = Dictionary(grouping: games) { $0.status }
        
        for (status, statusGames) in gamesByStatus {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Status:\(ANSIColor.reset) \(status)")
            print("\(ANSIColor.terran)Count:\(ANSIColor.reset) \(statusGames.count)")
            
            // Calculate average game length for completed games
            let completedGames = statusGames.filter { $0.complete }
            if !completedGames.isEmpty {
                let totalLength = completedGames.compactMap { $0.length }.reduce(0, +)
                let avgLength = Double(totalLength) / Double(completedGames.count)
                print("\(ANSIColor.terran)Average Length:\(ANSIColor.reset) \(Int(avgLength)) seconds")
            }
            
            // Count forfeits
            let forfeits = statusGames.filter { $0.forfeit }.count
            if forfeits > 0 {
                print("\(ANSIColor.terran)Forfeits:\(ANSIColor.reset) \(forfeits)")
            }
            print()
        }
    }
}
