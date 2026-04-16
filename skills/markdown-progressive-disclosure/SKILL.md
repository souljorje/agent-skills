---
name: markdown-progressive-disclosure
description: Restructure Markdown context with progressive disclosure: one entrypoint, explicit sources, lazy reading.
metadata: {"version":"1.0.5","last_updated":"2026-04-16"}
---

# Markdown Progressive Disclosure

Use this skill to make Markdown docs easier for AI agents to read incrementally. Prefer exact paths, stable headings, and local context over prose that requires cross-file guessing.

## Structure

Each logical doc unit has one entrypoint file:

```text
name.md
```

or:

```text
name/
  index.md
```

Do not keep both `name.md` and `name/index.md` for the same unit.

`index.md` is only a folder convention. There is no implicit directory lookup. References must always point to the exact file path.

Entrypoints may mix short inline sections with extracted sections:

```md
# Purpose
Short inline text.

# Workflow
Source: ./workflow.md

# Billing
Source: ./billing/index.md
```

`Source:` is the only reference directive.

## Read

Read inline text directly.

Follow only explicit relative `Source:` paths:

- `Source: ./file.md`
- `Source: ./folder/index.md`

Paths resolve relative to the file that contains the `Source:` line. Example: in `docs/getting-started.md`, `Source: ./local-setup.md` means `docs/local-setup.md`, not repo root.

Read lazily. Do not scan unrelated siblings unless validation requires it.

## Split

Split only when it improves readability and preserves meaning, order, and references.

Rules:

- `<=200` lines: keep as one file unless the user asks for decomposition
- `>200` lines: split only where the result is clearer
- do not split for symmetry; one large section is fine if keeping it whole is clearer
- prefer one split per coherent topic or workflow
- use flat `Source: ./name.md` for one coherent extracted topic, even if it is large
- use flat files for long linear sections such as numbered steps, logs, examples, and FAQs unless they contain clear internal subtopics
- use `Source: ./name/index.md` only when the topic needs two or more descriptive child files
- do not create a folder that contains only `index.md` unless the user explicitly wants folder layout
- child filenames must be descriptive
- never create vague chunks like `part-1.md`
- stop splitting when the entrypoint is scannable

When you split, replace the moved content in the entrypoint with the heading plus `Source:`. Do not keep the same substantial content both inline and external.

## Examples

### Default split

```text
guide.md
setup.md
workflow.md
```

`guide.md`:
```md
# Purpose
Short inline text.

## Quick reference
Some text.

## Setup
Source: ./setup.md

## Workflow
Source: ./workflow.md
```

### Folder-backed split

```text
guide.md
detailed-process.md
setup/
  index.md
  overview.md
  exceptions.md
```

`guide.md`:
```md
# Purpose
Short inline text

## Quick reference
Some text

## Setup
Source: ./setup/index.md

## Workflow
Source: ./workflow.md
```

`setup/index.md`:
```md
# Topic
Source: ./topic/index.md
```

### Naming defaults:

- `# Purpose` -> `purpose.md`
- `# FAQ / Edge Cases` -> `faq-edge-cases.md`
- `# Background Notes` -> `background-notes/index.md`

## Validate

Before finishing, check:

- one entrypoint only: `name.md` or `name/index.md`, not both
- every `Source:` target exists
- every `Source:` path resolves relative to the file containing it
- every public sibling file or folder is referenced from the entrypoint
- no entry has both substantial inline content and `Source:` for the same topic
- no extracted child has a vague name
- folder-backed sources have `index.md`
- nesting is no deeper than needed

These are manual checks. No built-in validator is required.

Fix in this order:

1. duplicate or missing entrypoints
2. broken `Source:` paths
3. hidden public files
4. mixed inline/external truth
5. vague names
6. over-splitting or needless depth

## Output

Report:

- final tree
- validation result
- files changed
- any intentionally inline large section and why it stayed inline
