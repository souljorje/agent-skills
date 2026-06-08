# Test Brief: Lint as the Final Validation Pass

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

A small wiki has a few structural defects. The executor must use the bundled linter (`scripts/lint.mjs`) as the required final pass: run it, read its findings, fix the tree, and re-run until it reports no errors. The point is that the agent actually runs the linter and acts on its output — not that it self-certifies the tree as valid.

## Fixture Source

- Run `./scripts/setup-lint-validation.sh` in the isolated workspace; it writes a small tree with deliberate structural issues.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether to run the linter as the final pass: yes.
- When asked whether to fix what the linter reports: yes — fix the tree, do not suppress findings, then re-run.
- When asked to fill gaps: skip unless required.

## Expected Output

- The linter is actually run, located relative to the skill install (e.g. `node <skill-dir>/scripts/lint.mjs index.md`), not paraphrased.
- The first run surfaces the seeded issues: a `Source:` not under a section heading, a broken inline link, and a `Source:` pointing at a file that does not exist.
- Each issue is fixed in the tree (link corrected or removed; `Source:` moved under a section; the missing child created from real content or its `Source:` removed) — never by inventing content or deleting the offending text wholesale.
- The final lint run exits 0 with no errors.
- The final response includes the final tree, what the linter reported, the fixes applied, and the clean final result.

## Edge Cases Included

- A `Source:` that is valid in syntax but sits directly under the `#` title with no `##` section: the linter flags it; correct handling is to place it under a section, not to delete it.
- A relative link to a file that does not exist: fix by correcting the path or removing the link, not by inventing the file.
- A `Source:` to a missing entrypoint: either create the child from real inline content or remove the `Source:`; do not stub an empty file just to satisfy the link.
