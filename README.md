# ios-design

Design-first iOS app development plugin for Claude Code. Produces motion-validated HTML prototypes before SwiftUI implementation; locks chosen design DNA into a persistent system; composes with `superpowers` for planning, simplification, and verification.

## What makes this different

The iOS skill ecosystem already covers framework knowledge well. What this plugin adds:

1. **Motion-validated prototypes** — every animation in the HTML preview maps 1:1 to a SwiftUI primitive that the implementation will faithfully reproduce
2. **Design DNA persistence** — DNA selected once at init, locked into `.design/design-system.json` + `.design/DESIGN_DNA.md`, enforced by every subsequent feature/tweak
3. **Self-introducing capability cards** — every skill announces what it can do (and what supercharges it) on first activation per session
4. **Research-and-recommend** — skill researches and proposes decisions with rationale instead of asking A/B/C config questions
5. **Companion plugin awareness** — detects missing complementary plugins/MCPs and explains the value loss without blocking

## Skills

- **`ios-design`** (router) — inspects state, prints capability card, dispatches to the right sub-skill
- **`ios-design:init`** — new project scaffold + 3 DNA prototypes + DNA selection + design system
- **`ios-design:feature`** — single prototype + SwiftUI implementation in approved DNA
- **`ios-design:tweak`** — focused motion/visual edit with DNA-conformance check

## Recommended companions

- **superpowers** (essential) — composition gateways
- **context7** MCP (essential) — live Apple docs
- **playwright** MCP (recommended) — auto-open prototypes
- **serena** MCP (recommended) — semantic Swift navigation

The plugin works without these; it just produces lower-quality results and warns you why.

## Default stack (for new projects)

| Decision | Default | Override mechanism |
|---|---|---|
| Min iOS | 26 | Lowered if app idea requires older device base |
| Bootstrap | Vanilla Xcode (solo) / Tuist (team) | Stated during init |
| Test framework | Swift Testing | Stack research recommends |
| State | `@Observable` + `@MainActor` | Locked |
| Persistence | SwiftData | Lowered to Core Data if iOS<17 chosen |
| Architecture | MVVM + Observable services | TCA for multi-team |

All choices written to `.design/DESIGN_DNA.md#Stack Decisions` with rationale.

## DNA catalog

Three opinionated defaults shipped:

- **Liquid Native** — Apple HIG + iOS 26 Liquid Glass, depth/gloss/spring
- **Editorial Crisp** — Linear/Notion aesthetic, sharp ease, monospace accents
- **Playful Character** — Arc/Duolingo energy, overshoot/bounce/celebration

Custom DNAs derived from a base by parameter tweak.

## Installation

(Once published to Claude Code marketplace.)

```bash
# placeholder — install command per Claude Code marketplace conventions
```

## Future versions

- v0.2 — `ios-design:audit` (DNA drift detection)
- v0.3 — `ios-design:storekit` (IAP)
- v0.4 — `ios-design:push` (notifications)
- v0.5 — `ios-design:appstore` (submission flow)
- v1.0 — `ios-design:backend-integration`

## Versions

- **Current:** v0.1.1 — see [`CHANGELOG.md`](CHANGELOG.md)
- v0.1.1 fixes a real-world playwright `file://` blocking issue surfaced during end-to-end testing; ships local HTTP server scripts.

## Source

- Changelog: [`CHANGELOG.md`](CHANGELOG.md)
- Design spec: [`docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md`](docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md) (includes §14 covering v0.1.1 changes)
- Implementation plan: [`docs/superpowers/plans/2026-04-20-ios-design-plugin.md`](docs/superpowers/plans/2026-04-20-ios-design-plugin.md)

## License

(Pick before publishing — MIT or Apache-2 candidates.)
