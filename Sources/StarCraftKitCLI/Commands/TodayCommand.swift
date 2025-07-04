import ArgumentParser
import Foundation
import StarCraftKit

struct TodayCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "today",
        abstract: "Show all StarCraft 2 matches happening today",
        discussion: "View today's schedule including finished, live, and upcoming matches"
    )
    
    @Flag(name: .shortAndLong, help: "Hide finished matches")
    var hideFinished: Bool = false
    
    @Option(name: .shortAndLong, help: "Filter by tournament name")
    var tournament: String?
    
    @Flag(name: .shortAndLong, help: "Group matches by tournament")
    var grouped: Bool = false
    
    func run() async throws {
        let context = try CLIContext.load()
        let client = StarCraftClient(configuration: StarCraftClient.Configuration(apiKey: context.apiKey, authMethod: context.authMethod))
        
        print("\n📅 TODAY'S MATCHES - \(Date().dateOnly)".bold())
        
        // Get all matches for today (past, running, upcoming)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Fetch all match types
        async let pastMatchesTask = client.getMatches(MatchesRequest(endpoint: .past, page: 1, pageSize: 100))
        async let runningMatchesTask = client.getMatches(MatchesRequest(endpoint: .running, page: 1, pageSize: 50))
        async let upcomingMatchesTask = client.getMatches(MatchesRequest(endpoint: .upcoming, page: 1, pageSize: 100))
        
        let (pastMatches, runningMatches, upcomingMatches) = try await (
            pastMatchesTask,
            runningMatchesTask,
            upcomingMatchesTask
        )
        
        // Combine and filter for today
        var todayMatches = (pastMatches + runningMatches + upcomingMatches)
            .filter { match in
                guard let matchDate = match.beginAt ?? match.endAt else { return false }
                return matchDate >= startOfDay && matchDate < endOfDay
            }
            .sorted { ($0.beginAt ?? Date.distantPast) < ($1.beginAt ?? Date.distantPast) }
        
        // Remove duplicates (same match might appear in multiple lists)
        var seenIDs = Set<Int>()
        todayMatches = todayMatches.filter { match in
            guard !seenIDs.contains(match.id) else { return false }
            seenIDs.insert(match.id)
            return true
        }
        
        // Filter by tournament if requested
        if let tournamentFilter = tournament?.lowercased() {
            let tournaments = try await client.getTournaments(TournamentsRequest(page: 1, pageSize: 100))
            let matchingTournamentIDs = tournaments
                .filter { $0.name.lowercased().contains(tournamentFilter) }
                .map { $0.id }
            
            todayMatches = todayMatches.filter { match in
                return matchingTournamentIDs.contains(match.tournamentID)
            }
        }
        
        // Hide finished if requested
        if hideFinished {
            todayMatches = todayMatches.filter { !$0.hasEnded }
        }
        
        if todayMatches.isEmpty {
            print("\n❌ No matches scheduled for today.".yellow)
            return
        }
        
        // Fetch tournament info
        let tournaments = try await client.getTournaments(TournamentsRequest(page: 1, pageSize: 100))
        let tournamentMap: [Int: Tournament] = Dictionary(uniqueKeysWithValues: tournaments.map { ($0.id, $0) })
        
        if grouped {
            // Group by tournament
            var matchesByTournament: [Int?: [StarCraftKit.Match]] = [:]
            for match in todayMatches {
                matchesByTournament[match.tournamentID, default: []].append(match)
            }
            
            for (tournamentID, matches) in matchesByTournament.sorted(by: { 
                let t1 = $0.key.map { tournamentMap[$0] } ?? nil
                let t2 = $1.key.map { tournamentMap[$0] } ?? nil
                return (t1?.tier ?? "") > (t2?.tier ?? "")
            }) {
                let tournament = tournamentID.map { tournamentMap[$0] } ?? nil
                let tournamentName = tournament?.name ?? "Unknown Tournament"
                let tierBadge = tournament?.tier.map { " [\($0.uppercased())]".brightYellow } ?? ""
                
                print("\n🏆 \(tournamentName)\(tierBadge)".bold())
                
                displayMatchList(matches, tournamentMap: tournamentMap, showTournament: false)
            }
        } else {
            // Show all matches in chronological order
            
            displayMatchList(todayMatches, tournamentMap: tournamentMap, showTournament: true)
        }
        
        // Show summary
        let finishedCount = todayMatches.filter { $0.hasEnded }.count
        let liveCount = todayMatches.filter { $0.isLive }.count
        let upcomingCount = todayMatches.filter { $0.isPending }.count
        
        print("\n📊 \(finishedCount) finished | \(liveCount) live | \(upcomingCount) upcoming".green)
    }
    
    private func displayMatchList(_ matches: [StarCraftKit.Match], tournamentMap: [Int: Tournament], showTournament: Bool) {
        for match in matches {
            let time = match.beginAt?.timeOnly ?? "--:--"
            
            // Get opponents
            let opponent1 = match.opponents[safe: 0]
            let opponent2 = match.opponents[safe: 1]
            
            let (name1, flag1) = formatOpponent(opponent1)
            let (name2, flag2) = formatOpponent(opponent2)
            
            // Get scores - check both teamID and playerID
            let score1 = match.results.first { result in
                if let opp1 = opponent1 {
                    return result.teamID == opp1.opponent.id || result.playerID == opp1.opponent.id
                }
                return false
            }?.score ?? 0
            
            let score2 = match.results.first { result in
                if let opp2 = opponent2 {
                    return result.teamID == opp2.opponent.id || result.playerID == opp2.opponent.id
                }
                return false
            }?.score ?? 0
            let scoreText = match.hasEnded || match.isLive ? "\(score1)-\(score2)" : "vs"
            
            // Get tournament
            let tournamentName = tournamentMap[match.tournamentID]?.name ?? "Unknown"
            
            // Get stream
            let streamInfo = match.streams?.first.map { _ in "📺" } ?? " "
            
            // Compact format
            let name1Short = TableFormatter.truncate(name1, to: 12)
            let name2Short = TableFormatter.truncate(name2, to: 12)
            let boText = match.numberOfGames > 1 ? "Bo\(match.numberOfGames)" : "Bo1"
            
            // Status indicator
            let statusIcon = match.isLive ? "●".brightGreen : (match.hasEnded ? "✓".gray : "○")
            
            if showTournament {
                let tournamentShort = TableFormatter.truncate(tournamentName, to: 15)
                print("\(statusIcon) \(time) \(flag1) \(name1Short) \(scoreText.padding(toLength: 5, withPad: " ", startingAt: 0)) \(name2Short) \(flag2) │ \(boText) │ \(tournamentShort) \(streamInfo)")
            } else {
                print("  \(statusIcon) \(time) \(flag1) \(name1Short) \(scoreText.padding(toLength: 5, withPad: " ", startingAt: 0)) \(name2Short) \(flag2) │ \(boText) \(streamInfo)")
            }
            
            // Show relative time for upcoming matches
            if match.isPending, let beginAt = match.beginAt {
                print("         \(beginAt.relativeTime)".gray)
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