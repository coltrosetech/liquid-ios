# Companion Plugins & MCPs

This plugin works standalone, but several complementary tools meaningfully amplify its quality. The router skill scans for these on first activation per session and reports any missing ones (without blocking).

## Detection rules

| Companion | Detection signal |
|---|---|
| `superpowers` | Skill `superpowers:brainstorming` (or any `superpowers:*`) appears in available skills |
| `context7` MCP | Tool prefix `mcp__plugin_context7_*` available |
| `playwright` MCP | Tool prefix `mcp__plugin_playwright_*` available |
| `serena` MCP | Tool prefix `mcp__plugin_serena_*` available |
| `claude-md-management` | Skill `claude-md-management:*` appears in available skills |
| `frontend-design` | Skill `frontend-design:*` appears in available skills |

## Catalog

### Essential

**superpowers**
- Why: ios-design composes brainstorming, writing-plans, simplify, verification-before-completion, test-driven-development, and systematic-debugging at gateway points (see `superpowers-composition.md`).
- Loss if missing: composition gateways are skipped silently. Skill works but produces lower-quality plans, no KISS pass, no verification gate.
- Install: Claude Code marketplace → `superpowers`.

**context7 MCP**
- Why: live Apple documentation (SwiftUI, SwiftData, Swift concurrency, Liquid Glass APIs). Without it, the skill is bounded by training cutoff.
- Loss if missing: skill falls back to WebSearch and prepends a staleness warning to its answers.
- Install: see context7 plugin docs.

### Recommended

**playwright MCP**
- Why: HTML prototypes auto-open in a browser tab, screenshots are captured for `DESIGN_DNA.md` archive, guided interaction (click/scroll prompts) supported.
- Loss if missing: skill outputs `file://` paths and asks the user to open them manually; feedback is text-only.
- Install: see playwright MCP docs.
- **Note:** Playwright blocks `file://` URLs. The plugin includes `scripts/serve-prototypes.sh` to spin up a local HTTP server (Python `http.server`, default port 8765) that the init/feature skills automatically invoke when playwright is detected. Stop with `scripts/stop-prototype-server.sh`.

**serena MCP**
- Why: semantic Swift code navigation (`find_symbol`, `find_referencing_symbols`). For tweak/feature edits in larger projects, this avoids reading whole files.
- Loss if missing: skill falls back to grep + full file reads — works but wastes tokens.
- Install: see serena MCP docs.

### Optional

**claude-md-management**
- Why: keeps the project's CLAUDE.md in sync with what was decided.
- Loss if missing: user maintains CLAUDE.md manually.

**frontend-design** skill
- Why: when generating prototype HTML, can be invoked for extra design polish on the static layout side.
- Loss if missing: prototypes can look slightly more "AI-generic"; motion fidelity is unaffected.

## Capability card rendering rules

- Essentials missing → ⚠️ warning line under "Skill'imi güçlendirir:"
- Recommended missing → 💡 info line
- Optional missing → suppressed (only mentioned if user asks "what else can you use?")
- All present → "✓ Tüm companion'lar yüklü" single line

The capability card never blocks. Detection happens once per session; subsequent activations skip the check.
