# Test Brief: Reference Existing Linked Document Instead Of Copying

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Update a valid unit where the requested new content is already owned by an existing linked non-child document. The correct behavior is to reference that document with inline links or context tables rather than copying the stable facts into the current tree or creating a child for them.

## Source Materials

The user asks to make these two terms easier to understand in the playbook:

- `Escalation Tier`
- `Verified Identity`

Those definitions already exist in the linked glossary and should not be copied into the playbook as stable inline facts.

## Fixture Source

- Run `./scripts/setup-reference-existing-doc.sh` inside a fresh temporary directory in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether the terminology definitions are already owned by `glossary.md`: yes.
- When asked whether those definitions should be copied into `playbook.md`: no.
- When asked whether a new child should be created for the glossary content: no.
- When asked whether an inline link or dependency entry is acceptable: yes.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `playbook.md` remains the canonical entrypoint.
- No new child is created for glossary or terminology content.
- The existing linked `glossary.md` is reused instead of copied.
- Stable glossary facts are not duplicated inline in `playbook.md`.
- `Dependencies` or inline links continue to carry the glossary reference.
- Final response includes the final tree, reused existing docs, new docs created, files changed, and validation summary.

## Edge Cases Included

- Existing non-child linked doc already owns the truth: correct handling references it instead of absorbing it.
- Same-wiki reference target: correct handling still keeps it out of `Source:` when it is not an owned child.
- Request for “add this info” without ownership change: correct handling prefers reference over copy.
