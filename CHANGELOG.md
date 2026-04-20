# Changelog

All notable changes to the `ios-design` plugin.

Format: [Keep a Changelog](https://keepachangelog.com/), [Semantic Versioning](https://semver.org/).

## [v0.1.1] — 2026-04-20

### Added
- `scripts/serve-prototypes.sh` — local HTTP server (Python `http.server`) for serving prototype HTML files to playwright-driven browser sessions. Auto-bumps port on collision, idempotent, PID-tracked.
- `scripts/stop-prototype-server.sh` — clean shutdown of the prototype server.

### Changed
- `skills/ios-design-init/SKILL.md` Step 5 — when playwright MCP is available, invoke `serve-prototypes.sh` to spin up a local HTTP server before navigating, then stop after DNA selection.
- `skills/ios-design-feature/SKILL.md` Step 4 — same pattern for feature prototype display.
- `references/companion-plugins.md` — documented playwright `file://` limitation and the HTTP server workaround.

### Fixed
- **Playwright `file://` blocking** — Playwright MCP refuses `file://` URLs for security; original v0.1.0 instructed `browser_navigate file://...` which silently failed. v0.1.1 routes through `http://localhost:PORT/` instead.

### Validation
End-to-end tested against a live todo-app project: 3 DNA prototypes opened in playwright, screenshots captured, click interaction validated, DNA tweak (v1.0.0 → v1.1.0 design system revision) flow exercised. See `docs/superpowers/specs/2026-04-20-ios-design-plugin-design.md` §14 for details.

## [v0.1.0] — 2026-04-20

### Added
- Initial release.
- 4 skills: `ios-design` (router), `ios-design:init`, `ios-design:feature`, `ios-design:tweak`.
- 4 reference documents: companion plugins catalog, motion fidelity rules, DNA prototypes catalog, superpowers composition map.
- 3 templates: design-system schema, DESIGN_DNA philosophy, prototype HTML shell.
- 3 default DNA prototypes: Liquid Native, Editorial Crisp, Playful Character.
- 1 SessionStart hook for resetting capability-card flags.
- 10 manual test scenarios.
- Full design spec and implementation plan committed under `docs/superpowers/`.
