# Querying Data

Learn how to use ``QueryParameters`` to filter, sort, and paginate API results.

## Overview

StarCraftKit provides a powerful query builder that allows you to customize your API requests with filtering, sorting, searching, and pagination options.

## Basic Query Building

Use ``QueryParameters`` to build your queries:

```swift
let parameters = QueryParameters()
    .filter(by: "nationality", value: "KR")
    .sort(by: "name", order: .ascending)
    .perPage(20)
    .page(1)

let players = try await client.getPlayers(parameters: parameters)
```

## Filtering

### Single Filter

```swift
// Get only Korean players
let parameters = QueryParameters()
    .filter(by: "nationality", value: "KR")
```

### Multiple Filters

```swift
// Get Korean Terran players
let parameters = QueryParameters()
    .filter(by: "nationality", value: "KR")
    .filter(by: "race", value: "terran")
```

### Range Filters

```swift
// Get matches from the last week
let weekAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
let now = Date()

let parameters = QueryParameters()
    .range(field: "scheduled_at", from: weekAgo, to: now)
```

## Searching

Search across multiple fields:

```swift
// Search for players or teams containing "SKT"
let parameters = QueryParameters()
    .search("SKT")

let players = try await client.getPlayers(parameters: parameters)
let teams = try await client.getTeams(parameters: parameters)
```

## Sorting

### Single Sort

```swift
// Sort by player name
let parameters = QueryParameters()
    .sort(by: "name", order: .ascending)
```

### Multiple Sorts

```swift
// Sort by date first, then by name
let parameters = QueryParameters()
    .sort(by: "scheduled_at", order: .descending)
    .sort(by: "name", order: .ascending)
```

## Pagination

Control the number of results and page through large datasets:

```swift
// Get 50 results per page
let parameters = QueryParameters()
    .perPage(50)
    .page(2) // Get the second page
```

### Handling Paginated Results

```swift
func fetchAllPlayers() async throws -> [Player] {
    var allPlayers: [Player] = []
    var page = 1
    var hasMore = true
    
    while hasMore {
        let parameters = QueryParameters()
            .perPage(100)
            .page(page)
        
        let (players, pagination) = try await client.getPlayersWithPagination(parameters: parameters)
        allPlayers.append(contentsOf: players)
        
        hasMore = pagination.hasNextPage
        page += 1
    }
    
    return allPlayers
}
```

## Complex Queries

Combine multiple query options for sophisticated searches:

```swift
// Get recent Korean tournament matches
let parameters = QueryParameters()
    .filter(by: "tournament_level", value: "tier1")
    .filter(by: "opponent1.nationality", value: "KR")
    .range(field: "scheduled_at", 
           from: Date().addingTimeInterval(-30 * 24 * 60 * 60),
           to: Date())
    .sort(by: "scheduled_at", order: .descending)
    .perPage(50)

let matches = try await client.getMatches(parameters: parameters)
```

## Available Filter Fields

### Players
- `nationality`: Country code (e.g., "KR", "US")
- `team_id`: Current team ID
- `race`: Player's race (terran, zerg, protoss)

### Matches
- `status`: Match status (not_started, running, finished)
- `tournament_id`: Tournament ID
- `opponent_id`: Player or team ID
- `scheduled_at`: Match date/time

### Teams
- `acronym`: Team abbreviation
- `location`: Team location

### Tournaments
- `tier`: Tournament tier (s, a, b, c, d)
- `prizepool`: Prize pool amount
- `serie_id`: Series ID

## Performance Tips

1. **Use specific filters** to reduce response size
2. **Limit results** with `perPage()` when you don't need all data
3. **Cache responses** for frequently accessed data
4. **Use pagination** for large datasets instead of requesting everything

## Error Handling

Handle query-related errors:

```swift
do {
    let results = try await client.getMatches(parameters: parameters)
} catch APIError.invalidRequest(let reason) {
    print("Invalid query: \(reason)")
} catch {
    print("Query failed: \(error)")
}
```