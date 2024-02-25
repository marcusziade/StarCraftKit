import Foundation

struct TournamentsResponse: Codable {
    let tournaments: [Tournament]

    /// Returns a list of tournaments that are currently ongoing.
    ///
    /// This computed property filters the `tournaments` array to include only those tournaments
    /// that have begun but not yet ended based on their `beginAt` and `endAt` dates.
    var ongoingTournaments: [Tournament] {
        let currentDate = Date()
        return tournaments.filter { tournament in
            let beginDate = tournament.beginAt
            let endDate = tournament.endAt
            return beginDate <= currentDate && endDate >= currentDate
        }
    }

    /// Returns a list of upcoming tournaments.
    ///
    /// Tournaments are considered upcoming if their start date is in the future.
    var upcomingTournaments: [Tournament] {
        let currentDate = Date()
        return tournaments.filter { tournament in
            let beginDate = tournament.beginAt
            return beginDate > currentDate
        }
    }

    /// Returns a list of tournaments that have concluded.
    ///
    /// A tournament is concluded if its end date is in the past.
    var concludedTournaments: [Tournament] {
        let currentDate = Date()  // Assuming `endAt` is a `Date` object
        return tournaments.filter { tournament in
            let endDate = tournament.endAt
            return endDate < currentDate
        }
    }

    /// Groups tournaments by their tier.
    ///
    /// - Returns: A dictionary where each key is a tournament tier (e.g., "S", "A") and each value is an array of tournaments belonging to that tier.
    var tournamentsByTier: [String: [Tournament]] {
        Dictionary(grouping: tournaments, by: { $0.tier })
    }

    /// Finds a tournament by its unique ID.
    ///
    /// - Parameter id: The unique identifier of the tournament.
    /// - Returns: A `Tournament` instance with the matching ID, or `nil` if no match is found.
    func tournamentById(id: Int) -> Tournament? {
        tournaments.first(where: { $0.id == id })
    }

    /// Returns a list of tournaments with a specific prize pool.
    ///
    /// - Parameter prizepool: The prize pool to filter tournaments by.
    /// - Returns: An array of `Tournament` instances that have the specified prize pool.
    func tournamentsWithPrizepool(_ prizepool: String) -> [Tournament] {
        tournaments.filter { $0.prizepool == prizepool }
    }

    /// Returns the total number of tournaments.
    ///
    /// This computed property provides the total count of tournaments in the response.
    var totalTournaments: Int {
        tournaments.count
    }

    /// Returns a list of tournaments sorted by their start date, from the most recent to the oldest.
    ///
    /// This computed property sorts the `tournaments` array by the `beginAt` date in descending order.
    var tournamentsByStartDate: [Tournament] {
        tournaments.sorted(by: { $0.beginAt > $1.beginAt })
    }

    /// Identifies tournaments supporting live games.
    ///
    /// - Returns: An array of `Tournament` instances where `liveSupported` is true, indicating live game support.
    var liveSupportedTournaments: [Tournament] {
        tournaments.filter { $0.liveSupported }
    }
}
