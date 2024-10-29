import Foundation
import StarCraftKit

// Command to show detailed tournament information
struct TournamentDetailsCommand: Command {
    let api: StarCraftAPI

    var description: String {
        return "Show detailed tournament information"
    }

    func execute() async throws {
        let response = try await api.allTournaments()
        let tournaments = response.tournaments.sorted { $0.beginAt > $1.beginAt }

        print("\(ANSIColor.protoss)Tournament Details:\(ANSIColor.reset)\n")

        for tournament in tournaments {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Name:\(ANSIColor.reset)         \(tournament.name)")
            print("\(ANSIColor.terran)Series:\(ANSIColor.reset)       \(tournament.serie?.fullName ?? "N/A")")
            print("\(ANSIColor.terran)Tier:\(ANSIColor.reset)         \(tournament.tier)")
            print("\(ANSIColor.terran)League:\(ANSIColor.reset)       \(tournament.league?.name ?? "N/A")")
            print("\(ANSIColor.terran)Start:\(ANSIColor.reset)        \(DateFormatter.prettyFormatter.string(from: tournament.beginAt))")
            print("\(ANSIColor.terran)End:\(ANSIColor.reset)          \(DateFormatter.prettyFormatter.string(from: tournament.endAt))")
            if let prizepool = tournament.prizepool {
                print("\(ANSIColor.terran)Prize Pool:\(ANSIColor.reset)   \(prizepool)")
            }

            if tournament.hasBracket {
                print("\(ANSIColor.terran)Bracket:\(ANSIColor.reset)      Available")
            }

            if tournament.liveSupported {
                print("\(ANSIColor.terran)Live Support:\(ANSIColor.reset) Yes")
            }

            if let matches = tournament.matches {
                print("\n\(ANSIColor.zerg)Matches:\(ANSIColor.reset) \(matches.count)")
                for match in matches.prefix(5) {  // Show only first 5 matches to avoid clutter
                    print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) \(match.name)")
                    print("    Status: \(match.status)")
                    if let beginAt = match.beginAt {
                        print("    Starts: \(DateFormatter.prettyFormatter.string(from: beginAt))")
                    }
                }
                if matches.count > 5 {
                    print("  ... and \(matches.count - 5) more matches")
                }
            }
            print()
        }
    }
}
