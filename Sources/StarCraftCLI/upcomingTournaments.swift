import Foundation

func upcomingTournaments() async {
    do {
        let response = try await api.allTournaments()
        let upcoming = response.upcomingTournaments

        let formattedTournaments = upcoming.map { tournament in
            let matchesInfo = tournament.matches?.map { match in
                """
                Match Name:      \(match.name)
                Match ID:        \(match.id ?? 0)
                Status:          \(match.status)
                Scheduled At:    \(match.scheduledAt.map { DateFormatter.prettyFormatter.string(from: $0) } ?? "Unknown")
                Begin At:        \(match.beginAt.map { DateFormatter.prettyFormatter.string(from: $0) } ?? "Unknown")
                End At:          \(match.endAt.map { DateFormatter.prettyFormatter.string(from: $0) } ?? "Unknown")
                Number of Games: \(match.numberOfGames)
                Match Type:      \(match.matchType)
                Detailed Stats:  \(match.detailedStats)
                Live Supported:  \(match.live.supported)
                Draw:            \(match.draw)
                Forfeit:         \(match.forfeit)
                Rescheduled:     \(match.rescheduled)
                Game Advantage:  \(match.gameAdvantage ?? 0)
                Winner ID:       \(match.winnerId ?? 0)
                Winner Type:     \(match.winnerType ?? "Unknown")
                Opponents:       \(match.opponents?.map { "\($0.opponent.name) (\($0.type))" }.joined(separator: ", ") ?? "Unknown")
                Streams:         \(match.streamsList.compactMap(\.embedUrl))
                \n
                """
            }.joined(separator: "\n\n") ?? "No Matches"

            return """
            Name:             \(tournament.name)
            Start Date:       \(DateFormatter.prettyFormatter.string(from: tournament.beginAt))
            End Date:         \(DateFormatter.prettyFormatter.string(from: tournament.endAt))
            League:           \(tournament.league?.name ?? "Unknown")
            League Image:     \(tournament.league?.imageUrl?.absoluteString ?? "–")
            League URL:       \(tournament.league?.url?.absoluteString ?? "–")
            League ID:        \(tournament.leagueId)
            Game:             \(tournament.videogame?.name ?? "Unknown")
            Game Slug:        \(tournament.videogame?.slug ?? "Unknown")
            Tier:             \(tournament.tier)
            Slug:             \(tournament.slug)
            Has Bracket:      \(tournament.hasBracket)
            Live Supported:   \(tournament.liveSupported)
            Detailed Stats:   \(tournament.detailedStats)
            Prize Pool:       \(tournament.prizepool ?? "Unknown")
            Series:           \(tournament.serie?.name ?? "Unknown")
            Series ID:        \(tournament.serieId)
            Winner ID:        \(tournament.winnerId ?? 0)
            Winner Type:      \(tournament.winnerType ?? "Unknown")
            Match Count:      \(tournament.matches?.count ?? 0)
            Matches:          \(matchesInfo)
            Last Modified:    \(DateFormatter.prettyFormatter.string(from: tournament.modifiedAt))
            ID:               \(tournament.id)
            \n
            """
        }
        
        formattedTournaments.forEach { print($0) }
    } catch {
        print("Failed to fetch upcoming tournaments: \(error)")
    }
}
