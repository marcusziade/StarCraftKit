import Foundation

public struct Player: Codable {
    let active: Bool
    let age: Int?
    let birthday: String?
    let firstName: String?
    let id: Int
    let imageUrl: URL?
    let lastName: String?
    let modifiedAt: Date
    let name: String
    let nationality: String
    let role: String?
    let slug: String
    let currentVideogame: Videogame?
}

public struct Tournament: Codable {
    let beginAt: Date
    let detailedStats: Bool
    let endAt: Date
    let hasBracket: Bool
    let id: Int
    let league: League?
    let leagueId: Int
    let liveSupported: Bool
    let matches: [Match]?
    let modifiedAt: Date
    let name: String
    let prizepool: String?
    let serie: Serie?
    let serieId: Int
    let slug: String
    let tier: String
    let videogame: Videogame?
    let winnerId: Int?
    let winnerType: String?
}

struct OpponentEntry: Codable {
    let opponent: Player
    let type: String
}

struct Videogame: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Game: Codable {
    let beginAt: Date?
    let complete: Bool
    let detailedStats: Bool
    let endAt: Date?
    let finished: Bool
    let forfeit: Bool
    let id: Int?
    let length: Int?
    let matchId: Int
    let position: Int
    let status: String
    let winner: Winner?
}

struct Result: Codable {
    let score: Int
    let playerId: Int
}

struct Stream: Codable {
    let embedUrl: URL?
    let language: String
    let main: Bool
    let official: Bool
    let rawUrl: URL?
}

struct League: Codable {
    let id: Int
    let imageUrl: URL?
    let modifiedAt: Date
    let name: String
    let slug: String
    let url: URL?
}

struct Serie: Codable {
    let beginAt: Date
    let endAt: Date
    let fullName: String
    let id: Int
    let leagueId: Int
    let modifiedAt: Date
    let name: String?
    let season: String?
    let slug: String
    let winnerId: Int?
    let winnerType: String?
    let year: Int
}

public struct Match: Codable {
    let status: String
    let detailedStats: Bool
    let live: Live
    let scheduledAt: Date?
    let leagueId: Int?
    let games: [Game]?
    let matchType: String
    let results: [Result]?
    let id: Int?
    let name: String
    let endAt: Date?
    let beginAt: Date?
    let winnerType: String?
    let originalScheduledAt: Date?
    let draw: Bool
    let numberOfGames: Int
    let rescheduled: Bool
    let league: League?
    let serie: Serie?
    let slug: String
    let videogame: Videogame?
    let tournamentId: Int
    let winner: Player?
    let modifiedAt: Date
    let opponents: [OpponentEntry]?
    let streamsList: [Stream]
    let winnerId: Int?
    let tournament: Tournament?
    let gameAdvantage: Int?
    let forfeit: Bool
}

struct Live: Codable {
    let opensAt: Date?
    let supported: Bool
    let url: URL?
}

struct Winner: Codable {
    let id: Int?
    let type: String
}
