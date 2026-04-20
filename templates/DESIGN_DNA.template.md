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
| Concurrency | <swift6-strict> | <why> |
| State | <observable-mainactor> | <why> |
| Architecture | <pattern> | <why> |
| Persistence | <choice> | <why> |
| DI | <approach> | <why> |
| Navigation | <navigation-stack-path-binding> | <why> |

## Override'lar

(Append-only log. Each entry: date, what was overridden, reason.)

- <DATE> — `<key.path>`: changed from `<old>` to `<new>`. Reason: <why>.

## Approximation Notes

(Append-only log of cases where the SwiftUI implementation could not exactly match the prototype.)

- <DATE> — `<feature>`: prototype showed <CSS effect>, implemented as <SwiftUI approximation>. Visual delta: <description>.
