import Foundation
import StarCraftKit

// Command to show league standings and history
struct LeagueDetailsCommand: Command {
    let api: StarCraftAPI

    var description: String {
        return "Show league information and tournaments"
    }

    func execute() async throws {
        let tournaments = try await api.allTournaments()
        let leagues = Dictionary(grouping: tournaments.tournaments) { $0.league?.id ?? -1 }

        print("\(ANSIColor.protoss)League Information:\(ANSIColor.reset)\n")

        for (_, tournaments) in leagues where tournaments.first?.league != nil {
            guard let league = tournaments.first?.league else { continue }

            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)League:\(ANSIColor.reset)       \(league.name)")
            if let url = league.url {
                print("\(ANSIColor.terran)URL:\(ANSIColor.reset)          \(url)")
            }
            print("\(ANSIColor.terran)Modified:\(ANSIColor.reset)     \(DateFormatter.prettyFormatter.string(from: league.modifiedAt))")

            print("\n\(ANSIColor.zerg)Tournaments:\(ANSIColor.reset)")
            let sortedTournaments = tournaments.sorted { $0.beginAt > $1.beginAt }
            for tournament in sortedTournaments {
                print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) \(tournament.name)")
                print("    Tier: \(tournament.tier)")
                print("    Date: \(DateFormatter.prettyFormatter.string(from: tournament.beginAt))")
                if let prizepool = tournament.prizepool {
                    print("    Prize: \(prizepool)")
                }
            }
            print()
        }
    }
}
