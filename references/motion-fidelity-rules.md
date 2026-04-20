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

## SwiftUI API naming — critical gotcha

**DNA tokens use readable names; SwiftUI API uses its own. Map correctly when emitting Swift code.**

| DNA token (conceptual) | SwiftUI `.spring(...)` parameter | Notes |
|---|---|---|
| `response` | `response:` | Direct — same name |
| `damping` | `dampingFraction:` | **NOT `damping:`** — common compile error |
| blendDuration (optional) | `blendDuration:` | Direct |

Correct SwiftUI output:
```swift
.animation(.spring(response: 0.4, dampingFraction: 0.6), value: trigger)
```

Incorrect (will not compile — `error: extra argument 'damping' in call`):
```swift
.animation(.spring(response: 0.4, damping: 0.6), value: trigger)
```

**Alternative (iOS 17+):** `.spring(duration:bounce:)` is the newer semantic form. Use when the DNA expresses motion as total duration + bounciness rather than response + damping.

Feature/init skills emitting SwiftUI MUST apply this mapping. Pre-commit self-check:

```bash
! grep -rE 'spring\(response:\s*[0-9.]+,\s*damping:' Sources/
# Expected: no matches
```

Discovered during v0.1.1 end-to-end validation (Xcode 16.2 build failed with this exact error on first compile of generated Sprout app).

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
