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
🔴 LIVE MATCHES (Last updated: 14:35)

● ESL Pro Tour - Summer                             32m 15s │ Bo5
  🇰🇷 Cure             2-0  🇮🇹 Reynor                       │ 📺 twitch.tv/esl_sc2
  
● GSL 2025 Season 2                                 28m 42s │ Bo5  
  🇰🇷 Dark             1-1  🇰🇷 Maru                         │ 📺 twitch.tv/gsl
  
● DreamHack Summer                                  45m 30s │ Bo7
  🇫🇮 Serral           3-0  🇫🇷 Clem                         │ No stream

Total: 3 live matches
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
STARCRAFT 2 MATCHES (Page 1/50)

● LIVE
#1203145  🇰🇷 Cure         2-0  🇮🇹 Reynor       │ Bo5 │ ESL Pro Tour
#1203146  🇰🇷 Dark         1-1  🇰🇷 Maru         │ Bo5 │ GSL 2025 S2

○ UPCOMING  
#1203147  🇫🇮 Serral       vs   🇫🇷 Clem         │ Bo7 │ DreamHack      │ in 1h
#1203148  🇰🇷 Rogue        vs   🇰🇷 Stats        │ Bo5 │ GSL 2025 S2    │ in 3h

✓ RECENT
#1203144  🇰🇷 ByuN         2-3  🇰🇷 herO         │ Bo5 │ GSL 2025 S2    │ 2h ago
#1203143  🇰🇷 Solar        3-1  🇰🇷 Bunny        │ Bo5 │ GSL 2025 S2    │ 4h ago

Use --page 2 for next page
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
STARCRAFT 2 PLAYERS (150 found, Page 1/8)

🇫🇮 Serral        │ ENCE        │ Zerg    │ 45W-8L  (84.9%)
🇰🇷 Maru          │ Team NV     │ Terran  │ 38W-12L (76.0%)
🇫🇷 Clem          │ Team Liquid │ Terran  │ 42W-15L (73.7%)
🇰🇷 Dark          │ Team NV     │ Zerg    │ 35W-18L (66.0%)
🇮🇹 Reynor        │ Shopify     │ Zerg    │ 40W-14L (74.1%)
🇰🇷 Rogue         │ Alpha X     │ Zerg    │ 33W-17L (66.0%)
🇰🇷 Stats         │ Alpha X     │ Protoss │ 30W-20L (60.0%)
🇰🇷 herO          │ Root Gaming │ Protoss │ 35W-15L (70.0%)

Use --nationality KR for Korean players only
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
STARCRAFT 2 TEAMS (Page 1/3)

Team Liquid      │ 📍 Netherlands │ 4 players │ teamliquid.com
  🇫🇷 Clem (T)   🇳🇱 uThermal (T)   🇺🇸 Neeb (P)   🇩🇪 HeRoMaRinE (T)

Team NV          │ 📍 South Korea │ 3 players
  🇰🇷 Maru (T)   🇰🇷 Dark (Z)   🇰🇷 Bunny (T)

ENCE             │ 📍 Finland     │ 1 player
  🇫🇮 Serral (Z)

Shopify Rebels   │ 📍 Canada      │ 2 players  
  🇮🇹 Reynor (Z)   🇨🇦 Scarlett (Z)
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
STARCRAFT 2 TOURNAMENTS

● ONGOING
GSL 2025 S2      │ $150,000 │ Jun 15-Jul 20 │ Seoul      │ RO16
DreamHack Sum... │ $50,000  │ Jul 1-7       │ Jönköping  │ QF

○ UPCOMING  
IEM Katowice     │ $500,000 │ Aug 15-25     │ Poland     │ in 41d
GSL Super Tour.. │ $100,000 │ Aug 1-10      │ Seoul      │ in 27d

✓ RECENT
ESL Pro Tour Sp. │ $200,000 │ Jun 1-10      │ 🏆 Serral   │ Finished
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
STARCRAFT 2 SERIES - 2025

GSL 2025              │ $550,000  │ 3 seasons + 1 super │ Mar-Nov
ESL Pro Tour 2025     │ $1,000,000│ 4 masters + 1 champ │ Jan-Dec  
DreamHack Masters     │ $300,000  │ 6 events EU/NA      │ Year-round
WTL 2025              │ $180,000  │ Team league         │ Apr-Oct
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
STARCRAFT 2 LEAGUES

GSL               │ 📍 South Korea  │ Since 2010 │ AfreecaTV   
ESL Pro Tour      │ 📍 International│ Since 2020 │ ESL Gaming
DreamHack         │ 📍 International│ Since 2012 │ DreamHack AB
WTL               │ 📍 International│ Since 2020 │ Team League
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
📄 Format: CSV │ Size: 4.2 KB

Sample:
ID,Date,Player1,Player2,Score,Tournament,Duration
1203138,2025-07-03,Serral,Clem,4-3,DreamHack Final,62m
1203125,2025-07-02,Serral,Maru,3-1,DreamHack SF,48m
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
📺 MATCHES WITH STREAMS

● LIVE - GSL 2025 S2 RO16                           Started 32m ago
  🇰🇷 Maru vs 🇰🇷 Dark
  📺 twitch.tv/gsl (EN) │ twitch.tv/gsl_kr (KR) │ youtube.com/gsl

○ UPCOMING - ESL Pro Tour QF                       in 1h 25m (16:00)
  🇫🇮 Serral vs 🇫🇷 Clem  
  📺 twitch.tv/esl_sc2 (EN)

Use --open to auto-open the first stream
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

Status: Active │ Hit Rate: 78.4% (412/526)
Size: 45 entries │ Memory: ~2.1 MB

API Hit Rates:
• Players:     85%
• Matches:     72%  
• Tournaments: 81%

Last cleared: 2h ago │ TTL: 15 min
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
🧪 TESTING API ENDPOINTS

✓ Leagues:     OK (245ms)
✓ Series:      OK (189ms)
✓ Tournaments: OK (156ms)
✓ Matches:     OK (203ms)
✓ Teams:       OK (167ms)
✓ Players:     OK (178ms)

Cache: ✓ Write ✓ Read ✓ Expiration

All tests passed! │ Avg: 189ms
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

URL: api.pandascore.co/starcraft2/matches/running
Auth: Bearer [REDACTED]

Response (200 OK):
{
  "id": 1203145,
  "name": "Upper bracket final: Maru vs Dark",
  "status": "running",
  "tournament_id": 12856,
  "begin_at": "2025-07-04T14:00:00Z",
  "opponents": [...]
}

Time: 187ms │ Rate limit: 950/1000
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