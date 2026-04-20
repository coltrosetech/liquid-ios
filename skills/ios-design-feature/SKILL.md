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
7. Open via playwright if available:
   - Start local HTTP server: `${CLAUDE_PLUGIN_ROOT}/scripts/serve-prototypes.sh` (it reuses an existing server if one is running for this project)
   - Capture the printed base URL
   - Navigate: `browser_navigate <baseUrl>/feature-<feature-name>.html`
   - After approval (Step 5), the server can stay running for subsequent feature iterations or be stopped with `${CLAUDE_PLUGIN_ROOT}/scripts/stop-prototype-server.sh`
   
   If playwright NOT available: print the `file://` path and ask the user to open it manually.
   
   **Why server, not file://:** Playwright MCP blocks `file://` for security; HTTP server unblocks automation.

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
