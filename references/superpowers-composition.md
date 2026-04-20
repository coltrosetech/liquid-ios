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
