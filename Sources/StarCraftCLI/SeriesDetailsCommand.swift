import Foundation
import StarCraftKit

// Command to show series information
struct SeriesDetailsCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Show series information and tournaments"
    }
    
    func execute() async throws {
        let tournaments = try await api.allTournaments()
        let series = Dictionary(grouping: tournaments.tournaments) { $0.serie?.id ?? -1 }
        
        print("\(ANSIColor.protoss)Series Information:\(ANSIColor.reset)\n")
        
        for (_, tournaments) in series where tournaments.first?.serie != nil {
            guard let serie = tournaments.first?.serie else { continue }
            
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Series:\(ANSIColor.reset)       \(serie.fullName)")
            print("\(ANSIColor.terran)Season:\(ANSIColor.reset)       \(serie.season ?? "N/A")")
            print("\(ANSIColor.terran)Year:\(ANSIColor.reset)         \(serie.year)")
            print("\(ANSIColor.terran)Period:\(ANSIColor.reset)       \(DateFormatter.prettyFormatter.string(from: serie.beginAt)) - \(DateFormatter.prettyFormatter.string(from: serie.endAt))")
            
            if let winnerId = serie.winnerId {
                print("\(ANSIColor.terran)Winner ID:\(ANSIColor.reset)    \(winnerId)")
            }
            
            print("\n\(ANSIColor.zerg)Tournaments:\(ANSIColor.reset)")
            let sortedTournaments = tournaments.sorted { $0.beginAt > $1.beginAt }
            for tournament in sortedTournaments {
                print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) \(tournament.name)")
                print("    Dates: \(DateFormatter.prettyFormatter.string(from: tournament.beginAt)) - \(DateFormatter.prettyFormatter.string(from: tournament.endAt))")
            }
            print()
        }
    }
}
