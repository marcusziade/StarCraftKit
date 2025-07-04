import ArgumentParser
import Foundation
import StarCraftKit

struct SearchCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "Search for players, teams, or tournaments",
        discussion: "Universal search across all StarCraft 2 entities"
    )
    
    @Argument(help: "Search query")
    var query: String
    
    @Option(name: .shortAndLong, help: "Entity type to search (player, team, tournament, all)")
    var type: String = "all"
    
    @Flag(name: .shortAndLong, help: "Show detailed information for each result")
    var detailed: Bool = false
    
    func run() async throws {
        let context = try CLIContext.load()
        let client = StarCraftClient(configuration: StarCraftClient.Configuration(apiKey: context.apiKey, authMethod: context.authMethod))
        
        let searchTypes = type.lowercased() == "all" ? ["player", "team", "tournament"] : [type.lowercased()]
        
        print("\n🔍 SEARCH RESULTS FOR: \"\(query)\"".bold())
        
        var totalResults = 0
        
        // Search Players
        if searchTypes.contains("player") {
            print("\n👤 PLAYERS".bold())
            
            let players = try await client.searchPlayers(name: query)
            
            let matchingPlayers = players.filter { player in
                let lowerQuery = query.lowercased()
                return player.name.lowercased().contains(lowerQuery) ||
                       (player.fullName?.lowercased().contains(lowerQuery) ?? false) ||
                       (player.firstName?.lowercased().contains(lowerQuery) ?? false) ||
                       (player.lastName?.lowercased().contains(lowerQuery) ?? false) ||
                       player.slug.lowercased().contains(lowerQuery)
            }
            
            if matchingPlayers.isEmpty {
                print("  No players found".gray)
            } else {
                totalResults += matchingPlayers.count
                
                for player in matchingPlayers.prefix(10) {
                    let flag = CountryFlag.flag(for: player.nationality)
                    let teamInfo = player.currentTeam.map { " (\($0.acronym ?? $0.name))" } ?? ""
                    
                    print("  \(flag) \(player.displayName.bold())\(teamInfo)")
                    
                    if detailed {
                        print("     Name: \(player.fullName ?? player.name)".gray)
                        if let age = player.age {
                            print("     Age: \(age)".gray)
                        }
                        if let hometown = player.hometown {
                            print("     Hometown: \(hometown)".gray)
                        }
                        print("     ID: \(player.id) | Slug: \(player.slug)".gray)
                        print("")
                    }
                }
                
                if matchingPlayers.count > 10 {
                    print("  ... and \(matchingPlayers.count - 10) more players".gray)
                }
            }
        }
        
        // Search Teams
        if searchTypes.contains("team") {
            print("\n👥 TEAMS".bold())
            
            let teams = try await client.searchTeams(name: query)
            
            let matchingTeams = teams.filter { team in
                team.name.lowercased().contains(query.lowercased()) ||
                team.acronym?.lowercased().contains(query.lowercased()) ?? false ||
                team.slug.lowercased().contains(query.lowercased())
            }
            
            if matchingTeams.isEmpty {
                print("  No teams found".gray)
            } else {
                totalResults += matchingTeams.count
                
                for team in matchingTeams.prefix(10) {
                    let locationFlag = team.location.map { " \(CountryFlag.flag(for: $0))" } ?? ""
                    let acronym = team.acronym.map { " [\($0)]" } ?? ""
                    
                    print("  \(team.name.bold())\(acronym)\(locationFlag)")
                    
                    if detailed {
                        if let location = team.location {
                            print("     Location: \(location)".gray)
                        }
                        if team.hasRoster {
                            print("     Roster Size: \(team.rosterSize) players".gray)
                            
                            // Show roster
                            if let players = team.players {
                                let playerNames = players.prefix(5).map { player in
                                    "\(CountryFlag.flag(for: player.nationality)) \(player.displayName)"
                                }.joined(separator: ", ")
                                print("     Players: \(playerNames)".gray)
                                if players.count > 5 {
                                    print("     ... and \(players.count - 5) more".gray)
                                }
                            }
                        }
                        print("     ID: \(team.id) | Slug: \(team.slug)".gray)
                        print("")
                    }
                }
                
                if matchingTeams.count > 10 {
                    print("  ... and \(matchingTeams.count - 10) more teams".gray)
                }
            }
        }
        
        // Search Tournaments
        if searchTypes.contains("tournament") {
            print("\n🏆 TOURNAMENTS".bold())
            
            let tournaments = try await client.getTournaments(TournamentsRequest(
                page: 1,
                pageSize: 20
            ))
            
            let matchingTournaments = tournaments.filter { tournament in
                tournament.name.lowercased().contains(query.lowercased()) ||
                tournament.slug.lowercased().contains(query.lowercased())
            }
            
            if matchingTournaments.isEmpty {
                print("  No tournaments found".gray)
            } else {
                totalResults += matchingTournaments.count
                
                // Sort by status and date
                let sortedTournaments = matchingTournaments.sorted { t1, t2 in
                    // Running tournaments first
                    if t1.isRunning && !t2.isRunning { return true }
                    if !t1.isRunning && t2.isRunning { return false }
                    
                    // Then upcoming
                    if t1.isPending && !t2.isPending { return true }
                    if !t1.isPending && t2.isPending { return false }
                    
                    // Then by date
                    return (t1.beginAt ?? Date.distantPast) > (t2.beginAt ?? Date.distantPast)
                }
                
                for tournament in sortedTournaments.prefix(10) {
                    let status = tournament.isRunning ? "● LIVE".brightGreen :
                               tournament.isPending ? "◯ Upcoming".yellow :
                               "✓ Finished".gray
                    let tier = tournament.tier.map { " [\($0.uppercased())]".brightYellow } ?? ""
                    
                    print("  \(tournament.name.bold())\(tier) - \(status)")
                    
                    if detailed {
                        if let beginAt = tournament.beginAt {
                            if tournament.isPending {
                                print("     Starts: \(beginAt.relativeTime) (\(beginAt.formattedString))".gray)
                            } else {
                                print("     Date: \(beginAt.formattedString)".gray)
                            }
                        }
                        if let prizepool = tournament.prizepool, !prizepool.isEmpty {
                            print("     Prize Pool: \(prizepool)".gray)
                        }
                        if tournament.hasEnded, let winner = tournament.winnerID {
                            print("     Winner ID: \(winner)".gray)
                        }
                        print("     ID: \(tournament.id) | Slug: \(tournament.slug)".gray)
                        print("")
                    }
                }
                
                if matchingTournaments.count > 10 {
                    print("  ... and \(matchingTournaments.count - 10) more tournaments".gray)
                }
            }
        }
        
        
        if totalResults == 0 {
            print("\n❌ No results found for \"\(query)\"".yellow)
            print("   Try a different search term or check the spelling.".gray)
        } else {
            print("\n✅ Found \(totalResults) total results".green)
            
            if !detailed {
                print("   Tip: Use --detailed to see more information about each result.".gray)
            }
        }
    }
}