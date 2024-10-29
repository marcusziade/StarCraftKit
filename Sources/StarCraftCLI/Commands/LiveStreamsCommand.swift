import Foundation
import StarCraftKit

// Command to show live streams
struct LiveStreamsCommand: Command {
    let api: StarCraftAPI
    
    var description: String {
        return "Show current live streams"
    }
    
    func execute() async throws {
        let response = try await api.allMatches()
        let liveMatches = response.ongoingMatches.filter { !$0.streamsList.isEmpty }
        
        print("\(ANSIColor.protoss)Live Streams:\(ANSIColor.reset)\n")
        
        for match in liveMatches {
            print("\(ANSIColor.neon)═══════════════════════════════════════\(ANSIColor.reset)")
            print("\(ANSIColor.terran)Match:\(ANSIColor.reset)        \(match.name)")
            print("\(ANSIColor.terran)Tournament:\(ANSIColor.reset)   \(match.tournament?.name ?? "Unknown")")
            
            print("\n\(ANSIColor.zerg)Streams:\(ANSIColor.reset)")
            for stream in match.streamsList {
                print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) \(stream.language.uppercased())")
                if stream.official {
                    print("    \(ANSIColor.terran)Official Stream\(ANSIColor.reset)")
                }
                if let url = stream.rawUrl {
                    print("    URL: \(url)")
                }
            }
            
            if let opponents = match.opponents {
                print("\n\(ANSIColor.zerg)Players:\(ANSIColor.reset)")
                for opponent in opponents {
                    print("  \(ANSIColor.protoss)◆\(ANSIColor.reset) \(opponent.opponent.name)")
                }
            }
            print()
        }
    }
}
