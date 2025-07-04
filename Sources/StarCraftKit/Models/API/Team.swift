import Foundation

/// StarCraft 2 team representation
public struct Team: Codable, Sendable, Identifiable {
    /// Unique identifier for the team
    public let id: Int
    
    /// Team name
    public let name: String
    
    /// URL-friendly version of the team name
    public let slug: String
    
    /// Team acronym/abbreviation
    public let acronym: String?
    
    /// URL to team logo
    public let imageURL: URL?
    
    /// Team location/country
    public let location: String?
    
    /// Current roster
    public let players: [Player]?
    
    /// Current game focus
    public let currentVideogame: Videogame?
    
    /// Last modification timestamp
    public let modifiedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case acronym
        case imageURL = "image_url"
        case location
        case players
        case currentVideogame = "current_videogame"
        case modifiedAt = "modified_at"
    }
}

// MARK: - Computed Properties
public extension Team {
    /// Display name (acronym or full name)
    var displayName: String {
        acronym ?? name
    }
    
    /// Number of players in roster
    var rosterSize: Int {
        players?.count ?? 0
    }
    
    /// Check if team has players
    var hasRoster: Bool {
        rosterSize > 0
    }
}

// MARK: - Equatable
extension Team: Equatable {
    public static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Team: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}