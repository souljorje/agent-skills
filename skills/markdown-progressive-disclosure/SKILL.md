---
name: markdown-progressive-disclosure
description: Restructure Markdown context with progressive disclosure: one entrypoint, explicit sources, lazy reading.
metadata: {"version":"1.0.10","last_updated":"2026-04-16"}
---

# Markdown Progressive Disclosure

Use this skill to make Markdown docs easier for AI agents to read incrementally. Prefer exact paths, stable headings, and local context over prose that requires cross-file guessing.

## Model

Treat the docs as an explicit file graph.

- unit: one logical documentation node that should be readable from one canonical starting file
- entrypoint: the canonical starting file for a unit; exactly one of `name.md` or `name/index.md`
- child: a file or folder-backed subtopic reached by one explicit `Source:` line from a parent file
- leaf: a child with no further `Source:` lines
- inline section: a heading whose content stays in the file where the heading appears
- extracted section: a heading whose content is moved to a child and replaced by `Source:`
- public child: a file or folder intended to be part of the same unit, not merely a nearby sibling

Treat `public child` narrowly.

A file or folder counts as a public child only if at least one of these is true:

- it is already reached by an explicit `Source:` path in the unit
- the user explicitly says it belongs to the unit
- it is an obvious unit-owned companion to the entrypoint topic and reusing it avoids creating a duplicate child

Do not treat a file or folder as a public child just because it is adjacent. These do not count as public children by default:

- scratch notes, drafts, TODOs, logs, temp files, or analyst notes
- another unit's entrypoint
- generic repo docs that live nearby but are not part of the same topic
- files whose relationship to the unit is unclear

Use these terms consistently when reading, splitting, validating, and reporting.

## Structure

Each unit has one entrypoint file: `name.md` or `name/index.md`.

Do not keep both `name.md` and `name/index.md` for the same unit.

`index.md` is only a folder convention. There is no implicit directory lookup. References must always point to the exact file path.

Entrypoints may mix inline sections and extracted sections:

```md
# Purpose
Short inline text.

# Workflow
Source: ./workflow.md

# Billing
Source: ./billing/index.md
```

`Source:` is the only reference directive.

## Heading Identity

Treat heading text and file paths as separate concerns.

- preserve the original heading text in the parent when replacing content with `Source:`
- sanitize filenames, not headings; `# FAQ / Edge Cases` may map to `faq-edge-cases.md`
- preserve heading order and relative subheading order inside the moved content
- if a child starts with a repeated top heading for standalone readability, use the same heading text as the extracted parent topic
- do not rename a topic in the child just to match the filename
- for folder-backed topics, `index.md` should use the same topic heading as the parent, not a generic placeholder like `# Topic`

Default pattern:

- parent keeps the original heading plus `Source:`
- flat child usually starts with the moved body and subheadings
- repeat the top heading in the child only when standalone readability clearly benefits

## Read

Read inline text directly.

Follow only explicit relative `Source:` paths from parent to child:

- `Source: ./file.md`
- `Source: ./folder/index.md`

Paths resolve relative to the file that contains the `Source:` line. Example: in `docs/getting-started.md`, `Source: ./local-setup.md` means the child `docs/local-setup.md`, not repo root.

Read lazily. Do not scan unrelated siblings unless validation requires it. Stay on the explicit unit graph.

## Procedure

Use this transform order. Do not skip ahead.

1. identify the unit boundary and canonical entrypoint
2. inventory the entrypoint headings in order
3. inventory existing public children already adjacent to the entrypoint; classify adjacency explicitly, do not assume every sibling belongs to the unit
4. classify each heading as inline section, extracted section, or folder-backed topic using the split rules below
5. choose the child path for each extracted section; reuse a good existing public child when it already matches the topic
6. rewrite the parent in place, preserving heading order and exact heading identity, replacing moved content with the same heading plus `Source:`
7. write each child file with the moved content in the same logical order and preserve heading identity rules
8. validate the resulting unit and fix issues in the validation order below

Constraints during the procedure:

- do not change the unit entrypoint unless the user asks
- do not reorder headings just to match filenames
- do not create duplicate children for content that already has a good public child
- do not absorb scratch notes or unrelated repo docs into the unit graph
- do not label ambiguous adjacent files as public children without evidence from the unit or the user
- do not rename extracted headings for filesystem convenience
- stop after the unit is explicit and scannable; do not continue decomposing for symmetry

## Split

Split only when it improves readability and preserves meaning, order, and parent-child references.

Rules:

- `<=200` lines: keep as one file unless the user asks for decomposition
- `>200` lines: split only where the result is clearer
- do not split for symmetry; one large section is fine if keeping it whole is clearer
- prefer one extracted child per coherent topic or workflow
- use flat `Source: ./name.md` for one coherent extracted topic, even if it is large
- use flat files for long linear sections such as numbered steps, logs, examples, and FAQs unless they contain clear internal subtopics
- use `Source: ./name/index.md` only when the topic needs two or more descriptive child files
- do not create a folder that contains only `index.md` unless the user explicitly wants folder layout
- child filenames must be descriptive
- never create vague chunks like `part-1.md`
- stop splitting when the entrypoint is scannable

When you split, replace the moved content in the parent with the heading plus `Source:`. Do not keep the same substantial content both inline and extracted.

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
# Setup
Source: ./overview.md

## Exceptions
Source: ./exceptions.md
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
- the `Source:` graph has no cycles
- every public child in the unit is reachable from the entrypoint, and only explicit unit-owned companions should be treated as public children
- each child in a unit has one parent by default; do not share one child across multiple parents unless the user explicitly wants shared docs
- in a folder-backed topic, every public descendant belongs to that folder-backed subtree and is reachable from its `index.md`
- traversal order is stable: read children in the same order their `Source:` lines appear in the parent
- extracted topics preserve heading identity; filenames may change, topic labels should not
- no parent has both substantial inline content and `Source:` for the same topic
- no extracted child has a vague name
- folder-backed sources have `index.md`
- nesting is no deeper than needed

These are manual checks. No built-in validator is required.

Fix in this order:

1. duplicate or missing entrypoints
2. broken `Source:` paths
3. cycles or shared-child mistakes
4. hidden public files or orphaned folder descendants
5. mixed inline/external truth
6. vague names
7. over-splitting or needless depth

## Output

Report:

- final tree
- validation result
- files changed
- any intentionally inline large section and why it stayed inline
