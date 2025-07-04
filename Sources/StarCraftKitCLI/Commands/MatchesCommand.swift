import ArgumentParser
import Foundation
import StarCraftKit

struct MatchesCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "matches",
        abstract: "Fetch and display StarCraft 2 matches"
    )
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    @Option(name: .shortAndLong, help: "Items per page")
    var size: Int = 10
    
    @Option(name: .long, help: "Match type: all, past, running, upcoming")
    var type: String = "all"
    
    @Option(name: .long, help: "Filter by opponent ID")
    var opponentID: Int?
    
    @Option(name: .long, help: "Filter by tournament ID")
    var tournamentID: Int?
    
    @Option(name: .long, help: "Filter by series ID")
    var serieID: Int?
    
    @Option(name: .long, help: "Filter by league ID")
    var leagueID: Int?
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        let endpoint: MatchEndpoint
        switch type.lowercased() {
        case "past":
            endpoint = .past
            print("🏁 Fetching past matches...")
        case "running", "live":
            endpoint = .running
            print("🔴 Fetching live matches...")
        case "upcoming":
            endpoint = .upcoming
            print("📅 Fetching upcoming matches...")
        default:
            endpoint = .all
            print("🎮 Fetching all matches...")
        }
        
        do {
            let request = MatchesRequest(
                endpoint: endpoint,
                page: page,
                pageSize: size,
                opponentID: opponentID,
                tournamentID: tournamentID,
                serieID: serieID,
                leagueID: leagueID
            )
            
            let matches = try await client.getMatches(request)
            
            if matches.isEmpty {
                print("\n📭 No matches found")
                return
            }
            
            print("\n📋 Found \(matches.count) matches:\n")
            
            for (index, match) in matches.enumerated() {
                print("[\(index + 1)] \(match.formatForOutput())")
                
                if !match.opponents.isEmpty {
                    print("   Opponents:")
                    for opponent in match.opponents {
                        print("   - \(opponent.opponent.name)")
                    }
                }
                
                if let winner = match.winner {
                    print("   🏆 Winner: \(winner.name ?? "Unknown")")
                }
                
                print(String(repeating: "-", count: 50))
            }
            
            let liveCount = matches.filter { $0.isLive }.count
            if liveCount > 0 {
                print("\n🔴 \(liveCount) matches are currently live!")
            }
            
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
}