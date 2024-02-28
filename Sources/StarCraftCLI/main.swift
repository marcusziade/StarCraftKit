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
        case "tournaments":
            await fetchTournaments()
        case "players":
            await fetchPlayers()
        case "matches":
            await fetchMatches()
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
    print("tournaments - Fetch all tournaments")
    print("players - Fetch all players")
    print("matches - Fetch all matches")
    print()
    print("You must provide a valid PANDA_TOKEN environment variable")
    print()
    print("Usage: swift build, swift run StarCraftCLI <command>")
    print("Exampled: swift run StarCraftCLI tournaments. This will fetch tournaments")
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

let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"]!

let api = StarCraftAPI(token: token)

main()
