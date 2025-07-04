import Foundation

/// StarCraft 2 league representation
public struct League: Codable, Sendable, Identifiable {
    /// Unique identifier for the league
    public let id: Int
    
    /// Name of the league
    public let name: String
    
    /// URL-friendly version of the league name
    public let slug: String
    
    /// URL to the league's logo/image
    public let imageURL: URL?
    
    /// Last modification timestamp
    public let modifiedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case imageURL = "image_url"
        case modifiedAt = "modified_at"
    }
}

// MARK: - Equatable
extension League: Equatable {
    public static func == (lhs: League, rhs: League) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension League: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}