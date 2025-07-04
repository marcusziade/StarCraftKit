import ArgumentParser
import Foundation
import StarCraftKit

struct PlayersCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "players",
        abstract: "Fetch and display StarCraft 2 players"
    )
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    @Option(name: .long, help: "Items per page")
    var size: Int = 10
    
    @Option(name: .long, help: "Search by player name")
    var search: String?
    
    @Option(name: .long, help: "Filter by nationality (ISO code)")
    var nationality: String?
    
    @Option(name: .long, help: "Filter by team ID")
    var teamID: Int?
    
    @Option(name: .shortAndLong, help: "Sort field")
    var sort: String?
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        print("🎮 Fetching StarCraft 2 Players...")
        
        do {
            let players: [Player]
            
            if let searchName = search {
                print("🔍 Searching for players matching: \"\(searchName)\"")
                players = try await client.searchPlayers(name: searchName)
            } else {
                var sortParams: [SortParameter]?
                if let sort = sort {
                    let direction: SortDirection = sort.hasPrefix("-") ? .descending : .ascending
                    let field = sort.hasPrefix("-") ? String(sort.dropFirst()) : sort
                    sortParams = [SortParameter(field: field, direction: direction)]
                }
                
                let request = PlayersRequest(
                    page: page,
                    pageSize: size,
                    sort: sortParams,
                    nationality: nationality,
                    teamID: teamID
                )
                players = try await client.getPlayers(request)
            }
            
            if players.isEmpty {
                print("\n📭 No players found")
                return
            }
            
            print("\n📋 Found \(players.count) players:\n")
            
            for (index, player) in players.enumerated() {
                print("[\(index + 1)] \(player.formatForOutput())")
                
                if let age = player.age {
                    print("   Age: \(age)")
                }
                
                if let hometown = player.hometown {
                    print("   Hometown: \(hometown)")
                }
                
                print(String(repeating: "-", count: 40))
            }
            
            if nationality != nil {
                let nationalities = Set(players.compactMap { $0.nationality })
                print("\n🌍 Players from \(nationalities.count) nation(s): \(nationalities.joined(separator: ", "))")
            }
            
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
}