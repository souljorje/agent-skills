# Test Brief: Update Near-Valid Unit Without Duplicating Children

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Update an otherwise-valid unit after the user requests one targeted structural change. The correct behavior is to preserve the existing explicit graph, reuse good public children, rename the intentionally vague existing child to a descriptive path, and add the new extracted topic without creating duplicates.

## Fixture Source

- Run `./scripts/setup-existing-child-targeted-update.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked what change is requested: extract `# Escalation Policies` while keeping the handbook easy to scan.
- When asked whether `ops.md` is part of the same unit: yes.
- When asked whether `ops.md` may be renamed if its filename is too vague: yes.
- When asked whether to create a second child for weekly operations instead of reusing the existing one: no.
- When asked whether `notes.md` belongs to the public graph: no.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `team-handbook.md` remains the canonical entrypoint.
- `# Escalation Policies` is extracted to a descriptive child such as `Source: [Escalation Policies](./escalation-policies.md)`.
- The existing weekly-operations child content is reused rather than duplicated.
- The intentionally vague `ops.md` child is renamed to a descriptive path such as `weekly-operations.md`.
- Heading order and heading identity are preserved.
- `notes.md` stays outside the unit graph.
- No broken `Source:` references.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Targeted update to an already-valid unit: correct handling changes only what the request requires.
- Existing vague child name: correct handling renames only if needed for validation.
- Existing good public child: correct handling reuses it instead of creating a duplicate topic file.
