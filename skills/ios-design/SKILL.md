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
