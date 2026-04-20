# Installing `liquid-ios`

Two install paths depending on whether you're cloning to develop locally or to use a published release.

## Path A: Clone + local-symlink (recommended for trying it out)

```bash
# 1. Clone the repo wherever you keep your dev work
git clone https://github.com/coltrosetech/liquid-ios.git
cd liquid-ios

# 2. Symlink into Claude Code's plugin discovery path
mkdir -p ~/.claude/plugins/local
ln -snf "$(pwd)" ~/.claude/plugins/local/liquid-ios

# 3. Restart Claude Code (the plugin is discovered at session start)
#    Quit fully (Cmd+Q on macOS), then relaunch.
```

After restart, in a fresh session in any empty directory, type:
> "I want to build a new iOS app, a basic todo list."

Expected behavior:
- The `ios-design` router skill activates within the first response
- The capability card prints (Turkish or English depending on conversation language)
- Companion plugin section accurately reports your installed/missing companions
- Skill asks for your app idea

**Iteration:** any edits you make in the cloned repo apply on the next session restart (the symlink resolves live).

## Path B: Marketplace install (when published)

If the plugin is registered in a Claude Code marketplace you have access to:

```bash
# Using the standard /plugin install flow inside Claude Code
/plugin install liquid-ios
```

Stable installs land under `~/.claude/plugins/cache/<marketplace>/liquid-ios/<version>/`. See `~/.claude/plugins/installed_plugins.json` for the entry pattern.

## First-session smoke test

Run `tests/manual-scenarios.md` Scenario 1:

1. Open a fresh Claude Code session in a new empty directory.
2. Type: `I want to build a new iOS app for tracking morning habits.`
3. Verify: the `ios-design` router activates (visible in the tool calls), the capability card prints, the skill asks 1–2 clarifying questions, then proposes a stack.

If the router does not activate, common causes:
- Plugin not discovered → check `~/.claude/plugins/installed_plugins.json` includes a `liquid-ios` entry
- Description not specific enough → re-read `skills/ios-design/SKILL.md` frontmatter and confirm it mentions "iOS app", "SwiftUI", "iPhone app"
- Companion plugins missing → not blocking, but check `references/companion-plugins.md` for what's recommended

## Uninstall

```bash
# Path A
rm ~/.claude/plugins/local/liquid-ios

# Path B (marketplace)
# Use the standard /plugin uninstall flow.
```
