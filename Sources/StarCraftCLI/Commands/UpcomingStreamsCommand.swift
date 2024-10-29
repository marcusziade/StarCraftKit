import Foundation
import StarCraftKit

// Command to show upcoming matches with streaming info
struct UpcomingStreamsCommand: Command {
    let api: StarCraftAPI

    var description: String {
        return "Show upcoming matches with stream information"
    }

    func execute() async throws {
        let response = try await api.allMatches()
        let upcoming = response.upcomingMatches
            .filter { $0.streamsList.isEmpty == false }
            .sorted { $0.beginAt ?? Date.distantFuture < $1.beginAt ?? Date.distantFuture }

        print("\(ANSIColor.protoss)Upcoming Streamed Matches:\(ANSIColor.reset)\n")

        for match in upcoming {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Match:\(ANSIColor.reset)        \(match.name)")
            if let beginAt = match.beginAt {
                print("\(ANSIColor.terran)Starts:\(ANSIColor.reset)       \(DateFormatter.prettyFormatter.string(from: beginAt))")
            }
            print("\(ANSIColor.terran)Series:\(ANSIColor.reset)       \(match.serie?.fullName ?? "N/A")")

            print("\n\(ANSIColor.zerg)Available Streams:\(ANSIColor.reset)")
            for stream in match.streamsList {
                print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) \(stream.language.uppercased())")
                if stream.official {
                    print("    Official Stream")
                }
                if let url = stream.rawUrl {
                    print("    URL: \(url)")
                }
            }
            print()
        }
    }
}
