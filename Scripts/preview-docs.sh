#!/bin/bash

# StarCraftKit Documentation Preview Server
# Serves the landing page locally for development

DOCS_DIR="$(dirname "$0")/../docs"
PORT=8889
HOST="0.0.0.0"

echo "🚀 Starting StarCraftKit documentation server..."
echo "📁 Serving from: $DOCS_DIR"
echo "🌐 Access at: http://localhost:$PORT"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Change to docs directory
cd "$DOCS_DIR" || exit 1

# Start Python HTTP server
if command -v python3 &> /dev/null; then
    python3 -m http.server $PORT --bind $HOST
elif command -v python &> /dev/null; then
    python -m SimpleHTTPServer $PORT
else
    echo "❌ Error: Python is not installed. Please install Python to run the preview server."
    exit 1
fi