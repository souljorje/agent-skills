# Test Brief: Validate Already-Scannable v2 Unit Without Churn

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Validate a unit that already follows strict v2. The correct behavior is to keep the explicit tree stable, avoid cosmetic renames, avoid reading unlinked nearby files, and stop once frontmatter, `Source:` links, and external context tables validate.

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
- `guide.md`, `setup.md`, `policies/index.md`, and `policies/exceptions.md` keep valid `title` and `tags` frontmatter.
- Child links remain labeled markdown `Source:` lines with descriptions.
- `## Dependencies` and `## Related` remain valid two-column tables and are not treated as children.
- No structural churn is introduced only for symmetry.
- `draft.md` stays outside the unit graph and is not read as implicit context.
- Final response includes the final tree, external context touched, files changed, and validation summary.

## Edge Cases Included

- Already-good v2 structure: correct handling makes minimal or zero edits.
- Mixed flat and folder-backed children: correct handling preserves asymmetry when it is clearer.
- External context tables: correct handling validates them without adding them to the tree.
- Nearby draft file: correct handling does not absorb it into the unit.
