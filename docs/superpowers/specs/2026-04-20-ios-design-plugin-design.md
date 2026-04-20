# `ios-design` Plugin — Design Specification

**Date:** 2026-04-20
**Status:** Implemented (v0.1.1 released and validated end-to-end)
**Owner:** <author>
**Target version:** v0.1.0 (initial), v0.1.1 (real-world fix — see §14)

---

## 1. Purpose & Differentiator

A Claude Code plugin for end-to-end iOS app development whose distinguishing value is **design polish** — smoothness, animation character, and visual novelty — not generic SwiftUI code generation.

The iOS skill ecosystem already covers framework knowledge well (avdlee/swiftui-agent-skill, twostraws/swift-agent-skills, dpearson2699/swift-ios-skills with 76 framework-specific skills). What it does not cover: a **design conductor** that produces motion-validated interactive prototypes before writing any Swift code, locks the approved design DNA into a persistent system, and enforces it across all subsequent feature work.

Three behaviors set this plugin apart from existing iOS skills:

1. **Self-introducing capability cards** — every skill announces what it can do (and what supercharges it) on first activation per session.
2. **Research-and-recommend** — skill researches and proposes decisions with rationale instead of asking the user A/B/C config questions.
3. **Companion plugin awareness** — detects missing complementary plugins/MCPs and explains the value loss without blocking.

## 2. Scope

### In scope (v0.1)
- New iOS project scaffold (Xcode project + structure)
- Design DNA selection via 3 interactive HTML prototypes
- Persistent design system (`.design/design-system.json` + `.design/DESIGN_DNA.md`)
- Per-feature workflow: prototype → user approval → SwiftUI implementation
- Per-tweak workflow: small motion/visual edits with DNA conformance check
- Composition with `superpowers` (brainstorming, writing-plans, simplify, verification-before-completion, test-driven-development, systematic-debugging)
- Companion-plugin recommendations (context7, playwright, serena)

### Out of scope (v0.1) — planned for later versions
- **v2:** `ios-design:audit` (DNA drift detection on existing code)
- **v3+:** `ios-design:storekit` (IAP), `ios-design:push` (notifications), `ios-design:appstore` (App Store Connect / submission), `ios-design:backend-integration` (URLSession/networking patterns, auth flows)

### Explicitly not the plugin's job
- Backend service implementation
- Generic process discipline (delegated to superpowers)
- Framework-specific reference knowledge (delegated to existing avdlee/twostraws/dpearson skills if user wants them)

## 3. Architecture

### 3.1 Plugin packaging

Distributed as a Claude Code plugin (`plugin.json` + `skills/` + `references/` + `templates/` + `hooks/`). Versioned in git. Installable via Claude Code marketplace once published.

### 3.2 Skill family

| Skill | Description trigger | Primary output |
|---|---|---|
| `ios-design` (router) | "iOS app", "iOS design", "SwiftUI app" — generic intent | Inspects state, routes to correct sub-skill, prints capability card |
| `ios-design:init` | New iOS project, new app, scaffold | Xcode project + 3 DNA prototypes (HTML) + DNA selection + `.design/design-system.json` + `.design/DESIGN_DNA.md` + initial commit |
| `ios-design:feature` | "Add feature", "new screen", "auth flow" | Single HTML prototype in approved DNA → user approval → SwiftUI implementation |
| `ios-design:tweak` | "Soften the animation", "adjust spacing" | Targeted edit with DNA-conformance check |

Each skill is < 2000 tokens (per Anthropic skill authoring guidance), with progressive disclosure via `references/`.

### 3.3 Directory layout

```
ios-design/
├── plugin.json
├── README.md
├── skills/
│   ├── ios-design/SKILL.md
│   ├── ios-design-init/SKILL.md
│   ├── ios-design-feature/SKILL.md
│   └── ios-design-tweak/SKILL.md
├── references/
│   ├── motion-fidelity-rules.md
│   ├── dna-prototypes.md
│   ├── superpowers-composition.md
│   └── companion-plugins.md
├── templates/
│   ├── design-system.template.json
│   ├── DESIGN_DNA.template.md
│   └── prototype-shell.html
└── hooks/
    └── session-start.sh
```

## 4. Distinguishing Behaviors (Detailed)

### 4.1 Self-introducing capability card

