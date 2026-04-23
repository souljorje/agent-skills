# Test Brief: Repair Invalid Strict v2 Graph In Place

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Repair an already-split Markdown unit that violates strict v2 rules. The correct behavior is to fix validation in order: duplicate entrypoints, missing frontmatter, malformed `Source:`, broken links, graph cycles, malformed external context tables, mixed truth, vague names, and needless depth.

## Fixture Source

- Run `./scripts/setup-invalid-split-structure.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked which entrypoint to keep: keep `ops-guide.md`.
- When asked whether raw-path `Source:` is acceptable in v2: no.
- When asked whether one child may be shared across multiple parents: no.
- When asked whether `refund-exceptions.md` belongs to the unit: yes.
- When asked whether inline incident content should remain if `Source:` stays: no.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `ops-guide.md` is the only remaining entrypoint for the unit.
- `ops-guide/index.md` is removed or converted so it is no longer a duplicate entrypoint.
- All surviving unit entrypoints have required `title` and `tags` frontmatter.
- Raw-path `Source:` lines are converted to labeled markdown links with section descriptions.
- `Source: [Missing Topic](./missing-topic.md)` is repaired from real content or removed.
- No cycle remains.
- `## Dependencies` and `## Related` are valid `Document | Purpose` tables, with relative links only.
- `refund-exceptions.md` is either reachable from the entrypoint or intentionally absorbed so it is no longer a hidden public file.
- `# Incident Response` does not keep substantial inline content and `Source:` for the same topic.
- Final response includes the final tree, external context touched, files changed, and validation summary.

## Edge Cases Included

- Duplicate entrypoint: correct handling resolves this first.
- Missing frontmatter: correct handling repairs every unit entrypoint.
- Raw-path Source: correct handling rejects v1 syntax in v2.
- Broken path plus cycle plus shared child: correct handling repairs graph validity, not just formatting.
- Malformed external table: correct handling separates external context from hierarchy.
