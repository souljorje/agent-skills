# Test Brief: Create Strict v2 File Graph From One Large Guide

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure one large Markdown guide into a strict v2 unit. The correct behavior is to keep one canonical entrypoint, add required frontmatter, extract large coherent topics into child entrypoints, keep short sections inline, use labeled `Source:` links with descriptions, and leave nearby scratch material outside the unit.

## Fixture Source

- Run `./scripts/setup-large-file.sh` in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether to keep `support-guide.md` as the entrypoint: yes.
- When asked whether short sections should stay inline: yes, if still scannable.
- When asked whether `# Access Recovery` may use a folder-backed topic: yes, only if the subheadings are preserved as descriptive child units.
- When asked whether `draft-notes.md` belongs to the public graph: no.
- When asked whether to add empty tags if no semantic tags are obvious: yes.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `support-guide.md` remains the canonical entrypoint.
- `support-guide.md` and every child unit entrypoint have `title` and `tags` frontmatter.
- `# Refund Workflow` is extracted to a descriptive child such as `Source: [Refund Workflow](./refund-workflow.md)` with a section description.
- `# Access Recovery` may remain one flat child or become a folder-backed topic, but only if the result is clearer and explicit.
- `# FAQ / Edge Cases` keeps its heading text in the parent if extracted and uses a safe path such as `faq-edge-cases.md`.
- `draft-notes.md` stays outside the unit graph and is not discovered by proximity.
- `Refund step 061: Never ask for a full card number.` is preserved in extracted content.
- No duplicate entrypoint such as both `support-guide.md` and `support-guide/index.md`.
- No raw-path `Source:` lines or broken links remain.
- Final response includes the final tree, external context touched, files changed, and validation summary.

## Edge Cases Included

- Legacy one-file input: correct handling creates strict v2 structure.
- One large linear topic: correct handling prefers a flat extracted child.
- One topic with clear internal subheadings: correct handling may justify a folder-backed topic, but only if explicit and shallow.
- Slash heading: correct handling preserves heading identity while sanitizing the path.
- Nearby scratch file: correct handling keeps it outside the unit.
