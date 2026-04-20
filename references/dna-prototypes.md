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
