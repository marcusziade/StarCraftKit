import ArgumentParser
import Foundation
import StarCraftKit

struct PlayerScheduleCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "player-schedule",
        abstract: "Show upcoming matches for a specific player",
        discussion: "Find when your favorite player will play next"
    )
    
    @Argument(help: "Player name to search for")
    var playerName: String
    
    @Option(name: .shortAndLong, help: "Number of days to look ahead")
    var days: Int = 7
    
    @Option(name: .shortAndLong, help: "Show matches from specific tournament")
    var tournament: String?
    
    @Flag(name: .shortAndLong, help: "Include finished matches from today")
    var includeFinished: Bool = false
    
    func run() async throws {
        let context = try CLIContext.load()
        let client = StarCraftClient(configuration: StarCraftClient.Configuration(apiKey: context.apiKey, authMethod: context.authMethod))
        
        // Find the player
        print("Searching for player: \(playerName)...".gray)
        let players = try await client.searchPlayers(name: playerName)
        
        guard let player = players.first(where: { 
            $0.name.lowercased().contains(playerName.lowercased()) ||
            $0.fullName?.lowercased().contains(playerName.lowercased()) ?? false
        }) else {
            throw CLIError.notFound("Player '\(playerName)' not found")
        }
        
        let flag = CountryFlag.flag(for: player.nationality)
        print("\n\(TableFormatter.header("\(flag) \(player.displayName)'s Upcoming Matches", width: 100))")
        
        // Get upcoming matches
        let endDate = Date().addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
        let upcomingMatches = try await client.getMatches(MatchesRequest(
            endpoint: .upcoming,
            page: 1,
            pageSize: 100
        ))
        
        // Filter matches for this player
        let playerMatches = upcomingMatches.filter { match in
            match.opponents.contains { opponent in
                if opponent.type.lowercased() == "player" {
                    return opponent.opponent.id == player.id
                }
                if opponent.type.lowercased() == "team" {
                    // For teams, we can't check individual players without additional data
                    return false
                }
                return false
            }
        }.filter { match in
            guard let beginAt = match.beginAt else { return false }
            return beginAt <= endDate && (includeFinished || !match.hasEnded)
        }.sorted { ($0.beginAt ?? Date.distantFuture) < ($1.beginAt ?? Date.distantFuture) }
        
        if playerMatches.isEmpty {
            print("\nNo upcoming matches found for \(player.displayName) in the next \(days) days.".yellow)
            print(TableFormatter.footer(width: 100))
            return
        }
        
        // Display matches grouped by day
        var currentDay: String?
        
        for match in playerMatches {
            guard let beginAt = match.beginAt else { continue }
            
            let dayString = beginAt.isToday ? "Today" : 
                           beginAt.isTomorrow ? "Tomorrow" : 
                           beginAt.dayOfWeek
            
            if currentDay != dayString {
                currentDay = dayString
                print("\n\(dayString.bold()) - \(beginAt.dateOnly)")
                print(TableFormatter.divider(100))
            }
            
            // Find opponent
            let opponentInfo = match.opponents.first { opponent in
                if opponent.type.lowercased() == "player" {
                    return opponent.opponent.id != player.id
                } else if opponent.type == "team" {
                    // For teams, we can't check individual players without additional data
                    return true
                } else {
                    return true
                }
            }
            
            let opponentName: String
            let opponentFlag: String
            
            if let opponentInfo = opponentInfo {
                if opponentInfo.type == "player" {
                    opponentName = opponentInfo.opponent.displayName
                    opponentFlag = CountryFlag.flag(for: opponentInfo.opponent.nationality ?? "")
                } else if opponentInfo.type == "team" {
                    opponentName = opponentInfo.opponent.displayName
                    opponentFlag = "👥"
                } else {
                    opponentName = "TBD"
                    opponentFlag = "❓"
                }
            } else {
                opponentName = "TBD"
                opponentFlag = "❓"
            }
            
            // Get tournament info
            var tournamentName = "Unknown Tournament"
            let tournamentID = match.tournamentID
            if let cachedTournaments = try? await client.getTournaments(TournamentsRequest(pageSize: 100)) {
                tournamentName = cachedTournaments.first { $0.id == tournamentID }?.name ?? "Tournament #\(tournamentID)"
            }
            
            // Format match info
            let timeInfo = match.isLive ? "LIVE NOW".brightGreen : beginAt.relativeTime
            let vsText = "vs".gray
            let matchType = match.numberOfGames > 1 ? "Bo\(match.numberOfGames)" : ""
            
            let tournamentCol = TableFormatter.truncate(tournamentName, to: 30)
            print("  \(beginAt.timeOnly) | \(flag) \(player.displayName) \(vsText) \(opponentFlag) \(opponentName) | \(tournamentCol) | \(matchType)")
            
            if match.isLive {
                let streamLink = match.streams?.first.map { StreamFormatter.formatStreamLink($0.rawURL.absoluteString) } ?? "No stream"
                print("    \(timeInfo) - \(streamLink)")
            } else {
                print("    \(timeInfo)".gray)
            }
            
            // Show current score if live
            if match.isLive && !match.results.isEmpty {
                let playerScore = match.results.first { $0.teamID == player.id || $0.teamID == player.currentTeam?.id }?.score ?? 0
                let opponentScore = match.results.first { $0.teamID != player.id && $0.teamID != player.currentTeam?.id }?.score ?? 0
                print("    Score: \(playerScore) - \(opponentScore)".cyan)
            }
        }
        
        print("\n" + TableFormatter.footer(width: 100))
        print("\nFound \(playerMatches.count) matches for \(player.displayName) in the next \(days) days.".green)
    }
}