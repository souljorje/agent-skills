# Test Brief: Create Explicit File Graph From One Large Guide

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure one large Markdown guide into an explicit progressive-disclosure unit. The correct behavior is to keep one canonical entrypoint, extract large coherent topics, keep short sections inline, use safe child paths, and leave nearby scratch material outside the unit.

## Fixture Source

- Run `./scripts/setup-large-file.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether to keep `support-guide.md` as the entrypoint: yes.
- When asked whether short sections should stay inline: yes, if still scannable.
- When asked whether `# Access Recovery` may use a folder-backed topic: yes, only if the subheadings are preserved as descriptive children.
- When asked whether `draft-notes.md` belongs to the public graph: no.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `support-guide.md` remains the canonical entrypoint.
- `# Refund Workflow` is extracted to a descriptive flat child such as `Source: ./refund-workflow.md`.
- `# Access Recovery` may remain one flat child or become a folder-backed topic, but only if the result is clearer and explicit.
- `# FAQ / Edge Cases` keeps its heading text in the parent if extracted and uses a safe path such as `faq-edge-cases.md`.
- `draft-notes.md` stays outside the unit graph.
- `Refund step 061: Never ask for a full card number.` is preserved in extracted content.
- No duplicate entrypoint such as both `support-guide.md` and `support-guide/index.md`.
- No broken `Source:` references.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- One large linear topic: correct handling prefers a flat extracted child.
- One topic with clear internal subheadings: correct handling may justify a folder-backed topic, but only if explicit and shallow.
- Slash heading: correct handling preserves heading identity while sanitizing the path.
- Nearby scratch file: correct handling keeps it outside the unit.
