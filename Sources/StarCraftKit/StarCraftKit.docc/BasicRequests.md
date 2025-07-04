# Basic Requests

Learn how to fetch different types of StarCraft II esports data using StarCraftKit.

## Overview

StarCraftKit provides simple, intuitive methods for fetching various types of esports data. All requests are asynchronous and use Swift's async/await pattern.

## Fetching Matches

### Live Matches

Get currently live matches:

```swift
let liveMatches = try await client.getLiveMatches()
for match in liveMatches {
    print("\(match.name) - \(match.tournament.name)")
    print("Score: \(match.results?.first?.score ?? 0) - \(match.results?.last?.score ?? 0)")
}
```

### Upcoming Matches

Fetch matches scheduled for the future:

```swift
let upcomingMatches = try await client.getUpcomingMatches()
print("Next \(upcomingMatches.count) matches:")
for match in upcomingMatches {
    print("\(match.name) starts at \(match.scheduledAt)")
}
```

### Past Matches

Get recently completed matches:

```swift
let pastMatches = try await client.getPastMatches()
for match in pastMatches {
    if let winner = match.winner {
        print("\(match.name): \(winner.name) won")
    }
}
```

### All Matches with Filtering

```swift
// Get matches for a specific date range
let startDate = Date().addingTimeInterval(-7 * 24 * 60 * 60) // 7 days ago
let endDate = Date()

let parameters = QueryParameters()
    .range(field: "scheduled_at", from: startDate, to: endDate)
    .sort(by: "scheduled_at", order: .descending)
    .perPage(50)

let matches = try await client.getMatches(parameters: parameters)
```

## Fetching Players

### All Players

```swift
let players = try await client.getPlayers()
for player in players {
    print("\(player.name) - \(player.nationality ?? "Unknown")")
}
```

### Search for Players

```swift
let parameters = QueryParameters()
    .search("Serral")
    .perPage(10)

let searchResults = try await client.getPlayers(parameters: parameters)
```

### Player Details

```swift
let playerId = 12345
let player = try await client.getPlayer(id: playerId)
print("Player: \(player.name)")
print("Team: \(player.currentTeam?.name ?? "No team")")
```

## Fetching Teams

### Active Teams

```swift
let teams = try await client.getTeams()
for team in teams {
    print("\(team.name) - \(team.acronym ?? "")")
}
```

### Team Details

```swift
let teamId = 67890
let team = try await client.getTeam(id: teamId)
print("Team: \(team.name)")
print("Players: \(team.players?.count ?? 0)")
```

## Fetching Tournaments

### Current Tournaments

```swift
let tournaments = try await client.getTournaments()
for tournament in tournaments {
    print("\(tournament.name) - \(tournament.serie.fullName)")
    if let prizePool = tournament.prizepool {
        print("Prize Pool: $\(prizePool)")
    }
}
```

### Tournament Matches

```swift
let tournamentId = 11111
let matches = try await client.getTournamentMatches(tournamentId: tournamentId)
print("Tournament has \(matches.count) matches")
```

## Fetching Leagues

```swift
let leagues = try await client.getLeagues()
for league in leagues {
    print("\(league.name) - \(league.url ?? "No URL")")
}
```

## Fetching Series

### All Series

```swift
let series = try await client.getSeries()
for serie in series {
    print("\(serie.fullName) - Year: \(serie.year ?? 0)")
}
```

### Running Series

```swift
let parameters = QueryParameters()
    .filter(by: "running", value: true)

let runningSeries = try await client.getSeries(parameters: parameters)
```

## Error Handling

Always handle potential errors when making requests:

```swift
do {
    let matches = try await client.getLiveMatches()
    // Process matches
} catch APIError.rateLimitExceeded(let retryAfter) {
    print("Rate limit exceeded. Retry after \(retryAfter) seconds")
} catch APIError.notFound {
    print("Resource not found")
} catch {
    print("Unexpected error: \(error)")
}
```

## Next Steps

- Learn about <doc:QueryingData> for advanced filtering
- Explore <doc:Pagination> for handling large datasets
- Understand <doc:Caching> to optimize performance