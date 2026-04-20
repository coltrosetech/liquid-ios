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

If `playwright` MCP available:
1. Run `${CLAUDE_PLUGIN_ROOT}/scripts/serve-prototypes.sh` from `<project>` root — it starts a local HTTP server (default port 8765, auto-bumps on collision) and prints the base URL on stdout. Capture this URL.
2. Open each prototype via `browser_navigate <baseUrl>/<dna-id>.html` (one navigation per DNA — playwright supports tabs but sequential snapshots are simpler).
3. After DNA selection (Step 6), stop the server with `${CLAUDE_PLUGIN_ROOT}/scripts/stop-prototype-server.sh`.

**Why a local server:** Playwright MCP and most browser MCPs block `file://` for security. The HTTP server unblocks programmatic browser automation.

If `playwright` MCP NOT available: print three `file://` paths and ask the user to open them in their browser manually. No server needed in this fallback.

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
