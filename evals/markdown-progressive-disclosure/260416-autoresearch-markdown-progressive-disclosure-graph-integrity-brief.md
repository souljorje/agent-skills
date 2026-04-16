# Test Brief: Preserve Graph Integrity In Folder-Backed Topics

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure a handbook into an explicit file graph with one folder-backed topic. The correct behavior is to keep the graph acyclic, avoid sharing one child across multiple parents, and keep every public descendant in the folder-backed topic reachable from its `index.md`.

## Source Materials

Create this starting structure in your isolated workspace:

```text
handbook.md
incident-operations.md
trust-review.md
playbooks/incident-response.md
playbooks/exceptions.md
playbooks/notes.md
```

Generate files with this exact shape:

- `handbook.md`
  - `# Purpose`: 4 short lines about support and trust operations
  - `# Incident Operations`: 140 numbered lines named `Incident op 001` through `Incident op 140`
  - `# Trust Review`: 120 numbered lines named `Trust review 001` through `Trust review 120`
  - `# Quick Rules`: 8 bullet lines short enough to stay inline
- `incident-operations.md`
  - 25 short lines of old content that may be reused or replaced
- `trust-review.md`
  - 25 short lines of old content that may be reused or replaced
- `playbooks/incident-response.md`
  - 90 numbered lines named `Playbook incident 001` through `Playbook incident 090`
- `playbooks/exceptions.md`
  - 40 numbered lines named `Playbook exception 001` through `Playbook exception 040`
- `playbooks/notes.md`
  - 15 short lines of scratch notes not intended as part of the public topic

The executor may choose flat files or one folder-backed topic if justified by the skill rules.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether one child file should be referenced from multiple parent headings: no.
- When asked whether `playbooks/notes.md` belongs in the public graph: no.
- When asked whether to use a folder-backed topic: yes only if the topic truly needs multiple descriptive children.
- When asked to fill gaps: skip unless required.
- If lint finds issues: fix them.

## Expected Output

- `handbook.md` remains the canonical entrypoint.
- If a folder-backed topic is created, it uses `index.md` and every public descendant in that topic is reachable from that `index.md`.
- No `Source:` cycle is introduced.
- No single child is shared across multiple parent headings unless explicitly required, which this brief does not require.
- `playbooks/notes.md` remains outside the public graph.
- No broken `Source:` references.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Existing sibling files that may tempt reuse across multiple headings: correct handling reuses selectively without creating shared-child ambiguity.
- Folder-backed topic with extra files present: correct handling keeps scratch notes out and prevents orphaned public descendants.
- Two long topics in one entrypoint: correct handling preserves traversal order from the parent.
