#!/usr/bin/env bash
# Start a local HTTP server to serve prototype HTML files.
#
# Why: Playwright MCP blocks file:// for security. Many other browser MCPs
# share this restriction. Serving the prototypes via http://localhost:PORT/
# unblocks programmatic browser automation while keeping prototypes local.
#
# Usage:
#   scripts/serve-prototypes.sh [DIR] [PORT]
#     DIR   default: $PWD/.design/prototypes
#     PORT  default: 8765 (auto-bumps to next free port if taken)
#
# Side effects:
#   - Spawns python3 http.server in background
#   - Writes PID to .design/.prototype-server.pid
#   - Prints base URL to stdout (single line) — caller can capture
#
# Stop with: scripts/stop-prototype-server.sh
#            (or: kill $(cat .design/.prototype-server.pid))

set -euo pipefail

SERVE_DIR="${1:-$PWD/.design/prototypes}"
PORT="${2:-8765}"
PROJECT_ROOT="$(cd "$(dirname "$SERVE_DIR")/.." && pwd)"
PID_FILE="$PROJECT_ROOT/.design/.prototype-server.pid"

if [ ! -d "$SERVE_DIR" ]; then
  echo "ERROR: serve dir does not exist: $SERVE_DIR" >&2
  exit 1
fi

# If a previous server is recorded and still alive, reuse it
if [ -f "$PID_FILE" ]; then
  OLD_PID="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "${OLD_PID:-}" ] && kill -0 "$OLD_PID" 2>/dev/null; then
    OLD_PORT="$(lsof -nPi -p "$OLD_PID" 2>/dev/null | awk '/LISTEN/ {split($9,a,":"); print a[length(a)]; exit}')"
    if [ -n "${OLD_PORT:-}" ]; then
      echo "http://localhost:${OLD_PORT}"
      exit 0
    fi
  fi
fi

# Find a free port starting at requested PORT, scan up to 20 ports
chosen=""
for try in $(seq 0 19); do
  test_port=$((PORT + try))
  if ! lsof -nPi :"$test_port" -sTCP:LISTEN >/dev/null 2>&1; then
    chosen="$test_port"
    break
  fi
done

if [ -z "$chosen" ]; then
  echo "ERROR: no free port in range $PORT..$((PORT+19))" >&2
  exit 1
fi

# Start server in background, redirect output to log
LOG_FILE="$PROJECT_ROOT/.design/.prototype-server.log"
mkdir -p "$(dirname "$PID_FILE")"

cd "$SERVE_DIR"
python3 -m http.server "$chosen" --bind 127.0.0.1 >"$LOG_FILE" 2>&1 &
SERVER_PID=$!

# Verify it actually came up
sleep 0.3
if ! kill -0 "$SERVER_PID" 2>/dev/null; then
  echo "ERROR: server failed to start. Log:" >&2
  cat "$LOG_FILE" >&2
  exit 1
fi

echo "$SERVER_PID" >"$PID_FILE"
echo "http://localhost:${chosen}"
