import ArgumentParser
import Foundation
import StarCraftKit

struct LeaguesCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "leagues",
        abstract: "Fetch and display StarCraft 2 leagues"
    )
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    @Option(name: .long, help: "Items per page")
    var size: Int = 10
    
    @Option(name: .shortAndLong, help: "Sort field")
    var sort: String?
    
    @Flag(name: .long, help: "Fetch all pages")
    var all = false
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        print("🎮 Fetching StarCraft 2 Leagues...")
        
        do {
            let leagues: [League]
            
            if all {
                print("📊 Fetching all leagues (this may take a moment)...")
                leagues = try await client.getAllLeagues()
            } else {
                var sortParams: [SortParameter]?
                if let sort = sort {
                    let direction: SortDirection = sort.hasPrefix("-") ? .descending : .ascending
                    let field = sort.hasPrefix("-") ? String(sort.dropFirst()) : sort
                    sortParams = [SortParameter(field: field, direction: direction)]
                }
                
                let request = LeaguesRequest(
                    page: page,
                    pageSize: size,
                    sort: sortParams
                )
                leagues = try await client.getLeagues(request)
            }
            
            print("\n📋 Found \(leagues.count) leagues:\n")
            
            for (index, league) in leagues.enumerated() {
                print("[\(index + 1)] \(league.formatForOutput())")
                print(String(repeating: "-", count: 40))
            }
            
            if !all {
                print("\n💡 Tip: Use --all to fetch all leagues")
            }
            
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
}