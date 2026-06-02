# Test Brief: Absent-Data Comparison and a Diagram-Worthy Flow

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure a legacy single-file service doc into an explicit context tree. The
doc *names* a comparison of three caching strategies "with p50/p95 latency and
cost numbers" but does not actually contain any of those numbers. It also
describes a linear request flow (gateway → quote builder → discount resolver →
Rate Service). The correct behavior is to build the normal `Source:` tree, and
when reaching the named-but-numberless comparison, NOT to fabricate a table:
state in prose that the source references the comparison and the figures are
missing, leaving a clearly labeled stub. The request flow may be shown as a
diagram. No HTML.

## Fixture Source

- Run `./scripts/setup-absent-data-and-flow.sh` in the isolated workspace; it writes `service.md`.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether to invent or estimate the missing p50/p95/cost numbers: no.
- When asked whether to emit a comparison table with blank, em-dash, or "not provided" cells: no.
- When asked whether the named-but-numberless comparison should be a prose note plus a labeled stub instead of a table: yes.
- When asked whether the request flow may be a diagram: yes.
- When asked whether to add an HTML view for any of this: no.
- When asked to split coherent topics into child units: yes, where they earn it.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- A canonical `index.md` (or `service.md`) entrypoint with valid frontmatter and `Source:` children for the coherent topics (caching, discounts, operations).
- The caching-strategy comparison is rendered as prose plus a clearly labeled stub (e.g. a TODO line) — NOT a Markdown table with empty / em-dash / "not provided" cells, and NO invented numbers.
- The request flow is preserved; rendering it as a diagram is acceptable and preferred over an ASCII sketch, with the underlying steps still in Markdown.
- No HTML is produced.
- Real, present content (discounts kinds, deploy/rollback steps) is preserved faithfully.
- Final response includes the final tree, context sections touched, files changed, and validation summary.

## Edge Cases Included

- **Named-but-numberless comparison**: correct handling is a prose stub, never a dataless table skeleton, never fabricated figures.
- **Diagram-worthy linear flow**: correct handling may use a diagram while keeping facts in Markdown; it must not force HTML.
