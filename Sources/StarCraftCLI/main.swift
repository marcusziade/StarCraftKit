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
            await fetchTournaments()
        case "-p":
            await fetchPlayers()
        case "-m":
            await fetchMatches()
        case "-ot":
            await fetchOngoingTournaments()
        case "-ut":
            await fetchUpcomingTournaments()
        case "-ct":
            await fetchConcludedTournaments()
        case "-lt":
            await fetchLiveSupportedTournaments()
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
    print("-t - Fetch all tournaments")
    print("-p - Fetch all players")
    print("-m - Fetch all matches")
    print("-ot - Fetch ongoing tournaments")
    print("-ut - Fetch upcoming tournaments")
    print("-ct - Fetch concluded tournaments")
    print("-lt - Fetch live supported tournaments")
    print()
    print("You must provide a valid PANDA_TOKEN environment variable")
    print()
    print("Usage: swift build, swift run StarCraftCLI <command>")
    print("Example: swift run StarCraftCLI -t. This will fetch all tournaments")
}

func fetchTournaments() async {
    do {
        let response = try await api.allTournaments()
        print("Fetched \(response.tournaments.count) tournaments")
        print("Upcoming tournaments: \(response.upcomingTournaments.count)")
    } catch {
        print("Failed to fetch tournaments: \(error)")
    }
}

func fetchPlayers() async {
    do {
        let response = try await api.allPlayers()
        print("Fetched \(response.players.count) players")
    } catch {
        print("Failed to fetch players: \(error)")
    }
}

func fetchMatches() async {
    do {
        let response = try await api.allMatches()
        print("Fetched \(response.matches.count) matches")
    } catch {
        print("Failed to fetch matches: \(error)")
    }
}

func fetchOngoingTournaments() async {
    do {
        let response = try await api.allTournaments()
        let ongoing = response.ongoingTournaments
        print("Fetched \(ongoing.count) ongoing tournaments")
    } catch {
        print("Failed to fetch ongoing tournaments: \(error)")
    }
}

func fetchUpcomingTournaments() async {
    do {
        let response = try await api.allTournaments()
        let upcoming = response.upcomingTournaments
        print("Fetched \(upcoming.count) upcoming tournaments")
    } catch {
        print("Failed to fetch upcoming tournaments: \(error)")
    }
}

func fetchConcludedTournaments() async {
    do {
        let response = try await api.allTournaments()
        let concluded = response.concludedTournaments
        print("Fetched \(concluded.count) concluded tournaments")
    } catch {
        print("Failed to fetch concluded tournaments: \(error)")
    }
}

func fetchLiveSupportedTournaments() async {
    do {
        let response = try await api.allTournaments()
        let liveSupported = response.liveSupportedTournaments
        print("Fetched \(liveSupported.count) tournaments with live support")
    } catch {
        print("Failed to fetch live supported tournaments: \(error)")
    }
}

let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"]!

let api = StarCraftAPI(token: token)

main()
