import ArgumentParser
import Foundation
import StarCraftKit

// MARK: - Date Formatting Extensions
extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

extension Int {
    var formattedString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

@main
struct StarCraftCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "starcraft-cli",
        abstract: "StarCraft 2 API testing CLI",
        version: "1.0.0",
        subcommands: [
            LeaguesCommand.self,
            MatchesCommand.self,
            PlayersCommand.self,
            TeamsCommand.self,
            SeriesCommand.self,
            TournamentsCommand.self,
            TestCommand.self,
            CacheCommand.self
        ],
        defaultSubcommand: TestCommand.self
    )
}

// MARK: - Configuration
extension StarCraftClient.Configuration {
    static func fromEnvironment() throws -> Self {
        guard let apiKey = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            throw CLIError.missingAPIKey
        }
        
        let authMethod: AuthMethod = ProcessInfo.processInfo.environment["AUTH_METHOD"] == "query" ? .queryParameter : .bearerToken
        
        return StarCraftClient.Configuration(apiKey: apiKey, authMethod: authMethod)
    }
}

// MARK: - CLI Errors
enum CLIError: LocalizedError {
    case missingAPIKey
    case invalidInput(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Missing API key. Set PANDA_TOKEN environment variable."
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        }
    }
}

// MARK: - Output Formatting
protocol OutputFormattable {
    func formatForOutput() -> String
}

extension League: OutputFormattable {
    func formatForOutput() -> String {
        """
        League: \(name)
        ID: \(id)
        Slug: \(slug)
        Modified: \(modifiedAt.formattedString)
        """
    }
}

extension Match: OutputFormattable {
    func formatForOutput() -> String {
        """
        Match: \(name)
        Status: \(status.rawValue)
        Begin: \(beginAt?.formattedString ?? "TBD")
        Tournament: \(tournamentID)
        """
    }
}

extension Player: OutputFormattable {
    func formatForOutput() -> String {
        """
        Player: \(displayName)
        Nationality: \(nationality ?? "Unknown")
        Team: \(currentTeam?.name ?? "None")
        Role: \(role ?? "Unknown")
        """
    }
}

extension Team: OutputFormattable {
    func formatForOutput() -> String {
        """
        Team: \(displayName)
        Location: \(location ?? "Unknown")
        Players: \(rosterSize)
        """
    }
}

extension Series: OutputFormattable {
    func formatForOutput() -> String {
        """
        Series: \(fullName)
        Year: \(year ?? 0)
        Begin: \(beginAt?.formattedString ?? "TBD")
        Tournaments: \(tournamentCount)
        """
    }
}

extension Tournament: OutputFormattable {
    func formatForOutput() -> String {
        """
        Tournament: \(name)
        Prize Pool: \(prizepool ?? "None")
        Begin: \(beginAt?.formattedString ?? "TBD")
        Teams: \(teamCount)
        """
    }
}