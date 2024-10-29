# StarCraftKit
<a href="https://wakatime.com/badge/user/52d828f5-807b-496a-bfc0-5dbef43c05e5/project/018de122-9301-4e14-a56f-4a6e87034a5d"><img src="https://wakatime.com/badge/user/52d828f5-807b-496a-bfc0-5dbef43c05e5/project/018de122-9301-4e14-a56f-4a6e87034a5d.svg" alt="wakatime"></a>

Welcome to StarCraftKit, a Swift package tailored for developers engaged in creating apps or tools focused on the professional StarCraft II scene. This package provides a robust set of interfaces designed to streamline the handling, querying, and presentation of data related to players, matches, and tournaments within the StarCraft II pro scene.

## About StarCraftKit
StarCraftKit offers Swift interfaces for the pro StarCraft II scene, making it easier to integrate professional game data into your applications. Whether you're building an app to display live match updates, track player statistics, or organize tournament information, StarCraftKit has the tools you need to get the job done efficiently and effectively.

## Features
- **Player Profiles**: Access detailed profiles of professional StarCraft II players, including statistics, current status, and match history.
- **Match Details**: Query information about specific matches, including player matchups, game results, and detailed statistical analysis.
- **Tournament Data**: Explore comprehensive details about past, ongoing, and upcoming tournaments, including brackets, match schedules, and winner information.

## Getting Started
To start using StarCraftKit in your project, ensure you have Swift 5.7 or later and add the package to your project dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/marcusziade/StarCraftKit.git", from: "1.0.0")
]
```

Then, import StarCraftKit in your Swift files to access its functionalities:

```swift
import StarCraftKit
```

## Terminal User Interface (TUI)
StarCraftTUI II is an interactive terminal-based interface built with the StarCraftKit package. It provides a user-friendly way to access StarCraft II professional scene data through a navigable menu system.

### Features
- Interactive command menu with keyboard navigation
- Real-time data fetching for tournaments, matches, and players
- VIM-style keyboard shortcuts
- Loading state indicators
- Color-coded interface elements

### Available Commands
- `-ap`: Active Players
- `-lt`: Live Tournaments
- `-om`: Ongoing Matches
- `-ot`: Ongoing Tournaments
- `-ut`: Upcoming Tournaments
- `-ls`: Live Streams
- `-pd`: Player Details
- `-td`: Tournament Details
- `-ms`: Match Stats
- `-gs`: Game Stats
- `-us`: Upcoming Streams
- `-ld`: League Details
- `-sd`: Series Details
- `-pa`: Player Activity

### Navigation
- Arrow keys or VIM keys (h,j,k,l) for movement
- Enter/Space to execute commands
- 'q' to quit

### Requirements
- A valid `PANDA_TOKEN` environment variable must be set
- Terminal with ANSI escape sequence support

## Environment Variables
To use StarCraftKit and its TUI, you'll need to set up the required environment variable:

### Setting Up PANDA_TOKEN
1. Sign up for a PandaScore API account to get your token
2. Set the environment variable:
   ```bash
   export PANDA_TOKEN=your_token_here
   ```
   
### Setting Up in Xcode
1. Open your project in Xcode
2. Select your target
3. Go to "Edit Scheme"
4. Under "Run" > "Arguments", add an environment variable named `PANDA_TOKEN`
5. Set its value to your PandaScore API token

## Contribution
StarCraftKit is under active development, and contributions are welcome. If you have ideas for improvements, find a bug, or want to add new features, feel free to open an issue or submit a pull request.