# ``StarCraftKitCLI``

A powerful command-line interface for accessing StarCraft II esports data.

## Overview

StarCraftKitCLI provides a comprehensive set of commands to interact with StarCraft II esports data from your terminal. Track live matches, explore player statistics, browse tournaments, and more - all from the command line.

## Installation

### Using Swift Package Manager

```bash
git clone https://github.com/yourusername/StarCraftKit.git
cd StarCraftKit
swift build -c release
sudo cp .build/release/starcraft-cli /usr/local/bin/
```

### Using Homebrew (if available)

```bash
brew install starcraft-cli
```

## Configuration

Set your PandaScore API token:

```bash
export PANDA_TOKEN="your-api-token"
```

Or add it to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
echo 'export PANDA_TOKEN="your-api-token"' >> ~/.zshrc
```

## Quick Start

```bash
# Check live matches
starcraft-cli live

# Today's matches
starcraft-cli today

# Search for a player
starcraft-cli search player Serral

# Get upcoming matches
starcraft-cli upcoming --days 7
```

## Topics

### Getting Started
- <doc:CLIQuickStart>
- <doc:CLIConfiguration>

### Core Commands
- <doc:LiveTracking>
- <doc:PlayerCommands>
- <doc:TournamentCommands>
- <doc:DataCommands>

### Advanced Features
- <doc:Filtering>
- <doc:Exporting>
- <doc:Caching>

### Reference
- ``StarCraftCLI``
- <doc:AllCommands>