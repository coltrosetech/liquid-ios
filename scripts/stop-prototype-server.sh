#!/usr/bin/env bash
# Stop the local HTTP server started by serve-prototypes.sh.
# Idempotent: safe to call when no server is running.

set -euo pipefail

PID_FILE="${1:-$PWD/.design/.prototype-server.pid}"

if [ ! -f "$PID_FILE" ]; then
  echo "no server running"
  exit 0
fi

PID="$(cat "$PID_FILE" 2>/dev/null || true)"
if [ -n "${PID:-}" ] && kill -0 "$PID" 2>/dev/null; then
  kill "$PID" 2>/dev/null || true
  # Give it a moment, then force if still alive
  sleep 0.2
  if kill -0 "$PID" 2>/dev/null; then
    kill -9 "$PID" 2>/dev/null || true
  fi
  echo "stopped pid=$PID"
else
  echo "no live process for pid=${PID:-unknown}"
fi

rm -f "$PID_FILE"
