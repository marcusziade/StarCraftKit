import Foundation
import StarCraftKit

@main
struct StarCraftCLI {
    private let api: StarCraftAPI
    private var commands: [String: Command] = [:]

    init() {
        guard let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            print("\(ANSIColor.warning)Error: PANDA_TOKEN environment variable not set\(ANSIColor.reset)")
            exit(1)
        }

        self.api = StarCraftAPI(token: token)
        setupCommands()
    }

    private mutating func setupCommands() {
        commands = [
            "-ap": ActivePlayersCommand(api: api),
            "-lt": LiveTournamentsCommand(api: api),
            "-om": OngoingMatchesCommand(api: api),
            "-ot": OngoingTournamentsCommand(api: api),
            "-ut": UpcomingTournamentsCommand(api: api)
        ]
    }

    static func main() {
        let cli = StarCraftCLI()
        let arguments = CommandLine.arguments

        if arguments.count > 1 {
            cli.execute(command: arguments[1])
        } else {
            cli.printInstructions()
        }
    }

    private func execute(command: String) {
        guard let cmd = commands[command] else {
            print("\(ANSIColor.warning)Unknown command: \(command)\(ANSIColor.reset)")
            return
        }

        Task.detached(priority: .medium) {
            do {
                try await cmd.execute()
                exit(0)
            } catch {
                print("\(ANSIColor.warning)Error: \(error)\(ANSIColor.reset)")
                exit(1)
            }
        }

        RunLoop.current.run()
    }

    private func printInstructions() {
        print()
        print("\(ANSIColor.neon)\(ANSIColor.bold)╔══════════════════════════════════╗")
        print("║     Welcome to StarCraftCLI II     ║")
        print("╚══════════════════════════════════╝\(ANSIColor.reset)")
        print()
        print("\(ANSIColor.terran)Available Commands:\(ANSIColor.reset)")
        commands.forEach { cmd, implementation in
            print("\(ANSIColor.protoss)\(cmd)\(ANSIColor.reset)  \(implementation.description)")
        }
        print()
        print("\(ANSIColor.warning)Note: You must provide a valid PANDA_TOKEN environment variable\(ANSIColor.reset)")
        print()
        print("\(ANSIColor.neon)Usage:\(ANSIColor.reset) swift run StarCraftCLI <command>")
        print("\(ANSIColor.neon)Example:\(ANSIColor.reset) swift run StarCraftCLI -ap")
    }
}
