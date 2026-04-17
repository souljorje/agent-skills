# Test Brief: Repair Invalid Split Graph In Place

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Repair an already-split Markdown unit that violates multiple validation rules. The correct behavior is to fix the unit in validation order: resolve duplicate entrypoints first, then broken paths, graph mistakes, hidden public files, mixed truth, vague names, and needless depth.

## Fixture Source

- Run `./scripts/setup-invalid-split-structure.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked which entrypoint to keep: keep `ops-guide.md`.
- When asked whether one child may be shared across multiple parents: no.
- When asked whether `refund-exceptions.md` belongs to the unit: yes.
- When asked whether inline incident content should remain if `Source:` stays: no.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `ops-guide.md` is the only remaining entrypoint for the unit.
- `ops-guide/index.md` is removed or converted so it is no longer a duplicate entrypoint.
- `Source: ./missing-topic.md` is repaired or removed.
- No cycle remains.
- No child is shared across multiple parent headings unless explicitly required, which this brief does not require.
- `refund-exceptions.md` is either reachable from the entrypoint or intentionally absorbed so it is no longer a hidden public file.
- `# Incident Response` does not keep substantial inline content and `Source:` for the same topic.
- Any vague surviving child name is replaced with a descriptive one.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Duplicate entrypoint: correct handling resolves this first.
- Broken path plus cycle plus shared child: correct handling repairs graph validity, not just formatting.
- Hidden public child: correct handling makes the unit explicit.
- Mixed truth in the parent: correct handling leaves one source of truth.
