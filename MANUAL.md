# StarCraftKit CLI Manual

A comprehensive guide to using the StarCraft 2 Pro Scene CLI - your gateway to professional StarCraft 2 esports data.

## Table of Contents

- [Getting Started](#getting-started)
- [Core Commands](#core-commands)
  - [Live Matches](#live-matches)
  - [Today's Schedule](#todays-schedule)
  - [Upcoming Matches](#upcoming-matches)
  - [Player Commands](#player-commands)
  - [Tournament Commands](#tournament-commands)
  - [Search](#search)
- [Data Commands](#data-commands)
  - [Matches](#matches)
  - [Players](#players)
  - [Teams](#teams)
  - [Tournaments](#tournaments)
  - [Series](#series)
  - [Leagues](#leagues)
- [Export & Streaming](#export--streaming)
  - [Export Data](#export-data)
  - [Stream Integration](#stream-integration)
- [Utility Commands](#utility-commands)
- [Tips & Tricks](#tips--tricks)

---

## Getting Started

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/StarCraftKit.git
cd StarCraftKit

# Build the project
swift build -c release

# Copy to your PATH (optional)
cp .build/release/starcraft-cli /usr/local/bin/starcraft
```

### Configuration

Set your PandaScore API token:
```bash
export PANDA_TOKEN="your-api-key-here"
```

Or create a `.env` file:
```bash
echo "PANDA_TOKEN=your-api-key-here" > .env
```

### Quick Start

```bash
# Check what's happening right now
starcraft live

# See today's schedule
starcraft today

# Find when a player plays next
starcraft player-schedule Serral

# Search for anything
starcraft search "GSL"
```

---

## Core Commands

### Live Matches

<details>
<summary><code>starcraft live</code> - Show all currently live StarCraft 2 matches</summary>

Monitor live matches with real-time scores and stream links.

#### Usage
```bash
starcraft live [options]
```

#### Options
- `-w, --watch` - Auto-refresh every 30 seconds
- `-t, --tier <tier>` - Filter by tournament tier (premier, major, minor)
- `-s, --streams-only` - Show only matches with available streams
- `-o, --open-stream <number>` - Open stream for match at index

#### Example Output
```
┌────────────────────────────── 🔴 LIVE MATCHES ──────────────────────────────┐
Last updated: 2025-07-04 14:35

🏆 ESL Pro Tour 2025 - Summer [PREMIER]
──────────────────────────────────────────────────────────────────────────────
[ 1] 🇰🇷 Cure                        ► 2-0 ◄ 🇮🇹 Reynor                      | Bo5     | 32m 15s | 📺 Twitch
    Game Progress: [██░░░░░░░░] 40%
    📺 https://www.twitch.tv/esl_sc2

[ 2] 🇰🇷 Dark                        ► 1-1 ◄ 🇰🇷 Maru                        | Bo5     | 28m 42s | 📺 Twitch
    Game Progress: [████░░░░░░] 40%
    📺 https://www.twitch.tv/gsl

🏆 DreamHack Summer 2025 [MAJOR]
──────────────────────────────────────────────────────────────────────────────
[ 3] 🇫🇮 Serral                      ► 3-0 ◄ 🇫🇷 Clem                        | Bo7     | 45m 30s | No stream

└──────────────────────────────────────────────────────────────────────────────┘

📊 Total: 3 live matches

Tip: Use --open-stream <number> to open a specific match stream
```

</details>

### Today's Schedule

<details>
<summary><code>starcraft today</code> - Show all StarCraft 2 matches happening today</summary>

View today's complete schedule including finished, live, and upcoming matches.

#### Usage
```bash
starcraft today [options]
```

#### Options
- `-h, --hide-finished` - Hide already finished matches
- `-t, --tournament <name>` - Filter by tournament name
- `-g, --grouped` - Group matches by tournament

#### Example Output
```
┌────────────────────────── 📅 TODAY'S MATCHES ───────────────────────────────┐
Date: Friday, July 4, 2025

✅ FINISHED (Morning)
──────────────────────────────────────────────────────────────────────────────
08:00 | 🇰🇷 ByuN         2-3 🇰🇷 herO         | Bo5 | GSL 2025 S2
09:30 | 🇰🇷 Solar        3-1 🇰🇷 Bunny        | Bo5 | GSL 2025 S2

🔴 LIVE
──────────────────────────────────────────────────────────────────────────────
14:35 | 🇰🇷 Cure         2-0 🇮🇹 Reynor       | Bo5 | ESL Pro Tour [PREMIER] | 📺
14:42 | 🇰🇷 Dark         1-1 🇰🇷 Maru         | Bo5 | GSL 2025 S2 [PREMIER] | 📺

⏰ UPCOMING
──────────────────────────────────────────────────────────────────────────────
16:00 | 🇫🇮 Serral       vs  🇫🇷 Clem         | Bo7 | DreamHack [MAJOR] | in 1h 25m
18:00 | 🇰🇷 Rogue        vs  🇰🇷 Stats        | Bo5 | GSL 2025 S2 | in 3h 25m
20:00 | 🇲🇽 SpeCial      vs  🇺🇸 Neeb         | Bo3 | ESL Open Cup | in 5h 25m

└──────────────────────────────────────────────────────────────────────────────┘

📊 Summary: 2 finished, 2 live, 3 upcoming (7 total today)
```

</details>

### Upcoming Matches

<details>
<summary><code>starcraft upcoming</code> - Show upcoming matches with countdown timers</summary>

View upcoming matches organized by time periods with color-coded countdowns.

#### Usage
```bash
starcraft upcoming [options]
```

#### Options
- `-h, --hours <number>` - Number of hours to look ahead (default: 24)
- `-p, --player <name>` - Filter by player name
- `-t, --tier <tier>` - Filter by tournament tier
- `--premier-only` - Show only premier tournaments

#### Example Output
```
┌────────────────────────── ⏰ UPCOMING MATCHES ──────────────────────────────┐
Next 24 hours | Current time: 2025-07-04 14:35

🔥 STARTING SOON (Next Hour)
──────────────────────────────────────────────────────────────────────────────
15:00 | in 25m       | 🇰🇷 Solar               vs Bunny                🇰🇷 | Bo5   | GSL 2025 Season 2        [PREMIER] 📺
15:30 | in 55m       | 🇫🇮 Serral              vs Clem                 🇫🇷 | Bo7   | DreamHack Summer         [MAJOR]   📺

⚡ Next 3 Hours
──────────────────────────────────────────────────────────────────────────────
16:00 | in 1h 25m    | 🇰🇷 Rogue               vs Stats                🇰🇷 | Bo5   | GSL 2025 Season 2        [PREMIER] 📺
17:00 | in 2h 25m    | 🇩🇪 ShoWTimE            vs HeRoMaRinE          🇩🇪 | Bo3   | ESL Masters              [MAJOR]    

📅 Next 6 Hours
──────────────────────────────────────────────────────────────────────────────
18:00 | in 3h 25m    | 🇲🇽 SpeCial             vs Neeb                 🇺🇸 | Bo3   | ESL Open Cup             [MINOR]   
20:00 | in 5h 25m    | 🇨🇦 Scarlett            vs uThermal             🇳🇱 | Bo5   | DreamHack Summer         [MAJOR]   📺

└──────────────────────────────────────────────────────────────────────────────┘

📊 Total: 6 matches in the next 24 hours
⏰ Next match starts in 25m
```

</details>

### Player Commands

<details>
<summary><code>starcraft player-schedule</code> - Track when a player will play next</summary>

Find all upcoming matches for your favorite player.

#### Usage
```bash
starcraft player-schedule <player-name> [options]
```

#### Options
- `-d, --days <number>` - Number of days to look ahead (default: 7)
- `-t, --tournament <name>` - Filter by tournament
- `-i, --include-finished` - Include recently finished matches

#### Example Output
```
┌───────────────────── 📅 SCHEDULE FOR SERRAL ─────────────────────────────┐

🏆 Player: Serral
🇫🇮 Finland | Team: ENCE
📊 Recent form: Won 8 of last 10 matches

⏰ UPCOMING MATCHES
──────────────────────────────────────────────────────────────────────────────
Tomorrow, 15:00 | 🇫🇮 Serral vs 🇫🇷 Clem      | Bo7 | DreamHack Summer QF [MAJOR] | in 24h 25m
Sunday, 18:00   | 🇫🇮 Serral vs TBD           | Bo7 | DreamHack Summer SF [MAJOR] | in 3d 3h
Monday, 20:00   | 🇫🇮 Serral vs TBD           | Bo7 | DreamHack Summer F  [MAJOR] | in 4d 5h

📊 3 matches scheduled in the next 7 days
⏰ Next match: Tomorrow at 15:00 (in 24h 25m)

💡 Tip: All times shown in your local timezone
```

</details>

<details>
<summary><code>starcraft player-matches</code> - Show recent match history</summary>

View a player's recent performance and match results.

#### Usage
```bash
starcraft player-matches <player-name> [options]
```

#### Options
- `-c, --count <number>` - Number of matches to show (default: 10)
- `-t, --tournament <name>` - Filter by tournament
- `-d, --detailed` - Show detailed match information

#### Example Output
```
┌────────────────────── 🎮 MATCH HISTORY: MARU ───────────────────────────┐

🏆 Player: Maru
🇰🇷 South Korea | Team: Team NV
📊 Last 10 matches: 7W - 3L (70% win rate)

RECENT MATCHES
──────────────────────────────────────────────────────────────────────────────
2025-07-04 | 🇰🇷 Maru  1-1  🇰🇷 Dark    | LIVE    | GSL 2025 S2 RO16     | Bo5
2025-07-03 | 🇰🇷 Maru  3-1  🇰🇷 Solar   | ✅ WIN  | GSL 2025 S2 RO16     | 42m
2025-07-01 | 🇰🇷 Maru  2-3  🇰🇷 Rogue   | ❌ LOSS | GSL 2025 S2 RO32     | 58m
2025-06-28 | 🇰🇷 Maru  3-0  🇰🇷 Stats   | ✅ WIN  | ESL Pro Tour         | 31m
2025-06-27 | 🇰🇷 Maru  3-2  🇮🇹 Reynor  | ✅ WIN  | ESL Pro Tour         | 67m

📊 Statistics:
• vs Terran: 3W - 1L (75%)
• vs Zerg: 2W - 2L (50%)
• vs Protoss: 2W - 0L (100%)

🔥 Current streak: 2 wins
```

</details>

### Tournament Commands

<details>
<summary><code>starcraft tournament-matches</code> - View tournament bracket</summary>

Show all matches in a tournament with bracket progression.

#### Usage
```bash
starcraft tournament-matches <tournament-name> [options]
```

#### Options
- `-g, --grouped` - Group by round/stage
- `-c, --completed-only` - Show only completed matches
- `-p, --player <name>` - Filter by player

#### Example Output
```
┌─────────────────── 🏆 GSL 2025 SEASON 2 ────────────────────┐

Tournament: GSL Code S 2025 Season 2
🏆 Prize Pool: $150,000
📅 June 15 - July 20, 2025
📍 Seoul, South Korea

ROUND OF 16 (Current Stage)
──────────────────────────────────────────────────────────────
Group A - Day 1
✅ 🇰🇷 Maru      3-1  🇰🇷 Solar    | June 28 | Upper Match
✅ 🇰🇷 Dark      3-2  🇰🇷 Cure     | June 28 | Upper Match
🔴 🇰🇷 Dark      1-1  🇰🇷 Maru     | LIVE    | Winners Match
⏰ 🇰🇷 Solar     vs   🇰🇷 Cure     | 16:00   | Losers Match

Group B - Day 2
⏰ 🇰🇷 Rogue     vs   🇰🇷 herO     | Tomorrow 14:00
⏰ 🇰🇷 Stats     vs   🇰🇷 ByuN     | Tomorrow 15:30

ROUND OF 32 (Completed)
──────────────────────────────────────────────────────────────
✅ 🇰🇷 Maru      3-0  🇰🇷 Trust    | June 20
✅ 🇰🇷 Solar     3-2  🇰🇷 Dream    | June 20
[... more matches ...]

📊 Progress: 16/31 matches completed (52%)
```

</details>

### Search

<details>
<summary><code>starcraft search</code> - Universal search across all entities</summary>

Search for players, teams, tournaments, or any other StarCraft 2 entity.

#### Usage
```bash
starcraft search <query> [options]
```

#### Options
- `-t, --type <type>` - Filter by entity type (player, team, tournament)
- `-d, --detailed` - Show detailed information

#### Example Output
```
┌────────────────────── 🔍 SEARCH RESULTS ─────────────────────────┐
Query: "GSL"

🏆 TOURNAMENTS (3 results)
──────────────────────────────────────────────────────────────────
• GSL 2025 Season 2
  Status: Ongoing | Tier: PREMIER | Prize: $150,000
  June 15 - July 20, 2025 | 32 participants
  
• GSL 2025 Season 1
  Status: Finished | Tier: PREMIER | Prize: $150,000
  Winner: 🇰🇷 Maru | March 1 - April 15, 2025
  
• GSL Super Tournament 2025
  Status: Upcoming | Tier: PREMIER | Prize: $100,000
  August 1-10, 2025 | 16 invited players

📊 SERIES (1 result)
──────────────────────────────────────────────────────────────────
• GSL 2025
  Year-long series | 3 seasons + 1 super tournament
  Total Prize Pool: $550,000

No results found in: Players, Teams, Leagues

└──────────────────────────────────────────────────────────────────┘
```

</details>

---

## Data Commands

### Matches

<details>
<summary><code>starcraft matches</code> - Browse match data</summary>

Fetch and display StarCraft 2 matches with various filters.

#### Usage
```bash
starcraft matches [options]
```

#### Options
- `--page <number>` - Page number
- `--size <number>` - Results per page
- `--type <type>` - Match type (all, running, upcoming, past)
- `--opponent-id <id>` - Filter by opponent ID
- `--tournament-id <id>` - Filter by tournament ID

#### Example Output
```
┌─────────────────────── STARCRAFT 2 MATCHES ───────────────────────┐

Page 1 of 50 (Total: 1000+ matches)

🔴 LIVE MATCHES
──────────────────────────────────────────────────────────────────
#1203145  | 🇰🇷 Cure  2-0  🇮🇹 Reynor | Bo5 | ESL Pro Tour Summer
#1203146  | 🇰🇷 Dark  1-1  🇰🇷 Maru   | Bo5 | GSL 2025 Season 2

⏰ UPCOMING MATCHES
──────────────────────────────────────────────────────────────────
#1203147  | 🇫🇮 Serral  vs  🇫🇷 Clem    | Bo7 | DreamHack Summer | in 1h
#1203148  | 🇰🇷 Rogue   vs  🇰🇷 Stats   | Bo5 | GSL 2025 S2      | in 3h

✅ RECENT RESULTS
──────────────────────────────────────────────────────────────────
#1203144  | 🇰🇷 ByuN  2-3  🇰🇷 herO    | Bo5 | GSL 2025 S2      | 2h ago
#1203143  | 🇰🇷 Solar 3-1  🇰🇷 Bunny   | Bo5 | GSL 2025 S2      | 4h ago

Navigation: Use --page 2 for next page
```

</details>

### Players

<details>
<summary><code>starcraft players</code> - Browse player database</summary>

View player profiles and statistics.

#### Usage
```bash
starcraft players [options]
```

#### Options
- `--search <name>` - Search by player name
- `--nationality <country>` - Filter by nationality
- `--team-id <id>` - Filter by team
- `--sort <field>` - Sort by field (name, age, nationality)

#### Example Output
```
┌──────────────────────── STARCRAFT 2 PLAYERS ─────────────────────────┐

Found 150 active players (Page 1 of 8)

TOP PLAYERS
──────────────────────────────────────────────────────────────────────
🇫🇮 Serral (Joona Sotala)
   Team: ENCE | Age: 25 | Race: Zerg
   Recent: 45W - 8L (84.9% win rate)
   
🇰🇷 Maru (Cho Sung-choo)
   Team: Team NV | Age: 26 | Race: Terran
   Recent: 38W - 12L (76.0% win rate)
   
🇫🇷 Clem (Clément Desplanches)
   Team: Team Liquid | Age: 21 | Race: Terran
   Recent: 42W - 15L (73.7% win rate)
   
🇰🇷 Dark (Park Ryung-woo)
   Team: Team NV | Age: 28 | Race: Zerg
   Recent: 35W - 18L (66.0% win rate)

[... more players ...]

Filters: Use --nationality KR for Korean players only
```

</details>

### Teams

<details>
<summary><code>starcraft teams</code> - Browse team information</summary>

View team rosters and information.

#### Usage
```bash
starcraft teams [options]
```

#### Options
- `--search <name>` - Search by team name
- `--location <country>` - Filter by location
- `--show-roster` - Display full team rosters

#### Example Output
```
┌───────────────────────── STARCRAFT 2 TEAMS ──────────────────────────┐

Active Teams (Page 1 of 3)

🏆 Team Liquid
──────────────────────────────────────────────────────────────────────
📍 Netherlands | Founded: 2000
👥 4 SC2 Players | 🌐 teamliquid.com

Current Roster:
• 🇫🇷 Clem (Terran) - Main Player
• 🇳🇱 uThermal (Terran)
• 🇺🇸 Neeb (Protoss)
• 🇩🇪 HeRoMaRinE (Terran)

🏆 Team NV (Naver)
──────────────────────────────────────────────────────────────────────
📍 South Korea | Founded: 2016
👥 3 SC2 Players

Current Roster:
• 🇰🇷 Maru (Terran) - Team Captain
• 🇰🇷 Dark (Zerg)
• 🇰🇷 Bunny (Terran)

[... more teams ...]
```

</details>

### Tournaments

<details>
<summary><code>starcraft tournaments</code> - Browse tournament list</summary>

View current and upcoming tournaments.

#### Usage
```bash
starcraft tournaments [options]
```

#### Options
- `--type <type>` - Filter by type (all, upcoming, ongoing, past)
- `--tier <tier>` - Filter by tier (premier, major, minor)
- `--prize-pools` - Sort by prize pool

#### Example Output
```
┌─────────────────── STARCRAFT 2 TOURNAMENTS ──────────────────────┐

🔴 ONGOING TOURNAMENTS
──────────────────────────────────────────────────────────────────
GSL 2025 Season 2 [PREMIER]
💰 $150,000 | 📅 June 15 - July 20 | 📍 Seoul, Korea
Status: Round of 16 | 32 players | GSL Format

DreamHack Summer 2025 [MAJOR]
💰 $50,000 | 📅 July 1-7 | 📍 Jönköping, Sweden
Status: Quarterfinals | 64 players | Double Elimination

⏰ UPCOMING TOURNAMENTS
──────────────────────────────────────────────────────────────────
IEM Katowice 2025 [PREMIER]
💰 $500,000 | 📅 August 15-25 | 📍 Katowice, Poland
Opens in: 41 days | 24 invited + 8 qualified

GSL Super Tournament [PREMIER]
💰 $100,000 | 📅 August 1-10 | 📍 Seoul, Korea
Opens in: 27 days | 16 invited players

✅ RECENT TOURNAMENTS
──────────────────────────────────────────────────────────────────
ESL Pro Tour 2025 - Spring [PREMIER]
💰 $200,000 | Winner: 🇫🇮 Serral
June 1-10 | 16 players | Single Elimination

[... more tournaments ...]
```

</details>

### Series

<details>
<summary><code>starcraft series</code> - Browse tournament series</summary>

View tournament series and their events.

#### Usage
```bash
starcraft series [options]
```

#### Options
- `--year <year>` - Filter by year
- `--league-id <id>` - Filter by league

#### Example Output
```
┌──────────────────── STARCRAFT 2 SERIES ─────────────────────────┐

2025 SERIES
──────────────────────────────────────────────────────────────────
GSL 2025
• 3 Seasons + 1 Super Tournament
• Total Prize Pool: $550,000
• March - November 2025

ESL Pro Tour 2025
• 4 Masters Events + 1 Championship
• Total Prize Pool: $1,000,000
• Circuit Points System
• January - December 2025

DreamHack SC2 Masters 2025
• 6 Events across Europe/NA
• Total Prize Pool: $300,000
• Open Registration
• Year-round

[... more series ...]
```

</details>

### Leagues

<details>
<summary><code>starcraft leagues</code> - Browse league information</summary>

View league organizations and their events.

#### Usage
```bash
starcraft leagues [options]
```

#### Options
- `--sort <field>` - Sort by field
- `--all` - Show all leagues including inactive

#### Example Output
```
┌──────────────────── STARCRAFT 2 LEAGUES ─────────────────────────┐

ACTIVE LEAGUES
──────────────────────────────────────────────────────────────────
Global StarCraft II League (GSL)
📍 South Korea | Founded: 2010
🏆 Premier League | AfreecaTV Production
Current: GSL 2025 S2

ESL Pro Tour
📍 International | Founded: 2020
🏆 Premier Circuit | ESL Gaming
Current: 2025 Season

DreamHack
📍 International | Founded: 2012
🏆 Major Circuit | DreamHack AB
Current: Summer 2025

[... more leagues ...]
```

</details>

---

## Export & Streaming

### Export Data

<details>
<summary><code>starcraft export</code> - Export data to JSON/CSV</summary>

Export match, player, or tournament data in various formats.

#### Usage
```bash
starcraft export <data-type> [options]
```

#### Arguments
- `data-type` - Type of data: matches, players, tournaments

#### Options
- `-f, --format <format>` - Output format: json, csv (default: json)
- `-o, --output <path>` - Output file path
- `-l, --limit <number>` - Number of items to export
- `-p, --player <name>` - Filter by player
- `-t, --tournament <name>` - Filter by tournament
- `-s, --since <date>` - Filter by date (YYYY-MM-DD)
- `-v, --verbose` - Include all available fields

#### Example Output
```
📦 Exporting matches data...
  Fetching matches...
  Filtering by player: Serral
  Exporting 25 matches...
✅ Export complete: serral_matches.csv
📄 Format: CSV
📊 Size: 4.2 KB

Sample CSV content:
ID,Name,Status,Date,Player1,Player2,Score1,Score2,Winner,Duration
1203138,"Grand final: Serral vs Clem",finished,2025-07-03 20:00,"Serral","Clem",4,3,"Serral",62m 45s
1203125,"Semifinal: Serral vs Maru",finished,2025-07-02 18:00,"Serral","Maru",3,1,"Serral",48m 12s
```

</details>

### Stream Integration

<details>
<summary><code>starcraft stream</code> - Find and open match streams</summary>

Discover live streams and open them in your browser.

#### Usage
```bash
starcraft stream [options]
```

#### Options
- `-m, --match <id>` - Specific match ID
- `-p, --player <name>` - Filter by player
- `-t, --tournament <name>` - Filter by tournament
- `-o, --open` - Auto-open first stream
- `-a, --all` - Show unofficial streams too
- `-l, --language <code>` - Preferred language (en, kr, etc)

#### Example Output
```
🔍 Finding matches with streams...

📺 Matches with Streams
────────────────────────────────────────────────────────────────

● LIVE GSL 2025 Season 2 - Round of 16
  🇰🇷 Maru vs 🇰🇷 Dark
  Started: 32m ago
  Streams:
    📺 Twitch (EN) [Official] [Main]
    https://www.twitch.tv/gsl
    📺 Twitch (KR) [Official]
    https://www.twitch.tv/gsl_kr
    📺 YouTube (EN)
    https://youtube.com/watch?v=abc123

◯ Upcoming ESL Pro Tour - Quarterfinals
  🇫🇮 Serral vs 🇫🇷 Clem
  Starts: in 1h 25m (16:00 Jul 04)
  Streams:
    📺 Twitch (EN) [Official] [Main]
    https://www.twitch.tv/esl_sc2

Tip: Use --open to automatically open the first stream
```

</details>

---

## Utility Commands

### Cache Management

<details>
<summary><code>starcraft cache</code> - Manage API response cache</summary>

View cache statistics and manage cached data.

#### Usage
```bash
starcraft cache stats
```

#### Example Output
```
📊 CACHE STATISTICS
──────────────────────────────────────────────────────────────────
Cache Status: Active
Hit Rate: 78.4% (412 hits / 526 requests)
Current Size: 45 entries
Memory Usage: ~2.1 MB

Recent Activity:
• Players API: 85% hit rate
• Matches API: 72% hit rate
• Tournaments API: 81% hit rate

Last cleared: 2 hours ago
Auto-cleanup: Enabled (expires after 15 min)
```

</details>

### Testing

<details>
<summary><code>starcraft test</code> - Test API endpoints</summary>

Verify all API endpoints are working correctly.

#### Usage
```bash
starcraft test [options]
```

#### Options
- `--extended` - Run extended test suite
- `--test-cache` - Test cache functionality
- `--test-errors` - Test error handling

#### Example Output
```
🧪 TESTING STARCRAFT API ENDPOINTS
──────────────────────────────────────────────────────────────────
✅ Leagues endpoint: OK (245ms)
✅ Series endpoint: OK (189ms)
✅ Tournaments endpoint: OK (156ms)
✅ Matches endpoint: OK (203ms)
✅ Teams endpoint: OK (167ms)
✅ Players endpoint: OK (178ms)

Cache Tests:
✅ Cache write: OK
✅ Cache read: OK
✅ Cache expiration: OK

All tests passed! ✨
API Response Time: 189ms average
```

</details>

### Debug

<details>
<summary><code>starcraft debug</code> - Debug API responses</summary>

View raw API responses for debugging.

#### Usage
```bash
starcraft debug [--type <endpoint>]
```

#### Options
- `--type <endpoint>` - Specific endpoint to debug

#### Example Output
```
🔍 DEBUG: Matches Endpoint
──────────────────────────────────────────────────────────────────
Request URL: https://api.pandascore.co/starcraft2/matches/running
Headers:
  Authorization: Bearer [REDACTED]
  Accept: application/json

Response (200 OK):
{
  "id": 1203145,
  "name": "Upper bracket final: Maru vs Dark",
  "status": "running",
  "tournament_id": 12856,
  "begin_at": "2025-07-04T14:00:00Z",
  "opponents": [
    {
      "type": "Player",
      "opponent": {
        "id": 1234,
        "name": "Maru",
        "nationality": "KR"
      }
    }
  ],
  ...
}

Response Time: 187ms
Rate Limit: 950/1000 remaining
```

</details>

---

## Tips & Tricks

### Performance Tips

1. **Use Watch Mode Wisely**
   ```bash
   # Great for monitoring live tournaments
   starcraft live --watch
   
   # But remember it makes API calls every 30 seconds
   ```

2. **Leverage Caching**
   ```bash
   # Second call will be instant due to caching
   starcraft players --search Serral
   starcraft players --search Serral  # Cached!
   ```

3. **Batch Exports**
   ```bash
   # Export all data at once rather than multiple small exports
   starcraft export matches --limit 1000 --format json
   ```

### Power User Features

1. **Combine Commands with Shell**
   ```bash
   # Find all Korean players and export them
   starcraft players --nationality KR | starcraft export players --format csv
   
   # Watch for specific player going live
   watch -n 60 'starcraft live | grep Serral'
   ```

2. **Quick Tournament Tracking**
   ```bash
   # Create an alias for your favorite tournament
   alias gsl='starcraft tournament-matches "GSL 2025"'
   ```

3. **Stream Integration**
   ```bash
   # Auto-open stream when match starts
   starcraft live --streams-only --open-stream 1
   ```

### Common Workflows

1. **Daily Routine**
   ```bash
   # Morning: Check today's schedule
   starcraft today
   
   # Before work: See if anything is live
   starcraft live
   
   # Evening: Check tomorrow's matches
   starcraft upcoming --hours 36
   ```

2. **Following a Tournament**
   ```bash
   # Track GSL progress
   starcraft tournament-matches GSL --grouped
   
   # Watch for upsets
   starcraft live --tournament GSL --watch
   ```

3. **Player Analysis**
   ```bash
   # Recent performance
   starcraft player-matches Serral --count 20
   
   # Upcoming matches
   starcraft player-schedule Serral --days 14
   
   # Export for analysis
   starcraft export matches --player Serral --format csv
   ```

### Troubleshooting

1. **No API Key Error**
   ```bash
   # Set your API key
   export PANDA_TOKEN="your-key-here"
   
   # Or use .env file
   echo "PANDA_TOKEN=your-key-here" > .env
   ```

2. **Rate Limiting**
   ```bash
   # Check your rate limit status
   starcraft debug
   
   # Use caching to reduce API calls
   starcraft cache stats
   ```

3. **Timezone Issues**
   ```bash
   # All times are shown in your local timezone
   # To see UTC times, set TZ
   TZ=UTC starcraft today
   ```

---

## Advanced Usage

### JSON Output for Scripting

Many commands support JSON output for scripting:

```bash
# Get player data as JSON
starcraft players --search Serral --format json | jq '.nationality'

# Extract match IDs
starcraft matches --type running --format json | jq '.[].id'
```

### Integration Examples

1. **Discord Bot Integration**
   ```python
   import subprocess
   import json
   
   def get_live_matches():
       result = subprocess.run(['starcraft', 'matches', '--type', 'running', '--format', 'json'], 
                               capture_output=True, text=True)
       return json.loads(result.stdout)
   ```

2. **Stream Alerts**
   ```bash
   #!/bin/bash
   # Alert when favorite player goes live
   while true; do
       if starcraft live | grep -q "Serral"; then
           osascript -e 'display notification "Serral is live!" with title "StarCraft Alert"'
           starcraft stream --player Serral --open
           break
       fi
       sleep 300
   done
   ```

3. **Tournament Tracker**
   ```bash
   # Generate daily tournament report
   {
       echo "# StarCraft 2 Daily Report - $(date)"
       echo
       echo "## Live Matches"
       starcraft live
       echo
       echo "## Today's Schedule"
       starcraft today
       echo
       echo "## Tournament Progress"
       starcraft tournament-matches "GSL 2025" --grouped
   } > daily_report_$(date +%Y%m%d).md
   ```

---

## Environment Variables

- `PANDA_TOKEN` - Your PandaScore API token (required)
- `TZ` - Timezone for date/time display (optional)
- `NO_COLOR` - Disable colored output (optional)
- `STARCRAFT_CACHE_TTL` - Cache TTL in seconds (default: 900)

---

## Contributing

Found a bug or have a feature request? Please open an issue on GitHub!

---

## License

This project is licensed under the MIT License. See LICENSE file for details.