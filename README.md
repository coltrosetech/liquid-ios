# 🌊 liquid-ios

> **Motion-validated SwiftUI for Claude Code.** Three design DNAs, locked-in via interactive HTML prototypes, then materialized as production SwiftUI — without losing the motion you approved.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE) [![Version](https://img.shields.io/badge/version-v0.1.1-green.svg)](CHANGELOG.md) [![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)](#) [![Made for](https://img.shields.io/badge/made%20for-Claude%20Code-orange.svg)](https://claude.com/claude-code)

---

<p align="center">
  <img src="docs/screenshots/sprout-playful-character.png" width="280" alt="Sprout — Playful Character DNA">
  &nbsp;
  <img src="docs/screenshots/breathe-liquid-native.png" width="280" alt="Breathe — Liquid Native DNA">
  &nbsp;
  <img src="docs/screenshots/editorial-crisp-todo.png" width="280" alt="Todo — Editorial Crisp DNA">
</p>

<p align="center">
  <em>The same plugin. Three different apps. Three different design DNAs — chosen, not guessed.</em>
</p>

---

## 🤔 Why this plugin exists

Most "build an iOS app with AI" tools generate **technically-correct, visually-generic SwiftUI**. Buttons exist. Lists scroll. Colors are vaguely on-brand. Motion is... whatever the model felt like.

**The hard part isn't the code. It's the design intentionality.** Smooth motion, novel interactions, a coherent visual language — these don't happen accidentally. They require:

1. A **chosen design language** (what character does this app have?)
2. **Validation before commitment** (does the motion feel right, before we lock it in?)
3. **Disciplined enforcement** (every new screen stays on-DNA — no drift)

`liquid-ios` is a Claude Code plugin that enforces all three. You start a project; the plugin researches your category, recommends a stack and a design DNA, generates **three interactive HTML prototypes** for you to feel the motion in a real browser, and then writes SwiftUI conformant to your approved DNA — every animation primitive in the prototype maps 1:1 to a SwiftUI counterpart it knows how to reproduce faithfully.

---

## ✨ What you get

### Four skills, one workflow

| Skill | Use when… | Produces |
|---|---|---|
| `ios-design` *(router)* | You're not sure where to start | Inspects state, prints a capability card, dispatches to the right sub-skill |
| `ios-design:init` | Starting a new iOS app from scratch | 3 interactive HTML prototypes → your DNA → Xcode scaffold + initial commit |
| `ios-design:feature` | Adding a screen / view / flow | Single prototype in your DNA → SwiftUI implementation |
| `ios-design:tweak` | Adjusting motion / spacing / a color | Targeted edit + DNA-conformance check |

### Three behaviors that set this apart

1. **Self-introducing capability cards** — every skill announces *what it does* and *what supercharges it* on first activation. No more guessing what just got triggered.
2. **Research-and-recommend over A/B/C config** — the skill researches your app category and recommends decisions (min iOS, persistence, architecture, DNA) with rationale. You accept, override, or ask for alternatives. No bare multiple-choice questions.
3. **Companion plugin awareness** — detects missing helpful plugins/MCPs (`superpowers`, `context7`, `playwright`, `serena`) and explains the value loss without blocking execution.

---

## 🎬 See it in action — three apps, one plugin

### Scenario 1 — Productivity tool → Editorial Crisp

**The prompt:**
> "Yeni bir iOS app yapmak istiyorum: basic bir todo app. Hızlı task yönetimi."

**What the plugin did:**
- Researched the productivity category → recommended **iOS 17** (mass-market) + **Editorial Crisp** DNA (sharp ease, monospace timestamps, minimal ornament — Linear/Notion aesthetic).
- Generated 3 prototypes; user approved Editorial Crisp.
- Scaffolded `Sources/` with `TodoTask` model, `TodoListService` (`@Observable @MainActor`), `TodayView` with `List` + checkboxes + 200ms easeInOut toggle.

<p align="center">
  <img src="docs/screenshots/editorial-crisp-todo.png" width="320" alt="Todo today screen — Editorial Crisp">
  <img src="docs/screenshots/editorial-crisp-after-toggle.png" width="320" alt="After toggling a task">
</p>

**Key takeaway:** No magic numbers in the SwiftUI. Every color, spacing value, and animation timing references the locked design system.

---

### Scenario 2 — Meditation app → Liquid Native

**The prompt:**
> "Breathe — günde 5 dakikalık nefes egzersizleri rehberi. Premium meditation kategorisi."

**What the plugin did:**
- Researched meditation/wellness → recommended **iOS 26** (Liquid Glass benefit clear for premium) + **Liquid Native** DNA (depth, glassmorphism, slow spring transitions).
- Generated 3 prototypes — Liquid Native an obvious fit for the calm/premium feel.
- Scaffolded `BreathSession` SwiftData model, `SessionLog`, `TodayView` with `phaseAnimator`-driven breathing orb wrapped in `.glassEffect()` (with `.ultraThinMaterial` fallback for iOS<26).

<p align="center">
  <img src="docs/screenshots/breathe-liquid-native.png" width="280" alt="Breathe — Liquid Native">
  <img src="docs/screenshots/breathe-editorial-crisp.png" width="280" alt="Breathe — Editorial Crisp">
  <img src="docs/screenshots/breathe-playful-character.png" width="280" alt="Breathe — Playful Character">
</p>

**Key takeaway:** Same app idea, three DNAs — three completely different feels. Liquid Native won because clinical (Editorial) feels wrong for meditation, and bouncy (Playful) feels wrong for calm. The plugin's recommendation matched the category instinct.

---

### Scenario 3 — Lifestyle app with character → Playful Character

**The prompt:**
> "Sprout — ev bitkileri sulama hatırlatıcısı. Plant parents için karakterli bir app."

**What the plugin did:**
- Researched plant care apps → recommended **iOS 17** (mass-market) + **Playful Character** DNA (overshoot, warm gradients, character emoji wiggle).
- Scaffolded `Plant` model with thirst calculation, `Garden` observable service, `GardenView` with `THIRSTY/HAPPY` sections + animated thirst bars + bounce on water tap, `AddPlantSheet` with emoji picker grid, `PlantDetailView` with watering history `Charts`.

<p align="center">
  <img src="docs/screenshots/sprout-playful-character.png" width="320" alt="Sprout main screen">
  <img src="docs/screenshots/sprout-feature-plant-detail.png" width="320" alt="Plant detail screen">
</p>

**Key takeaway:** A real app surface — multiple screens, navigation, gamification (drop counter), data flow — produced from prototype-first workflow with **zero generic AI feel**.

---

## 🚀 Quick start

```bash
# Clone
git clone https://github.com/coltrosetech/liquid-ios.git
cd liquid-ios

# Install via local symlink (Claude Code discovers plugins in ~/.claude/plugins/)
mkdir -p ~/.claude/plugins/local
ln -snf "$(pwd)" ~/.claude/plugins/local/liquid-ios

# Restart Claude Code (Cmd+Q, relaunch)
```

In a fresh Claude Code session in any empty directory:

```
You: Yeni bir iOS app yapmak istiyorum: <your idea>
```

The router activates, prints its capability card, recommends a stack and DNA, and walks you through the rest.

> Full install paths (marketplace, GitHub, etc.) → see [`INSTALL.md`](INSTALL.md).
> Detailed prompting guide → see [`USAGE.md`](USAGE.md).

---

## 🧭 How it works (workflow snapshot)

```
Day 1
  You:    "Yeni iOS app: <idea>"
  Plugin: → ios-design:init activates
          → Capability card prints
          → Stack research + recommendation (with rationale)
          → 3 DNA prototypes opened in browser via local HTTP server
          → You pick one (or a hybrid)
          → .design/design-system.json + DESIGN_DNA.md persisted
          → Xcode scaffold + initial commit

Day 1 (later)
  You:    "Today screen'e <feature> ekle"
  Plugin: → ios-design:feature activates
          → DNA context auto-loaded
          → Single prototype rendered in your DNA
          → You approve
          → SwiftUI generated (motion mapped 1:1 from prototype)
          → simplify pass → verification gate → commit

Day 2
  You:    "<X> animasyonu daha yumuşak"
  Plugin: → ios-design:tweak activates
          → Diffs your request against DNA
          → If DNA-deviating: asks "tek seferlik mi, DNA revize mi?"
          → Applies + commits
```

---

## 🎨 The DNA catalog (3 opinionated defaults)

| DNA | Character | Motion signature | Typical fit |
|---|---|---|---|
| **Liquid Native** | Apple HIG + iOS 26 Liquid Glass — depth, gloss, layered transitions | `spring(response: 0.5, damping: 0.8)`, matchedGeometryEffect-heavy | Premium consumer, content-heavy, Apple ecosystem (journal, reader, meditation) |
| **Editorial Crisp** | Linear/Notion aesthetic — sharp lines, sharp ease, monospace accents | `easeInOut` 200ms, short transitions, no distraction | Productivity, tools, B2B, dev-facing apps |
| **Playful Character** | Arc/Duolingo energy — overshoot, bounce, color bursts, micro-celebrations | `spring(response: 0.4, damping: 0.6)`, TimelineView, haptic-rich | Consumer entertainment, gamified, social, lifestyle |

Custom DNAs are derived from a base preset by parameter tweak with a new `dna_id` (e.g., "Liquid Native but calmer motion" → `liquid-native-calm`).

---

## ⚙️ Default stack (research-and-recommend output)

The init flow recommends these as defaults; you accept all, accept some, or override:

| Decision | Default | When it changes |
|---|---|---|
| Min iOS | 26 | Lowered to 17 if your app needs broad device reach (mass-market) |
| Bootstrap | Vanilla Xcode (solo) / Tuist (team) | Module count + team size driven |
| Test framework | Swift Testing (iOS 18+) | Falls back to XCTest if min iOS < 18 |
| Concurrency | Swift 6 strict | Locked |
| State | `@Observable` + `@MainActor` | Locked (iOS 17+ standard) |
| Persistence | SwiftData | Falls back to Core Data only if min iOS < 17 |
| Architecture | MVVM + Observable services | TCA recommended for multi-team |
| DI | Manual constructor injection | YAGNI — framework only if proven needed |
| Navigation | NavigationStack + path binding | iOS 16+ standard |

All chosen values are persisted to `.design/DESIGN_DNA.md#Stack Decisions` with rationale per item.

---

## 🔗 Composition with `superpowers`

`liquid-ios` doesn't reimplement planning, simplification, or verification — it **delegates** to [`superpowers`](https://github.com/anthropic-experimental/superpowers) at well-defined gateway points:

| ios-design skill | Gateway | Invoked superpowers skill |
|---|---|---|
| `init` | After capability card | `brainstorming` (skipped if a recent spec exists) |
| `init` | After DNA selection | `writing-plans` |
| `init` | Before initial commit | `verification-before-completion` |
| `feature` | Before prototype design | `brainstorming` (only if scope unclear) |
| `feature` | After prototype approval | `writing-plans` (when > 3 implementation steps) |
| `feature` | During implementation (logic only) | `test-driven-development` |
| `feature` | After implementation | `simplify` |
| `feature` | Before commit | `verification-before-completion` |
| `tweak` | Before applying change | `systematic-debugging` (if change is bug-driven) |
| `tweak` | After applying change | `simplify` |

If `superpowers` is not installed, gateways are skipped silently with a warning. **Quality drops noticeably** — install superpowers.

---

## 🧰 Companion plugins / MCPs

Recommended for full power. The plugin gracefully degrades when any are missing:

| Plugin / MCP | Criticality | Loss if missing |
|---|---|---|
| [`superpowers`](https://github.com/anthropic-experimental/superpowers) | **Essential** | Composition gateways skipped → lower-quality plans, no KISS pass, no verification |
| `context7` (MCP) | **Essential** | Apple docs frozen at training cutoff |
| `playwright` (MCP) | Recommended | Prototypes open via `file://` paths you click manually |
| `serena` (MCP) | Recommended | Tweak skill falls back to full file reads instead of semantic navigation |
| `claude-md-management` | Optional | CLAUDE.md upkeep is manual |
| `frontend-design` | Optional | Prototypes may look slightly more "AI-generic" |

---

## 🛣️ Roadmap

- [x] **v0.1.0** — Initial release: 4 skills, 3 DNAs, design system persistence, motion fidelity rules
- [x] **v0.1.1** — Local HTTP server scripts (unblocks playwright `file://` limitation)
- [ ] **v0.2** — `ios-design:audit` — DNA drift detection on existing code
- [ ] **v0.3** — `ios-design:storekit` — IAP / subscription flows with DNA-conformant paywall design
- [ ] **v0.4** — `ios-design:push` — push notification UI patterns + permission flows
- [ ] **v0.5** — `ios-design:appstore` — App Store Connect integration, screenshot generation per DNA, submission checklist
- [ ] **v1.0** — `ios-design:backend-integration` — networking patterns, auth, error/loading state DNA enforcement

See [`CHANGELOG.md`](CHANGELOG.md) for detailed version history.

---

## 📚 Documentation

| Document | What it covers |
|---|---|
| [`USAGE.md`](USAGE.md) | Prompting guide — which words trigger which skill, good/bad prompt examples, common pitfalls |
| [`INSTALL.md`](INSTALL.md) | Install paths (local symlink, marketplace, GitHub) + smoke test |
| [`CHANGELOG.md`](CHANGELOG.md) | Version history with rationale per release |
| [`docs/superpowers/specs/`](docs/superpowers/specs/) | Original design specification (deep dive on every architectural decision) |
| [`docs/superpowers/plans/`](docs/superpowers/plans/) | Implementation plan (15 tasks, executed via subagent-driven development) |
| [`tests/manual-scenarios.md`](tests/manual-scenarios.md) | 10 manual release-validation scenarios |

---

## 🛠️ Repo structure

```
liquid-ios/
├── plugin.json              # Manifest
├── README.md / USAGE.md / INSTALL.md / CHANGELOG.md / LICENSE
├── skills/                  # The 4 skills (router, init, feature, tweak)
│   ├── ios-design/SKILL.md
│   ├── ios-design-init/SKILL.md
│   ├── ios-design-feature/SKILL.md
│   └── ios-design-tweak/SKILL.md
├── references/              # Progressive-disclosure knowledge base
│   ├── motion-fidelity-rules.md   # CSS↔SwiftUI whitelist (the bedrock)
│   ├── dna-prototypes.md           # 3 default DNAs + token defaults
│   ├── superpowers-composition.md  # Per-skill gateway map
│   └── companion-plugins.md        # Detection rules + criticality
├── templates/               # Skeletons substituted at runtime
│   ├── design-system.template.json
│   ├── DESIGN_DNA.template.md
│   └── prototype-shell.html
├── prototypes/              # Default DNA prototype HTML (motion-fidelity-validated)
│   ├── liquid-native.html
│   ├── editorial-crisp.html
│   └── playful-character.html
├── scripts/                 # Local HTTP server for playwright
│   ├── serve-prototypes.sh
│   └── stop-prototype-server.sh
├── hooks/                   # Lifecycle hooks
│   └── session-start.sh     # Resets capability-card flags per session
├── tests/                   # Manual release-validation scenarios
│   └── manual-scenarios.md
└── docs/
    ├── screenshots/         # Visual proof (3 apps × 3 DNAs)
    └── superpowers/         # Spec + implementation plan
```

> **Naming note:** the GitHub repo is named `liquid-ios` for branding. The plugin's manifest name (`ios-design`) and skill IDs (`ios-design:init`, `ios-design:feature`, etc.) reflect the technical purpose. They're intentionally distinct.

---

## 🙏 Acknowledgments

- Built end-to-end via Claude Code with the `superpowers` plugin (brainstorming → writing-plans → subagent-driven-development → verification → finishing-a-development-branch).
- Inspired by the existing iOS skill ecosystem ([`avdlee/swiftui-agent-skill`](https://github.com/AvdLee/SwiftUI-Agent-Skill), [`twostraws/swift-agent-skills`](https://github.com/twostraws/swift-agent-skills), [`dpearson2699/swift-ios-skills`](https://github.com/dpearson2699/swift-ios-skills)) — `liquid-ios` complements these knowledge skills with a workflow-first, design-DNA-locked approach.

---

## 📜 License

MIT — see [`LICENSE`](LICENSE).

---

<p align="center">
  <em>Built with intention. Generated with discipline. Shipped with motion that survives the trip from prototype to production.</em>
</p>
