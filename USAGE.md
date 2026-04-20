# Using `ios-design`: A Prompting Guide

This plugin is **trigger-driven**. You don't invoke it explicitly — Claude reads your message, matches it to one of the four skill descriptions, and the right skill activates. That means **the way you phrase your request determines the result.**

This guide shows what triggers what, what each skill needs from you, and how to get the most out of the plugin in the fewest turns.

---

## TL;DR — Three good first messages

For 90% of starts, one of these is what you want:

| Goal | Message |
|---|---|
| Start a new iOS app | `"Yeni bir iOS app yapmak istiyorum: <2-3 sentence idea>. Hedef kitle <X>."` |
| Add a feature to an existing app | `"<Project>'a <feature> ekleyelim. <1 sentence about what it does>."` |
| Adjust a small visual/motion detail | `"<Component>'in <X> davranışı çok <too-Y>, biraz daha <less-Y> yap."` |

That's it. The plugin handles the rest — research, DNA selection, motion fidelity, SwiftUI generation, simplify pass, verification.

---

## How the plugin reads your message

When you start a session in a project where this plugin is installed, Claude inspects:

1. **Current directory state** — empty? `.xcodeproj` exists? `.design/` folder exists?
2. **Your message keywords** — "yeni proje" / "feature ekle" / "tweak"

It then routes to one of:

- **`ios-design`** (router) — generic intent, decides which sub-skill
- **`ios-design:init`** — new project from scratch
- **`ios-design:feature`** — add a screen/flow to existing app
- **`ios-design:tweak`** — small visual/motion adjustment

You **don't need to name the skill** — the trigger words do it. Below: which words trigger which skill.

---

## The 4 skills — when each activates

### `ios-design` (router)

**Use when:** You're not sure where to start, or want the plugin to figure out state for you.

**Trigger phrases:**
- "iOS app yapacağım"
- "SwiftUI app üzerinde çalışıyorum"
- "iPhone app design help"

**What happens:** Router prints capability card, scans the project, asks one disambiguating question, routes you to the right sub-skill.

**Skip the router by being specific** — see the three sub-skills below.

---

### `ios-design:init`

**Use when:** You're starting a new iOS app from scratch.

**Trigger phrases (Turkish or English work):**
- "Yeni bir iOS app yapmak istiyorum…"
- "Sıfırdan bir SwiftUI app scaffold edelim"
- "New iPhone app, idea is…"
- "iOS proje başlatmak istiyorum"

**What you should include in the prompt:**
- **App idea (1-3 sentences)** — what is it, who is it for
- **(Optional) Constraints** — "iOS 17 destek lazım", "tek developer, küçük takım yok"

