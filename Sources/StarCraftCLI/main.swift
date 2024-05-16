import Foundation
import StarCraftKit

let arguments = CommandLine.arguments

func main() {
    guard arguments.count > 1 else {
        printInstructions()
        return
    }

    let command = arguments[1]

    Task.detached(priority: .medium) {
        switch command {
        case "-ot":
            await ongoingTournaments()
        case "-ut":
            await upcomingTournaments()
        case "-lt":
            await liveSupportedTournaments()
        case "-om":
            await ongoingMatches()
        default:
            print("Unknown command: \(command)")
        }
    }

    RunLoop.current.run()
}

let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"]!

let api = StarCraftAPI(token: token)

main()
