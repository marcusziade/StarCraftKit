import Foundation

struct MatchResponse: Codable {
    let matches: [Match]

    /// Returns a list of matches that are scheduled to occur in the future.
    ///
    /// This computed property filters the `matches` array to include only those
    /// matches whose status is marked as `not_started`, indicating they have not
    /// yet begun.
    var upcomingMatches: [Match] {
        matches.filter { match in
            match.status.lowercased() == "not_started"
        }
    }

    /// Returns a list of matches currently in progress.
    ///
    /// Matches are considered ongoing if their status is marked as `ongoing`.
    /// This computed property filters the `matches` array accordingly.
    var ongoingMatches: [Match] {
        matches.filter { match in
            match.status.lowercased() == "ongoing"
        }
    }

    /// Returns a list of matches that have been completed.
    ///
    /// A match is deemed completed if its status is `finished`. This computed property
    /// filters all matches to return only those that meet this criteria.
    var completedMatches: [Match] {
        matches.filter { match in
            match.status.lowercased() == "finished"
        }
    }

    /// Finds matches involving a specific player.
    ///
    /// - Parameter playerId: The unique identifier of the player.
    /// - Returns: An array of `Match` instances where the specified player is one of the opponents.
    func matchesBy(playerId: Int) -> [Match] {
        matches.filter { match in
            match.opponents?.contains { $0.opponent.id == playerId } ?? false
        }
    }

    /// Calculates the average duration of all matches.
    ///
    /// Assumes each `Game` within a match has a duration measured in seconds. This computed
    /// property aggregates all game durations across all matches to compute the average.
    var averageMatchDuration: Double {
        let durations = matches.compactMap { $0.games?.compactMap { $0.length }.reduce(0, +) }
        let totalDuration = durations.reduce(0, +)
        return durations.isEmpty ? 0 : Double(totalDuration) / Double(durations.count)
    }

    /// Groups matches by their associated league.
    ///
    /// Matches are grouped based on the league ID. Matches without a league are grouped under `-1`.
    /// - Returns: A dictionary with league IDs as keys and arrays of matches as values.
    var matchesByLeague: [Int: [Match]] {
        Dictionary(grouping: matches, by: { $0.league?.id ?? -1 })
    }

    /// Groups matches by their associated tournament.
    ///
    /// Matches are grouped by their `tournamentId` field.
    /// - Returns: A dictionary where each key is a tournament ID and each value is an array of matches within that tournament.
    var matchesByTournament: [Int: [Match]] {
        Dictionary(grouping: matches, by: { $0.tournamentId })
    }

    /// Computes the win rate of a specified player across all matches.
    ///
    /// - Parameter playerId: The unique identifier of the player.
    /// - Returns: The win rate of the player as a percentage of matches won out of those participated in.
    func winRateByPlayer(playerId: Int) -> Double {
        let playerMatches = matchesBy(playerId: playerId)
        let wins = playerMatches.filter { $0.winner?.id == playerId }.count
        return Double(wins) / Double(playerMatches.count) * 100.0
    }

    /// Identifies the most common matchup between two players.
    ///
    /// - Returns: A tuple containing the IDs of the two players involved in the most frequent matchup and the count of such matches, or `nil` if there's no such matchup.
    var mostCommonMatchup: (player1Id: Int, player2Id: Int, count: Int)? {
        var matchupCounts = [String: Int]()
        for match in matches {
            guard let opponents = match.opponents, opponents.count == 2 else { continue }
            let sortedIds = opponents.map { $0.opponent.id }.sorted()
            let key = "\(sortedIds[0])_\(sortedIds[1])"
            matchupCounts[key, default: 0] += 1
        }
        if let mostCommon = matchupCounts.max(by: { $0.value < $1.value }) {
            let ids = mostCommon.key.split(separator: "_").compactMap { Int($0) }
            if ids.count == 2 {
                return (player1Id: ids[0], player2Id: ids[1], count: mostCommon.value)
            }
        }
        return nil
    }

    /// Filters matches that have detailed statistics available.
    ///
    /// - Returns: An array of `Match` instances where `detailedStats` is true, indicating detailed statistics are available for these matches.
    var matchesWithDetailedStats: [Match] {
        matches.filter { $0.detailedStats }
    }
}
