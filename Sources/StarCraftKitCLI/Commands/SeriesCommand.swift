import ArgumentParser
import Foundation
import StarCraftKit

struct SeriesCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "series",
        abstract: "Fetch and display StarCraft 2 series"
    )
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    @Option(name: .shortAndLong, help: "Items per page")
    var size: Int = 10
    
    @Option(name: .long, help: "Series type: all, past, running, upcoming")
    var type: String = "all"
    
    @Option(name: .long, help: "Filter by year")
    var year: Int?
    
    @Option(name: .long, help: "Filter by league ID")
    var leagueID: Int?
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        let endpoint: SeriesEndpoint
        switch type.lowercased() {
        case "past":
            endpoint = .past
            print("🏁 Fetching past series...")
        case "running":
            endpoint = .running
            print("🔴 Fetching running series...")
        case "upcoming":
            endpoint = .upcoming
            print("📅 Fetching upcoming series...")
        default:
            endpoint = .all
            print("🎮 Fetching all series...")
        }
        
        do {
            let request = SeriesRequest(
                endpoint: endpoint,
                page: page,
                pageSize: size,
                leagueID: leagueID,
                year: year
            )
            
            let series = try await client.getSeries(request)
            
            if series.isEmpty {
                print("\n📭 No series found")
                return
            }
            
            print("\n📋 Found \(series.count) series:\n")
            
            for (index, serie) in series.enumerated() {
                print("[\(index + 1)] \(serie.formatForOutput())")
                
                if let tier = serie.tier {
                    print("   Tier: \(tier)")
                }
                
                if let description = serie.description, !description.isEmpty {
                    let preview = description.prefix(100)
                    print("   Description: \(preview)\(description.count > 100 ? "..." : "")")
                }
                
                if serie.isRunning {
                    print("   🔴 Currently Running")
                } else if serie.hasEnded {
                    print("   ✅ Completed")
                } else if serie.isPending {
                    print("   ⏳ Upcoming")
                }
                
                print(String(repeating: "-", count: 50))
            }
            
            if year != nil {
                print("\n📅 Showing series from year \(year!)")
            }
            
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
}