---
name: markdown-progressive-disclosure
description: Restructure Markdown context with progressive disclosure: one entrypoint, explicit sources, lazy reading.
metadata: {"version":"1.0.13","last_updated":"2026-04-17"}
---

# Markdown Progressive Disclosure

Use this skill to make Markdown docs easier for AI agents to read incrementally. Prefer exact paths, stable headings, and local context over prose that requires cross-file guessing.

## Model

Treat the docs as an explicit file graph.

- unit: one logical documentation node with one canonical starting file
- entrypoint: exactly one of `name.md` or `name/index.md`
- child: a file or folder-backed subtopic reached by one explicit `Source:` line from a parent file
- inline section: content stays under its heading in the current file
- extracted section: content moves to a child and the parent keeps the heading plus `Source:`
- public child: a file or folder that belongs to the same unit, not merely a nearby sibling

Treat `public child` narrowly. Count it as public only if it is already referenced by `Source:`, the user explicitly says it belongs to the unit, or it is an obvious unit-owned companion that avoids a duplicate child.

Do not treat these as public children by default:

- scratch notes, drafts, TODOs, logs, temp files, or analyst notes
- another unit's entrypoint
- generic nearby docs with no clear topic ownership
- files whose relationship to the unit is unclear

Use these terms consistently. Keep one entrypoint only: `name.md` or `name/index.md`, never both. `index.md` is only a folder convention; there is no implicit directory lookup.

Entrypoints may mix inline sections and extracted sections:

```md
# Purpose
Short inline text.

# Workflow
Source: ./workflow.md

# Policies
Source: ./policies/index.md
```

`Source:` is the only reference directive.

## Heading Identity

Treat heading text and file paths as separate concerns.

- keep the original heading text in the parent when replacing content with `Source:`
- sanitize filenames, not headings; `# FAQ / Edge Cases` may map to `faq-edge-cases.md`
- preserve heading order and subheading order inside moved content
- repeat a top heading in the child only if standalone readability needs it, and then use the exact same topic label
- in folder-backed topics, `index.md` should use the real topic heading, not a placeholder

## Read

Read inline text directly.

- follow only explicit relative `Source:` paths such as `./file.md` or `./folder/index.md`
- resolve each path relative to the file that contains it, then read lazily and stay on the explicit unit graph unless validation requires adjacent-file checks

## Procedure

Use this transform order. Do not skip ahead.

1. identify the unit boundary, canonical entrypoint, and any existing public children
2. inventory the entrypoint headings in order and classify each as inline, flat child, or folder-backed topic
3. choose child paths; reuse a good existing public child when it already matches the topic, and do not create duplicates or relabel ambiguous nearby files as public
4. rewrite the parent in place without changing the entrypoint unless asked; preserve heading order and heading identity, then write each child in the same logical order without absorbing unrelated docs
5. validate the unit and fix issues in the validation order below; stop once the unit is explicit and scannable, not symmetric

## Split

Split only when it improves readability and preserves meaning, order, and parent-child references.

Rules:

- keep one file by default; split when the result is clearly easier to scan, especially once a section grows large
- prefer one extracted child per coherent topic or workflow
- use flat `Source: ./name.md` for one coherent extracted topic; this is usually best for long linear sections such as steps, logs, examples, and FAQs
- use `Source: ./name/index.md` only when the topic needs two or more descriptive child files
- do not create a folder that contains only `index.md` unless the user explicitly wants folder layout
- do not split for symmetry; one large section is fine if keeping it whole is clearer
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

## Setup
Source: ./setup/index.md
```

`setup/index.md`:
```md
# Setup
Source: ./overview.md

## Exceptions
Source: ./exceptions.md
```

### Filename patterns

- `# Purpose` -> `purpose.md`
- `# FAQ / Edge Cases` -> `faq-edge-cases.md`
- `# Background Notes` -> `background-notes/index.md`

## Validate

Before finishing, check:

- one entrypoint only: `name.md` or `name/index.md`, not both
- every `Source:` target exists and resolves relative to the file that contains it
- the `Source:` graph is acyclic and traversal order follows the `Source:` line order
- every public child is reachable from the entrypoint; do not treat non-unit companions as public children
- each child has one parent by default unless the user explicitly wants shared docs
- in a folder-backed topic, every public descendant belongs to that subtree and is reachable from its `index.md`
- extracted topics preserve heading identity; filenames may change, topic labels should not
- no parent has both substantial inline content and `Source:` for the same topic
- no extracted child has a vague name
- folder-backed sources have `index.md`
- nesting is no deeper than needed

Fix in this order: 
- entrypoints
- broken paths
- graph mistakes
- hidden/orphaned public files
- mixed truth
- vague names
- needless depth

## Output

Report:

- final tree
- validation result
- files changed
- any intentionally inline large section and why it stayed inline