On the **first activation** of a skill within a session, the first message includes a standard card:

```
🎨 ios-design:feature aktif
─────────────────────────────────────
Ne yaparım:
  • Onaylanmış DNA içinde feature tasarımı
  • HTML interactive prototype (motion validated)
  • SwiftUI implementation (design-system.json'a uyumlu)

Kullandığım superpowers:
  • brainstorming → feature scope netse skip
  • writing-plans → >3 adımlık feature için
  • simplify → her implementation sonrası
  • verification-before-completion → "tamamlandı" demeden önce

Şu an okudum: design-system.json (✓), DESIGN_DNA.md (✓)
Bekliyorum: feature ne, hangi ekran/akış?
```

Subsequent activations in the same session: single-line continuation only.

**State tracking:** flag file at `<project>/.claude/state/ios-design-<skill>-introduced.flag`, reset by `SessionStart` hook.

**Language:** card text matches the user's conversation language (Turkish in this example, English when conversing in English). Skill detects from recent user messages.

### 4.2 Research-and-recommend principle

**Project-wide rule:** the skill never asks the user to choose between A/B/C config options for decisions it can determine itself. Instead:

1. Gather minimum context (1–2 questions max)
2. Research (web + context7 + project state)
3. Present recommendations with rationale per item
4. User accepts all / accepts some / overrides

Example: instead of "iOS 17 or 26?", the skill asks "what's the app idea?", researches the category and target audience, recommends with reasoning ("iOS 26 because <category> benefits most from Liquid Glass; reach trade-off is acceptable for premium/indie segment"), and accepts override.

Override reasons are persisted to `DESIGN_DNA.md` so future sessions understand the context.

### 4.3 Companion plugin awareness

Curated list (`references/companion-plugins.md`):

| Criticality | Plugin/MCP | Loss if missing |
|---|---|---|
| Essential | `superpowers` | Composition gateways disabled |
| Essential | `context7` (MCP) | Limited to training cutoff for Apple docs |
| Highly recommended | `playwright` (MCP) | Manual file:// link instead of auto-open |
| Highly recommended | `serena` (MCP) | Token-wasteful full file reads |
| Optional | `claude-md-management` | Manual CLAUDE.md upkeep |
| Optional | `frontend-design` | Prototype may look more AI-generic |

**Detection:** router scans available skills + MCP tool prefixes (`mcp__plugin_context7_*`, `mcp__plugin_playwright_*`, etc.) on activation. Missing essentials produce a friendly warning under the capability card; missing optionals are listed quietly. Never blocks execution.

## 5. Design DNA System

### 5.1 DNA catalog

Three opinionated default DNAs in `references/dna-prototypes.md`:

| DNA | Character | Motion signature | Typical use |
|---|---|---|---|
| **Liquid Native** | Apple HIG + iOS 26 Liquid Glass — depth, gloss, layered transitions | `spring(response: 0.5, damping: 0.8)`, matchedGeometryEffect-heavy | Premium consumer, content-heavy, Apple ecosystem |
| **Editorial Crisp** | Linear/Notion aesthetic — sharp lines, sharp ease, monospace accents | `easeInOut` 200ms, short transitions, no distraction | Productivity, tools, B2B, dev-facing |
| **Playful Character** | Arc/Duolingo energy — overshoot, bounce, color bursts, micro-celebrations | `spring(response: 0.4, damping: 0.6)`, TimelineView, haptic-rich | Consumer entertainment, gamified, social, lifestyle |

Custom DNAs are derived from a base preset by parameter tweak with a new `dna_id`.

### 5.2 Init flow

