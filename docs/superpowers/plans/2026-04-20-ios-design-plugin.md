# `ios-design` Plugin v0.1.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the v0.1.0 release of the `ios-design` Claude Code plugin — a 4-skill family (router + init + feature + tweak) that produces motion-validated HTML design prototypes before SwiftUI implementation, with persistent design DNA, superpowers composition, self-introducing capability cards, and companion-plugin awareness.

**Architecture:** Plugin lives at the project root (`<plugin-root>/`). Skills are markdown-only with YAML frontmatter; references hold curated knowledge for progressive disclosure; templates and prototypes ship as static assets; one bash hook resets per-session state flags. No runtime code execution other than the SessionStart hook.

**Tech Stack:** Markdown (skills, references, README), JSON (plugin manifest, design tokens), HTML/CSS (prototype templates), Bash (one hook), Git (versioning, commits).

**Source spec:** `docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md` — authoritative reference for content depth on each artifact.

---

## Task 1: Plugin Scaffold

**Files:**
- Create: `<plugin-root>/plugin.json`
- Create: `<plugin-root>/.gitignore`
- Create: `<plugin-root>/README.md` (skeleton — finalized in Task 14)
- Modify: initialize git repo at project root

- [ ] **Step 1: Initialize git and create directory skeleton**

```bash
cd <plugin-root>
git init
mkdir -p references templates prototypes hooks skills/ios-design skills/ios-design-init skills/ios-design-feature skills/ios-design-tweak tests
```

- [ ] **Step 2: Create `plugin.json`**

Write `<plugin-root>/plugin.json`:

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
      "description": "Reset per-skill capability-card flags for new session"
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

- [ ] **Step 3: Create `.gitignore`**

Write `<plugin-root>/.gitignore`:

```
.DS_Store
.claude/state/
*.log
node_modules/
.env
.env.local
```

- [ ] **Step 4: Create README skeleton**

Write `<plugin-root>/README.md`:

```markdown
# ios-design

Design-first iOS app development plugin for Claude Code.

> **Status:** v0.1.0 in development. See `docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md` for the full design.

## Skills (provided)

- `ios-design` — router; prints capability card and dispatches to the right sub-skill
- `ios-design:init` — new project scaffold + 3 design DNA prototypes + DNA selection + design system persistence
- `ios-design:feature` — single prototype + SwiftUI implementation in approved DNA
- `ios-design:tweak` — focused motion/visual edit with DNA-conformance check

(Full README finalized in Task 14.)
```

- [ ] **Step 5: Validate JSON**

Run: `python3 -c "import json; json.load(open('<plugin-root>/plugin.json'))"`
Expected: no output (success). Failure prints `JSONDecodeError`.

- [ ] **Step 6: Commit**

```bash
cd <plugin-root>
git add plugin.json .gitignore README.md
git commit -m "chore: scaffold ios-design plugin v0.1.0 manifest and structure"
```

---

## Task 2: Companion Plugins Reference

**Files:**
- Create: `<plugin-root>/references/companion-plugins.md`

- [ ] **Step 1: Write companion-plugins.md**

```markdown
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

### Highly recommended

**playwright MCP**
- Why: HTML prototypes auto-open in a browser tab, screenshots are captured for `DESIGN_DNA.md` archive, guided interaction (click/scroll prompts) supported.
- Loss if missing: skill outputs `file://` paths and asks the user to open them manually; feedback is text-only.
- Install: see playwright MCP docs.

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
```

- [ ] **Step 2: Commit**

```bash
cd <plugin-root>
git add references/companion-plugins.md
git commit -m "feat(refs): add companion plugins detection catalog"
```

---

## Task 3: Motion Fidelity Rules Reference

**Files:**
- Create: `<plugin-root>/references/motion-fidelity-rules.md`

- [ ] **Step 1: Write motion-fidelity-rules.md**

```markdown
# Motion Fidelity Rules

**The single most important technical rule of this plugin.** HTML prototypes may use only CSS primitives that SwiftUI can faithfully reproduce. If a prototype uses a CSS-only effect that has no SwiftUI counterpart, the user approves something the implementation cannot deliver — the plugin's value proposition collapses.

## Whitelist (CSS → SwiftUI)

