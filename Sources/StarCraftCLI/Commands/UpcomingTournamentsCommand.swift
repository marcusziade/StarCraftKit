import Foundation
import StarCraftKit

struct UpcomingTournamentsCommand: Command {
    let api: StarCraftAPI

    var description: String {
        return "Fetch upcoming tournaments"
    }

    func execute() async throws {
        let response = try await api.allTournaments()
        let upcoming = response.upcomingTournaments

        print("\(ANSIColor.protoss)Upcoming Tournaments:\(ANSIColor.reset)\n")

        for tournament in upcoming {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Name:\(ANSIColor.reset)         \(tournament.name)")
            print("\(ANSIColor.terran)Start Date:\(ANSIColor.reset)   \(DateFormatter.prettyFormatter.string(from: tournament.beginAt))")
            print("\(ANSIColor.terran)End Date:\(ANSIColor.reset)     \(DateFormatter.prettyFormatter.string(from: tournament.endAt))")
            print("\(ANSIColor.terran)League:\(ANSIColor.reset)       \(tournament.league?.name ?? "Unknown")")
            print("\(ANSIColor.terran)Game:\(ANSIColor.reset)         \(tournament.videogame?.name ?? "Unknown")")
            print("\(ANSIColor.terran)Prize Pool:\(ANSIColor.reset)   \(tournament.prizepool ?? "Unknown")")

            if let matches = tournament.matches {
                print("\n\(ANSIColor.zerg)Matches:\(ANSIColor.reset)")
                for match in matches {
                    print("\(ANSIColor.neon)  ➤\(ANSIColor.reset) \(match.name)")
                    print("    Status: \(match.status)")
                    if let opponents = match.opponents {
                        print("    \(ANSIColor.protoss)VS\(ANSIColor.reset)")
                        for opponent in opponents {
                            print("    \(ANSIColor.terran)◆\(ANSIColor.reset) \(opponent.opponent.name)")
                        }
                    }
                }
            }
            print()
        }
    }
}
