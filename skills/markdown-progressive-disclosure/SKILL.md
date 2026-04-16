---
name: markdown-progressive-disclosure
description: Restructure Markdown context with progressive disclosure: one entrypoint, explicit sources, lazy reading.
metadata: {"version":"1.0.1","last_updated":"2026-04-15"}
---

# Markdown Progressive Disclosure

Use this skill to read, navigate, or decompose Markdown context files without turning every detail into top-level noise.

## Model

A **node** is one logical context unit. It has exactly one entrypoint:

```text
name.md
```

or:

```text
name/
  index.md
```

Never keep both `name.md` and `name/index.md` for the same node.

Entrypoints may mix short inline content with extracted sources:

```md
# Purpose
Short inline text.

# Workflow
Source: ./workflow.md

# Billing Playbook
Source: ./billing-playbook/index.md
```

`Source:` is the only reference directive. It may point to a file or to a folder-backed entrypoint. Source-only references do **not** mean every section must be extracted; keep short sections inline when that is clearer.

## Read

References must use explicit relative paths.

Read lazily:

- use inline text directly
- follow `Source: ./file.md` only when needed
- follow `Source: ./folder/index.md` when the source is folder-backed
- do not scan unrelated sibling files unless validation requires it

## Split

Split only when it improves readability and preserves meaning, order, and references.

Default policy:

- `<=200` lines: keep as one file unless the user asks for decomposition
- `>200` lines: split only where the result is clearer
- one large section is allowed; size imbalance alone is not a reason to split
- prefer one split per coherent topic or workflow
- prefer flat `Source: ./name.md` for one coherent extracted topic, even if it is large
- use flat files for long linear sections, such as numbered steps, logs, examples, or FAQs, unless they contain clear internal topics
- use folder-backed `Source: ./name/index.md` only when the topic needs two or more descriptive child files
- do not create a folder that contains only `index.md` unless the user explicitly wants folder layout
- child filenames must be descriptive
- never create meaningless chunks like `part-1.md` or `part-2.md`
- stop splitting when the entrypoint is scannable

When splitting, move the content out of the entrypoint and leave only the heading plus `Source:`. Do not keep the same substantial content inline and in the source file.

## Examples

Minimal split:

```text
support-agent.md
billing-workflow.md
```

```md
# Purpose
Short inline text.

# Billing Workflow
Source: ./billing-workflow.md
```

Huge-file split:

```text
operations-manual.md
billing-playbook.md
access-recovery.md
incident-response.md
trust-and-safety.md
faq-edge-cases.md
```

```md
# Purpose
Short inline text.

# Billing Playbook
Source: ./billing-playbook.md

# Access Recovery
Source: ./access-recovery.md

# Incident Response
Source: ./incident-response.md
```

Folder-backed split:

```text
operations-manual.md
billing-playbook/
  index.md
  eligibility.md
  exceptions.md
```

```md
# Billing Playbook
Source: ./billing-playbook/index.md
```

```md
# Billing Playbook

Source: ./eligibility.md
Source: ./exceptions.md
```

Naming defaults:

- `# Purpose` -> `purpose.md`
- `# FAQ / Edge Cases` -> `faq-edge-cases.md`
- `# Trust And Safety` -> `trust-and-safety/index.md`

## Validate

Before finishing, check:

- every node has one entrypoint: `name.md` or `name/index.md`, not both
- every `Source:` target exists
- every public sibling file or folder is referenced from the entrypoint
- no entry has both substantial inline content and `Source:` for the same topic
- no extracted child uses a vague name such as `part-1.md`
- folder-backed sources have `index.md`
- nesting stays as shallow as the content allows

These are manual checks; no built-in validator is required.

Fix in this order:

1. duplicate or missing entrypoints
2. broken `Source:` references
3. hidden public files
4. mixed inline/source truth
5. vague names
6. over-splitting or needless depth

## Output

Report:

- final tree
- validation result
- files changed
- any intentionally inline large section and why it stayed inline
