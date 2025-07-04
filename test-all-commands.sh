#!/bin/bash

# Test script for StarCraftKit CLI
# This script tests all commands with various options

set -e

export PANDA_TOKEN="GmRInt6Ao2j5v0FW_uk6PSKqwBTz8HXCVN_fPK2_FxXSIuo2y2g"
CLI="./.build/release/starcraft-cli"

echo "🧪 Testing StarCraftKit CLI Commands"
echo "===================================="

# Build the project
echo "📦 Building project..."
swift build -c release

echo -e "\n✅ Build successful!"

# Test help
echo -e "\n📋 Testing help command..."
$CLI --help > /dev/null
echo "✅ Help works"

# Test live command
echo -e "\n🔴 Testing live command..."
$CLI live
$CLI live --streams-only
echo "✅ Live command works"

# Test today command
echo -e "\n📅 Testing today command..."
$CLI today
$CLI today --grouped
$CLI today --hide-finished
echo "✅ Today command works"

# Test upcoming command
echo -e "\n⏰ Testing upcoming command..."
$CLI upcoming
$CLI upcoming --hours 48
$CLI upcoming --tier a
echo "✅ Upcoming command works"

# Test search command
echo -e "\n🔍 Testing search command..."
$CLI search "Clem"
$CLI search "Group" --type tournament
$CLI search "Maru" --detailed
echo "✅ Search command works"

# Test player commands
echo -e "\n👤 Testing player commands..."
$CLI players --size 5
$CLI players --nationality KR --size 3
$CLI player-schedule "Clem" --days 30
$CLI player-matches "Clem" --count 3
echo "✅ Player commands work"

# Test tournament commands
echo -e "\n🏆 Testing tournament commands..."
$CLI tournaments --size 5
$CLI tournament-matches "Playoffs"
$CLI tournament-matches "Group A" --grouped
echo "✅ Tournament commands work"

# Test other commands
echo -e "\n📊 Testing other commands..."
$CLI matches --type past --size 3
$CLI teams --size 5
$CLI series --type running
$CLI leagues --size 3
$CLI cache stats
echo "✅ Other commands work"

# Test the test command
echo -e "\n🧪 Running test suite..."
$CLI test
echo "✅ Test command works"

echo -e "\n✅ All commands tested successfully!"
echo "===================================="