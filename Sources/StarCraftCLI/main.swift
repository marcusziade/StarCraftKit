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
        let tournamentNames = upcoming.map { $0.league?.name ?? "Unknown" }
        print(Set(tournamentNames))
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
