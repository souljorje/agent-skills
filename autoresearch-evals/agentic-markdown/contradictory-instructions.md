# Test Brief: Stop On Unresolved Contradictory Refactor Request

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

The user gives a targeted refactor request that contains a real contradiction and points to a nearby `local-note.md` file with a local constraint. The correct behavior is to detect the conflict before structural edits, explain the contradiction concretely, and ask for resolution instead of inventing a hybrid file graph.

## Fixture Source

- Run `./scripts/setup-contradictory-instructions.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm the contradictory request as written: do not confirm; resolve the contradiction first.
- When asked whether `# Setup` must stay fully inline in `playbook.md`: yes.
- When asked whether `# Setup` must also be extracted to `./setup.md` right now: yes.
- When asked whether one of those requirements can be dropped: not yet; ask me to choose.
- When asked to fill gaps: refuse to guess across the contradiction.

## Expected Output

- The executor identifies the contradiction before structural edits.
- The response names the conflicting requirements in concrete terms.
- The response asks the user to choose between keeping `# Setup` inline or extracting it.
- No new child file is created while the contradiction is unresolved.
- `playbook.md` remains unchanged until the user resolves the conflict.

## Edge Cases Included

- Contradictory user request: correct handling stops before refactoring.
- Existing nearby note with a stronger local constraint: correct handling surfaces it instead of quietly overriding it.
- Tempting hybrid outcome: correct handling avoids keeping substantial inline content plus extracted duplicate truth.
