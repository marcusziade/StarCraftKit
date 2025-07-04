# Getting Started

Learn how to integrate StarCraftKit into your Swift project and make your first API call.

## Installation

### Swift Package Manager

Add StarCraftKit to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/StarCraftKit.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: ["StarCraftKit"]
)
```

### Xcode

1. In Xcode, select **File → Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/yourusername/StarCraftKit.git`
3. Select the version you want to use
4. Add StarCraftKit to your target

## Basic Setup

### Import the Framework

```swift
import StarCraftKit
```

### Initialize the Client

Create an instance of ``StarCraftClient`` with your PandaScore API token:

```swift
let client = StarCraftClient(apiToken: "your-api-token")
```

### Make Your First Request

Fetch current live matches:

```swift
do {
    let matches = try await client.getLiveMatches()
    for match in matches {
        print("\(match.name) - Status: \(match.status)")
    }
} catch {
    print("Error: \(error)")
}
```

## Environment Variables

For security, store your API token in environment variables:

```bash
export PANDA_TOKEN="your-api-token"
```

Then load it in your app:

```swift
let token = ProcessInfo.processInfo.environment["PANDA_TOKEN"] ?? ""
let client = StarCraftClient(apiToken: token)
```

## Next Steps

- Learn about <doc:Authentication> and API token management
- Explore <doc:BasicRequests> to fetch different types of data
- Understand <doc:ErrorHandling> for robust applications