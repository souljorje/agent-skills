# Validation Checklist

This is the required final pass after restructuring or updating a unit. Use it every time before finishing. Do not skip it.

## Linter

Running the linter is part of this final pass, not optional. It mechanizes the structural checks below; run it first, then read for the meaning checks a script cannot do (contradictions, stale claims, duplicated facts).

The script has no dependencies and is location-agnostic — run it from wherever the skill is installed and point it at the wiki you are validating:

```
node <skill-dir>/scripts/lint.mjs <wiki-root>/index.md
```

`<skill-dir>` is this skill's own directory (the one holding this `references/` folder, wherever it is installed); `<wiki-root>/index.md` is the root entrypoint of the tree you are checking. A non-zero exit means errors were found — fix them and re-run until it is clean. Run `node <skill-dir>/scripts/lint.mjs --help` for full usage.

Run it:

- after splitting a file or restructuring a tree,
- after a targeted update that adds, moves, or renames links,
- before reporting the work as done.

Flags: `--check-unreferenced` (warn on files nothing links to) and `--check-all-entrypoints` (validate every file, not only those reachable from the root).

To gate a docs build in CI, add a step that fails on a non-zero exit — for example, GitHub Actions:

```yaml
- run: node path/to/agentic-markdown/scripts/lint.mjs docs/index.md
```

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

## Fix In This Order

1. duplicate entrypoints
2. missing or invalid frontmatter
3. malformed `Source:`
4. broken links
5. graph cycles or wrong hierarchy
6. malformed context tables
7. duplicate inline/extracted truth
8. vague names or needless depth
