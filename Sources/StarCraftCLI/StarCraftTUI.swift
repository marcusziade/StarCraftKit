import Foundation
import StarCraftKit

@main
struct StarCraftTUI {
    private let api: StarCraftAPI
    private var commands: [String: Command] = [:]
    private var isRunning = true
    private var selectedIndex = 0
    private var selectedColumn = 0
    private let stateManager = TUIStateManager()

    // ANSI escape codes for terminal control
    private struct Terminal {
        static let up = "\u{1B}[A"
        static let down = "\u{1B}[B"
        static let right = "\u{1B}[C"
        static let left = "\u{1B}[D"
        static let clearLine = "\u{1B}[2K"
        static let clearScreen = "\u{1B}[2J\u{1B}[H"
        static let hideCursor = "\u{1B}[?25l"
        static let showCursor = "\u{1B}[?25h"

        static func enableRawMode() {
            var raw = termios()
            tcgetattr(STDIN_FILENO, &raw)
            raw.c_lflag &= ~UInt(ECHO | ICANON)
            tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw)
        }

        static func disableRawMode() {
            var raw = termios()
            tcgetattr(STDIN_FILENO, &raw)
            raw.c_lflag |= UInt(ECHO | ICANON)
            tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw)
        }
    }

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
            "-ut": UpcomingTournamentsCommand(api: api),
            "-ls": LiveStreamsCommand(api: api),
            "-pd": PlayerDetailsCommand(api: api),
            "-td": TournamentDetailsCommand(api: api),
            "-ms": MatchStatsCommand(api: api),
            "-us": UpcomingStreamsCommand(api: api),
            "-ld": LeagueDetailsCommand(api: api),
            "-sd": SeriesDetailsCommand(api: api),
            "-gs": GameStatsCommand(api: api),
            "-pa": PlayerActivityCommand(api: api)
        ]
    }

    static func main() {
        var tui = StarCraftTUI()
        tui.start()
    }

    private mutating func start() {
        Terminal.enableRawMode()
        print(Terminal.hideCursor)

        defer {
            print(Terminal.showCursor)
            Terminal.disableRawMode()
        }

        while isRunning {
            clearScreen()
            printInterface()
            handleInput()
        }

        print("\n\(ANSIColor.neon)Goodbye!\(ANSIColor.reset)")
    }

    private mutating func handleInput() {
        let sortedCommands = Array(commands.sorted(by: { $0.key < $1.key }))
        let byte = readByte()

        switch byte {
        case 0x1B:  // Escape sequence
            let _ = readByte() // Skip [
            switch readByte() {
            case 0x41:  // Up arrow
                moveUp()
            case 0x42:  // Down arrow
                moveDown()
            case 0x43:  // Right arrow
                moveRight()
            case 0x44:  // Left arrow
                moveLeft()
            default: break
            }
        case 0x6B:  // k (vim up)
            moveUp()
        case 0x6A:  // j (vim down)
            moveDown()
        case 0x6C:  // l (vim right)
            moveRight()
        case 0x68:  // h (vim left)
            moveLeft()
        case 0x0A, 0x0D, 0x20:  // Enter or Space
            if selectedIndex >= 0 && selectedIndex < sortedCommands.count {
                clearScreen()
                executeCommand(sortedCommands[selectedIndex].key)
                print("\n\(ANSIColor.terran)Press Enter to continue...\(ANSIColor.reset)")
                while readByte() != 0x0A { }
            }
        case 0x71, 0x51:  // q or Q
            isRunning = false
        default: break
        }
    }

    private mutating func moveUp() {
        let sortedCommands = Array(commands.sorted(by: { $0.key < $1.key }))
        let midpoint = (sortedCommands.count + 1) / 2
        let offset = selectedColumn * midpoint
        let maxIndex = selectedColumn == 0 ? midpoint : sortedCommands.count

        selectedIndex = ((selectedIndex - 1 - offset + midpoint) % midpoint) + offset
        if selectedIndex >= maxIndex {
            selectedIndex = maxIndex - 1
        }
    }

    private mutating func moveDown() {
        let sortedCommands = Array(commands.sorted(by: { $0.key < $1.key }))
        let midpoint = (sortedCommands.count + 1) / 2
        let offset = selectedColumn * midpoint
        let maxIndex = selectedColumn == 0 ? midpoint : sortedCommands.count

        selectedIndex = ((selectedIndex + 1 - offset) % midpoint) + offset
        if selectedIndex >= maxIndex {
            selectedIndex = offset
        }
    }

    private mutating func moveRight() {
        let sortedCommands = Array(commands.sorted(by: { $0.key < $1.key }))
        let midpoint = (sortedCommands.count + 1) / 2

        if selectedColumn == 0 {
            selectedColumn = 1
            let newIndex = selectedIndex + midpoint
            if newIndex < sortedCommands.count {
                selectedIndex = newIndex
            } else {
                selectedColumn = 0
            }
        }
    }

    private mutating func moveLeft() {
        let sortedCommands = Array(commands.sorted(by: { $0.key < $1.key }))
        let midpoint = (sortedCommands.count + 1) / 2

        if selectedColumn == 1 {
            selectedColumn = 0
            selectedIndex -= midpoint
        }
    }

    private func readByte() -> UInt8 {
        var byte: UInt8 = 0
        _ = read(STDIN_FILENO, &byte, 1)
        return byte
    }

    private mutating func executeCommand(_ command: String) {
        guard let cmd = commands[command] else {
            print("\(ANSIColor.warning)Unknown command: \(command)\(ANSIColor.reset)")
            return
        }

        stateManager.startLoading(command: command) { [self] in
            clearScreen()
            printInterface()
        }

        let semaphore = DispatchSemaphore(value: 0)
        let manager = stateManager

        Task { [weak manager] in
            do {
                try await cmd.execute()
            } catch {
                manager?.loadingMessage = "\(ANSIColor.warning)Error: \(error)\(ANSIColor.reset)"
            }
            manager?.stopLoading()
            semaphore.signal()
        }

        semaphore.wait()
    }

    private func clearScreen() {
        print(Terminal.clearScreen, terminator: "")
    }

    private func printInterface() {
        print("\(ANSIColor.neon)\(ANSIColor.bold)╔════════════════════════════════════════════════════════════════════╗")
        print("║                    StarCraftTUI II Command Center                     ║")
        print("╚════════════════════════════════════════════════════════════════════╝\(ANSIColor.reset)")

        if stateManager.isLoading {
            print("\n\(ANSIColor.terran)\(stateManager.loadingMessage)\(ANSIColor.reset)")
            return
        }

        print()
        print("\(ANSIColor.terran)Navigation:\(ANSIColor.reset)")
        print("  \(ANSIColor.protoss)↑/k\(ANSIColor.reset) Up    \(ANSIColor.protoss)↓/j\(ANSIColor.reset) Down    \(ANSIColor.protoss)←/h\(ANSIColor.reset) Left    \(ANSIColor.protoss)→/l\(ANSIColor.reset) Right")
        print("  \(ANSIColor.protoss)Enter/Space\(ANSIColor.reset) Execute    \(ANSIColor.protoss)q\(ANSIColor.reset) Quit")
        print()

        let sortedCommands = commands.sorted(by: { $0.key < $1.key })
        let midpoint = (sortedCommands.count + 1) / 2

        for i in 0..<midpoint {
            var line = ""

            // First column
            if selectedColumn == 0 && i == selectedIndex {
                line += "\(ANSIColor.neon)➤ \(ANSIColor.reset)"
            } else {
                line += "  "
            }

            let cmd1 = sortedCommands[i]
            line += "\(ANSIColor.protoss)\(cmd1.key.padRight(6))\(ANSIColor.reset)\(cmd1.value.description.padRight(45))"

            // Second column if available
            if i + midpoint < sortedCommands.count {
                if selectedColumn == 1 && i + midpoint == selectedIndex {
                    line += "\(ANSIColor.neon)➤ \(ANSIColor.reset)"
                } else {
                    line += "  "
                }

                let cmd2 = sortedCommands[i + midpoint]
                line += "\(ANSIColor.protoss)\(cmd2.key.padRight(6))\(ANSIColor.reset)\(cmd2.value.description)"
            }

            print(line)
        }

        print("\n\(ANSIColor.warning)Note: PANDA_TOKEN environment variable required\(ANSIColor.reset)")
    }
}

extension String {
    func padRight(_ length: Int) -> String {
        if self.count < length {
            return self + String(repeating: " ", count: length - self.count)
        }
        return self
    }
}
