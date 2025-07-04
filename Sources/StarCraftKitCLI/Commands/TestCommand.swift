import ArgumentParser
import Foundation
import StarCraftKit

struct TestCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "test",
        abstract: "Test all API endpoints and features"
    )
    
    @Flag(name: .long, help: "Run extended tests (fetch more data)")
    var extended = false
    
    @Flag(name: .long, help: "Test caching functionality")
    var testCache = false
    
    @Flag(name: .long, help: "Test error handling")
    var testErrors = false
    
    mutating func run() async throws {
        let config = try StarCraftClient.Configuration.fromEnvironment()
        let client = StarCraftClient(configuration: config)
        
        print("🧪 StarCraft 2 API Test Suite")
        print(String(repeating: "=", count: 50))
        
        var passedTests = 0
        var failedTests = 0
        
        // Test Leagues
        print("\n📋 Testing Leagues endpoint...")
        do {
            let leagues = try await client.getLeagues(LeaguesRequest(pageSize: 5))
            print("✅ Fetched \(leagues.count) leagues")
            passedTests += 1
        } catch {
            print("❌ Leagues test failed: \(error)")
            failedTests += 1
        }
        
        // Test Matches
        print("\n⚔️ Testing Matches endpoints...")
        do {
            let allMatches = try await client.getMatches(MatchesRequest(pageSize: 5))
            print("✅ Fetched \(allMatches.count) matches")
            
            let liveMatches = try await client.getLiveMatches()
            print("✅ Fetched \(liveMatches.count) live matches")
            
            let upcomingMatches = try await client.getMatches(MatchesRequest(endpoint: .upcoming, pageSize: 5))
            print("✅ Fetched \(upcomingMatches.count) upcoming matches")
            
            passedTests += 3
        } catch {
            print("❌ Matches test failed: \(error)")
            failedTests += 1
        }
        
        // Test Players
        print("\n👤 Testing Players endpoint...")
        do {
            let players = try await client.getPlayers(PlayersRequest(pageSize: 5))
            print("✅ Fetched \(players.count) players")
            
            if extended {
                let searchResults = try await client.searchPlayers(name: "Serral")
                print("✅ Search found \(searchResults.count) players matching 'Serral'")
                passedTests += 1
            }
            
            passedTests += 1
        } catch {
            print("❌ Players test failed: \(error)")
            failedTests += 1
        }
        
        // Test Teams
        print("\n👥 Testing Teams endpoint...")
        do {
            let teams = try await client.getTeams(TeamsRequest(pageSize: 5))
            print("✅ Fetched \(teams.count) teams")
            passedTests += 1
        } catch {
            print("❌ Teams test failed: \(error)")
            failedTests += 1
        }
        
        // Test Series
        print("\n📅 Testing Series endpoints...")
        do {
            let series = try await client.getSeries(SeriesRequest(pageSize: 5))
            print("✅ Fetched \(series.count) series")
            
            let runningSeries = try await client.getSeries(.running())
            print("✅ Fetched \(runningSeries.count) running series")
            
            passedTests += 2
        } catch {
            print("❌ Series test failed: \(error)")
            failedTests += 1
        }
        
        // Test Tournaments
        print("\n🏆 Testing Tournaments endpoint...")
        do {
            let tournaments = try await client.getTournaments(TournamentsRequest(pageSize: 5))
            print("✅ Fetched \(tournaments.count) tournaments")
            passedTests += 1
        } catch {
            print("❌ Tournaments test failed: \(error)")
            failedTests += 1
        }
        
        // Test Pagination
        if extended {
            print("\n📄 Testing Pagination...")
            do {
                let page1 = try await client.getPlayers(PlayersRequest(page: 1, pageSize: 10))
                let page2 = try await client.getPlayers(PlayersRequest(page: 2, pageSize: 10))
                
                let page1IDs = Set(page1.map { $0.id })
                let page2IDs = Set(page2.map { $0.id })
                
                if page1IDs.isDisjoint(with: page2IDs) {
                    print("✅ Pagination working correctly (no duplicate IDs)")
                    passedTests += 1
                } else {
                    print("❌ Pagination test failed: Found duplicate IDs")
                    failedTests += 1
                }
            } catch {
                print("❌ Pagination test failed: \(error)")
                failedTests += 1
            }
        }
        
        // Test Caching
        if testCache {
            print("\n💾 Testing Cache...")
            await client.clearCache()
            
            let start = Date()
            _ = try await client.getLeagues()
            let firstFetchTime = Date().timeIntervalSince(start)
            
            let cacheStart = Date()
            _ = try await client.getLeagues()
            let cachedFetchTime = Date().timeIntervalSince(cacheStart)
            
            if cachedFetchTime < firstFetchTime * 0.1 {
                print("✅ Cache working (cached fetch was \(Int(firstFetchTime / cachedFetchTime))x faster)")
                passedTests += 1
            } else {
                print("⚠️ Cache might not be working effectively")
            }
            
            let stats = await client.getCacheStatistics()
            print("📊 Cache stats: \(stats.hitCount) hits, \(stats.missCount) misses, \(String(format: "%.1f", stats.hitRate * 100))% hit rate")
        }
        
        // Test Error Handling
        if testErrors {
            print("\n⚠️ Testing Error Handling...")
            
            // Test with invalid request
            do {
                let invalidRequest = MatchesRequest(
                    endpoint: .all,
                    page: 99999,
                    pageSize: 1
                )
                let _ = try await client.getMatches(invalidRequest)
                print("❌ Error handling test failed: Expected error but succeeded")
                failedTests += 1
            } catch {
                print("✅ Error handling working: \(error)")
                passedTests += 1
            }
        }
        
        // Test Rate Limiting Info
        print("\n🚦 Testing Rate Limit Status...")
        let (remaining, resetTime) = await client.getRateLimitStatus()
        if let remaining = remaining {
            print("✅ Rate limit remaining: \(remaining)")
            if let resetTime = resetTime {
                print("   Reset time: \(resetTime.formattedString)")
            }
            passedTests += 1
        } else {
            print("⚠️ Rate limit information not available")
        }
        
        // Summary
        print("\n" + String(repeating: "=", count: 50))
        print("🏁 Test Summary:")
        print("✅ Passed: \(passedTests)")
        print("❌ Failed: \(failedTests)")
        print("📊 Success Rate: \(String(format: "%.1f", Double(passedTests) / Double(passedTests + failedTests) * 100))%")
        
        if failedTests > 0 {
            throw ExitCode.failure
        }
    }
}

