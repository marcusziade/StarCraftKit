import ArgumentParser
import Foundation
import StarCraftKit

struct TournamentMatchesCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "tournament-matches",
        abstract: "Show all matches in a tournament",
        discussion: "View tournament bracket and match results"
    )
    
    @Argument(help: "Tournament name or ID")
    var tournament: String
    
    @Flag(name: .shortAndLong, help: "Show matches grouped by round/stage")
    var grouped: Bool = false
    
    @Flag(name: .shortAndLong, help: "Show only completed matches")
    var completedOnly: Bool = false
    
    @Option(name: .shortAndLong, help: "Filter by player name")
    var player: String?
    
    func run() async throws {
        let context = try CLIContext.load()
        let client = StarCraftClient(configuration: StarCraftClient.Configuration(apiKey: context.apiKey, authMethod: context.authMethod))
        
        // Find tournament
        print("Searching for tournament: \(tournament)...".gray)
        
        let tournaments = try await client.getTournaments(TournamentsRequest(page: 1, pageSize: 50))
        
        // Try to find by ID first, then by name
        let targetTournament: Tournament?
        if let tournamentID = Int(tournament) {
            targetTournament = tournaments.first { $0.id == tournamentID }
        } else {
            targetTournament = tournaments.first { tournament in
                tournament.name.lowercased().contains(self.tournament.lowercased()) ||
                tournament.slug.lowercased() == self.tournament.lowercased()
            }
        }
        
        guard let selectedTournament = targetTournament else {
            throw CLIError.notFound("Tournament '\(tournament)' not found")
        }
        
        let tierBadge = selectedTournament.tier.map { " [\($0.uppercased())]".brightYellow } ?? ""
        let status = selectedTournament.isRunning ? "● LIVE".brightGreen :
                    selectedTournament.isPending ? "◯ Upcoming".yellow :
                    "✓ Finished".gray
        
        print("\n🏆 \(selectedTournament.name)\(tierBadge)".bold())
        print("Status: \(status)")
        
        if let beginAt = selectedTournament.beginAt, let endAt = selectedTournament.endAt {
            print("Duration: \(beginAt.formattedString) - \(endAt.formattedString)".gray)
        } else if let beginAt = selectedTournament.beginAt {
            if selectedTournament.isPending {
                print("Starts: \(beginAt.relativeTime) (\(beginAt.formattedString))".gray)
            } else {
                print("Started: \(beginAt.formattedString)".gray)
            }
        }
        
        if let prizepool = selectedTournament.prizepool, !prizepool.isEmpty {
            print("Prize Pool: \(prizepool)".cyan)
        }
        
        // Get all matches for this tournament
        print("\nLoading matches...".gray)
        
        // Fetch all match types
        async let pastMatchesTask = client.getMatches(MatchesRequest(
            endpoint: .past,
            page: 1, 
            pageSize: 100,
            tournamentID: selectedTournament.id
        ))
        async let runningMatchesTask = client.getMatches(MatchesRequest(
            endpoint: .running,
            page: 1,
            pageSize: 50,
            tournamentID: selectedTournament.id
        ))
        async let upcomingMatchesTask = client.getMatches(MatchesRequest(
            endpoint: .upcoming,
            page: 1,
            pageSize: 100,
            tournamentID: selectedTournament.id
        ))
        
        let (pastMatches, runningMatches, upcomingMatches) = try await (
            pastMatchesTask,
            runningMatchesTask,
            upcomingMatchesTask
        )
        
        // Combine all matches
        var allMatches = pastMatches + runningMatches + upcomingMatches
        
        // Remove duplicates
        var seenIDs = Set<Int>()
        allMatches = allMatches.filter { match in
            guard !seenIDs.contains(match.id) else { return false }
            seenIDs.insert(match.id)
            return true
        }
        
        // Filter by tournament ID (in case the filter didn't work)
        allMatches = allMatches.filter { $0.tournamentID == selectedTournament.id }
        
        // Filter by completed only if requested
        if completedOnly {
            allMatches = allMatches.filter { $0.hasEnded }
        }
        
        // Filter by player if requested
        if let playerFilter = player?.lowercased() {
            allMatches = allMatches.filter { match in
                match.opponents.contains { opponent in
                    if opponent.type == "player" {
                        return opponent.opponent.name.lowercased().contains(playerFilter)
                    } else if opponent.type == "team" {
                        // For teams, we can't check players without additional data
                        return opponent.opponent.name.lowercased().contains(playerFilter)
                    } else {
                        return false
                    }
                }
            }
        }
        
        // Sort by date
        allMatches.sort { ($0.beginAt ?? Date.distantPast) < ($1.beginAt ?? Date.distantPast) }
        
        if allMatches.isEmpty {
            print("\n❌ No matches found for this tournament.".yellow)
            print(TableFormatter.footer(width: 140))
            return
        }
        
        // Display matches
        print("\n📋 MATCHES (\(allMatches.count) total)".bold())
        
        if grouped {
            // Group by match name (which often contains round info)
            var matchesByRound: [String: [StarCraftKit.Match]] = [:]
            
            for match in allMatches {
                let roundName = extractRoundName(from: match.name) ?? "Other Matches"
                matchesByRound[roundName, default: []].append(match)
            }
            
            // Sort rounds logically
            let sortedRounds = matchesByRound.keys.sorted { round1, round2 in
                let order = ["Final", "Grand Final", "Semifinal", "Quarterfinal", "Round of 8", "Round of 16", "Round of 32", "Group"]
                let index1 = order.firstIndex { round1.contains($0) } ?? order.count
                let index2 = order.firstIndex { round2.contains($0) } ?? order.count
                return index1 < index2
            }
            
            for round in sortedRounds {
                print("\n\(round.uppercased().bold())")
                print(String(repeating: "-", count: round.count))
                
                if let matches = matchesByRound[round] {
                    displayMatchList(matches.sorted { ($0.beginAt ?? Date.distantPast) > ($1.beginAt ?? Date.distantPast) })
                }
            }
        } else {
            // Show all matches chronologically
            print("\nDate       Time   | Status      | Match                                          | Score | Type")
            print(String(repeating: "-", count: 100))
            
            displayMatchList(allMatches)
        }
        
        // Show tournament winner if finished
        if selectedTournament.hasEnded, let winnerID = selectedTournament.winnerID {
            
            // Try to find winner info
            if let winnerMatch = allMatches.first(where: { match in
                match.winner?.id == winnerID
            }), let winner = winnerMatch.winner {
                if winner.type == "player" {
                    print("🏆 Tournament Winner: \(winner.name ?? "Unknown")".brightGreen.bold())
                } else if winner.type == "team" {
                    print("🏆 Tournament Winner: 👥 \(winner.name ?? "Unknown")".brightGreen.bold())
                }
            } else {
                print("🏆 Tournament Winner: ID \(winnerID)".brightGreen.bold())
            }
        }
        
        
        // Summary
        let completedCount = allMatches.filter { $0.hasEnded }.count
        let liveCount = allMatches.filter { $0.isLive }.count
        let upcomingCount = allMatches.filter { $0.isPending }.count
        
        print("\n📊 Summary: \(completedCount) completed | \(liveCount) live | \(upcomingCount) upcoming".green)
    }
    
    private func displayMatchList(_ matches: [StarCraftKit.Match]) {
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
            
            // Highlight winner
            let winner1 = match.hasEnded && match.winner?.id == opponent1?.opponent.id
            let winner2 = match.hasEnded && match.winner?.id == opponent2?.opponent.id
            
            let displayName1 = winner1 ? name1.brightGreen : name1
            let displayName2 = winner2 ? name2.brightGreen : name2
            
            // Format match type
            let matchType = match.numberOfGames > 1 ? "Bo\(match.numberOfGames)" : ""
            
            // Compact format
            let name1Short = TableFormatter.truncate(displayName1, to: 12)
            let name2Short = TableFormatter.truncate(displayName2, to: 12)
            let streamIcon = match.streams?.isEmpty == false ? "📺" : "  "
            let statusIcon = match.isLive ? "●".brightGreen : (match.hasEnded ? "✓".gray : "○")
            
            print("\(statusIcon) \(time) \(flag1) \(name1Short) \(scoreText.padding(toLength: 5, withPad: " ", startingAt: 0)) \(name2Short) \(flag2) | \(matchType) \(streamIcon)")
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
    
    private func extractRoundName(from matchName: String) -> String? {
        // Common round patterns
        let patterns = [
            "Grand Final", "Final", "Semifinal", "Quarterfinal",
            "Round of 32", "Round of 16", "Round of 8",
            "Group Stage", "Group [A-Z]", "Playoffs",
            "Upper Bracket", "Lower Bracket", "Losers",
            "Winners", "Consolidation"
        ]
        
        for pattern in patterns {
            if matchName.contains(pattern) {
                return pattern
            }
        }
        
        // Check for group matches
        if let range = matchName.range(of: "Group [A-Z]", options: .regularExpression) {
            return String(matchName[range])
        }
        
        return nil
    }
}