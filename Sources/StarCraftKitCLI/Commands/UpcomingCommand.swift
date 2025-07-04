import ArgumentParser
import Foundation
import StarCraftKit

struct UpcomingCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "upcoming",
        abstract: "Show upcoming StarCraft 2 matches with countdown timers",
        discussion: "View when matches will start with relative time displays"
    )
    
    @Option(name: .shortAndLong, help: "Number of hours to look ahead")
    var hours: Int = 24
    
    @Option(name: .shortAndLong, help: "Filter by player name")
    var player: String?
    
    @Option(name: .shortAndLong, help: "Filter by tournament tier")
    var tier: String?
    
    @Flag(name: .shortAndLong, help: "Show only premier tournaments")
    var premierOnly: Bool = false
    
    func run() async throws {
        let context = try CLIContext.load()
        let client = StarCraftClient(configuration: StarCraftClient.Configuration(apiKey: context.apiKey, authMethod: context.authMethod))
        
        let endTime = Date().addingTimeInterval(TimeInterval(hours * 3600))
        
        print("\n\(TableFormatter.header("⏰ UPCOMING MATCHES", width: 140))")
        print("Next \(hours) hours | Current time: \(Date().formattedString)".gray)
        
        // Get upcoming matches
        let upcomingMatches = try await client.getMatches(MatchesRequest(endpoint: .upcoming, page: 1, pageSize: 100))
        
        // Filter by time window
        var filteredMatches = upcomingMatches.filter { match in
            guard let beginAt = match.beginAt else { return false }
            return beginAt <= endTime
        }
        
        // Filter by player if requested
        if let playerFilter = player?.lowercased() {
            filteredMatches = filteredMatches.filter { match in
                match.opponents.contains { opponent in
                    let details = opponent.opponent
                    if opponent.type.lowercased() == "player" {
                        return details.name.lowercased().contains(playerFilter) ||
                               (details.firstName?.lowercased().contains(playerFilter) ?? false) ||
                               (details.lastName?.lowercased().contains(playerFilter) ?? false)
                    }
                    // For teams, we can't check players without a separate API call
                    return false
                }
            }
        }
        
        // Fetch tournaments for filtering and display
        let tournaments = try await client.getTournaments(TournamentsRequest(page: 1, pageSize: 100))
        let tournamentMap: [Int: Tournament] = Dictionary(uniqueKeysWithValues: tournaments.map { ($0.id, $0) })
        
        // Filter by tier
        if premierOnly || tier != nil {
            let tierFilter = premierOnly ? "premier" : tier?.lowercased()
            filteredMatches = filteredMatches.filter { match in
                let tournament = tournamentMap[match.tournamentID]
                guard tournament != nil else { return false }
                return tierFilter == nil || tournament!.tier?.lowercased() == tierFilter
            }
        }
        
        // Sort by start time
        filteredMatches.sort { ($0.beginAt ?? Date.distantFuture) < ($1.beginAt ?? Date.distantFuture) }
        
        if filteredMatches.isEmpty {
            print("\n❌ No upcoming matches in the next \(hours) hours.".yellow)
            if let playerFilter = player {
                print("   No matches found for player: \(playerFilter)".gray)
            }
            print(TableFormatter.footer(width: 140))
            return
        }
        
        // Group by time periods
        let now = Date()
        let in1Hour = now.addingTimeInterval(3600)
        let in3Hours = now.addingTimeInterval(3 * 3600)
        let in6Hours = now.addingTimeInterval(6 * 3600)
        let in12Hours = now.addingTimeInterval(12 * 3600)
        
        let next1Hour = filteredMatches.filter { 
            ($0.beginAt ?? Date.distantFuture) <= in1Hour 
        }
        let next3Hours = filteredMatches.filter { 
            let beginAt = $0.beginAt ?? Date.distantFuture
            return beginAt > in1Hour && beginAt <= in3Hours 
        }
        let next6Hours = filteredMatches.filter { 
            let beginAt = $0.beginAt ?? Date.distantFuture
            return beginAt > in3Hours && beginAt <= in6Hours 
        }
        let next12Hours = filteredMatches.filter { 
            let beginAt = $0.beginAt ?? Date.distantFuture
            return beginAt > in6Hours && beginAt <= in12Hours 
        }
        let later = filteredMatches.filter { 
            ($0.beginAt ?? Date.distantFuture) > in12Hours 
        }
        
        // Display matches by time period
        if !next1Hour.isEmpty {
            print("\n🔥 STARTING SOON (Next Hour)".brightRed.bold())
            print(TableFormatter.divider(140))
            displayMatchGroup(next1Hour, tournamentMap: tournamentMap)
        }
        
        if !next3Hours.isEmpty {
            print("\n⚡ Next 3 Hours".brightYellow.bold())
            print(TableFormatter.divider(140))
            displayMatchGroup(next3Hours, tournamentMap: tournamentMap)
        }
        
        if !next6Hours.isEmpty {
            print("\n📅 Next 6 Hours".yellow.bold())
            print(TableFormatter.divider(140))
            displayMatchGroup(next6Hours, tournamentMap: tournamentMap)
        }
        
        if !next12Hours.isEmpty {
            print("\n📆 Next 12 Hours".bold())
            print(TableFormatter.divider(140))
            displayMatchGroup(next12Hours, tournamentMap: tournamentMap)
        }
        
        if !later.isEmpty && hours > 12 {
            print("\n🗓  Later".gray.bold())
            print(TableFormatter.divider(140))
            displayMatchGroup(later, tournamentMap: tournamentMap)
        }
        
        print("\n" + TableFormatter.footer(width: 140))
        print("\n📊 Total: \(filteredMatches.count) matches in the next \(hours) hours".green)
        
        // Show next match time
        if let nextMatch = filteredMatches.first, let beginAt = nextMatch.beginAt {
            print("⏰ Next match starts \(beginAt.relativeTime)".cyan)
        }
    }
    
    private func displayMatchGroup(_ matches: [StarCraftKit.Match], tournamentMap: [Int: Tournament]) {
        for match in matches {
            let beginAt = match.beginAt ?? Date()
            let countdown = beginAt.relativeTime
            let time = beginAt.timeOnly
            
            // Get opponents
            let opponent1 = match.opponents[safe: 0]
            let opponent2 = match.opponents[safe: 1]
            
            let (name1, flag1) = formatOpponent(opponent1)
            let (name2, flag2) = formatOpponent(opponent2)
            
            // Get tournament
            let tournament = tournamentMap[match.tournamentID]
            let tournamentName = tournament?.name ?? "Unknown"
            let tierBadge = tournament?.tier.map { "[\($0.uppercased())]" } ?? ""
            
            // Check for stream
            let hasStream = !(match.streams?.isEmpty ?? true)
            let streamIcon = hasStream ? "📺" : " "
            
            // Format match type
            let matchType = match.numberOfGames > 1 ? "Bo\(match.numberOfGames)" : ""
            
            // Color code countdown
            let coloredCountdown: String
            let timeInterval = beginAt.timeIntervalSinceNow
            if timeInterval < 900 { // Less than 15 minutes
                coloredCountdown = countdown.brightRed
            } else if timeInterval < 3600 { // Less than 1 hour
                coloredCountdown = countdown.brightYellow
            } else if timeInterval < 10800 { // Less than 3 hours
                coloredCountdown = countdown.yellow
            } else {
                coloredCountdown = countdown.gray
            }
            
            print(String(format: "%@ %-12s | %@ %-20s vs %-20s %@ | %-6s | %-25s %@ %@",
                time,
                coloredCountdown,
                flag1,
                TableFormatter.truncate(name1, to: 20),
                TableFormatter.truncate(name2, to: 20),
                flag2,
                matchType,
                TableFormatter.truncate(tournamentName, to: 25),
                tierBadge.brightYellow,
                streamIcon
            ))
            
            // Show day if not today
            if !beginAt.isToday {
                print("                    \(beginAt.dayOfWeek), \(beginAt.dateOnly)".gray)
            }
        }
    }
    
    private func formatOpponent(_ opponent: Opponent?) -> (name: String, flag: String) {
        guard let opponent = opponent else {
            return ("TBD", "❓")
        }
        
        switch opponent.type.lowercased() {
        case "player":
            return (opponent.opponent.displayName, CountryFlag.flag(for: opponent.opponent.nationality))
        case "team":
            return (opponent.opponent.displayName, "👥")
        default:
            return ("TBD", "❓")
        }
    }
}