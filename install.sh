#!/usr/bin/env bash
# liquid-ios plugin installer
# Usage:  curl -fsSL https://raw.githubusercontent.com/coltrosetech/liquid-ios/main/install.sh | bash
# Or:     ./install.sh           (if you've already cloned the repo)
#
# What it does:
#   1. Clones (or updates) the liquid-ios repo into ~/.claude/plugins/local/liquid-ios
#   2. Verifies the plugin.json manifest is present
#   3. Prints a restart hint and a "try it" prompt

set -euo pipefail

REPO_URL="https://github.com/coltrosetech/liquid-ios.git"
PLUGIN_DIR="${HOME}/.claude/plugins/local"
TARGET="${PLUGIN_DIR}/liquid-ios"

info()  { printf '\033[1;34m→\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m!\033[0m %s\n' "$*"; }
fail()  { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || fail "git is required but not installed."

info "Target: ${TARGET}"
mkdir -p "${PLUGIN_DIR}"

if [ -d "${TARGET}/.git" ]; then
  info "Existing installation found — updating…"
  git -C "${TARGET}" fetch --quiet origin
  git -C "${TARGET}" reset --hard --quiet origin/main
  ok "Updated to $(git -C "${TARGET}" rev-parse --short HEAD)"
elif [ -e "${TARGET}" ]; then
  fail "${TARGET} exists but isn't a git clone. Remove or rename it and re-run."
else
  info "Cloning ${REPO_URL}…"
  git clone --depth=1 --quiet "${REPO_URL}" "${TARGET}"
  ok "Cloned to ${TARGET}"
fi

[ -f "${TARGET}/plugin.json" ] || fail "plugin.json missing — install looks incomplete."

VERSION=$(sed -n 's/.*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "${TARGET}/plugin.json" | head -1)
ok "liquid-ios${VERSION:+ v${VERSION}} installed."

cat <<'BANNER'

─────────────────────────────────────────────────────
 Next:
   1. Restart Claude Code (Cmd+Q on macOS, then reopen)
   2. Open a new session in an empty directory
   3. Try:  "I want to build a new iOS app, a habit tracker."

 The ios-design router should activate in the first response,
 print the capability card, and start the DNA flow.

 Docs:    https://github.com/coltrosetech/liquid-ios
 Examples: https://github.com/coltrosetech/liquid-ios-examples
─────────────────────────────────────────────────────
BANNER
