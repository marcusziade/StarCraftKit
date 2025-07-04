import ArgumentParser
import Foundation
import StarCraftKit

struct TeamsCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "teams",
        abstract: "Fetch and display StarCraft 2 teams"
    )
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    @Option(name: .shortAndLong, help: "Items per page")
    var size: Int = 10
    
    @Option(name: .long, help: "Search by team name")
    var search: String?
    
    @Option(name: .long, help: "Filter by location")
    var location: String?
    
    @Flag(name: .long, help: "Show roster details")
    var showRoster = false
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        print("🎮 Fetching StarCraft 2 Teams...")
        
        do {
            let teams: [Team]
            
            if let searchName = search {
                print("🔍 Searching for teams matching: \"\(searchName)\"")
                teams = try await client.searchTeams(name: searchName)
            } else {
                let request = TeamsRequest(
                    page: page,
                    pageSize: size,
                    location: location
                )
                teams = try await client.getTeams(request)
            }
            
            if teams.isEmpty {
                print("\n📭 No teams found")
                return
            }
            
            print("\n📋 Found \(teams.count) teams:\n")
            
            for (index, team) in teams.enumerated() {
                print("[\(index + 1)] \(team.formatForOutput())")
                
                if showRoster, let players = team.players, !players.isEmpty {
                    print("   📝 Roster:")
                    for player in players.prefix(5) {
                        print("      - \(player.name) (\(player.nationality ?? "?"))")
                    }
                    if players.count > 5 {
                        print("      ... and \(players.count - 5) more")
                    }
                }
                
                print(String(repeating: "-", count: 40))
            }
            
            let totalRosterSize = teams.reduce(0) { $0 + $1.rosterSize }
            print("\n📊 Total players across all teams: \(totalRosterSize)")
            
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
}