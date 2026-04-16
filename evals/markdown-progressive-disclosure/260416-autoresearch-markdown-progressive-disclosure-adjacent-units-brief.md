# Test Brief: Distinguish Nearby Docs From Same-Unit Children

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure one operations doc without absorbing nearby docs that belong to separate units. The correct behavior is to reuse an obvious same-unit companion if needed, but leave adjacent entrypoints and generic repo notes outside the unit graph.

## Source Materials

Create this starting structure in your isolated workspace:

```text
ops/release-guide.md
ops/release-checklist.md
ops/incident-guide.md
ops/README.md
```

Generate files with this exact shape:

- `ops/release-guide.md`
  - `# Purpose`: 4 short lines about release coordination
  - `# Release Sequence`: 95 numbered lines named `Release step 001` through `Release step 095`
  - `# Rollback`: 28 numbered lines named `Rollback 001` through `Rollback 028`
  - `# Contacts`: 6 bullet lines
- `ops/release-checklist.md`
  - 35 numbered lines named `Checklist 001` through `Checklist 035`
  - This is an obvious same-unit companion and may be reused if the final structure makes it part of the release-guide unit.
- `ops/incident-guide.md`
  - `# Purpose`: 4 short lines about incident response
  - 60 numbered lines named `Incident step 001` through `Incident step 060`
  - This is a separate unit entrypoint and must not be absorbed into the release-guide unit.
- `ops/README.md`
  - 20 short lines of directory overview notes
  - This is nearby repo documentation, not part of the release-guide unit by default.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether `release-checklist.md` may be reused for the release-guide unit: yes.
- When asked whether `incident-guide.md` belongs to the same unit: no.
- When asked whether `ops/README.md` belongs to the same unit: no.
- When asked to fill gaps: skip unless required.
- If lint finds issues: fix them.

## Expected Output

- `ops/release-guide.md` remains the canonical entrypoint for the release-guide unit.
- `ops/release-checklist.md` may remain outside the unit or become a referenced public child, but only if the final structure makes that relationship explicit.
- `ops/incident-guide.md` is not treated as a public child of `ops/release-guide.md`.
- `ops/README.md` is not treated as a public child of `ops/release-guide.md`.
- No broken `Source:` references.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Same-directory docs with mixed roles: correct handling distinguishes same-unit companions from separate units.
- Nearby README: correct handling does not over-scope the unit boundary.
- Existing companion file: correct handling may reuse it when the topic fit is obvious.