| SwiftUI primitive | CSS equivalent | Fidelity | Notes |
|---|---|---|---|
| `.spring(response:, damping:)` | `transition: ... cubic-bezier(...)` computed from spring parameters | ⭐⭐⭐⭐ | Use [spring → cubic-bezier converter](https://www.cssportal.com/css-cubic-bezier-generator/); document parameters in HTML comment |
| `.easeInOut(duration:)` | `transition: ... ease-in-out <duration>ms` | ⭐⭐⭐⭐⭐ | Direct mapping |
| `.easeIn` / `.easeOut` | `ease-in` / `ease-out` | ⭐⭐⭐⭐⭐ | Direct mapping |
| `.linear` | `linear` | ⭐⭐⭐⭐⭐ | Direct mapping |
| `.matchedGeometryEffect(id:in:)` | View Transitions API (`view-transition-name`) or manual FLIP | ⭐⭐⭐ | Browser support varies; document the SwiftUI namespace + id in comment |
| `.phaseAnimator([...])` | CSS `@keyframes` with chained `animation-timing-function` per stop | ⭐⭐⭐ | Encode each phase as a keyframe |
| `.symbolEffect(.bounce)` | SF Symbols web font + `@keyframes scale` | ⭐⭐ | Approximation; document the exact SF Symbol effect name |
| `.symbolEffect(.pulse)` | `@keyframes opacity` | ⭐⭐⭐ | Approximation |
| `.glassEffect()` (iOS 26+) | `backdrop-filter: blur(<n>px) saturate(<m>%)` + gradient overlay | ⭐⭐ | Approximation; document fallback `.background(.ultraThinMaterial)` |
| `TimelineView(.animation)` continuous loop | `requestAnimationFrame` JS loop | ⭐⭐⭐ | For per-frame animations only |
| `.transition(.move(edge:))` | CSS `translate*` transition | ⭐⭐⭐⭐ | Direction mapping required |
| `.transition(.scale)` | `transform: scale()` transition | ⭐⭐⭐⭐ | Direct |
| `.transition(.opacity)` | `opacity` transition | ⭐⭐⭐⭐⭐ | Direct |

## Forbidden CSS

These have no clean SwiftUI counterpart and must NOT appear in prototypes:

- `transform: skew(...)` — SwiftUI lacks shear transforms
- Complex SVG `<animateTransform>` morphs (Lottie excepted, but Lottie is a separate decision)
- `scroll-timeline:` / scroll-driven CSS animations — SwiftUI's scroll-position APIs are different and harder to map directly
- `IntersectionObserver`-driven reveals — implementable in SwiftUI but heavyweight
- Filter chains beyond `blur` / `saturate` / `brightness` (e.g., `hue-rotate`, `drop-shadow` chains)

## Prototype embedding rule

Every motion declaration in the prototype HTML MUST be paired with a render-invisible HTML comment naming the SwiftUI counterpart. Example:

```html
<!-- swiftui: .animation(.spring(response: 0.5, damping: 0.8), value: isExpanded) -->
<div class="card" style="transition: transform 500ms cubic-bezier(0.5, 1.8, 0.5, 0.75)"></div>

<!-- swiftui: .glassEffect() | fallback iOS<26: .background(.ultraThinMaterial) -->
<div class="nav-bar" style="backdrop-filter: blur(20px) saturate(180%); background: linear-gradient(...)"></div>
```

These comments are how the implementation phase produces SwiftUI code with zero mapping uncertainty.

## Self-test (mandatory before showing prototype)

After generating a prototype, the skill MUST scan its own output for:

1. Every `transition:`, `animation:`, `transform:`, `backdrop-filter:` declaration → verify a sibling `<!-- swiftui: ... -->` comment exists
2. Every motion declaration → verify the primitive appears in the whitelist
3. No forbidden CSS used

If any check fails: revise the prototype before showing it to the user. Do not surface a non-conforming prototype.

## Spring parameter conversion (reference)

A SwiftUI `.spring(response: r, damping: d)` approximates to a cubic-bezier. Heuristic (good enough for prototype validation):

- `response` ≈ duration in seconds (use `r * 1000` for ms in CSS)
- `damping` 1.0 → no overshoot, near-cubic ease-out
- `damping` 0.7-0.9 → slight overshoot, natural feel
- `damping` 0.5-0.7 → noticeable bounce
- `damping` < 0.5 → strong bounce (rare in production)

Common pairs:
- `(0.5, 0.8)` → `cubic-bezier(0.32, 0.72, 0.32, 1.08)` over 500ms
- `(0.4, 0.6)` → `cubic-bezier(0.18, 0.89, 0.32, 1.28)` over 400ms (playful)
- `(0.6, 1.0)` → `cubic-bezier(0.25, 0.46, 0.45, 0.94)` over 600ms (calm)

When in doubt, generate the bezier dynamically and document the source spring parameters in the HTML comment.
```

- [ ] **Step 2: Commit**

```bash
cd <plugin-root>
git add references/motion-fidelity-rules.md
git commit -m "feat(refs): add motion fidelity rules with CSS<>SwiftUI whitelist"
```

---

## Task 4: DNA Prototypes Catalog Reference

**Files:**
- Create: `<plugin-root>/references/dna-prototypes.md`

- [ ] **Step 1: Write dna-prototypes.md**

```markdown
# DNA Prototypes Catalog

Three opinionated default DNAs ship with the plugin. Each is realized as a complete HTML prototype in `prototypes/` showing a representative screen (home / detail / a transition) so users can feel the motion character before choosing.

Custom DNAs are derived from a base by parameter tweak with a new `dna_id`.

## DNA 1: Liquid Native

**ID:** `liquid-native`
**One-line character:** Apple HIG + iOS 26 Liquid Glass — depth, gloss, layered transitions.
**Motion signature:** `spring(response: 0.5, damping: 0.8)`, matchedGeometryEffect-heavy.
**Typography:** SF Pro, generous line-height, semantic weights.
**Color logic:** semantic system colors + a single accent; honors light/dark.
**Component bias:** `.glassEffect()` on nav/tab/modal backgrounds; `.background(.ultraThinMaterial)` fallback for iOS<26.
**Typical use:** premium consumer apps, content-heavy, Apple ecosystem (journal, reader, weather, music).

**Prototype file:** `prototypes/liquid-native.html`

## DNA 2: Editorial Crisp

**ID:** `editorial-crisp`
**One-line character:** Linear/Notion aesthetic — sharp lines, sharp ease, monospace accents, minimal ornament.
**Motion signature:** `easeInOut` 200ms, short transitions, no distraction.
**Typography:** SF Pro for headings + SF Mono for accents (timestamps, IDs, code-like content).
**Color logic:** monochromatic spine + one signal color; high-contrast in both modes.
**Component bias:** flat surfaces, hairline dividers (1px @ low opacity), no shadows beyond functional ones (focus rings).
**Typical use:** productivity, dev tools, B2B, editorial apps.

**Prototype file:** `prototypes/editorial-crisp.html`

## DNA 3: Playful Character

**ID:** `playful-character`
**One-line character:** Arc/Duolingo energy — overshoot, bounce, color bursts, micro-celebrations.
**Motion signature:** `spring(response: 0.4, damping: 0.6)`, TimelineView for ambient animations, haptic-rich.
**Typography:** rounded variants (SF Pro Rounded), generous, expressive sizes.
**Color logic:** vibrant palette (3-4 hues in active rotation), gradients permitted but disciplined.
**Component bias:** rounded corners (>16pt), playful illustrations, success states celebrate.
**Typical use:** consumer entertainment, gamified, social, lifestyle, education for kids.

**Prototype file:** `prototypes/playful-character.html`

## Selection flow (init skill consumes this)

1. After init's research step, the skill chooses ONE DNA as primary recommendation with a 1-2 sentence rationale grounded in the app idea
2. All three prototypes are presented anyway — recommendation does not foreclose
3. User can: accept primary / pick a different one / request a hybrid (e.g., "Liquid Native but calmer motion") → custom DNA derived
4. Custom DNA derivation: clone base preset, tweak named parameters (motion timings, color saturation, etc.), assign new `dna_id` (e.g., `liquid-native-calm`)

## Token defaults per DNA

These are the values that get written into `design-system.json` when the DNA is selected. (Override examples shown for liquid-native; others follow analogous structure.)

```json
{
  "liquid-native": {
    "color": {
      "primary": "system.tint",
      "background": { "light": "system.background", "dark": "system.background" },
      "semantic": "system"
    },
    "typography": { "scale": "1.25", "families": { "primary": "SF Pro", "mono": "SF Mono" } },
    "spacing": { "rhythm": [4, 8, 12, 16, 24, 32, 48, 64] },
    "motion": {
      "primary_spring": { "response": 0.5, "damping": 0.8 },
      "transition_duration_ms": 500,
      "easing": "spring",
      "swiftui_primitives": ["spring", "matchedGeometryEffect", "phaseAnimator", "glassEffect"]
    },
    "components": {
      "card": { "corner_radius": 16, "shadow": "soft", "blur_intensity": "regular" },
      "navbar": { "material": "glassEffect", "fallback_material": "ultraThinMaterial" }
    }
  },
  "editorial-crisp": {
    "color": {
      "primary": "#0066FF",
      "background": { "light": "#FFFFFF", "dark": "#0A0A0A" },
      "semantic": "system"
    },
    "typography": { "scale": "1.20", "families": { "primary": "SF Pro", "mono": "SF Mono" } },
    "spacing": { "rhythm": [4, 8, 12, 16, 20, 24, 32, 48] },
    "motion": {
      "primary_easing": "easeInOut",
      "transition_duration_ms": 200,
      "easing": "easeInOut",
      "swiftui_primitives": ["easeInOut", "linear", "transition.opacity", "transition.move"]
    },
    "components": {
      "card": { "corner_radius": 8, "shadow": "none", "border": "1px hairline" },
      "navbar": { "material": "regularMaterial", "border_bottom": "hairline" }
    }
  },
  "playful-character": {
    "color": {
      "primary": "#FF5E5B",
      "background": { "light": "#FFFEF7", "dark": "#1B1A1F" },
      "semantic": "custom",
      "accents": ["#FFE74C", "#5BC0EB", "#7CFC00"]
    },
    "typography": { "scale": "1.333", "families": { "primary": "SF Pro Rounded", "mono": "SF Mono" } },
    "spacing": { "rhythm": [4, 8, 12, 16, 24, 32, 48, 64, 96] },
    "motion": {
      "primary_spring": { "response": 0.4, "damping": 0.6 },
      "transition_duration_ms": 400,
      "easing": "spring",
      "swiftui_primitives": ["spring", "phaseAnimator", "symbolEffect.bounce", "TimelineView"]
    },
    "components": {
      "card": { "corner_radius": 24, "shadow": "playful", "blur_intensity": "none" },
      "navbar": { "material": "regularMaterial", "accent_underline": true }
    }
  }
}
```
```

- [ ] **Step 2: Commit**

```bash
cd <plugin-root>
git add references/dna-prototypes.md
git commit -m "feat(refs): add 3 default DNA catalog with token defaults"
```

---

## Task 5: Superpowers Composition Reference

**Files:**
- Create: `<plugin-root>/references/superpowers-composition.md`

- [ ] **Step 1: Write superpowers-composition.md**

```markdown
# Superpowers Composition Map

This plugin's skills compose with `superpowers` rather than reimplementing planning, simplification, or verification logic. This file is the binding contract: which superpowers skill is invoked at which gate, and under what condition.

## Composition principle

Each ios-design skill's SKILL.md must DELEGATE at the gates below — never duplicate the logic. Delegation = invoke the named skill via the Skill tool with appropriate context.

If `superpowers` is not installed, gates are skipped with a one-line warning ("⚠️ <skill-name> skipped — superpowers not installed; quality reduced").

## Gateway table

### `ios-design:init`

| Gate | Invoked superpowers skill | Condition |
|---|---|---|
| After capability card, before scaffold | `superpowers:brainstorming` | Skipped if user message includes evidence of prior brainstorming (e.g., a spec already exists in `docs/superpowers/specs/` for this app) |
| After DNA selection persisted | `superpowers:writing-plans` | Always (multi-step scaffold needs a plan) |
| Before initial git commit | `superpowers:verification-before-completion` | Always |

### `ios-design:feature`

| Gate | Invoked superpowers skill | Condition |
|---|---|---|
| Before prototype design | `superpowers:brainstorming` | Only if feature scope is unclear from the user's initial request |
| After prototype approval | `superpowers:writing-plans` | Only if implementation requires > 3 distinct steps |
| During implementation | `superpowers:test-driven-development` | Only for non-UI logic (services, ViewModels, business rules). UI/View code is excluded — TDD doesn't fit SwiftUI view code well |
| After implementation, before commit | `superpowers:simplify` | Always (KISS pass) |
| Before claiming completion | `superpowers:verification-before-completion` | Always |

### `ios-design:tweak`

| Gate | Invoked superpowers skill | Condition |
|---|---|---|
| Before applying change | `superpowers:systematic-debugging` | Only if the change request stems from a bug or unexpected behavior |
| After applying change | `superpowers:simplify` | Always |

## Invocation pattern (in SKILL.md)

Each gate is expressed as a step in the SKILL.md flow. Example for `feature`:

```markdown
### Step 4: Implementation

After prototype approval:

1. Check estimated step count
2. If > 3 steps: invoke `superpowers:writing-plans` to produce an implementation plan
3. For each non-UI logic file: invoke `superpowers:test-driven-development`
4. Implement UI per the prototype's `<!-- swiftui: ... -->` comments and design-system.json tokens
5. Invoke `superpowers:simplify` for a KISS pass
6. Invoke `superpowers:verification-before-completion` before declaring done
```

## When to NOT compose

- Trivial single-line tweaks (`tweak` skill on a single value): skip simplify; commit directly
- Init when called with `--minimal` flag (future v0.2 feature): skip brainstorming + writing-plans, scaffold defaults

## Audit (v0.2)

`ios-design:audit` will additionally compose:
- `superpowers:systematic-debugging` for root-causing DNA drift
- `superpowers:verification-before-completion` for the audit report itself
```

- [ ] **Step 2: Commit**

```bash
cd <plugin-root>
git add references/superpowers-composition.md
git commit -m "feat(refs): add superpowers composition map with per-skill gateways"
```

---

## Task 6: Templates

**Files:**
- Create: `<plugin-root>/templates/design-system.template.json`
- Create: `<plugin-root>/templates/DESIGN_DNA.template.md`
- Create: `<plugin-root>/templates/prototype-shell.html`

- [ ] **Step 1: Write design-system.template.json**

```json
{
  "$schema": "./design-system.schema.json",
  "dna_id": "<DNA_ID>",
  "version": "1.0.0",
  "ios_min": 26,
  "color": {
    "primary": "<COLOR_TOKEN_OR_HEX>",
    "background": {
      "light": "<COLOR>",
      "dark": "<COLOR>"
    },
    "semantic": "<system | custom>",
    "accents": []
  },
  "typography": {
    "scale": "<RATIO_AS_STRING>",
    "families": {
      "primary": "<FONT_FAMILY>",
      "mono": "<FONT_FAMILY>"
    }
  },
  "spacing": {
    "rhythm": [4, 8, 12, 16, 24, 32, 48, 64]
  },
  "motion": {
    "primary_spring": { "response": 0.0, "damping": 0.0 },
    "primary_easing": null,
    "transition_duration_ms": 0,
    "easing": "<spring | easeInOut | linear>",
    "swiftui_primitives": []
  },
  "components": {
    "card": {
      "corner_radius": 0,
      "shadow": "<none | soft | playful>",
      "blur_intensity": "<none | regular | thick>"
    },
    "navbar": {
      "material": "<glassEffect | regularMaterial | ultraThinMaterial>",
      "fallback_material": "<MATERIAL>"
    }
  },
  "stack_decisions": {
    "min_ios": 26,
    "bootstrap": "<vanilla-xcode | tuist | xcodegen>",
    "test_framework": "<swift-testing | xctest>",
    "concurrency": "swift6-strict",
    "state": "observable-mainactor",
    "persistence": "<swiftdata | core-data>",
    "architecture": "<mvvm-observable | tca | clean>",
    "di": "<manual-constructor | swift-dependencies>",
    "navigation": "navigation-stack-path-binding"
  },
  "overrides": []
}
```

- [ ] **Step 2: Write DESIGN_DNA.template.md**

```markdown
# Design DNA: <NAME>

**DNA ID:** `<DNA_ID>`
**Version:** 1.0.0
**Established:** <DATE>

## Karakter

<One paragraph: what does this app feel like? Write in the user's conversation language.>

## Motion Felsefesi

- <Rule 1: e.g., "Hareket yumuşak ama belirleyici — hiçbir geçiş 1s'yi geçmez">
- <Rule 2: e.g., "Spring ağırlıklı, lineer asla">
- <Rule 3: e.g., "matchedGeometryEffect tercih sebebi (continuity)">

## Ne Zaman Bu, Ne Zaman O

| Karar noktası | Tercih | Gerekçe |
|---|---|---|
| Sheet vs fullScreenCover | <preference> | <reason> |
| Liquid Glass kullanımı | <when applied> | <reason> |
| Haptic | <when used> | <reason> |
| Accent color usage | <pattern> | <reason> |

## Stack Decisions

(Mirror of `design-system.json#stack_decisions` with prose rationale per item.)

| Karar | Seçim | Gerekçe |
|---|---|---|
| Min iOS | <version> | <why> |
| Bootstrap | <tool> | <why> |
| Test framework | <framework> | <why> |
| Architecture | <pattern> | <why> |
| Persistence | <choice> | <why> |
| DI | <approach> | <why> |

## Override'lar

(Append-only log. Each entry: date, what was overridden, reason.)

- <DATE> — `<key.path>`: changed from `<old>` to `<new>`. Reason: <why>.

## Approximation Notes

(Append-only log of cases where the SwiftUI implementation could not exactly match the prototype.)

- <DATE> — `<feature>`: prototype showed <CSS effect>, implemented as <SwiftUI approximation>. Visual delta: <description>.
```

- [ ] **Step 3: Write prototype-shell.html**

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Prototype — {{DNA_NAME}}</title>
<style>
:root {
  /* Injected from design-system.json — placeholders below replaced at generation */
  --color-primary: {{COLOR_PRIMARY}};
  --color-bg-light: {{COLOR_BG_LIGHT}};
  --color-bg-dark: {{COLOR_BG_DARK}};
  --space-1: {{SPACE_1}}px;
  --space-2: {{SPACE_2}}px;
  --space-3: {{SPACE_3}}px;
  --space-4: {{SPACE_4}}px;
  --motion-duration: {{MOTION_DURATION_MS}}ms;
  --motion-easing: {{MOTION_EASING_BEZIER}};
  --font-primary: {{FONT_PRIMARY}};
  --font-mono: {{FONT_MONO}};
  --radius-card: {{CARD_RADIUS}}px;
}

@media (prefers-color-scheme: dark) {
  :root { --color-bg: var(--color-bg-dark); }
}
@media (prefers-color-scheme: light) {
  :root { --color-bg: var(--color-bg-light); }
}

* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: var(--font-primary), -apple-system, BlinkMacSystemFont, sans-serif;
  background: #2a2a2a;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 40px 0;
}

/* iPhone 16 Pro frame: 393x852 logical points */
.device {
  width: 393px;
  height: 852px;
  background: var(--color-bg);
  border-radius: 55px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 30px 80px rgba(0,0,0,0.5);
}

.device::before {
  /* Dynamic Island */
  content: "";
  position: absolute;
  top: 11px; left: 50%;
  transform: translateX(-50%);
  width: 126px; height: 37px;
  background: #000;
  border-radius: 20px;
  z-index: 100;
}

.status-bar {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 54px;
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  padding: 0 24px 8px;
  font-size: 17px;
  font-weight: 600;
  z-index: 50;
}

.home-indicator {
  position: absolute;
  bottom: 8px; left: 50%;
  transform: translateX(-50%);
  width: 134px; height: 5px;
  background: currentColor;
  border-radius: 3px;
  opacity: 0.6;
  z-index: 50;
}

.safe-area {
  position: absolute;
  top: 59px; left: 0; right: 0; bottom: 34px;
  overflow-y: auto;
}

/* Components — DNA-specific styling appended at generation */
</style>
</head>
<body>
<div class="device">
  <div class="status-bar"><span>9:41</span><span>·· 􀙇 􀛨</span></div>
  <div class="safe-area">
    <!-- DNA-specific markup appended here at generation -->
    {{CONTENT}}
  </div>
  <div class="home-indicator"></div>
</div>
<script>
// Reserved for TimelineView-equivalent requestAnimationFrame loops if needed.
// {{SCRIPT}}
</script>
</body>
</html>
```

- [ ] **Step 4: Validate JSON template**

Run: `python3 -c "import json; json.load(open('<plugin-root>/templates/design-system.template.json'))"`
Expected: no output (success).

- [ ] **Step 5: Commit**

```bash
cd <plugin-root>
git add templates/
git commit -m "feat(templates): add design-system, DESIGN_DNA, and prototype shell"
```

---

## Task 7: Default DNA Prototype HTMLs

Each prototype shows a representative screen pattern (home + a transition + a detail) so the user can feel the DNA's motion character. All three follow the same structural shell from Task 6 but inject DNA-specific tokens and components.

**Files:**
- Create: `<plugin-root>/prototypes/liquid-native.html`
- Create: `<plugin-root>/prototypes/editorial-crisp.html`
- Create: `<plugin-root>/prototypes/playful-character.html`

- [ ] **Step 1: Build liquid-native.html**

Generate by:
1. Take `templates/prototype-shell.html`
2. Substitute placeholders with `dna-prototypes.md#liquid-native` token defaults
3. Inject this content section showing a card list → tap → matched-geometry detail expansion:

```html
<!-- swiftui: NavigationStack root -->
<div class="screen">
  <h1 style="padding: var(--space-4) var(--space-3) var(--space-2); font-size: 34px; font-weight: 700;">Saved</h1>

  <!-- swiftui: ForEach(items) { item in CardView(item).matchedGeometryEffect(id: item.id, in: ns) } -->
  <div class="card-list" style="display: flex; flex-direction: column; gap: var(--space-2); padding: 0 var(--space-3) var(--space-3);">
    <!-- swiftui: CardView with .glassEffect() | fallback .background(.ultraThinMaterial) -->
    <div class="card" onclick="expand(this)" style="
      background: rgba(255,255,255,0.6);
      backdrop-filter: blur(20px) saturate(180%);
      -webkit-backdrop-filter: blur(20px) saturate(180%);
      border-radius: var(--radius-card);
      padding: var(--space-3);
      transition: transform var(--motion-duration) var(--motion-easing),
                  box-shadow var(--motion-duration) var(--motion-easing);
      cursor: pointer;
    ">
      <h3 style="font-size: 17px; font-weight: 600; margin-bottom: 4px;">Morning ritual</h3>
      <p style="font-size: 15px; opacity: 0.7;">A short note about how the day began…</p>
    </div>
    <!-- Repeat 3 more cards with varied content -->
  </div>
</div>

<style>
.card:active { transform: scale(0.98); }
.card.expanded {
  position: fixed;
  top: 100px; left: 16px; right: 16px;
  height: calc(100% - 200px);
  z-index: 10;
}
</style>

<script>
function expand(el) {
  // swiftui equivalent: state toggle drives matchedGeometryEffect transition
  el.classList.toggle('expanded');
}
</script>
```

Final file should also include 3 more cards with varied realistic content (not Lorem) — sample copy for a journaling/reading app.

- [ ] **Step 2: Build editorial-crisp.html**

Same shell, substitute editorial-crisp tokens, inject content showing a list with hairline dividers + crisp 200ms ease-in-out transitions on row tap:

```html
<div class="screen">
  <h1 style="padding: var(--space-4) var(--space-3) var(--space-2); font-size: 28px; font-weight: 600; letter-spacing: -0.02em;">Inbox</h1>

  <!-- swiftui: List with hairline separators, .easeInOut(duration: 0.2) on selection -->
  <ul style="list-style: none; padding: 0;">
    <!-- swiftui: row with .background(isSelected ? Color.accent.opacity(0.1) : .clear).animation(.easeInOut(duration: 0.2), value: isSelected) -->
    <li onclick="toggle(this)" style="
      padding: var(--space-3);
      border-bottom: 1px solid rgba(0,0,0,0.06);
      transition: background var(--motion-duration) var(--motion-easing);
      cursor: pointer;
      display: flex;
      gap: var(--space-2);
      align-items: center;
    ">
      <span style="font-family: var(--font-mono); font-size: 12px; opacity: 0.5; min-width: 50px;">10:42</span>
      <div>
        <h4 style="font-size: 15px; font-weight: 500;">Q3 metrics review</h4>
        <p style="font-size: 13px; opacity: 0.6;">Numbers from the dashboard…</p>
      </div>
    </li>
    <!-- Repeat 4-5 more rows with realistic Linear-style content -->
  </ul>
</div>

<style>
li.selected { background: rgba(0, 102, 255, 0.08); }
</style>

<script>
function toggle(el) { el.classList.toggle('selected'); }
</script>
```

- [ ] **Step 3: Build playful-character.html**

Same shell, playful-character tokens, content showing a "streak achieved" celebration with bounce + confetti (CSS keyframes only, no libraries):

```html
<div class="screen">
  <!-- swiftui: VStack with .symbolEffect(.bounce) on celebration trigger -->
  <div style="display: flex; flex-direction: column; align-items: center; padding: var(--space-4) var(--space-3); gap: var(--space-3);">
    <!-- swiftui: Image(systemName: "flame.fill").symbolEffect(.bounce.up.byLayer, value: count).foregroundStyle(.orange) -->
    <div onclick="celebrate(this)" style="
      width: 120px; height: 120px;
      border-radius: 60px;
      background: linear-gradient(135deg, #FFE74C, #FF5E5B);
      display: flex; align-items: center; justify-content: center;
      font-size: 64px;
      cursor: pointer;
      animation: float 3s ease-in-out infinite;
      transition: transform var(--motion-duration) var(--motion-easing);
    ">🔥</div>

    <!-- swiftui: Text("7 day streak!").font(.title.bold()) with phaseAnimator for entrance -->
    <h1 style="font-size: 32px; font-weight: 700; font-family: var(--font-primary);">7 day streak!</h1>
    <p style="font-size: 17px; opacity: 0.7;">Keep the flame alive 💪</p>

    <!-- swiftui: Button with .buttonStyle(.borderedProminent) sized large, with custom spring on press -->
    <button style="
      margin-top: var(--space-4);
      padding: var(--space-3) var(--space-4);
      background: var(--color-primary);
      color: white;
      font-size: 17px; font-weight: 600;
      border: none;
      border-radius: 30px;
      cursor: pointer;
      transition: transform var(--motion-duration) var(--motion-easing);
    ">Continue today's lesson</button>
  </div>
</div>

<style>
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}
@keyframes pop {
  0% { transform: scale(1); }
  40% { transform: scale(1.25); }
  100% { transform: scale(1); }
}
.popping { animation: pop 0.4s cubic-bezier(0.18, 0.89, 0.32, 1.28); }
button:active { transform: scale(0.95); }
</style>

<script>
function celebrate(el) {
  el.classList.remove('popping');
  void el.offsetWidth; // restart animation
  el.classList.add('popping');
}
</script>
```

- [ ] **Step 4: Self-test each prototype against motion-fidelity-rules.md**

For each of the 3 files:
1. Open the file
2. Find every `transition:`, `animation:`, `transform:`, `backdrop-filter:` declaration
3. Verify a sibling `<!-- swiftui: ... -->` comment exists
4. Verify the SwiftUI primitive named in the comment appears in the whitelist
5. Verify no forbidden CSS (`skew`, scroll-driven, intersection-observer, hue-rotate filter chains)

If any check fails: edit the file before commit.

- [ ] **Step 5: Open each in a browser to visually verify**

If playwright MCP available: open each file via `browser_navigate file:///<absolute-path>` and take a screenshot for visual sanity.
If not: print the file:// path and ask the implementer to open manually and confirm.

- [ ] **Step 6: Commit**

```bash
cd <plugin-root>
git add prototypes/
git commit -m "feat(prototypes): add 3 default DNA interactive prototypes"
```

---

## Task 8: SessionStart Hook

**Files:**
- Create: `<plugin-root>/hooks/session-start.sh`

- [ ] **Step 1: Write session-start.sh**

```bash
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
```

- [ ] **Step 2: Make executable**

Run: `chmod +x <plugin-root>/hooks/session-start.sh`
Expected: no output.

- [ ] **Step 3: Lint with shellcheck (if installed)**

Run: `command -v shellcheck >/dev/null && shellcheck <plugin-root>/hooks/session-start.sh || echo "shellcheck not installed — skipped"`
Expected: no output (success) or "shellcheck not installed — skipped".

- [ ] **Step 4: Smoke test the hook**

Run:
```bash
mkdir -p /tmp/ios-design-hook-test/.claude/state
touch /tmp/ios-design-hook-test/.claude/state/ios-design-init-introduced.flag
CLAUDE_PROJECT_DIR=/tmp/ios-design-hook-test <plugin-root>/hooks/session-start.sh
ls /tmp/ios-design-hook-test/.claude/state/
rm -rf /tmp/ios-design-hook-test
```
Expected: `ls` prints empty (flag was deleted).

- [ ] **Step 5: Commit**

```bash
cd <plugin-root>
git add hooks/session-start.sh
git commit -m "feat(hooks): add SessionStart hook to reset capability-card flags"
```

---

## Task 9: Router Skill (`ios-design`)

**Files:**
- Create: `<plugin-root>/skills/ios-design/SKILL.md`

- [ ] **Step 1: Write SKILL.md**

```markdown
---
name: ios-design
description: Design-first iOS app development orchestrator. Use when the user mentions building, designing, or working on an iOS app, SwiftUI app, or iPhone app. Inspects current project state, prints capability card, and routes to ios-design:init (new project), ios-design:feature (add feature), or ios-design:tweak (small change).
---

# ios-design (router)

You are the entry point for the `ios-design` plugin family. Your job is to figure out what the user actually needs and route to the right sub-skill, while transparently announcing your capabilities and the ecosystem state.

## Step 1: Print capability card (first activation only)

Check for `<project>/.claude/state/ios-design-router-introduced.flag`. If absent:

1. Detect companion plugins/MCPs per `references/companion-plugins.md`
2. Print the capability card in the user's conversation language (detect from recent messages):

```
🎨 ios-design router aktif
─────────────────────────────────────
Ne yaparım:
  • iOS app geliştirme isteğini doğru sub-skill'e yönlendiririm
  • Mevcut proje durumunu (var mı yok mu, DNA seçilmiş mi) tespit ederim

Sub-skill'lerim:
  • ios-design:init    → yeni iOS projesi + DNA seçimi
  • ios-design:feature → onaylanmış DNA içinde feature
  • ios-design:tweak   → mevcut UI'da mikro değişiklik

Skill'imi güçlendirir:
  <one line per detected/missing companion per companion-plugins.md rules>

Şu an okudum: <list of project files inspected>
Bekliyorum: ne yapmak istiyorsun?
```

3. Create the flag: `touch <project>/.claude/state/ios-design-router-introduced.flag` (mkdir -p first)

If flag present: skip card, print one-line continuation: `🎨 ios-design router devam — bekliyorum: ...`

## Step 2: Inspect project state

Check in this order:

| Check | Signal | Implication |
|---|---|---|
| Is current dir a git repo with `.xcodeproj` or `Package.swift`? | iOS project exists | Likely `feature` or `tweak` |
| Does `.design/design-system.json` exist? | DNA already selected | `feature` or `tweak` ready |
| Does `.design/DESIGN_DNA.md` exist? | DNA philosophy documented | Same |
| Empty/non-iOS dir? | No project yet | `init` likely |
| User message includes "yeni proje", "new app", "scratch", "scaffold"? | Explicit init intent | `init` |
| User message includes "feature", "ekle", "ekran", "screen", "auth flow"? | Feature intent | `feature` |
| User message includes "değiştir", "tweak", "yumuşat", "spacing", "animation"? | Tweak intent | `tweak` |

## Step 3: Route

State results in a recommendation:

> "Mevcut durum: <X>. Önerim: `ios-design:<sub-skill>`. Doğru mu?"

If user confirms (or user's intent is unambiguous): invoke the sub-skill via the Skill tool.
If ambiguous: ask one disambiguating question.

## Boundaries

- Do not implement features yourself — always delegate to a sub-skill
- Do not modify files in this step (read-only inspection)
- Do not skip the capability card on first activation per session
```

- [ ] **Step 2: Validate frontmatter**

Run:
```bash
python3 -c "
import re, sys
with open('<plugin-root>/skills/ios-design/SKILL.md') as f:
    content = f.read()
m = re.match(r'---\n(.*?)\n---\n', content, re.DOTALL)
assert m, 'Missing frontmatter'
fm = m.group(1)
assert 'name: ios-design' in fm, 'Missing or wrong name'
assert 'description:' in fm, 'Missing description'
print('OK')
"
```
Expected: `OK`

- [ ] **Step 3: Commit**

```bash
cd <plugin-root>
git add skills/ios-design/SKILL.md
git commit -m "feat(skill): add ios-design router skill"
```

---

## Task 10: Init Skill (`ios-design:init`)

**Files:**
- Create: `<plugin-root>/skills/ios-design-init/SKILL.md`

- [ ] **Step 1: Write SKILL.md**

```markdown
---
name: ios-design-init
description: Scaffold a new iOS project with design-DNA-first workflow. Use when the user wants to start a new iOS app, new SwiftUI app, scaffold an iPhone app from scratch, or initialize a fresh project. Produces Xcode project + 3 interactive HTML design DNA prototypes + DNA selection + persistent design system.
---

# ios-design:init

Initialize a new iOS project. Your job: gather minimum context, recommend stack with rationale, generate 3 DNA prototypes, lock the chosen DNA into the project, scaffold the Xcode project, commit.

## Step 1: Capability card (first activation per session)

Check `<project>/.claude/state/ios-design-init-introduced.flag`. If absent, print:

```
🎨 ios-design:init aktif
─────────────────────────────────────
Ne yaparım:
  • Uygulaman için stack kararlarını araştırır + öneririm (min iOS, persistence, architecture, …)
  • 3 farklı design DNA'sı için interaktif HTML prototip üretirim
  • Seçtiğin DNA'yı .design/ klasörüne (json + md) kalıcı yazarım
  • Xcode projesini scaffold ederim
  • İlk commit'i atarım

Kullandığım superpowers:
  • brainstorming → ürün ve scope için (zaten brainstorm yapıldıysa skip)
  • writing-plans → multi-step scaffold için
  • verification-before-completion → ilk commit öncesi

Şu an okudum: <project state>
Bekliyorum: app fikrin ne, kim için?
```

Then `mkdir -p .claude/state && touch .claude/state/ios-design-init-introduced.flag`.

Subsequent activations: one-line continuation only.

## Step 2: Brainstorming gate

If `docs/superpowers/specs/` already contains a recent app spec, ask user: "Bu spec'i kullanayım mı, yoksa baştan brainstorm yapalım mı?"

Otherwise: invoke `superpowers:brainstorming` to clarify the app idea, target users, and scope.

## Step 3: Stack research-and-recommend

After brainstorming, research:
1. Comparable apps in the same category (web search)
2. Their typical min iOS targets, frameworks (context7 if SwiftUI/SwiftData questions)
3. Target audience's device base assumptions

Present recommendations in a single message:

```
Önerim:
• Min iOS: <26 default, lower if rationale demands>
  Çünkü: <1-2 sentences, evidence-backed>
• Bootstrap: <vanilla-xcode | tuist | xcodegen>
  Çünkü: <reason>
• Test framework: <swift-testing | xctest>
  Çünkü: <reason>
• Architecture: <mvvm-observable | tca>
  Çünkü: <reason>
• Persistence: <swiftdata | core-data>
  Çünkü: <reason>

Tüm öneriyi kabul ediyor musun? Tek tek değiştirebilirsin.
```

Persist user's decisions (and override reasons) for Step 6.

## Step 4: DNA recommendation

Based on the brainstormed idea, pick the best-fit DNA from `references/dna-prototypes.md` and explain why in 1-2 sentences:

> "Sezgim **<DNA name>** — çünkü <reason tied to app character>. Yine de üçünü de açıyorum karşılaştırasın."

## Step 5: Generate 3 prototypes

For each of the 3 DNAs (`liquid-native`, `editorial-crisp`, `playful-character`):

1. Take `prototypes/<dna-id>.html` from the plugin
2. Inject app-idea-specific realistic content into the `{{CONTENT}}` placeholder (replace the generic sample copy with copy that reflects the user's actual app idea — e.g., for a journaling app, use journal entry snippets)
3. Write the result to `<project>/.design/prototypes/<dna-id>.html`

If `playwright` MCP available: open all three via `browser_navigate file://...` (one tab each).
Otherwise: print three `file://` paths and ask the user to open them.

## Step 6: DNA selection

Ask user to choose:
- Accept the recommendation
- Pick a different DNA
- Request a hybrid (e.g., "Liquid Native but calmer motion")

If hybrid: derive a custom DNA from the chosen base by tweaking named parameters; assign new `dna_id` (e.g., `liquid-native-calm`).

## Step 7: Persist design system

Use `superpowers:writing-plans` to plan the multi-step scaffold (it's > 3 steps).

Then:

1. Copy `templates/design-system.template.json` → `<project>/.design/design-system.json`
2. Substitute placeholders with chosen DNA's tokens (from `references/dna-prototypes.md`) and stack decisions from Step 3
3. Copy `templates/DESIGN_DNA.template.md` → `<project>/.design/DESIGN_DNA.md`
4. Fill in the human-readable sections (Karakter, Motion Felsefesi, etc.) in the user's conversation language; populate Stack Decisions table from Step 3 with rationale

## Step 8: Scaffold Xcode project

Per the chosen bootstrap tool:
- **vanilla-xcode**: invoke `xcodebuild -create-xcframework` is NOT used; instead, instruct user to run `open -a Xcode` and create new project via Xcode UI with the agreed name + bundle ID + min deployment target. Provide the exact menu path. (Reason: there is no clean `xcodebuild` command to create a new project; this is by Apple's design.)
- **tuist**: run `tuist init --platform ios` and edit the generated `Project.swift` per stack decisions
- **xcodegen**: write `project.yml` per stack decisions, then run `xcodegen generate`

Generated project must include:
- The min iOS target from Stack Decisions
- An empty `Sources/` directory ready for feature work
- A reference to `.design/design-system.json` (read at app launch by future feature code)

## Step 9: Verification gate

Invoke `superpowers:verification-before-completion`. Confirm:
- `.design/design-system.json` parses as valid JSON
- `.design/DESIGN_DNA.md` exists and is non-empty
- `.design/prototypes/*.html` (3 files) exist
- Xcode project file (or `Project.swift` / `project.yml`) exists
- All paths absolute, no broken references

## Step 10: Initial commit

```bash
cd <project>
git init  # if not already initialized
git add .design/ <project-files>
git commit -m "chore: initialize iOS project with <DNA-name> design DNA"
```

## Boundaries

- Do not write Swift code in this skill (that's `feature` skill's job)
- Do not skip the brainstorming gate unless a recent spec exists
- Do not present DNA prototypes without 3 alternatives (recommendation does not foreclose)
```

- [ ] **Step 2: Validate frontmatter**

Run the same Python validation as Task 9 Step 2, with path adjusted.

- [ ] **Step 3: Commit**

```bash
cd <plugin-root>
git add skills/ios-design-init/SKILL.md
git commit -m "feat(skill): add ios-design-init skill (scaffold + DNA selection)"
```

---

## Task 11: Feature Skill (`ios-design:feature`)

**Files:**
- Create: `<plugin-root>/skills/ios-design-feature/SKILL.md`

- [ ] **Step 1: Write SKILL.md**

```markdown
---
name: ios-design-feature
description: Design and implement a single feature in an iOS project that has an established design DNA. Use when the user wants to add a new screen, new view, new flow, new feature, or new functionality to an existing iOS app initialized via ios-design:init. Produces a single HTML prototype in the approved DNA, gets user approval, then implements in SwiftUI per the design system tokens.
---

# ios-design:feature

Add a feature to an existing iOS project, conformant to its established DNA.

## Step 1: Capability card (first activation per session)

Check `<project>/.claude/state/ios-design-feature-introduced.flag`. If absent, print:

```
🎨 ios-design:feature aktif
─────────────────────────────────────
Ne yaparım:
  • Onaylanmış DNA içinde feature için interaktif HTML prototip üretirim
  • Kullanıcı onayı sonrası SwiftUI implementation yazarım (design-system.json'a uyumlu)
  • Motion-fidelity rules'u enforce ederim (CSS<>SwiftUI 1:1)

Kullandığım superpowers:
  • brainstorming → feature scope belirsizse
  • writing-plans → >3 adımlık feature için
  • test-driven-development → logic katmanı için (UI hariç)
  • simplify → her implementation sonrası KISS pass
  • verification-before-completion → "tamamlandı" demeden önce

Şu an okudum:
  ✓ .design/design-system.json (dna: <id>, v<version>)
  ✓ .design/DESIGN_DNA.md
Bekliyorum: feature ne, hangi ekran/akış?
```

Then create the flag.

## Step 2: Read DNA context

REQUIRED before any other action:
1. Read `<project>/.design/design-system.json` — fail with friendly error if missing ("init önce çalıştırılmalı")
2. Read `<project>/.design/DESIGN_DNA.md`
3. Hold both in context for all subsequent decisions

## Step 3: Scope check

If user's feature description is vague (e.g., "auth flow" without specifying screens): invoke `superpowers:brainstorming` to clarify scope.

If clear: proceed.

## Step 4: Generate single prototype

1. Use `templates/prototype-shell.html` as base
2. Inject design tokens from `design-system.json`
3. Build the feature's primary screen + key transitions per DNA's motion signature (from `motion` field in design-system.json)
4. Every motion declaration MUST have a sibling `<!-- swiftui: ... -->` comment per `references/motion-fidelity-rules.md`
5. Self-test: scan output against motion-fidelity-rules whitelist; revise if violations
6. Write to `<project>/.design/prototypes/feature-<feature-name>.html`
7. Open via playwright if available, otherwise print path

## Step 5: User approval gate

Ask:
> "Prototip hazır: <path>. <Brief description of motion behavior to look for>. Onaylıyor musun, yoksa tweak mı?"

If tweak: iterate on the prototype until approved.

## Step 6: Implementation planning

Estimate implementation step count. If > 3: invoke `superpowers:writing-plans` to produce a feature implementation plan.

## Step 7: TDD for non-UI logic

For each non-UI file (services, ViewModels, business rules, data layer):
1. Invoke `superpowers:test-driven-development`
2. Write failing test → minimal implementation → passing test → commit per its protocol

UI/View code is NOT TDD'd — SwiftUI views are implemented directly per the prototype.

## Step 8: SwiftUI implementation

For each view in the feature:
1. Read the corresponding section of the prototype HTML
2. Map every `<!-- swiftui: ... -->` comment to its SwiftUI primitive
3. Reference design-system.json tokens — NEVER hardcode magic numbers (colors, spacing, motion timings)
4. Use the architecture pattern from Stack Decisions (e.g., MVVM + Observable services)
5. For Liquid Glass primitives on iOS<26 targets: use `#available(iOS 26)` with the documented fallback

## Step 9: Simplify pass

Invoke `superpowers:simplify`. Apply suggested KISS reductions.

## Step 10: Verification gate

Invoke `superpowers:verification-before-completion`. Confirm:
- All tests pass (if logic layer was TDD'd)
- Project compiles
- Generated SwiftUI matches the prototype's visual structure
- No hardcoded magic numbers (search for raw color hexes, raw point values)
- All `<!-- swiftui: -->` comment annotations were honored

## Step 11: Commit

```bash
cd <project>
git add <feature-files> .design/prototypes/feature-<name>.html
git commit -m "feat: <feature-name>"
```

## Boundaries

- NEVER implement before showing the prototype
- NEVER skip motion-fidelity self-test
- NEVER hardcode tokens (always reference design-system.json values)
- NEVER deviate from DNA without explicit user permission
```

- [ ] **Step 2: Validate frontmatter** (same pattern as Task 9 Step 2)

- [ ] **Step 3: Commit**

```bash
cd <plugin-root>
git add skills/ios-design-feature/SKILL.md
git commit -m "feat(skill): add ios-design-feature skill (prototype + impl)"
```

---

## Task 12: Tweak Skill (`ios-design:tweak`)

**Files:**
- Create: `<plugin-root>/skills/ios-design-tweak/SKILL.md`

- [ ] **Step 1: Write SKILL.md**

```markdown
---
name: ios-design-tweak
description: Make a focused motion or visual change to an existing iOS app's UI. Use when the user wants to soften an animation, adjust spacing, change a color, modify a transition, or make a small visual tweak. Checks the change against the project's established design DNA and asks whether deviations should be one-time or DNA revisions.
---

# ios-design:tweak

Apply small, focused changes to existing UI. Not for new features (that's `ios-design:feature`).

## Step 1: Capability card (first activation per session)

Check `<project>/.claude/state/ios-design-tweak-introduced.flag`. If absent, print:

```
🎨 ios-design:tweak aktif
─────────────────────────────────────
Ne yaparım:
  • Mevcut UI'da motion/visual mikro değişiklikler
  • Değişikliği DNA'ya karşı kontrol ederim, sapma varsa sorarım

Kullandığım superpowers:
  • systematic-debugging → değişiklik bug kaynaklıysa
  • simplify → her değişiklik sonrası

Şu an okudum:
  ✓ .design/design-system.json (dna: <id>)
  ✓ .design/DESIGN_DNA.md
Bekliyorum: ne değişsin?
```

Then create the flag.

## Step 2: Read DNA context

Same as feature skill — read both `.design/` files; fail if missing.

## Step 3: Locate the target

Identify which file(s) the tweak affects:
- If `serena` MCP available: use `find_symbol` / `find_referencing_symbols`
- Otherwise: grep for the relevant view/component name

## Step 4: Diff against DNA

Compare the requested change to DNA's defaults:
- New value matches DNA token? → straightforward apply
- New value deviates from DNA? → flag

## Step 5: If bug-driven, debug first

If the user describes the tweak as fixing unwanted behavior (e.g., "this animation is jittery"): invoke `superpowers:systematic-debugging` to root-cause before changing.

## Step 6: Confirm and apply

For straightforward changes:
> "Şunu değiştireceğim: <file>:<line> — <old> → <new>. Onay?"

For DNA deviations:
> "Bu DNA dışı bir tercih. Tek seferlik mi, yoksa DNA'yı (<token>) revize edeyim mi?"

If DNA revision: bump version in `design-system.json` (1.0.0 → 1.1.0), update both files, append to `DESIGN_DNA.md` Override log.

## Step 7: Simplify pass

Invoke `superpowers:simplify`.

## Step 8: Commit

```bash
cd <project>
git add <changed-files> [.design/ if DNA was revised]
git commit -m "style: <description of tweak>"
```

## Boundaries

- NEVER add new components or features (that's feature skill)
- NEVER silently let DNA deviations through — always ask
- NEVER skip the simplify pass even on tiny changes
```

- [ ] **Step 2: Validate frontmatter** (same pattern)

- [ ] **Step 3: Commit**

```bash
cd <plugin-root>
git add skills/ios-design-tweak/SKILL.md
git commit -m "feat(skill): add ios-design-tweak skill (focused edits + DNA check)"
```

---

## Task 13: Manual Test Scenarios

**Files:**
- Create: `<plugin-root>/tests/manual-scenarios.md`

- [ ] **Step 1: Write manual-scenarios.md**

```markdown
# Manual Test Scenarios — ios-design v0.1.0

Until automated skill testing matures, these scenarios are run manually before each release. Each scenario describes setup, action, and expected behavior.

## Scenario 1: Skill discoverability

**Setup:** Plugin installed, fresh Claude Code session in empty directory.

**Action:** Type "I want to build an iOS app".

**Expected:**
- `ios-design` router activates (visible in tool call)
- Capability card prints (Turkish or English depending on language detection)
- Companion plugin section accurately reports installed/missing
- Skill asks for app idea

## Scenario 2: Capability card suppression on second activation

**Setup:** After Scenario 1, ios-design router has activated once.

**Action:** Type "Remind me about the iOS app idea".

**Expected:**
- Router activates again
- Capability card does NOT print
- Single-line continuation prints instead

**Verification:**
```bash
ls .claude/state/ | grep ios-design-router-introduced.flag
# expected: file present
```

## Scenario 3: Companion detection accuracy

**Setup:** Run twice — once with all companions installed, once with only superpowers.

**Action:** Activate router.

**Expected:**
- All-installed: capability card shows ✓ for each
- Only superpowers: shows ⚠️ for context7 (essential), 💡 for playwright/serena, suppresses optional

## Scenario 4: Init flow happy path

**Setup:** Empty project directory, ios-design installed.

**Action:** Invoke `ios-design:init` with idea "a daily journal app for solo writers".

**Expected:**
- Capability card prints
- `superpowers:brainstorming` invoked (or skip if spec exists)
- Stack recommendations presented with rationale
- 3 prototype files generated in `.design/prototypes/`
- Recommendation given (likely Liquid Native for journal app)
- After user picks: `.design/design-system.json` and `.design/DESIGN_DNA.md` created and consistent
- Initial commit created

**Verification:**
```bash
test -f .design/design-system.json && python3 -c "import json; json.load(open('.design/design-system.json'))"
test -f .design/DESIGN_DNA.md
ls .design/prototypes/ | wc -l  # expected: 3
git log --oneline | head -1  # expected: initial commit
```

## Scenario 5: Persistence integrity

**Setup:** Project initialized via Scenario 4.

**Action:** Manually edit `.design/DESIGN_DNA.md` to change a Stack Decisions row, then invoke `ios-design:feature`.

**Expected:**
- Feature skill detects the inconsistency between json and md
- Prompts user: "Hangisi doğru?"
- After user picks, syncs both files

## Scenario 6: Motion fidelity self-test

**Setup:** Test directory.

**Action:** Inject a forbidden CSS rule (`transform: skew(10deg)`) into `prototypes/liquid-native.html` temporarily, then run feature skill which would generate from this template.

**Expected:**
- Self-test catches the violation
- Skill revises the prototype before showing
- The skew is removed in the user-facing output

(After test: `git checkout` the prototype file to restore.)

## Scenario 7: Feature skill — full path

**Setup:** Project initialized.

**Action:** "Add a sign-in screen with email + password and a forgot-password link".

**Expected:**
- Feature skill activates, capability card shown
- DNA context read
- Single prototype generated (in chosen DNA), opened in browser if playwright present
- After approval: `superpowers:writing-plans` invoked (>3 steps)
- Logic layer (auth service) implemented via TDD
- Views implemented per prototype's `<!-- swiftui: -->` comments
- `superpowers:simplify` invoked
- `superpowers:verification-before-completion` invoked
- Commit created with feature files

## Scenario 8: Tweak — DNA-aligned

**Action:** "Soften the card press animation slightly".

**Expected:**
- Tweak skill activates
- Locates affected view
- Proposes a new spring value still within DNA's character
- Applies after confirmation
- `superpowers:simplify` invoked
- Single commit

## Scenario 9: Tweak — DNA deviation

**Action:** "Make the card press use linear easing".

**Expected:**
- Tweak skill flags DNA deviation (DNA prefers spring)
- Asks: "Tek seferlik mi yoksa DNA'yı revize edeyim mi?"
- If DNA revision: version bump, both files updated, override log appended
- Commit includes `.design/` if revised

## Scenario 10: Missing essentials graceful degradation

**Setup:** Uninstall context7 MCP.

**Action:** Run init flow.

**Expected:**
- Capability card warns context7 missing
- Stack research falls back to WebSearch
- Stale-info warning printed
- Flow still completes
```

- [ ] **Step 2: Commit**

```bash
cd <plugin-root>
git add tests/manual-scenarios.md
git commit -m "test: add 10 manual scenario tests for v0.1.0 release validation"
```

---

## Task 14: README Finalize

**Files:**
- Modify: `<plugin-root>/README.md`

- [ ] **Step 1: Replace skeleton with full README**

Write the complete contents (replacing what was created in Task 1 Step 4):

```markdown
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

## Source

- Design spec: `docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md`
- Implementation plan: `docs/superpowers/plans/2026-04-20-ios-design-plugin.md`

## License

(Pick before publishing — MIT or Apache-2 candidates.)
```

- [ ] **Step 2: Commit**

```bash
cd <plugin-root>
git add README.md
git commit -m "docs: finalize v0.1.0 README"
```

---

## Task 15: Validation Pass

Run end-to-end validation using available tooling.

- [ ] **Step 1: Plugin manifest validation**

If `plugin-dev:plugin-validator` skill available: invoke it on the project root.
If not: manual validation:
```bash
cd <plugin-root>
python3 -c "
import json, os, sys
m = json.load(open('plugin.json'))
required = ['name', 'version', 'description', 'skills']
for k in required:
    assert k in m, f'Missing {k}'
for skill_dir in m['skills']:
    skill_md = f'{skill_dir}/SKILL.md'
    assert os.path.exists(skill_md), f'Missing {skill_md}'
for hook in m.get('hooks', []):
    cmd = hook['command'].replace('\${CLAUDE_PLUGIN_ROOT}', '.')
    assert os.path.exists(cmd), f'Missing hook script: {cmd}'
print('Manifest OK')
"
```
Expected: `Manifest OK`

- [ ] **Step 2: Skill frontmatter validation (all 4)**

```bash
cd <plugin-root>
for skill_md in skills/*/SKILL.md; do
  python3 -c "
import re, sys
with open('$skill_md') as f:
    content = f.read()
m = re.match(r'---\n(.*?)\n---\n', content, re.DOTALL)
assert m, 'Missing frontmatter in $skill_md'
fm = m.group(1)
assert 'name:' in fm and 'description:' in fm, 'Missing required field in $skill_md'
print('OK: $skill_md')
"
done
```
Expected: 4 lines of `OK: ...`

- [ ] **Step 3: All references / templates / prototypes exist**

```bash
cd <plugin-root>
test -f references/companion-plugins.md
test -f references/motion-fidelity-rules.md
test -f references/dna-prototypes.md
test -f references/superpowers-composition.md
test -f templates/design-system.template.json
test -f templates/DESIGN_DNA.template.md
test -f templates/prototype-shell.html
test -f prototypes/liquid-native.html
test -f prototypes/editorial-crisp.html
test -f prototypes/playful-character.html
test -x hooks/session-start.sh
test -f tests/manual-scenarios.md
echo "All artifacts present"
```
Expected: `All artifacts present`

- [ ] **Step 4: Motion fidelity audit on shipped prototypes**

For each of `prototypes/*.html`:
1. Open the file
2. List every `transition:`, `animation:`, `transform:`, `backdrop-filter:` line
3. For each, verify a sibling `<!-- swiftui: ... -->` comment exists
4. Verify each named SwiftUI primitive appears in `references/motion-fidelity-rules.md` whitelist
5. Confirm zero forbidden CSS

If any violation: fix, re-test, re-commit.

- [ ] **Step 5: Run a manual scenario**

Pick Scenario 1 (Skill discoverability) from `tests/manual-scenarios.md` and execute it in a fresh Claude Code session. Confirm the capability card prints with correct content.

- [ ] **Step 6: Tag the release**

```bash
cd <plugin-root>
git tag -a v0.1.0 -m "ios-design plugin v0.1.0 — initial release"
```

- [ ] **Step 7: Final summary commit (if any cleanup)**

If validation surfaced any fixes:
```bash
git add <fixed-files>
git commit -m "fix: address v0.1.0 validation findings"
git tag -d v0.1.0 && git tag -a v0.1.0 -m "ios-design plugin v0.1.0 — initial release"
```

---

## Self-Review Notes

This plan was checked against the spec sections:

| Spec section | Covered by |
|---|---|
| §2 Scope (in/out) | Tasks 1-15 cover in-scope; out-of-scope acknowledged in §12 of spec, README §Future versions |
| §3.2 Skill family | Tasks 9, 10, 11, 12 |
| §3.3 Directory layout | Task 1 + each subsequent task creates its slice |
| §4.1 Capability card | Each skill task includes the card text in user's language |
| §4.2 Research-and-recommend | Task 10 Step 3 (init stack research) |
| §4.3 Companion awareness | Task 2 (catalog) + Task 9 (router uses it) |
| §5 Design DNA system | Task 4 (catalog) + Task 6 (templates) + Task 7 (default prototypes) + Task 10 (selection flow) |
| §6 HTML preview engineering | Task 3 (rules) + Task 6 (shell) + Task 7 (default prototypes self-tested) + Task 11 (feature uses it) |
| §7 Superpowers composition | Task 5 (map) + Tasks 10-12 (skills delegate per the map) |
| §8 Default stack | Task 4 (per-DNA defaults) + Task 10 (research-and-recommend output) |
| §9 Testing | Task 13 (manual scenarios) + Task 15 (validation pass) |
| §10 Error handling | Distributed across skill SKILL.md files (e.g., feature skill fails friendly when DNA missing) |
| §11 Manifest sketch | Task 1 Step 2 |
| §13 Open implementation questions | Decisions made: state location `<project>/.claude/state/`, prototype shipping shipped pre-rendered (Task 7), license deferred to publishing time (README §License) |

**Type/name consistency check:** Skill IDs (`ios-design`, `ios-design-init`, `ios-design-feature`, `ios-design-tweak`), file paths under `.design/`, design-system.json field names — all consistent across tasks.

**Placeholder scan:** No "TBD" / "implement later" / "similar to Task N" patterns. Schema-sketch `<DNA_ID>` placeholders in Task 6 templates are intentional (template substitution markers), not unfilled spec ambiguity.
