# StarCraftKit

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![CI](https://github.com/marcusziade/StarCraftKit/actions/workflows/ci.yml/badge.svg)](https://github.com/marcusziade/StarCraftKit/actions/workflows/ci.yml)
[![Documentation](https://github.com/marcusziade/StarCraftKit/actions/workflows/docc.yml/badge.svg)](https://github.com/marcusziade/StarCraftKit/actions/workflows/docc.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS-lightgray.svg)](https://developer.apple.com/swift/)

A modern, production-ready Swift SDK for the PandaScore StarCraft 2 API. Built with protocol-oriented programming, async/await, and comprehensive error handling.

## Features

- 🚀 **Modern Swift 5.9** - Uses latest language features including async/await and actors
- 🏗️ **Protocol-Oriented Architecture** - Clean, testable, and extensible design
- 🔄 **Automatic Retry Logic** - Exponential backoff with jitter for resilient API calls
- 💾 **Response Caching** - Actor-based thread-safe caching with configurable TTL
- 🛡️ **Type Safety** - Strongly typed models and endpoints
- 📊 **Comprehensive Error Handling** - Detailed error types with retry suggestions
- 🧪 **Well Tested** - Unit tests for all non-networking components
- 📱 **Cross-Platform** - Supports macOS, iOS, watchOS, and tvOS
- 🐳 **Docker Support** - Ready for containerized deployments
- 📚 **Full Documentation** - DocC documentation for all public APIs

## Installation

### Swift Package Manager

Add StarCraftKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/marcusziade/StarCraftKit", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/marcusziade/StarCraftKit`

## Quick Start

```swift
import StarCraftKit

// Initialize the client
let config = StarCraftClient.Configuration(apiKey: "YOUR_API_KEY")
let client = StarCraftClient(configuration: config)

// Fetch players
let players = try await client.getPlayers()

// Search for specific players
let serralMatches = try await client.searchPlayers(name: "Serral")

// Get live matches
let liveMatches = try await client.getLiveMatches()

// Fetch upcoming tournaments
let tournaments = try await client.getTournaments(.upcoming())
```

## Advanced Usage

### Custom Queries

```swift
// Build complex queries with filters and sorting
let request = PlayersRequest(
    page: 1,
    pageSize: 100,
    sort: [SortParameter(field: "name", direction: .ascending)],
    nationality: "KR"
)
let koreanPlayers = try await client.getPlayers(request)

// Paginate through all results
let allTournaments = try await client.executePaginated(
    TournamentsRequest(),
    maxPages: nil // Fetch all pages
)
```

### Error Handling

```swift
do {
    let matches = try await client.getMatches()
} catch let error as APIError {
    switch error {
    case .rateLimitExceeded(let retryAfter, _):
        print("Rate limited. Retry after \(retryAfter ?? 60) seconds")
    case .unauthorized:
        print("Invalid API key")
    case .networkError:
        print("Network connection issue")
    default:
        print("Error: \(error.localizedDescription)")
    }
}
```

### Configuration Options

```swift
// Use query parameter authentication instead of Bearer token
let config = StarCraftClient.Configuration(
    apiKey: "YOUR_API_KEY",
    authMethod: .queryParameter,
    retryConfiguration: .aggressive,
    cacheConfiguration: .init(maxSize: 200, defaultTTL: 600)
)

// Check rate limit status
let (remaining, resetTime) = await client.getRateLimitStatus()
print("Requests remaining: \(remaining ?? -1)")

// Clear cache
await client.clearCache()

// Get cache statistics
let stats = await client.getCacheStatistics()
print("Cache hit rate: \(stats.hitRate * 100)%")
```

## CLI Tool

StarCraftKit includes a comprehensive CLI tool for testing and exploration:

```bash
# Set your API token
export PANDA_TOKEN="your_api_key_here"

# Test all endpoints
swift run starcraft-cli test

# Fetch specific resources
swift run starcraft-cli players --search "Maru"
swift run starcraft-cli matches --type live
swift run starcraft-cli tournaments --type upcoming

# View cache statistics
swift run starcraft-cli cache stats
```

### CLI Features

- Interactive testing of all API endpoints
- Formatted output with colors
- Search and filter capabilities
- Cache management
- Performance testing

## Docker

Build and run with Docker:

```bash
# Build the image
docker build -t starcraftkit .

# Run tests
docker run --rm -e PANDA_TOKEN="your_key" starcraftkit

# Use docker-compose
docker-compose run --rm test
```

## API Coverage

- ✅ **Leagues** - List all StarCraft 2 leagues
- ✅ **Matches** - All, past, running, and upcoming matches
- ✅ **Players** - Search and filter professional players
- ✅ **Teams** - Professional team information
- ✅ **Series** - Tournament series data
- ✅ **Tournaments** - Tournament details with prize pools
- ⚠️ **WebSocket** - Live data streaming (Apple platforms only)

## Architecture

StarCraftKit uses a clean, protocol-oriented architecture:

```
StarCraftKit/
├── Core/
│   ├── Networking/     # API client, retry logic
│   ├── Cache/          # Thread-safe response caching
│   └── Utilities/      # Helper functions
├── Models/
│   ├── API/            # API response models
│   └── Domain/         # Business logic models
├── Protocols/          # Core protocol definitions
└── Endpoints/          # Type-safe endpoint definitions
```

### Key Components

- **APIClientProtocol** - Main interface for API operations
- **NetworkingClient** - Handles HTTP requests with retry logic
- **ResponseCache** - Actor-based thread-safe caching
- **RetryHandler** - Configurable exponential backoff
- **Endpoints** - Type-safe, composable endpoint definitions

## Testing

Run the test suite:

```bash
# Run all tests
swift test

# Run specific tests
swift test --filter PlayerTests

# Run with verbose output
swift test -v
```

## Documentation

Full API documentation is available at: https://marcusziade.github.io/StarCraftKit

Generate documentation locally:

```bash
swift package generate-documentation
```

## Requirements

- Swift 5.9+
- macOS 13.0+ / iOS 16.0+ / watchOS 9.0+ / tvOS 16.0+
- PandaScore API key (get one at https://developers.pandascore.co)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [PandaScore](https://pandascore.co) for providing the StarCraft 2 esports API
- The Swift community for excellent open-source tools and libraries

## Author

Marcus Ziadé - [@marcusziade](https://github.com/marcusziade)