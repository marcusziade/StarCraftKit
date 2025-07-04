import Foundation

/// StarCraft 2 tournament representation
public struct Tournament: Codable, Sendable, Identifiable {
    /// Unique identifier for the tournament
    public let id: Int
    
    /// Tournament name
    public let name: String
    
    /// URL-friendly version of the tournament name
    public let slug: String
    
    /// Tournament start date
    public let beginAt: Date?
    
    /// Tournament end date
    public let endAt: Date?
    
    /// ID of the parent series
    public let serieID: Int
    
    /// ID of the parent league
    public let leagueID: Int
    
    /// Whether live data is available
    public let liveSupported: Bool
    
    /// Total prize pool
    public let prizepool: String?
    
    /// Participating teams
    public let teams: [Team]?
    
    /// Winner of the tournament
    public let winnerID: Int?
    
    /// Winner type (player or team)
    public let winnerType: String?
    
    /// Last modification timestamp
    public let modifiedAt: Date
    
    /// Tier level
    public let tier: String?
    
    /// Has bracket
    public let hasBracket: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case beginAt = "begin_at"
        case endAt = "end_at"
        case serieID = "serie_id"
        case leagueID = "league_id"
        case liveSupported = "live_supported"
        case prizepool
        case teams
        case winnerID = "winner_id"
        case winnerType = "winner_type"
        case modifiedAt = "modified_at"
        case tier
        case hasBracket = "has_bracket"
    }
}

// MARK: - Computed Properties
public extension Tournament {
    /// Check if tournament is currently running
    var isRunning: Bool {
        guard let beginAt = beginAt else { return false }
        if let endAt = endAt {
            let now = Date()
            return now >= beginAt && now <= endAt
        }
        return Date() >= beginAt
    }
    
    /// Check if tournament has ended
    var hasEnded: Bool {
        guard let endAt = endAt else { return false }
        return Date() > endAt
    }
    
    /// Check if tournament hasn't started
    var isPending: Bool {
        guard let beginAt = beginAt else { return false }
        return Date() < beginAt
    }
    
    /// Duration of the tournament
    var duration: TimeInterval? {
        guard let beginAt = beginAt, let endAt = endAt else { return nil }
        return endAt.timeIntervalSince(beginAt)
    }
    
    /// Number of participating teams
    var teamCount: Int {
        teams?.count ?? 0
    }
    
    /// Parse prize pool amount
    var prizepoolAmount: Double? {
        guard let prizepool = prizepool else { return nil }
        let cleanedString = prizepool.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        return Double(cleanedString)
    }
}

// MARK: - Equatable
extension Tournament: Equatable {
    public static func == (lhs: Tournament, rhs: Tournament) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Tournament: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}