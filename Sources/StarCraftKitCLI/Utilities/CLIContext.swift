import Foundation
import StarCraftKit

// MARK: - CLI Context
struct CLIContext {
    let apiKey: String
    let authMethod: StarCraftClient.Configuration.AuthMethod
    
    static func load() throws -> CLIContext {
        guard let apiKey = ProcessInfo.processInfo.environment["PANDA_TOKEN"] else {
            throw CLIError.missingAPIKey
        }
        
        let authMethod: StarCraftClient.Configuration.AuthMethod = ProcessInfo.processInfo.environment["AUTH_METHOD"] == "query" ? .queryParameter : .bearerToken
        
        return CLIContext(apiKey: apiKey, authMethod: authMethod)
    }
}

// MARK: - CLI Errors
enum CLIError: LocalizedError {
    case missingAPIKey
    case invalidInput(String)
    case notFound(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Missing API key. Set PANDA_TOKEN environment variable."
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .notFound(let message):
            return "Not found: \(message)"
        }
    }
}