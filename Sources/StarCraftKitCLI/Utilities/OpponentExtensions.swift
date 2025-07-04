import Foundation
import StarCraftKit

// MARK: - Opponent Extensions

extension Opponent {
    /// Enumeration to represent the type of opponent
    public enum OpponentType {
        case player(OpponentDetails)
        case team(OpponentDetails)
        case none
        
        var id: Int? {
            switch self {
            case .player(let details), .team(let details):
                return details.id
            case .none:
                return nil
            }
        }
    }
    
    /// Get the opponent type based on the type string
    public var opponentType: OpponentType {
        switch type.lowercased() {
        case "player":
            return .player(opponent)
        case "team":
            return .team(opponent)
        default:
            return .none
        }
    }
}

extension OpponentDetails {
    /// Display name for the opponent
    public var displayName: String {
        return name
    }
    
    /// Check if this is a team based on certain properties
    public var isTeam: Bool {
        return acronym != nil || location != nil
    }
    
    /// Check if this is a player
    public var isPlayer: Bool {
        return nationality != nil || firstName != nil || lastName != nil || role != nil
    }
}