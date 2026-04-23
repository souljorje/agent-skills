---
name: agentic-markdown
description: "Use this skill when restructuring agent-readable Markdown into progressive-disclosure file graphs with short entrypoints, explicit relative `Source:` links, and lazy reads."
metadata:
  version: "1.2.2"
  last_updated: "2026-04-20"
---

# Agentic Markdown

Use this skill to make Markdown files easier for AI agents to read incrementally and act on without guessing. Use progressive disclosure: keep entrypoints short, push detail into explicit children, and read lazily through exact paths instead of broad scanning.

## Model

Treat the docs as an explicit file graph.

- unit: one logical documentation node with one canonical starting file
- entrypoint: exactly one of `name.md` or `name/index.md`
- child: a file or folder-backed subtopic reached by one explicit `Source:` line from a parent file
- inline section: content stays under its heading in the current file
- extracted section: content moves to a child and the parent keeps the heading plus `Source:`
- public child: a file or folder that belongs to the same unit, not merely a nearby sibling

Treat `public child` narrowly. Count it as public only if it is already referenced by `Source:`, the user explicitly says it belongs to the unit, or it is an obvious unit-owned companion that avoids a duplicate child.

During validation, you may discover a hidden public child by adjacent-file checks. Treat it as public only if its topic clearly belongs to a heading in the unit, it does not compete with another parent's topic, and the user or local instructions do not exclude it.

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
One short sentence describing what this child contains.

Source: [Workflow](./workflow.md)

# Policies
One short sentence describing what this child contains.

Source: [Policies](./policies/index.md)
```

`Source:` is the only reference directive.

Canonical `Source:` form is a markdown link with a human-readable label:

```md
Source: [Workflow](./workflow.md)
```

Raw paths remain valid when brevity matters:

```md
Source: ./workflow.md
```

Default extracted-section format:

- heading
- one short factual description when it adds clarity; omit it when the heading plus `Source:` is already explicit
- `Source:`

Use a table only for dense index sections with many peer children and short descriptions. In that case, prefer:

```md
| Name | Description | Source |
|---|---|---|
| Workflow | Daily operating flow | [Workflow](./workflow.md) |
| Policies | Rules and exceptions | [Policies](./policies/index.md) |
```

## Heading Identity

Treat heading text and file paths as separate concerns.

- keep the original heading text in the parent when replacing content with `Source:`
- sanitize filenames, not headings; `# FAQ / Edge Cases` may map to `faq-edge-cases.md`
- preserve heading order and subheading order inside moved content
- default a standalone child file to `# Topic`; if you repeat a top heading in the child, use the exact same topic label
- in folder-backed topics, `index.md` should use the real topic heading, not a placeholder
- in folder-backed topics, keep every extracted subtopic heading in the index, including the first subtopic after the top-level topic heading

## Read

Read inline text directly.

- follow only explicit relative `Source:` targets, either as raw paths such as `./file.md` or as markdown links such as `[Workflow](./workflow.md)`
- when a `Source:` line uses a markdown link, treat the link target as the path and the link label as human-facing text only
- resolve each `Source:` target relative to the file that contains it, then read lazily and stay on the explicit unit graph unless validation requires adjacent-file checks
- treat `nearby explicit instructions` narrowly: the user request, files the user explicitly points to, files already on the unit graph, and any local constraint file explicitly named by the user or brief

## Contradictions

Check for contradictions before structural edits.

- look for instructions that cannot both be true at once, such as conflicting split requests, incompatible path requirements, or one instruction that says to preserve a child while another says to replace it
- if the user points to a nearby instruction file or local constraint that governs the unit, read it before refactoring
- prefer the most specific in-scope instruction when there is an obvious precedence relationship
- if the conflict is real and unresolved, surface it to the user before refactoring the unit
- do not paper over contradictions by producing a hybrid structure that violates the file graph model

## Procedure

Use this transform order. Do not skip ahead.

1. check for contradictions in the user request, current file graph, and nearby explicit instructions. If a real unresolved conflict remains, stop and ask the user to resolve it before refactoring.
2. identify the unit boundary, canonical entrypoint, and any existing public children
3. inventory the entrypoint headings in order and classify each as inline, flat child, or folder-backed topic
4. choose child paths; reuse a good existing public child when it already matches the topic, and do not create duplicates or relabel ambiguous nearby files as public. In targeted updates, preserve an existing public child unless it fails validation or no longer matches the topic.
5. rewrite the parent in place without changing the entrypoint unless asked; preserve heading order and heading identity, then write each child in the same logical order without absorbing unrelated docs. If the unit already satisfies the model and validation checks, make zero edits and report none.
6. validate the unit and fix issues in the validation order below; stop once the unit is explicit and scannable, not symmetric

## Split

Split only when it improves readability and preserves meaning, order, and parent-child references.

Rules:

- keep one file by default; split when the result is clearly easier to scan, especially once a section grows large
- prefer one extracted child per coherent topic or workflow
- prefer `Source: [Human Readable Name](./name.md)` for one coherent extracted topic; this is usually best for long linear sections such as steps, logs, examples, and FAQs
- use `Source: [Human Readable Name](./name/index.md)` only when the topic needs two or more descriptive child files or already contains multiple descriptive subtopics that would stay explicit as children
- raw-path `Source:` lines remain valid, but prefer labeled markdown links when writing or rewriting parent files for humans
- do not create a folder that contains only `index.md` unless the user explicitly wants folder layout
- do not split for symmetry; one large section is fine if keeping it whole is clearer
- child filenames must be descriptive
- when renaming a vague extracted child, derive the new filename from the child heading or topic label, not from incidental brief phrasing
- never create vague chunks like `part-1.md`
- stop splitting when the entrypoint is scannable

Treat `scannable` concretely: a human should be able to identify the entrypoint structure in one quick pass through headings, short descriptions, and `Source:` lines without opening every child immediately.

When you split, replace the moved content in the parent with the heading plus `Source:`. Do not keep the same substantial content both inline and extracted.

For extracted sections, prefer heading + short description + `Source:` over title-only links. Use tables only when they improve scanability more than normal headings.

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
Source: [Setup](./setup.md)

## Workflow
Source: [Workflow](./workflow.md)
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
Source: [Setup](./setup/index.md)
```

`setup/index.md`:
```md
# Setup
Source: [Overview](./overview.md)

## Exceptions
Source: [Exceptions](./exceptions.md)
```

### Filename patterns

- `# Purpose` -> `purpose.md`
- `# FAQ / Edge Cases` -> `faq-edge-cases.md`
- `# Background Notes` -> `background-notes/index.md`

## Validate

Before finishing, check:

- one entrypoint only: `name.md` or `name/index.md`, not both
- every `Source:` target exists and resolves relative to the file that contains it
- in markdown-link `Source:` lines, the label and target do not contradict the surrounding topic
- the `Source:` graph is acyclic and traversal order follows the `Source:` line order
- every public child is reachable from the entrypoint; do not treat non-unit companions as public children
- each child has one parent by default unless the user explicitly wants shared docs
- in a folder-backed topic, every public descendant belongs to that subtree and is reachable from its `index.md`
- extracted topics preserve heading identity; filenames may change, topic labels should not
- no parent has both substantial inline content and `Source:` for the same topic
- no extracted child has a vague name
- broken placeholder `Source:` stubs are removed or inlined; do not invent missing child files just to satisfy the link
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
