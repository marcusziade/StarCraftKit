import ArgumentParser
import Foundation
import StarCraftKit

struct PlayerMatchesCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "player-matches",
        abstract: "Show recent match history for a player",
        discussion: "View a player's recent performance and results"
    )
    
    @Argument(help: "Player name to search for")
    var playerName: String
    
    @Option(name: .shortAndLong, help: "Number of recent matches to show")
    var count: Int = 20
    
    @Option(name: .shortAndLong, help: "Filter by tournament name")
    var tournament: String?
    
    @Flag(name: .shortAndLong, help: "Show detailed game scores")
    var detailed: Bool = false
    
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
        print("\n\(flag) \(player.displayName)'s Recent Matches".bold())
        
        // Get past matches
        let pastMatches = try await client.getMatches(MatchesRequest(
            endpoint: .past,
            page: 1,
            pageSize: 100
        ))
        
        // Filter matches for this player
        let playerMatches = pastMatches.filter { match in
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
        }.prefix(count)
        
        if playerMatches.isEmpty {
            print("\nNo recent matches found for \(player.displayName).".yellow)
            return
        }
        
        // Calculate stats
        var wins = 0
        var losses = 0
        var gameWins = 0
        var gameLosses = 0
        
        
        for match in playerMatches {
            // Find opponent and result
            let playerOpponent = match.opponents.first { opponent in
                if opponent.type.lowercased() == "player" {
                    return opponent.opponent.id == player.id
                } else if opponent.type == "team" {
                    // For teams, we can't check individual players without additional data
                    return false
                } else {
                    return false
                }
            }
            
            let otherOpponent = match.opponents.first { opponent in
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
            
            if let otherOpponent = otherOpponent {
                if otherOpponent.type.lowercased() == "player" {
                    opponentName = otherOpponent.opponent.displayName
                    opponentFlag = CountryFlag.flag(for: otherOpponent.opponent.nationality)
                } else if otherOpponent.type.lowercased() == "team" {
                    opponentName = otherOpponent.opponent.displayName
                    opponentFlag = "👥"
                } else {
                    opponentName = "TBD"
                    opponentFlag = "❓"
                }
            } else {
                opponentName = "TBD"
                opponentFlag = "❓"
            }
            
            // Check if player won
            let playerWon: Bool
            let scoreText: String
            
            if let winner = match.winner {
                if winner.type?.lowercased() == "player" {
                    playerWon = winner.id == player.id
                } else if winner.type?.lowercased() == "team" {
                    // For teams, we can't check individual players without additional data
                    playerWon = false
                } else {
                    playerWon = false
                }
            } else {
                playerWon = false
            }
            
            // Get scores - need to match with opponent IDs from the match
            let playerOpponentID = playerOpponent?.opponent.id
            let otherOpponentID = otherOpponent?.opponent.id
            
            if let playerResult = match.results.first(where: { 
                $0.playerID == playerOpponentID || $0.teamID == playerOpponentID
            }),
            let opponentResult = match.results.first(where: { 
                $0.playerID == otherOpponentID || $0.teamID == otherOpponentID
            }) {
                scoreText = "\(playerResult.score)-\(opponentResult.score)"
                gameWins += playerResult.score
                gameLosses += opponentResult.score
            } else {
                scoreText = "N/A"
            }
            
            if playerWon {
                wins += 1
            } else if match.hasEnded {
                losses += 1
            }
            
            // Get tournament info
            var tournamentName = "Unknown"
            // tournamentID is not optional
            let tournamentID = match.tournamentID
            if let cachedTournaments = try? await client.getTournaments(TournamentsRequest(pageSize: 100)) {
                tournamentName = cachedTournaments.first { $0.id == tournamentID }?.name ?? "Tournament"
            }
            
            // Format row
            let dateStr = match.endAt?.dateOnly ?? match.beginAt?.dateOnly ?? "Unknown"
            let resultStr: String
            if match.hasEnded {
                resultStr = playerWon ? "WIN".brightGreen : "LOSS".brightRed
            } else if match.isLive {
                resultStr = "LIVE".brightYellow
            } else {
                resultStr = "N/A".gray
            }
            let durationStr = match.duration?.formattedDuration ?? "-"
            
            // Compact format
            let opponentShort = TableFormatter.truncate(opponentName, to: 12)
            let tournamentShort = TableFormatter.truncate(tournamentName, to: 12)
            
            print("\(dateStr) \(opponentFlag) \(opponentShort) \(scoreText.padding(toLength: 5, withPad: " ", startingAt: 0)) \(resultStr) | \(tournamentShort) | \(durationStr)")
            
            // Show detailed game results if requested
            if detailed && !match.games.isEmpty {
                for (index, game) in match.games.enumerated() {
                    let gameWinner = game.winner
                    let gameWon = gameWinner?.id == player.id || 
                                  (gameWinner?.id == player.currentTeam?.id)
                    let gameResult = gameWon ? "✓".green : "✗".red
                    print("           Game \(index + 1): \(gameResult)")
                }
            }
        }
        
        // Show statistics
        let totalMatches = wins + losses
        let winRate = totalMatches > 0 ? Double(wins) / Double(totalMatches) * 100 : 0
        let gameWinRate = (gameWins + gameLosses) > 0 ? 
            Double(gameWins) / Double(gameWins + gameLosses) * 100 : 0
        
        print("\n📊 Statistics:".bold())
        let winRateStr = winRate.rounded(toPlaces: 1)
        print("  Match Record: \(wins)W - \(losses)L (\(winRateStr)% win rate)".cyan)
        let gameWinRateStr = gameWinRate.rounded(toPlaces: 1)
        print("  Game Record: \(gameWins)W - \(gameLosses)L (\(gameWinRateStr)% win rate)".cyan)
        
        print("\n" + TableFormatter.footer(width: 120))
    }
}

// formattedDuration extension moved to UIEnhancements.swift