import Foundation
import StarCraftKit

let arguments = CommandLine.arguments

func main() {
    guard arguments.count > 1 else {
        printInstructions()
        return
    }

    let command = arguments[1]

    Task {
        switch command {
        case "-t":
            await tournaments()
        case "-p":
            await players()
        case "-m":
            await matches()
        case "-ot":
            await ongoingTournaments()
        case "-ut":
            await upcomingTournaments()
        case "-ct":
            await concludedTournaments()
        case "-lt":
            await liveSupportedTournaments()
        case "-ap":
            await activePlayers()
        case "-um":
            await upcomingMatches()
        case "-om":
            await ongoingMatches()
        case "-cm":
            await completedMatches()
        default:
            print("Unknown command: \(command)")
        }
    }

    RunLoop.current.run()
}

func printInstructions() {
    print()
    print("👾 Welcome to StarCraftCLI 👾")
    print()
    print("Commands:")
    print("-t   all tournaments")
    print("-p   all players")
    print("-m   all matches")
    print("-ot  ongoing tournaments")
    print("-ut  upcoming tournaments")
    print("-ct  concluded tournaments")
    print("-lt  live supported tournaments")
    print("-um  upcoming matches")
    print("-om  ongoing matches")
    print("-ap  active players")
    print("-cm  completed matches")
    print()
    print("You must provide a valid PANDA_TOKEN environment variable")
    print()
    print("Usage: swift build, swift run StarCraftCLI <command>")
    print("Example: swift run StarCraftCLI -t. This will fetch all tournaments")
}

func tournaments() async {
    do {
        let response = try await api.allTournaments()
        print("Fetched \(response.tournaments.count) tournaments")
        print("Upcoming tournaments: \(response.upcomingTournaments.count)")
    } catch {
        print("Failed to fetch tournaments: \(error)")
    }
}

func players() async {
    do {
        let response = try await api.allPlayers()
        print("Fetched \(response.players.count) players")
    } catch {
        print("Failed to fetch players: \(error)")
    }
}

func matches() async {
    do {
        let response = try await api.allMatches()
        print("Fetched \(response.matches.count) matches")
    } catch {
        print("Failed to fetch matches: \(error)")
    }
}

func ongoingTournaments() async {
    do {
        let response = try await api.allTournaments()
        let ongoing = response.ongoingTournaments
        print("Fetched \(ongoing.count) ongoing tournaments")
    } catch {
        print("Failed to fetch ongoing tournaments: \(error)")
    }
}

func upcomingTournaments() async {
    do {
        let response = try await api.allTournaments()
        let upcoming = response.upcomingTournaments

        let formattedTournaments = upcoming.map { tournament in
            let matchesInfo = tournament.matches?.map { match in
                """
                Match Name:      \(match.name)
                Match ID:        \(match.id ?? 0)
                Status:          \(match.status)
                Scheduled At:    \(match.scheduledAt.map { DateFormatter.prettyFormatter.string(from: $0) } ?? "Unknown")
                Begin At:        \(match.beginAt.map { DateFormatter.prettyFormatter.string(from: $0) } ?? "Unknown")
                End At:          \(match.endAt.map { DateFormatter.prettyFormatter.string(from: $0) } ?? "Unknown")
                Number of Games: \(match.numberOfGames)
                Match Type:      \(match.matchType)
                Detailed Stats:  \(match.detailedStats)
                Live Supported:  \(match.live.supported)
                Draw:            \(match.draw)
                Forfeit:         \(match.forfeit)
                Rescheduled:     \(match.rescheduled)
                Game Advantage:  \(match.gameAdvantage ?? 0)
                Winner ID:       \(match.winnerId ?? 0)
                Winner Type:     \(match.winnerType ?? "Unknown")
                Opponents:       \(match.opponents?.map { "\($0.opponent.name) (\($0.type))" }.joined(separator: ", ") ?? "Unknown")
                Streams:         \(match.streamsList.compactMap(\.embedUrl))
                \n
                """
            }.joined(separator: "\n\n") ?? "No Matches"

            return """
            Name:             \(tournament.name)
            Start Date:       \(DateFormatter.prettyFormatter.string(from: tournament.beginAt))
            End Date:         \(DateFormatter.prettyFormatter.string(from: tournament.endAt))
            League:           \(tournament.league?.name ?? "Unknown")
            League Image:     \(tournament.league?.imageUrl?.absoluteString ?? "–")
            League URL:       \(tournament.league?.url?.absoluteString ?? "–")
            League ID:        \(tournament.leagueId)
            Game:             \(tournament.videogame?.name ?? "Unknown")
            Game Slug:        \(tournament.videogame?.slug ?? "Unknown")
            Tier:             \(tournament.tier)
            Slug:             \(tournament.slug)
            Has Bracket:      \(tournament.hasBracket)
            Live Supported:   \(tournament.liveSupported)
            Detailed Stats:   \(tournament.detailedStats)
            Prize Pool:       \(tournament.prizepool ?? "Unknown")
            Series:           \(tournament.serie?.name ?? "Unknown")
            Series ID:        \(tournament.serieId)
            Winner ID:        \(tournament.winnerId ?? 0)
            Winner Type:      \(tournament.winnerType ?? "Unknown")
            Match Count:      \(tournament.matches?.count ?? 0)
            Matches:          \(matchesInfo)
            Last Modified:    \(DateFormatter.prettyFormatter.string(from: tournament.modifiedAt))
            ID:               \(tournament.id)
            \n
            """
        }
        
        formattedTournaments.forEach { print($0) }
    } catch {
        print("Failed to fetch upcoming tournaments: \(error)")
    }
}

func concludedTournaments() async {
    do {
        let response = try await api.allTournaments()
        let concluded = response.concludedTournaments
        print("Fetched \(concluded.count) concluded tournaments")
    } catch {
        print("Failed to fetch concluded tournaments: \(error)")
    }
}

func liveSupportedTournaments() async {
    do {
        let response = try await api.allTournaments()
        let liveSupported = response.liveSupportedTournaments
        print("Fetched \(liveSupported.count) tournaments with live support")
    } catch {
        print("Failed to fetch live supported tournaments: \(error)")
    }
}

func activePlayers() async {
    do {
        let response = try await api.allPlayers()
        let activePlayers = response.activePlayers
        print("Fetched \(activePlayers.count) active players")
    } catch {
        print("Failed to fetch active players: \(error)")
    }
}

func upcomingMatches() async {
    do {
        let response = try await api.allMatches()
        let upcomingMatches = response.upcomingMatches
        print("Fetched \(upcomingMatches.count) upcoming matches")
    } catch {
        print("Failed to fetch upcoming matches: \(error)")
    }
}

func ongoingMatches() async {
    do {
        let response = try await api.allMatches()
        let ongoingMatches = response.ongoingMatches
        print("Fetched \(ongoingMatches.count) ongoing matches")
    } catch {
        print("Failed to fetch ongoing matches: \(error)")
    }
}

func completedMatches() async {
    do {
        let response = try await api.allMatches()
        let completedMatches = response.completedMatches
        print("Fetched \(completedMatches.count) completed matches")
    } catch {
        print("Failed to fetch completed matches: \(error)")
    }
}

let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"]!

let api = StarCraftAPI(token: token)

main()
