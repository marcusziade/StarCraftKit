import Foundation

public extension Array<Tournament> {
    /// Groups the tournaments by their associated league and returns an array of tuples containing the league and its corresponding tournaments.
    ///
    /// The tournaments are grouped based on their `league` property. If a tournament has a `nil` league, it will be filtered out from the result.
    ///
    /// - Returns: An array of tuples, where each tuple contains a `League` instance and an array of its associated `Tournament` instances. The tuples are sorted based on the league's name in ascending order.
    /// - Complexity: O(*n*), where *n* is the number of tournaments in the array.
    func groupedByLeague() -> [(league: League, tournaments: [Tournament])] {
        let groupedTournaments = Dictionary(grouping: self, by: { $0.league })
            .mapValues { tournaments -> [Tournament] in
                tournaments.compactMap { $0 }
            }
        
        return groupedTournaments
            .compactMap { (league, tournaments) -> (league: League, tournaments: [Tournament])? in
                guard let league else {
                    return nil
                }
                return (league: league, tournaments: tournaments)
            }
            .sorted { $0.league.name < $1.league.name }
    }
}
