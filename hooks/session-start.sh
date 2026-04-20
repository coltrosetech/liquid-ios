#!/usr/bin/env bash
# Reset per-session capability-card flags so each new session re-introduces skills.
# Hook contract: SessionStart receives no arguments; runs in project root.

set -euo pipefail

STATE_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/state"

# Only act if the state dir exists (created lazily by skills on first run)
if [ -d "$STATE_DIR" ]; then
  rm -f "$STATE_DIR"/ios-design-*-introduced.flag 2>/dev/null || true
fi

exit 0
