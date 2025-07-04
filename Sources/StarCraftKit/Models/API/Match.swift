import Foundation

/// Status of a match
public enum MatchStatus: String, Codable, Sendable {
    case notStarted = "not_started"
    case running
    case finished
}

/// StarCraft 2 match representation
public struct Match: Codable, Sendable, Identifiable {
    /// Unique identifier for the match
    public let id: Int
    
    /// Name of the match
    public let name: String
    
    /// URL-friendly version of the match name
    public let slug: String
    
    /// Current status of the match
    public let status: MatchStatus
    
    /// ID of the parent tournament
    public let tournamentID: Int
    
    /// ID of the parent series
    public let serieID: Int
    
    /// Scheduled start time
    public let beginAt: Date?
    
    /// Actual end time
    public let endAt: Date?
    
    /// Number of games in the match
    public let numberOfGames: Int
    
    /// List of games in the match
    public let games: [Game]
    
    /// Teams/players competing
    public let opponents: [Opponent]
    
    /// Match results
    public let results: [MatchResult]
    
    /// Winning team/player
    public let winner: Winner?
    
    /// ID of the winner
    public let winnerID: Int?
    
    /// Live match data
    public let live: LiveData?
    
    /// Available streams
    public let streams: [Stream]?
    
    /// Last modification timestamp
    public let modifiedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case status
        case tournamentID = "tournament_id"
        case serieID = "serie_id"
        case beginAt = "begin_at"
        case endAt = "end_at"
        case numberOfGames = "number_of_games"
        case games
        case opponents
        case results
        case winner
        case winnerID = "winner_id"
        case live
        case streams = "streams_list"
        case modifiedAt = "modified_at"
    }
}

/// Game within a match
public struct Game: Codable, Sendable {
    public let id: Int
    public let beginAt: Date?
    public let endAt: Date?
    public let complete: Bool
    public let finished: Bool
    public let forfeit: Bool
    public let length: Int?
    public let position: Int
    public let status: MatchStatus
    public let winner: GameWinner?
    public let winnerType: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case complete
        case finished
        case forfeit
        case length
        case position
        case status
        case winner
        case winnerType = "winner_type"
    }
}

/// Game winner information (simplified)
public struct GameWinner: Codable, Sendable {
    public let id: Int?
    public let type: String
}

/// Opponent in a match
public struct Opponent: Codable, Sendable {
    public let opponent: OpponentDetails
    public let type: String
}

/// Opponent details
public struct OpponentDetails: Codable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let imageURL: URL?
    public let acronym: String?
    public let location: String?
    public let active: Bool?
    public let role: String?
    public let modifiedAt: Date?
    public let birthday: Date?
    public let firstName: String?
    public let lastName: String?
    public let nationality: String?
    public let age: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case imageURL = "image_url"
        case acronym
        case location
        case active
        case role
        case modifiedAt = "modified_at"
        case birthday
        case firstName = "first_name"
        case lastName = "last_name"
        case nationality
        case age
    }
}

/// Match result
public struct MatchResult: Codable, Sendable {
    public let score: Int
    public let teamID: Int?
    public let playerID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case score
        case teamID = "team_id"
        case playerID = "player_id"
    }
}

/// Winner information
public struct Winner: Codable, Sendable {
    public let id: Int
    public let type: String?
    public let name: String?
    public let slug: String?
}

/// Live match data
public struct LiveData: Codable, Sendable {
    public let supported: Bool
    public let opensAt: Date?
    public let url: URL?
    
    private enum CodingKeys: String, CodingKey {
        case supported
        case opensAt = "opens_at"
        case url
    }
}

/// Stream information
public struct Stream: Codable, Sendable {
    public let language: String
    public let main: Bool
    public let official: Bool
    public let rawURL: URL
    public let embedURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case language
        case main
        case official
        case rawURL = "raw_url"
        case embedURL = "embed_url"
    }
}

// MARK: - Computed Properties
public extension Match {
    /// Check if match is live
    var isLive: Bool {
        status == .running
    }
    
    /// Check if match has ended
    var hasEnded: Bool {
        status == .finished
    }
    
    /// Check if match hasn't started
    var isPending: Bool {
        status == .notStarted
    }
    
    /// Get match duration if available
    var duration: TimeInterval? {
        guard let beginAt = beginAt, let endAt = endAt else { return nil }
        return endAt.timeIntervalSince(beginAt)
    }
}