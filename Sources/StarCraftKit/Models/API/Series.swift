import Foundation

/// StarCraft 2 series representation
public struct Series: Codable, Sendable, Identifiable {
    /// Unique identifier for the series
    public let id: Int
    
    /// Name of the series
    public let name: String
    
    /// URL-friendly version of the series name
    public let slug: String
    
    /// Series start date
    public let beginAt: Date?
    
    /// Series end date
    public let endAt: Date?
    
    /// ID of the parent league
    public let leagueID: Int
    
    /// Tournaments in this series
    public let tournaments: [Tournament]?
    
    /// Year of the series
    public let year: Int?
    
    /// Season name
    public let season: String?
    
    /// Full series name
    public let fullName: String
    
    /// Winner of the series
    public let winnerID: Int?
    
    /// Winner type (player or team)
    public let winnerType: String?
    
    /// Last modification timestamp
    public let modifiedAt: Date
    
    /// Description of the series
    public let description: String?
    
    /// Tier level
    public let tier: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case beginAt = "begin_at"
        case endAt = "end_at"
        case leagueID = "league_id"
        case tournaments
        case year
        case season
        case fullName = "full_name"
        case winnerID = "winner_id"
        case winnerType = "winner_type"
        case modifiedAt = "modified_at"
        case description
        case tier
    }
}

// MARK: - Computed Properties
public extension Series {
    /// Check if series is currently running
    var isRunning: Bool {
        guard let beginAt = beginAt else { return false }
        if let endAt = endAt {
            let now = Date()
            return now >= beginAt && now <= endAt
        }
        return Date() >= beginAt
    }
    
    /// Check if series has ended
    var hasEnded: Bool {
        guard let endAt = endAt else { return false }
        return Date() > endAt
    }
    
    /// Check if series hasn't started
    var isPending: Bool {
        guard let beginAt = beginAt else { return false }
        return Date() < beginAt
    }
    
    /// Duration of the series
    var duration: TimeInterval? {
        guard let beginAt = beginAt, let endAt = endAt else { return nil }
        return endAt.timeIntervalSince(beginAt)
    }
    
    /// Number of tournaments
    var tournamentCount: Int {
        tournaments?.count ?? 0
    }
}

// MARK: - Equatable
extension Series: Equatable {
    public static func == (lhs: Series, rhs: Series) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Series: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}