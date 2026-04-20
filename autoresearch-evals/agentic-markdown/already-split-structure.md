# Test Brief: Validate Already-Scannable Unit Without Churn

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Validate a unit that already follows the skill well. The correct behavior is to keep the graph explicit and stable, avoid symmetry edits, avoid cosmetic renames, and stop once the unit is explicit and scannable.

## Fixture Source

- Run `./scripts/setup-already-split-structure.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether to make the structure more symmetrical: no.
- When asked whether to convert `setup.md` into a folder-backed topic anyway: no.
- When asked whether to rename valid descriptive files for consistency only: no.
- When asked whether `draft.md` belongs to the unit: no.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them, otherwise stop.

## Expected Output

- `guide.md` remains the only unit entrypoint.
- `setup.md` remains a flat child, referenced with labeled `Source:` syntax such as `Source: [Setup](./setup.md)`.
- `policies/index.md` remains a folder-backed topic with reachable descendants.
- No structural churn is introduced only for symmetry.
- No cosmetic rename is performed if the current paths are already valid and descriptive.
- `draft.md` stays outside the unit graph.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Already-good structure: correct handling makes minimal or zero edits.
- Mixed flat and folder-backed children: correct handling preserves asymmetry when it is clearer.
- Nearby draft file: correct handling does not absorb it into the unit.
