---
name: agentic-markdown
description: "Use this skill when restructuring agent-readable Markdown into deterministic context trees with required frontmatter, explicit `Source:` child links, external context tables, and lazy traversal."
metadata:
  version: "2.0.0"
  last_updated: "2026-04-23"
---

# Agentic Markdown

Use this skill to turn Markdown into a deterministic, human-readable context system for agents. The tree is the only primary navigation. Agents read selectively through explicit links, never by scanning nearby files or directories.

## Model

- unit: one logical context block with exactly one entrypoint
- entrypoint: exactly one of `name.md` or `name/index.md`, never both
- child unit: a unit reached by one structural `Source:` link from its parent
- external context: non-tree units listed under `Dependencies` or `Related`
- inline section: short content that remains in the current entrypoint
- extracted section: content moved to a child unit, leaving heading, description, and `Source:`

No implicit discovery. File proximity, sibling files, directory contents, and backlinks do not define structure.

## Entrypoints

Every unit entrypoint must use this format:

```md
---
title: Human Title
tags: [tag-a, tag-b]
---

# Human Title

Short overview of this unit.

## Section Name
One or two lines describing the child content.
Source: [Readable Title](./child.md)
```

Frontmatter rules:

- `title` is required, string, human-readable
- `tags` is required, flat list; it may be empty
- frontmatter title and top `#` heading should match unless preserving an existing public title is more important

Child targets are also entrypoints and must follow the same format.

## Source Links

`Source:` is the only structural child directive.

Required form:

```md
## Section Name
One or two lines explaining why this child exists.
Source: [Readable Title](./relative-entrypoint.md)
```

Rules:

- must be under a section header
- must have a useful one- or two-line description before it
- must use a Markdown link with readable label text
- must use a relative path
- must point to a valid unit entrypoint
- must not point to external units, independent sibling units, URLs, anchors, or unlinked nearby files
- raw paths such as `Source: ./workflow.md` are invalid in v2

Semantics:

- defines the tree hierarchy
- participates in primary traversal
- is eligible for recursive descent when relevant
- order follows the `Source:` line order in the file

## External Context

External context is explicit and not part of the tree.

Use `Dependencies` for external units required for correct interpretation:

```md
## Dependencies

| Document | Purpose |
|---|---|
| [Glossary](../glossary.md) | Defines required terms |
```

Use `Related` for optional expansion:

```md
## Related

| Document | Purpose |
|---|---|
| [Patterns](../patterns.md) | Alternative approaches |
```

Rules for both tables:

- must be Markdown tables with exactly `Document` and `Purpose` columns
- each row must include one relative Markdown link and a short purpose
- links must not be children of the current unit
- links are external context, not structural hierarchy

Read `Dependencies` only when ambiguity, undefined terms, or correctness needs require them. Read `Related` only when more context, comparison, or exploration is useful.

## Traversal

Follow this algorithm:

1. Open the entrypoint.
2. Read frontmatter, overview, section headers, descriptions, and link labels.
3. If sufficient, stop.
4. For each relevant `Source:`, open the child entrypoint.
5. If ambiguity or missing prerequisite remains, open relevant `Dependencies`.
6. If still incomplete or expansion is useful, open relevant `Related`.
7. Never scan sibling files, directories, or unlinked files.

Choose relevance from section headers, descriptions, link text, target tags, and the current task. Do not auto-expand every child, dependency, or related document.

## Transform Procedure

1. Check the user request, explicit local constraints, and current linked graph for contradictions. If a real conflict remains, stop and ask for resolution.
2. Identify the unit boundary from the requested entrypoint and explicit links only.
3. Choose the canonical entrypoint; if both `name.md` and `name/index.md` exist for one unit, keep one and remove or convert the duplicate.
4. Add or repair required frontmatter on every unit entrypoint.
5. Inventory sections in order. Keep short sections inline; extract only coherent topics that improve scanability.
6. For extracted topics, preserve heading identity, choose descriptive relative paths, move content into child entrypoints, and leave description plus `Source:`.
7. Convert external non-child references to `Dependencies` or `Related` tables when they are needed.
8. Validate in the order below and fix failures before finishing.

Do not split for symmetry. Do not invent missing children only to satisfy a broken link; either create the child from real inline content or remove/inline the stub.

### Contradiction Stops

When step 1 finds mutually exclusive requirements:

- make no structural edits
- name the conflicting requirements concretely
- ask the user which requirement wins
- report validation as skipped because the transform intentionally stopped
- do not treat later transform steps as ambiguous; they are not applicable until the conflict is resolved

Read an unlinked local constraint file only when the user request, brief, or entrypoint explicitly identifies it. Otherwise, unlinked nearby files remain outside the unit.

### Legacy Markdown

When converting legacy Markdown that uses multiple top-level `#` headings:

- keep or create one document-level `#` heading from the canonical entrypoint title
- convert remaining top-level topic headings to `##` sections unless they become child entrypoints
- preserve the visible heading text when extracting; only sanitize filenames
- keep heading order stable unless validation requires moving a child link

## Splitting

- keep one file by default
- split when the entrypoint becomes hard to scan or a section is a coherent reusable topic
- keep short residual sections inline when they are easy to scan and not reusable
- prefer `./topic.md` for one coherent topic
- use `./topic/index.md` only when that topic has multiple substantial subtopics that should be explicit children
- never create vague files like `part-1.md`
- sanitize filenames, not headings; `FAQ / Edge Cases` may become `faq-edge-cases.md`
- preserve source order and meaning
- never keep substantial duplicate truth inline and in a child

Folder-backed topics are just units whose entrypoint is `index.md`; directories are never traversed implicitly.

Shared reference files that are needed for interpretation but are not owned by the current tree should stay outside the tree and be listed in `Dependencies`. Do not absorb or duplicate them only to avoid an external context table.

## Validation

Before finishing, check:

- exactly one entrypoint per unit: `name.md` or `name/index.md`
- every entrypoint has valid frontmatter with `title` and `tags`
- each entrypoint has one top `#` heading and a short overview
- every `Source:` sits under a section header, has a description, and uses readable Markdown-link syntax
- every `Source:` target is relative, exists, and points to a valid entrypoint
- resolve every relative link from the file that contains the link, not from the root entrypoint
- no `Source:` target points to `Dependencies`, `Related`, URLs, anchors, independent sibling units, or unrelated nearby docs
- the `Source:` graph is acyclic
- all `Dependencies` and `Related` sections are valid two-column tables with `Document` and `Purpose`
- every dependency/related row has a relative Markdown link and purpose text
- no broken links in structural or external-context sections
- no implicit filesystem discovery is required to understand the unit

Fix in this order:

1. duplicate entrypoints
2. missing or invalid frontmatter
3. malformed `Source:`
4. broken links
5. graph cycles or wrong hierarchy
6. malformed external-context tables
7. duplicate inline/extracted truth
8. vague names or needless depth

## Backlinks

Backlinks are optional and non-canonical. If needed, generate them outside source files. They must never affect traversal or validation.

## Output

Report:

- final tree
- external context sections touched
- validation result
- files changed
- any intentionally inline large section and why it stayed inline
