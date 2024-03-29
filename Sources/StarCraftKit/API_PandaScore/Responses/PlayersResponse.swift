import Foundation

public struct PlayersResponse: Codable {
    public let players: [Player]
    public init(players: [Player]) {
        self.players = players
    }

    /// Returns a list of active players.
    ///
    /// This computed property filters the `players` array to include only those players who are marked as active.
    public var activePlayers: [Player] {
        players.filter { $0.active }
    }

    /// Returns a list of players sorted by age, youngest first.
    ///
    /// This computed property sorts the `players` array by the player's age in ascending order.
    public var playersByAge: [Player] {
        players.sorted(by: { ($0.age ?? 0) < ($1.age ?? 0) })
    }

    /// Returns a list of players from a specific country.
    ///
    /// - Parameter nationality: The country code (e.g., "KR" for South Korea) to filter players by.
    /// - Returns: An array of `Player` instances matching the specified nationality.
    public func playersFrom(nationality: String) -> [Player] {
        players.filter { $0.nationality == nationality }
    }

    /// Groups players by the race they play.
    ///
    /// - Returns: A dictionary where each key is a race (e.g., "Protoss", "Terran", "Zerg") and each value is an array of players who play that race.
    public var playersByPlayedRace: [String: [Player]] {
        Dictionary(grouping: players, by: { $0.role ?? "Unknown" })
    }

    /// Finds a player by their unique ID.
    ///
    /// - Parameter id: The unique identifier of the player.
    /// - Returns: A `Player` instance with the matching ID, or `nil` if no match is found.
    public func playerById(id: Int) -> Player? {
        players.first(where: { $0.id == id })
    }

    /// Returns a list of players who do not have an associated image URL.
    ///
    /// This computed property filters the `players` array to include only those players who lack an image URL.
    public var playersWithoutImage: [Player] {
        players.filter { $0.imageUrl == nil }
    }

    /// Returns the average age of all players.
    ///
    /// This computed property calculates the average age of the players.
    public var averageAge: Double {
    let totalAge = players.reduce(0) { $0 + ($1.age ?? 0) }
        return players.isEmpty ? 0 : Double(totalAge) / Double(players.count)
    }

    /// Returns a list of players sorted by their name alphabetically.
    ///
    /// This computed property sorts the `players` array by the player's name in ascending alphabetical order.
    public var playersByName: [Player] {
        players.sorted(by: { $0.name < $1.name })
    }

    /// Identifies players who have recently modified their profile.
    ///
    /// - Returns: An array of `Player` instances sorted by the most recently modified profiles first.
    public var recentlyModifiedPlayers: [Player] {
        players.sorted(by: { $0.modifiedAt > $1.modifiedAt })
    }
}
