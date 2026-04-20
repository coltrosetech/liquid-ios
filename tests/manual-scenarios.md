# Manual Test Scenarios — ios-design v0.1.0

Until automated skill testing matures, these scenarios are run manually before each release. Each scenario describes setup, action, and expected behavior.

## Scenario 1: Skill discoverability

**Setup:** Plugin installed, fresh Claude Code session in empty directory.

**Action:** Type "I want to build an iOS app".

**Expected:**
- `ios-design` router activates (visible in tool call)
- Capability card prints (Turkish or English depending on language detection)
- Companion plugin section accurately reports installed/missing
- Skill asks for app idea

## Scenario 2: Capability card suppression on second activation

**Setup:** After Scenario 1, ios-design router has activated once.

**Action:** Type "Remind me about the iOS app idea".

**Expected:**
- Router activates again
- Capability card does NOT print
- Single-line continuation prints instead

**Verification:**
```bash
ls .claude/state/ | grep ios-design-router-introduced.flag
# expected: file present
```

## Scenario 3: Companion detection accuracy

**Setup:** Run twice — once with all companions installed, once with only superpowers.

**Action:** Activate router.

**Expected:**
- All-installed: capability card shows ✓ for each
- Only superpowers: shows ⚠️ for context7 (essential), 💡 for playwright/serena, suppresses optional

## Scenario 4: Init flow happy path

**Setup:** Empty project directory, ios-design installed.

**Action:** Invoke `ios-design:init` with idea "a daily journal app for solo writers".

**Expected:**
- Capability card prints
- `superpowers:brainstorming` invoked (or skip if spec exists)
- Stack recommendations presented with rationale
- 3 prototype files generated in `.design/prototypes/`
- Recommendation given (likely Liquid Native for journal app)
- After user picks: `.design/design-system.json` and `.design/DESIGN_DNA.md` created and consistent
- Initial commit created

**Verification:**
```bash
test -f .design/design-system.json && python3 -c "import json; json.load(open('.design/design-system.json'))"
test -f .design/DESIGN_DNA.md
ls .design/prototypes/ | wc -l  # expected: 3
git log --oneline | head -1  # expected: initial commit
```

## Scenario 5: Persistence integrity

**Setup:** Project initialized via Scenario 4.

**Action:** Manually edit `.design/DESIGN_DNA.md` to change a Stack Decisions row, then invoke `ios-design:feature`.

**Expected:**
- Feature skill detects the inconsistency between json and md
- Prompts user: "Hangisi doğru?"
- After user picks, syncs both files

## Scenario 6: Motion fidelity self-test

**Setup:** Test directory.

**Action:** Inject a forbidden CSS rule (`transform: skew(10deg)`) into `prototypes/liquid-native.html` temporarily, then run feature skill which would generate from this template.

**Expected:**
- Self-test catches the violation
- Skill revises the prototype before showing
- The skew is removed in the user-facing output

(After test: `git checkout` the prototype file to restore.)

## Scenario 7: Feature skill — full path

**Setup:** Project initialized.

**Action:** "Add a sign-in screen with email + password and a forgot-password link".

**Expected:**
- Feature skill activates, capability card shown
- DNA context read
- Single prototype generated (in chosen DNA), opened in browser if playwright present
- After approval: `superpowers:writing-plans` invoked (>3 steps)
- Logic layer (auth service) implemented via TDD
- Views implemented per prototype's `<!-- swiftui: -->` comments
- `superpowers:simplify` invoked
- `superpowers:verification-before-completion` invoked
- Commit created with feature files

## Scenario 8: Tweak — DNA-aligned

**Action:** "Soften the card press animation slightly".

**Expected:**
- Tweak skill activates
- Locates affected view
- Proposes a new spring value still within DNA's character
- Applies after confirmation
- `superpowers:simplify` invoked
- Single commit

## Scenario 9: Tweak — DNA deviation

**Action:** "Make the card press use linear easing".

**Expected:**
- Tweak skill flags DNA deviation (DNA prefers spring)
- Asks: "Tek seferlik mi yoksa DNA'yı revize edeyim mi?"
- If DNA revision: version bump, both files updated, override log appended
- Commit includes `.design/` if revised

## Scenario 10: Missing essentials graceful degradation

**Setup:** Uninstall context7 MCP.

**Action:** Run init flow.

**Expected:**
- Capability card warns context7 missing
- Stack research falls back to WebSearch
- Stale-info warning printed
- Flow still completes
