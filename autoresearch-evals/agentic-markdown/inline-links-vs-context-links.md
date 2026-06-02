# Test Brief: Clarify Inline Links Versus Context Links

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Update a mostly valid unit where some non-child links should stay ordinary inline Markdown links while whole-unit context links belong in `Dependencies` or `Related`. The correct behavior is to keep `Source:` child-only, preserve useful inline citations/examples, and avoid promoting every non-child link into a context table.

## Fixture Source

- Run `./scripts/setup-inline-links-vs-context-links.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether `Source:` may point to a glossary, citation, or example file that is not an owned child unit: no.
- When asked whether inline Markdown links inside paragraphs or bullets must be copied into `Dependencies` or `Related`: no.
- When asked whether a glossary required to interpret the whole unit belongs in `Dependencies`: yes.
- When asked whether an optional patterns document belongs in `Related`: yes.
- When asked whether a cited example document used only as a local example must stay inline: yes.
- When asked whether `workflow.md` is the owned child for the `Workflow` section: yes.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `playbook.md` remains the canonical entrypoint.
- `## Workflow` keeps `Source: [Workflow](./workflow.md)` as the only child link in the file.
- `## Dependencies` and `## Related` remain valid `Document | Purpose` tables.
- The glossary required for whole-unit understanding is listed under `Dependencies`.
- The optional comparison document is listed under `Related`.
- Ordinary inline links used as a citation, local example, or supporting note remain inline and are not duplicated into `Dependencies` or `Related`.
- No inline citation or example link is converted into `Source:`.
- Final response includes the final tree, context sections touched, files changed, and validation summary.

## Edge Cases Included

- Non-child links inside the same wiki: correct handling keeps them out of `Source:` unless they are owned children.
- Inline example/citation links: correct handling leaves them inline without forcing table promotion.
- Mixed context roles in one entrypoint: correct handling separates child traversal from dependency/related context.
