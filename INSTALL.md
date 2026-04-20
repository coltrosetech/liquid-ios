# Installing `ios-design`

Two install paths depending on where the plugin source lives.

## Path A: Local development install (recommended while iterating)

Use this when you're actively developing the plugin and want to test changes immediately.

```bash
# 1. Symlink the plugin source into Claude Code's plugin discovery path
mkdir -p ~/.claude/plugins/local
ln -snf /Users/f.d.developer/personal/skill-dev ~/.claude/plugins/local/ios-design

# 2. Restart Claude Code (the plugin is discovered at session start)
#    Quit Claude Code fully, then relaunch.
```

After restart, in a fresh session, type:
> "I want to build a new iOS app, a basic todo list."

Expected behavior:
- `ios-design` router activates within the first response
- Capability card prints (Turkish or English depending on conversation language)
- Companion plugin section accurately reports your installed/missing companions
- Skill asks for your app idea

**Iteration:** any edits you make under `/Users/f.d.developer/personal/skill-dev/` apply on the next session start (the symlink resolves live).

## Path B: GitHub install (for sharing / stable use)

Use this when the plugin is stable and you want to publish it.

```bash
# 1. Create a GitHub repo (do this in browser at github.com/new)
#    e.g., github.com/<your-user>/ios-design

# 2. Add remote and push
cd /Users/f.d.developer/personal/skill-dev
git remote add origin git@github.com:<your-user>/ios-design.git
git push -u origin main --tags

# 3. Install via Claude Code marketplace (use the appropriate /plugin install
#    syntax for your Claude Code version — typically marketplace add + plugin install)
```

Stable install paths land under `~/.claude/plugins/cache/<marketplace>/ios-design/<version>/` — see `~/.claude/plugins/installed_plugins.json` for the exact entry pattern other marketplace plugins use.

## First-session smoke test (after install)

Run `tests/manual-scenarios.md` Scenario 1:

1. Open a fresh Claude Code session in a new empty directory.
2. Type: `I want to build a new iOS app for tracking morning habits.`
3. Verify: the `ios-design` router activates (visible in the tool calls), the capability card prints, the skill asks 1–2 clarifying questions, then proposes a stack.

If the router does not activate, common causes:
- Plugin not discovered → check `~/.claude/plugins/installed_plugins.json` includes an `ios-design` entry
- Description not specific enough → re-read `skills/ios-design/SKILL.md` frontmatter and confirm it mentions "iOS app", "SwiftUI", "iPhone app"
- Companion plugins missing → not blocking, but check `references/companion-plugins.md` for what's recommended

## Uninstall

```bash
# Path A
rm ~/.claude/plugins/local/ios-design

# Path B (marketplace)
# Use the standard /plugin uninstall flow.
```
