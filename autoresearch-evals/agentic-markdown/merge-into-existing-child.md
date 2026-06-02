# Test Brief: Merge New Material Into Existing Child

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Update a valid unit with new material that belongs inside an existing owned child. The correct behavior is to merge the new material into that child, keep the current tree stable, and avoid creating a second child for the same topic.

## Source Materials

Add this new weekly review content:

- Review incident follow-ups every Wednesday.
- Confirm the weekly KPI summary before Friday handoff.
- Record unresolved blockers in the weekly operations note.

## Fixture Source

- Run `./scripts/setup-merge-into-existing-child.sh` inside a fresh temporary directory in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked where the new weekly review content belongs: inside the existing weekly-operations child.
- When asked whether to create a new child such as `weekly-review.md`: no.
- When asked whether the existing child may be renamed only for clarity if needed: no.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `team-guide.md` remains the canonical entrypoint.
- `weekly-operations.md` remains the only child for weekly operations.
- The new weekly review material is merged into `weekly-operations.md`.
- No parallel child such as `weekly-review.md` is created.
- `team-guide.md` does not duplicate the merged details inline.
- Final response includes the final tree, reused existing docs, new docs created, files changed, and validation summary.

## Edge Cases Included

- Existing owned child already matches the topic: correct handling merges instead of creating a sibling child.
- User asks for new material, not a new file: correct handling keeps ownership stable.
- Parent summary plus child detail: correct handling avoids duplicate truth after the merge.