1. User: "I want to build an iOS app, idea is X"
2. Skill asks 1–2 minimum-context questions
3. Skill researches comparable apps and target category
4. Skill recommends one DNA with rationale, but generates all three prototypes
5. Three HTML prototypes opened in parallel (auto-open via playwright if available, otherwise file:// links)
6. User selects (recommendation / different / hybrid → custom DNA derived)
7. Selection persisted to `.design/design-system.json` + `.design/DESIGN_DNA.md`

### 5.3 Persistence layer

**`.design/design-system.json`** — machine-readable tokens:

```json
{
  "dna_id": "liquid-native",
  "version": "1.0.0",
  "ios_min": 26,
  "color": {
    "primary": "...",
    "background": { "light": "...", "dark": "..." },
    "semantic": { ... }
  },
  "typography": {
    "scale": "1.25",
    "families": { "primary": "SF Pro", "mono": "SF Mono" }
  },
  "spacing": { "rhythm": [4, 8, 12, 16, 24, 32, 48, 64] },
  "motion": {
    "primary_spring": { "response": 0.5, "damping": 0.8 },
    "transition_duration_ms": 200,
    "easing": "spring",
    "swiftui_primitives": ["spring", "matchedGeometryEffect", "phaseAnimator"]
  },
  "components": {
    "card": { "corner_radius": 16, "shadow": "...", "blur_intensity": "regular" }
  }
}
```

**`.design/DESIGN_DNA.md`** — human-readable philosophy:

```markdown
# Design DNA: <name>

## Karakter
<one-paragraph statement of feel>

## Motion Felsefesi
<rules for motion choices>

## Ne Zaman Bu, Ne Zaman O
<decision guidance>

## Override'lar
<deviations from default with reasons>

## Stack Decisions
<min iOS, persistence, architecture, testing — with rationale>
```

Both files are created and updated together. Out-of-sync state is detected and surfaced for user resolution.

### 5.4 Runtime usage

Every skill activation reads both files first and reports them in the capability card. The `feature` skill uses `design-system.json` for token references (no hardcoded magic numbers in generated SwiftUI) and `DESIGN_DNA.md` for "is this pattern on-DNA?" decisions.

### 5.5 DNA evolution

DNA locks after init. Changes require explicit user permission, simultaneous update of both files, version bump (1.0.0 → 1.1.0), and a git commit.

When a `tweak` request deviates from DNA, the skill asks: "One-time exception or update DNA?"

## 6. HTML Preview Engineering

### 6.1 Motion fidelity constraint

**The single most important technical rule.** Prototypes may use **only CSS primitives that SwiftUI can faithfully reproduce**. Whitelist in `references/motion-fidelity-rules.md`:

| SwiftUI primitive | CSS equivalent | Fidelity |
|---|---|---|
| `.spring(response:, damping:)` | `cubic-bezier(...)` family computed from parameters | ⭐⭐⭐⭐ |
| `.easeInOut(duration:)` | `ease-in-out` + duration | ⭐⭐⭐⭐⭐ |
| `.matchedGeometryEffect` | FLIP technique (View Transitions API or manual) | ⭐⭐⭐ |
| `.phaseAnimator` | CSS keyframes + animation-timing-function chain | ⭐⭐⭐ |
| `.symbolEffect(.bounce)` | SF Symbols web font + `@keyframes scale` | ⭐⭐ |
| Liquid Glass `.glassEffect()` | `backdrop-filter: blur() saturate()` + gradient overlay | ⭐⭐ (approximation) |
| `TimelineView` continuous animation | `requestAnimationFrame` loop | ⭐⭐⭐ |

**Forbidden** (no natural SwiftUI counterpart):
- CSS-only `transform: skew()` patterns
- Complex SVG morph animations (Lottie excepted)
- Scroll-driven CSS animations
- Intersection Observer reveals

Enforcement: prompt for prototype generation embeds the whitelist; Claude self-checks every motion declaration; non-conforming primitives are removed or replaced.

### 6.2 Generation pipeline

1. Inject design tokens into CSS variables
2. DNA-aware component generation (DNA dictates component appearance rules)
3. Motion declarations filtered against fidelity table
4. Realistic content (no Lorem ipsum — uses idea-specific copy from init context)
5. iPhone chrome (status bar, home indicator, safe area)
6. Self-test pass — Claude reads its own output for fidelity violations

### 6.3 Hosting

- **With playwright:** auto-open via `browser_navigate file://`, take screenshots, support guided interaction
- **Without playwright:** message includes `file://` path, user opens manually, feedback is text-based

Init produces 3 prototypes simultaneously; with playwright opens 3 tabs for side-by-side comparison.

### 6.4 Prototype → SwiftUI mapping

Each prototype embeds render-invisible HTML comments (present in source, hidden in browser display) declaring the SwiftUI counterpart:

```html
<!-- swiftui: .glassEffect() | fallback: .background(.ultraThinMaterial) -->
<div class="card">...</div>
```

During implementation, Claude reads these comments to produce SwiftUI code with zero mapping uncertainty.

### 6.5 Edge cases

- Prototype works in CSS but SwiftUI must approximate → "approximation note" added to `DESIGN_DNA.md`, surfaced to user
- User wants override of a specific value → alternative offered or custom token added
- iOS version doesn't support Liquid Glass → fallback variant rendered alongside primary, toggle for comparison
- Prototype size (~500 lines per DNA) — accepted one-time cost at init; all subsequent work bound to chosen DNA

## 7. Superpowers Composition Map

Binding table in `references/superpowers-composition.md`:

| Skill | Gate | Invoked | Condition |
|---|---|---|---|
| `init` | Pre-scaffold | `brainstorming` | Skipped if user already brainstormed |
| `init` | Post-DNA-selection | `writing-plans` | Always (multi-step scaffold) |
| `init` | Pre-commit | `verification-before-completion` | Always |
| `feature` | Pre-design | `brainstorming` | Only if feature scope is unclear |
| `feature` | Post-prototype-approval | `writing-plans` | When > 3 implementation steps |
| `feature` | Mid-implementation | `test-driven-development` | Logic layer only (UI excluded) |
| `feature` | Post-implementation | `simplify` | Always — KISS pass |
| `feature` | Pre-commit | `verification-before-completion` | Always |
| `tweak` | Pre-change | `systematic-debugging` | When deviation request is complex |
| `tweak` | Post-change | `simplify` | Always |

**Rule:** skills delegate, never duplicate. SKILL.md says "invoke X here", not reimplemented logic.

## 8. Default Stack (Research-and-Recommend Output)

| Decision | Default | Rationale |
|---|---|---|
| Min iOS | 26 | Liquid Glass + newest motion APIs. Lowered if app idea requires older device base |
| Bootstrap | Vanilla Xcode (solo) / Tuist (team) | Module count + team size |
| Test framework | Swift Testing (iOS 18+) | Apple's new standard, cleaner syntax |
| Concurrency | Swift 6 strict | Compile-time race safety |
| State | `@Observable` + `@MainActor` | iOS 17+ standard, performance benefit |
| Persistence | SwiftData | iOS 17+, autosave + lightweight migration |
| Architecture | MVVM + Observable services (<10 screens) / TCA (multi-team) | Complexity-driven |
| DI | Manual constructor injection | YAGNI; framework only if proven needed |
| Navigation | NavigationStack + path binding | iOS 16+ standard |

All decisions written to `DESIGN_DNA.md` "Stack Decisions" section with rationale.

## 9. Testing Strategy (the plugin itself)

Validated during plugin development:

1. Skill discoverability — `description` field triggers correctly
2. Capability card — prints on first activation, suppressed on subsequent
3. Companion detection — context7/playwright/serena presence detected
4. Persistence integrity — `design-system.json` ↔ `DESIGN_DNA.md` consistency
5. Motion fidelity — sample prototype generated and every primitive verified against whitelist
6. Superpowers composition — correct skill invoked at each gate (manual scenario test)
7. End-to-end smoke — new project → DNA selection → 1 feature → 1 tweak completes cleanly

`tests/` directory: v0.1 manual scripts, v0.2+ scenario-based automation (if Claude Code skill testing matures).

## 10. Error Handling

| Condition | Behavior |
|---|---|
| `design-system.json` missing but `feature` invoked | Halt, message "init must run first", recommend it |
| DNA files conflict (manual edit) | Show diff, ask user which is correct, sync |
| Prototype HTML render error | Show error, fall back to text-only design description |
| context7 rate-limited | Fall back to web search, warn about staleness |
| SwiftUI syntax error during write | Caught at TDD/verification gate, auto-fix attempt, otherwise surface to user |
| Liquid Glass primitive on iOS<26 | Auto-fallback (`.ultraThinMaterial` etc.) + note added to `DESIGN_DNA.md` |
| User request strongly deviates from DNA | Ask: one-time exception or DNA revision? |

## 11. Plugin Manifest Sketch

```json
{
  "name": "ios-design",
  "version": "0.1.0",
  "description": "Design-first iOS app development plugin. Motion-validated HTML prototypes → SwiftUI implementation. Composes with superpowers.",
  "author": "<author>",
  "skills": [
    "skills/ios-design",
    "skills/ios-design-init",
    "skills/ios-design-feature",
    "skills/ios-design-tweak"
  ],
  "hooks": [
    {
      "event": "SessionStart",
      "command": "${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh",
      "description": "Reset capability-card flags for new session"
    }
  ],
  "recommendedPlugins": [
    { "name": "superpowers", "criticality": "essential" },
    { "name": "context7", "criticality": "essential", "type": "mcp" },
    { "name": "playwright", "criticality": "recommended", "type": "mcp" },
    { "name": "serena", "criticality": "recommended", "type": "mcp" }
  ]
}
```

`recommendedPlugins` is a plugin-internal convention (not a standard Claude Code manifest field). The router skill reads `references/companion-plugins.md` at runtime to perform the actual detection.

## 12. Future Scope (post-v0.1)

- **v0.2:** `ios-design:audit` — DNA drift detection on existing code; uses `design-system.json` as source of truth, diffs against codebase
- **v0.3:** `ios-design:storekit` — IAP / subscription flows with DNA-conformant paywall design
- **v0.4:** `ios-design:push` — push notification UI patterns + permission flows
- **v0.5:** `ios-design:appstore` — App Store Connect integration, screenshot generation per DNA, submission checklist
- **v1.0:** `ios-design:backend-integration` — networking patterns, auth flows, error/loading state DNA enforcement

Each future skill follows the same architecture rules: < 2000 tokens, self-introducing card, research-and-recommend, superpowers composition, companion-aware.

## 13. Open Implementation Questions (for writing-plans phase)

These are deliberate deferrals — design intent is set, but implementation details are best decided in the planning phase:

1. Exact JSON schema for `design-system.json` (need to validate against real-world DNA expression)
2. Whether to ship pre-rendered baseline prototype HTML for each default DNA, or generate fresh per-init
3. State flag storage location (`.claude/state/` is convention; verify it doesn't conflict with user's git ignores)
4. CI/test approach for skill behavior (Claude Code skill testing is still maturing as of 2026-04)
5. License for shipped prototype shell template (MIT vs Apache-2 — pick during repo init)

## 14. Post-v0.1.0 Changes (v0.1.1)

Real-world end-to-end testing surfaced one bug that warranted an immediate patch.

### 14.1 Playwright `file://` blocking — fix

**Symptom:** Playwright MCP rejects `file://` URLs for security. The init/feature skills' "open prototypes via `browser_navigate file://...`" step failed.

**Root cause:** Browser-automation MCPs broadly block `file://` to prevent local-file exfiltration. This is by design and not configurable.

**Fix:** Added two helper scripts in a new `scripts/` directory:
- `scripts/serve-prototypes.sh` — starts a local HTTP server (Python `http.server`) on `127.0.0.1`. Default port 8765, auto-bumps on collision (scans up to 19 ports). Idempotent: detects an existing server for the project and reuses it. Writes PID to `.design/.prototype-server.pid`. Prints the base URL on stdout for the caller to capture.
- `scripts/stop-prototype-server.sh` — kills the recorded PID, idempotent.

The `init` and `feature` SKILL.md files were updated to invoke these scripts when playwright is detected, and to fall back to `file://` paths when playwright is absent (manual user opening).

The `references/companion-plugins.md` playwright entry was annotated with the limitation and the workaround.

### 14.2 Validation

The fix was validated by running the full init-then-feature flow against a live `todo-app` test project:
- Server started on `http://localhost:8765`
- All three DNA prototypes opened in playwright successfully
- Screenshots captured for each
- Click interaction tested on a task row → toggle animation fired → state persisted in DOM
- Server stopped cleanly via the stop script

### 14.3 Affected version

Released as `v0.1.1` (annotated git tag). plugin.json bumped from `0.1.0` to `0.1.1`. No SKILL.md frontmatter changes; no breaking changes for users of `v0.1.0`.

### 14.4 Spec implication

The original §13 "Open Implementation Questions" item #2 ("Whether to ship pre-rendered baseline prototype HTML for each default DNA, or generate fresh per-init") was decided during implementation in favor of pre-rendered baselines (Task 7). This v0.1.1 fix reinforces that decision: with prototypes as static files, a simple HTTP server suffices; if prototypes were generated per-init we would have needed more complex server-management lifecycle.

---

**End of design specification.**
