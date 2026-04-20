# Installing `liquid-ios`

Three install paths, listed fastest-first.

## Path A — Claude Code marketplace (recommended)

Inside Claude Code:

```
/plugin marketplace add coltrosetech/claude-plugins
/plugin install liquid-ios@coltrosetech
```

Two commands. The plugin is cached under `~/.claude/plugins/cache/coltrosetech/liquid-ios/<version>/` and registered in `~/.claude/plugins/installed_plugins.json`.

**Updating:** `/plugin update liquid-ios@coltrosetech`

**Uninstall:** `/plugin uninstall liquid-ios@coltrosetech`

## Path B — one-liner shell script

If you prefer the terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/coltrosetech/liquid-ios/main/install.sh | bash
```

The script:
- Clones (or updates) the repo into `~/.claude/plugins/local/liquid-ios`
- Is idempotent — running it again updates to latest `main`
- Prints a restart hint when done

Then restart Claude Code fully (`Cmd+Q` on macOS, then relaunch).

## Path C — manual clone + symlink (for development)

If you want to edit the plugin source and have edits reflected live:

```bash
# 1. Clone wherever you keep your dev work
git clone https://github.com/coltrosetech/liquid-ios.git
cd liquid-ios

# 2. Symlink into Claude Code's plugin discovery path
mkdir -p ~/.claude/plugins/local
ln -snf "$(pwd)" ~/.claude/plugins/local/liquid-ios

# 3. Restart Claude Code
```

Edits apply on the next session restart.

## First-session smoke test

After any of the install paths:

1. Open a fresh Claude Code session in an empty directory.
2. Type: `I want to build a new iOS app for tracking morning habits.`
3. Expected:
   - The `ios-design` router activates within the first response
   - The capability card prints
   - The skill asks 1–2 clarifying questions, then proposes a stack

If the router does not activate:
- Check `~/.claude/plugins/installed_plugins.json` contains a `liquid-ios` entry (Path A) — or `~/.claude/plugins/local/liquid-ios` exists as a directory (Paths B/C)
- Re-read `skills/ios-design/SKILL.md` frontmatter and confirm it mentions "iOS app", "SwiftUI", "iPhone app"
- Companion plugins missing → not blocking, but check `references/companion-plugins.md`

## Uninstall

| Path | Command |
|---|---|
| A (marketplace) | `/plugin uninstall liquid-ios@coltrosetech` |
| B (one-liner) | `rm -rf ~/.claude/plugins/local/liquid-ios` |
| C (manual symlink) | `rm ~/.claude/plugins/local/liquid-ios` (and your clone if desired) |
