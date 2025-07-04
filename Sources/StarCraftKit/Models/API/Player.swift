import Foundation

/// A professional StarCraft II player.
///
/// The `Player` type represents a professional StarCraft II esports player,
/// including their personal information, team affiliation, and gaming history.
///
/// ## Accessing Player Information
///
/// ```swift
/// // Fetch a specific player
/// let player = try await client.getPlayer(id: 12345)
/// 
/// // Display player info
/// print("Player: \(player.name)")
/// print("Real name: \(player.fullName)")
/// print("Country: \(player.nationality ?? "Unknown")")
/// print("Team: \(player.currentTeam?.name ?? "No team")")
/// 
/// // Search for players
/// let parameters = QueryParameters().search("Serral")
/// let players = try await client.getPlayers(parameters: parameters)
/// ```
///
/// ## Player Properties
///
/// Players have both gaming and personal information:
/// - Gaming info: ``name``, ``currentTeam``, ``role``
/// - Personal info: ``firstName``, ``lastName``, ``age``, ``nationality``
/// - Media: ``imageURL`` for player photos
///
/// ## Topics
///
/// ### Identity
/// - ``id``
/// - ``name``
/// - ``slug``
///
/// ### Personal Information
/// - ``firstName``
/// - ``lastName``
/// - ``fullName``
/// - ``age``
/// - ``birthday``
/// - ``nationality``
///
/// ### Gaming Profile
/// - ``currentTeam``
/// - ``role``
/// - ``currentVideogame``
///
/// ### Media
/// - ``imageURL``
public struct Player: Codable, Sendable, Identifiable {
    /// Unique identifier for the player
    public let id: Int
    
    /// Player's gaming name (e.g., "Serral", "Maru", "Dark")
    public let name: String
    
    /// URL-friendly version of the player name
    public let slug: String
    
    /// Player's first name
    public let firstName: String?
    
    /// Player's last name
    public let lastName: String?
    
    /// Player's role/position
    public let role: String?
    
    /// Player's nationality as ISO country code (e.g., "KR" for South Korea, "FI" for Finland)
    public let nationality: String?
    
    /// URL to the player's profile photo
    public let imageURL: URL?
    
    /// The team the player currently represents
    public let currentTeam: Team?
    
    /// Current game specialization
    public let currentVideogame: Videogame?
    
    /// Player's age
    public let age: Int?
    
    /// Player's birthday
    public let birthday: Date?
    
    /// Player's hometown
    public let hometown: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case firstName = "first_name"
        case lastName = "last_name"
        case role
        case nationality
        case imageURL = "image_url"
        case currentTeam = "current_team"
        case currentVideogame = "current_videogame"
        case age
        case birthday
        case hometown
    }
}

/// Videogame information
public struct Videogame: Codable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
}

// MARK: - Computed Properties
public extension Player {
    /// Full name if available
    var fullName: String? {
        guard let firstName = firstName, let lastName = lastName else { return nil }
        return "\(firstName) \(lastName)"
    }
    
    /// Display name (full name or gaming name)
    var displayName: String {
        fullName ?? name
    }
    
    /// Check if player is on a team
    var hasTeam: Bool {
        currentTeam != nil
    }
}

// MARK: - Equatable
extension Player: Equatable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Player: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}