**What the skill does (so you don't have to ask):**
1. Asks 1-2 minimum-context questions if the idea is vague
2. **Researches the category** (web + context7) and **recommends a stack** with rationale (min iOS, persistence, architecture, test framework, DI) — you accept all / accept some / override
3. **Recommends one DNA** (Liquid Native / Editorial Crisp / Playful Character) with reasoning, but **shows all three as interactive HTML prototypes**
4. You pick a DNA (or a hybrid)
5. Persists `.design/design-system.json` + `.design/DESIGN_DNA.md`
6. Scaffolds the Xcode project (or instructs you on Xcode UI steps for the bootstrap tool selected)
7. Initial commit

**Things you do NOT need to say:**
- "Use SwiftUI" → assumed
- "Use @Observable" → assumed (modern Apple direction)
- "Set up SwiftData" → assumed for iOS 17+ idea
- "Pick a design style for me" → it does, with options
- "Make it look nice" → that's literally the plugin's job

**Good init prompt example:**
> "Yeni bir iOS app yapmak istiyorum: 'Hydra' — günlük su tüketimi takip uygulaması. Hedef kitle 25-40 yaş aralığı, sağlığını önemseyen kişiler. Streak/motivation öğeleri olabilir."

The plugin will: research wellness apps → recommend Playful Character DNA + iOS 17 (mass-market) → generate prototypes → scaffold.

**Bad init prompt example:**
> "Bana iOS app yap"

Too vague — the skill will spend turns asking what kind of app, who for, etc. You're paying for those turns.

---

### `ios-design:feature`

**Use when:** You have an existing iOS app (initialized via `ios-design:init`) and want to add a screen, view, flow, or piece of functionality.

**Trigger phrases:**
- "Şu feature'ı ekleyelim: <X>"
- "Yeni bir ekran lazım — <X>"
- "Auth flow ekleyelim"
- "Add a sign-in screen"
- "New view for <X>"

**What you should include in the prompt:**
- **Feature description (1-2 sentences)** — what does it do
- **(Optional) Where it fits** — "settings içinde" / "tab bar'a yeni sekme"

**What the skill does:**
1. Reads `.design/design-system.json` + `.design/DESIGN_DNA.md` automatically — knows your DNA
2. Asks for clarification only if scope is genuinely ambiguous
3. Generates a **single HTML prototype** in your DNA, opens in browser via local HTTP server
4. You approve / iterate
5. (For >3-step features) Invokes `superpowers:writing-plans` to plan the implementation
6. Generates SwiftUI code that maps **1:1** to the prototype's `<!-- swiftui: ... -->` annotations — no hardcoded magic numbers
7. For non-UI logic: invokes `superpowers:test-driven-development`
8. Runs `superpowers:simplify` for KISS pass
9. Runs `superpowers:verification-before-completion` before declaring done
10. Commit

**Things you do NOT need to say:**
- "Match the existing design" → DNA is read automatically
- "Use the design tokens" → enforced by the skill
- "Test it" → TDD invoked for logic; verification gate for UI
- "Make it animate smoothly" → motion fidelity rules are bedrock

**Good feature prompt example:**
> "Today screen'e bir 'add new task' butonu + sheet ekleyelim. Sheet'te task title, optional due time ve optional tag girilebilsin."

**Bad feature prompt example:**
> "Bir şey daha ekle"

---

### `ios-design:tweak`

**Use when:** You want a small, focused change to existing UI — animation timing, spacing, color, easing.

**Trigger phrases:**
- "<X> animasyonu çok hızlı/yavaş, <Y> yapalım"
- "Spacing biraz sıkışık, biraz açalım"
- "Bu rengi biraz daha sönük yap"
- "Soften the press animation"

**What the skill does:**
1. Reads DNA context
2. Locates the affected file(s) — uses `serena` MCP if available, otherwise grep
3. **Diffs your request against DNA** — is this a one-time exception or a DNA-level shift?
4. If DNA deviation: asks "tek seferlik mi, DNA revize mi?" — if you pick revise, version-bumps and updates both `.design/` files atomically
5. Applies the change
6. Runs simplify pass
7. Commit

**Good tweak prompt examples:**
> "Card press animation 200ms biraz keskin, 350ms yapalım app genelinde."
> "FAB shadow rengi biraz fazla doygun, biraz daha sakin tonlar."

---

## Composition with `superpowers`

This plugin **delegates** all generic process work to `superpowers`:

| What you might say | What the plugin invokes (you don't have to ask) |
|---|---|
| "düşünelim önce" / "henüz net değil" | `superpowers:brainstorming` |
| (multi-step feature) | `superpowers:writing-plans` |
| (logic implementation) | `superpowers:test-driven-development` |
| (after every implementation) | `superpowers:simplify` |
| (before every "tamamlandı") | `superpowers:verification-before-completion` |
| (debug-driven tweak) | `superpowers:systematic-debugging` |

If `superpowers` isn't installed, the gateways are skipped silently with a warning. **Quality drops noticeably** without superpowers — install it.

---

## What to install for full power

In your Claude Code marketplace:

| Plugin/MCP | Effect if missing |
|---|---|
| **superpowers** | Composition gateways skipped → lower-quality plans, no KISS pass, no verification |
| **context7** MCP | Apple docs frozen at training cutoff |
| **playwright** MCP | Prototypes open via `file://` URLs you click manually instead of browser auto-open |
| **serena** MCP | Tweak skill falls back to full file reads instead of semantic navigation |

Optional (nice but not crucial): `claude-md-management`, `frontend-design`.

---

## Common pitfalls

**1. "Just write the SwiftUI code" without a prototype**
→ This bypasses the plugin's design DNA. You'll get generic SwiftUI. **Trust the prototype step** — it takes one extra turn but locks in motion quality and DNA conformance.

**2. Hand-editing `.design/design-system.json` directly**
→ Either edit via the tweak skill (which keeps the DNA.md in sync), or edit both files together and bump the version. The plugin detects out-of-sync state and asks which is correct.

**3. Mid-project DNA changes**
→ Changing DNA after features exist is expensive (every screen drifts). The DNA is locked at init for a reason. If you genuinely need a new direction, treat it as a "v2 redesign" and start fresh.

**4. Vague prompts**
→ "Bir login screen yap" → the skill has to ask: email/password, OAuth, social, magic link, session-only or persistent? Save turns by being specific upfront.

**5. Forgetting Liquid Glass needs iOS 26**
→ If your idea has mass-market reach, push back on the iOS 26 default during init's stack research step. The plugin will lower min iOS and document the override in `DESIGN_DNA.md`.

---

## Workflow snapshot — a typical project

```
[Day 1]
You: "Yeni iOS app: <idea>"
→ ios-design:init activates
→ Stack recommendations + 3 prototypes
→ You pick a DNA
→ Project scaffolded, .design/ persisted, initial commit

[Day 1, later]
You: "Today screen'e <X> ekleyelim"
→ ios-design:feature activates
→ Single prototype in your DNA
→ You approve
→ SwiftUI implementation, simplify pass, commit

[Day 2]
You: "<Y> animasyonu biraz <Z>"
→ ios-design:tweak activates
→ Diff vs DNA, deviation handling, commit

[Day 3]
You: "Settings flow ekleyelim, profile + notifications + theme"
→ ios-design:feature activates
→ Scope unclear, asks brainstorm questions OR invokes superpowers:brainstorming
→ Three screens prototyped, plan written, implemented in waves
```

---

## Where to look when something feels off

| Symptom | Check |
|---|---|
| Plugin doesn't activate | Description matching — is your message specific enough? See trigger phrases above |
| Generated SwiftUI doesn't match prototype | Check `<!-- swiftui: -->` comments in the prototype HTML — they should be the source of truth |
| Animation feels different in app vs prototype | Look up the SwiftUI primitive in `references/motion-fidelity-rules.md` — fidelity stars indicate approximation level |
| Companion not detected | Confirm via `~/.claude/plugins/installed_plugins.json` — and that the corresponding `mcp__plugin_*` tools appear in your session |

---

## See also

- [`README.md`](README.md) — what the plugin is
- [`INSTALL.md`](INSTALL.md) — installation paths
- [`CHANGELOG.md`](CHANGELOG.md) — version history
- [`docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md`](docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md) — design rationale (deep dive)
