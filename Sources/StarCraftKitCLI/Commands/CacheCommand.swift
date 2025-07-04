import ArgumentParser
import Foundation
import StarCraftKit

struct CacheCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "cache",
        abstract: "Manage API response cache",
        subcommands: [
            ClearCommand.self,
            StatsCommand.self
        ],
        defaultSubcommand: StatsCommand.self
    )
}

struct ClearCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "clear",
        abstract: "Clear the API response cache"
    )
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        print("🗑️ Clearing cache...")
        await client.clearCache()
        print("✅ Cache cleared successfully")
    }
}

struct StatsCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "stats",
        abstract: "Display cache statistics"
    )
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        let stats = await client.getCacheStatistics()
        
        print("📊 Cache Statistics")
        print("=" * 40)
        print("Hit Count:    \(stats.hitCount)")
        print("Miss Count:   \(stats.missCount)")
        print("Total:        \(stats.hitCount + stats.missCount)")
        let hitRatePercent = (stats.hitRate * 100).rounded(toPlaces: 1)
        print("Hit Rate:     \(hitRatePercent)%")
        print("Cache Size:   \(stats.currentSize) entries")
        print("=" * 40)
        
        if stats.hitCount + stats.missCount > 0 {
            let efficiency = stats.hitRate
            if efficiency > 0.8 {
                print("🟢 Cache is performing excellently!")
            } else if efficiency > 0.5 {
                print("🟡 Cache is performing well")
            } else {
                print("🔴 Cache hit rate is low - consider warming up the cache")
            }
        } else {
            print("ℹ️ No cache activity yet")
        }
    }
}

