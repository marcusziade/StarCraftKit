import Foundation

public struct Player: Codable, Identifiable {
    public let active: Bool
    public let age: Int?
    public let birthday: String?
    public let firstName: String?
    public let id: Int
    public let imageUrl: URL?
    public let lastName: String?
    public let modifiedAt: Date
    public let name: String
    public let nationality: String?
    public let role: String?
    public let slug: String
    public let currentVideogame: Videogame?
}

public struct Tournament: Codable, Identifiable {
    public let beginAt: Date
    public let detailedStats: Bool
    public let endAt: Date
    public let hasBracket: Bool
    public let id: Int
    public let league: League?
    public let leagueId: Int
    public let liveSupported: Bool
    public let matches: [Match]?
    public let modifiedAt: Date
    public let name: String
    public let prizepool: String?
    public let serie: Serie?
    public let serieId: Int
    public let slug: String
    public let tier: String
    public let videogame: Videogame?
    public let winnerId: Int?
    public let winnerType: String?
}

public struct OpponentEntry: Codable {
    public let opponent: Player
    public let type: String
}

public struct Videogame: Codable {
    public let id: Int
    public let name: String
    public let slug: String
}

public struct Game: Codable, Identifiable {
    public let beginAt: Date?
    public let complete: Bool
    public let detailedStats: Bool
    public let endAt: Date?
    public let finished: Bool
    public let forfeit: Bool
    public let id: Int?
    public let length: Int?
    public let matchId: Int
    public let position: Int
    public let status: String
    public let winner: Winner?
}

public struct Result: Codable {
    public let score: Int
    public let playerId: Int
}

public struct Stream: Codable {
    public let embedUrl: URL?
    public let language: String
    public let main: Bool
    public let official: Bool
    public let rawUrl: URL?
}

public struct League: Codable, Identifiable, Hashable {
    public let id: Int
    public let imageUrl: URL?
    public let modifiedAt: Date
    public let name: String
    public let slug: String
    public let url: URL?
}

public struct Serie: Codable, Identifiable {
    public let beginAt: Date
    public let endAt: Date
    public let fullName: String
    public let id: Int
    public let leagueId: Int
    public let modifiedAt: Date
    public let name: String?
    public let season: String?
    public let slug: String
    public let winnerId: Int?
    public let winnerType: String?
    public let year: Int
}

public struct Match: Codable, Identifiable {
    public let status: String
    public let detailedStats: Bool
    public let live: Live
    public let scheduledAt: Date?
    public let leagueId: Int?
    public let games: [Game]?
    public let matchType: String
    public let results: [Result]?
    public let id: Int?
    public let name: String
    public let endAt: Date?
    public let beginAt: Date?
    public let winnerType: String?
    public let originalScheduledAt: Date?
    public let draw: Bool
    public let numberOfGames: Int
    public let rescheduled: Bool
    public let league: League?
    public let serie: Serie?
    public let slug: String
    public let videogame: Videogame?
    public let tournamentId: Int
    public let winner: Player?
    public let modifiedAt: Date
    public let opponents: [OpponentEntry]?
    public let streamsList: [Stream]
    public let winnerId: Int?
    public let tournament: Tournament?
    public let gameAdvantage: Int?
    public let forfeit: Bool
}

public struct Live: Codable {
    public let opensAt: Date?
    public let supported: Bool
    public let url: URL?
}

public struct Winner: Codable {
    public let id: Int?
    public let type: String
}
