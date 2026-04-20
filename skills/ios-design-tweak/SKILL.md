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
