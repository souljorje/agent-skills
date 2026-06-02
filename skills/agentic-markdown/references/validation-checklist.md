# Validation Checklist

This is the required final pass after restructuring or updating a unit. Use it every time before finishing. Do not skip it.

## Structure

- exactly one entrypoint per unit: `name.md` or `name/index.md`
- every entrypoint has valid frontmatter with `title` and `tags`
- except agent-instruction files such as `SKILL.md`, `AGENTS.md`, `CLAUDE.md`, or similar agentic control files, which should stay frontmatter-free unless an explicit local convention requires frontmatter
- each entrypoint has one top `#` heading and a short overview

## Source Tree

- every `Source:` sits under a section header, has a description, and uses readable Markdown-link syntax
- every `Source:` target is relative, exists, and points to a valid entrypoint
- resolve every relative link from the file that contains the link, not from the root entrypoint
- no `Source:` target points to `Dependencies`, `Related`, URLs, anchors, independent sibling units, or unrelated nearby docs
- the `Source:` graph is acyclic

## Context And Reuse

- all `Dependencies` and `Related` sections are valid two-column tables with `Document` and `Purpose`
- every dependency/related row has a relative Markdown link and purpose text
- no broken links in structural or context sections
- ordinary inline links do not need to appear in `Dependencies` or `Related`
- no new child duplicates the topic or stable facts of an existing linked document when merge or reference would suffice
- reused linked documents are preferred over creating parallel truth

## Presenting Data

- no HTML in the output: the unit is Markdown only
- no comparison left as a dataless table skeleton (blank, `—`, or "not provided" cells); a comparison named without numbers is prose plus a labeled stub, never invented figures

## Fix In This Order

1. duplicate entrypoints
2. missing or invalid frontmatter
3. malformed `Source:`
4. broken links
5. graph cycles or wrong hierarchy
6. malformed context tables
7. duplicate inline/extracted truth
8. vague names or needless depth
9. HTML output or a dataless table skeleton
