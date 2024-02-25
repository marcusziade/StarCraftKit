import Foundation

/// All the endpoints available in the PandaScore API for StarCraft II.
public enum StarCraft2Endpoint: String {
    case players

    case allMatches
    case pastMatches
    case upcomingMatches
    case ongoingMatches

    case allTournaments
    case pastTournaments
    case upcomingTournaments
    case ongoingTournaments

    /// The path for the endpoint. This is used to construct the full URL for the API request.
    var path: String {
        switch self {
        case .players:
            return "players"

        case .allMatches:
            return "matches"
        case .pastMatches:
            return "matches/past"
        case .upcomingMatches:
            return "matches/upcoming"
        case .ongoingMatches:
            return "matches/ongoing"

        case .allTournaments:
            return "tournaments"
        case .pastTournaments:
            return "tournaments/past"
        case .upcomingTournaments:
            return "tournaments/upcoming"
        case .ongoingTournaments:
            return "tournaments/ongoing"
        }
    }
}
