# Test Brief: Preserve Unit Boundaries Around Scratch Files

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure one Markdown unit into progressive disclosure form without absorbing adjacent scratch material. The correct behavior is to keep one canonical entrypoint, extract the large public topic, and leave unrelated local notes outside the unit graph.

## Source Materials

Create this starting structure in your isolated workspace:

```text
playbooks/refunds.md
playbooks/refund-exceptions.md
playbooks/scratch-notes.md
playbooks/TODO.md
```

Generate files with this exact shape:

- `playbooks/refunds.md`
  - `# Purpose`: 4 short lines about refund triage for support staff
  - `# Core Policy`: 95 numbered lines named `Policy line 001` through `Policy line 095`
  - `# Exception Handling`: 80 numbered lines named `Exception handoff 001` through `Exception handoff 080`
  - `# Quick Replies`: 8 bullet lines short enough to stay inline
- `playbooks/refund-exceptions.md`
  - 60 numbered lines named `Exception detail 001` through `Exception detail 060`
  - This file is a public child candidate and should remain part of the same refunds unit if referenced explicitly.
- `playbooks/scratch-notes.md`
  - 15 short lines of analyst notes
  - This file is scratch material and is not part of the refunds unit.
- `playbooks/TODO.md`
  - 10 short lines of repo maintenance notes
  - This file is unrelated repo content and is not part of the refunds unit.

The executor may rename or fold `refund-exceptions.md` into the unit if the final graph stays explicit and descriptive.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether adjacent scratch files belong to the same unit: only `refunds.md` and any explicitly referenced public child belong to the unit.
- When asked whether to extract the large policy content: extract it if that keeps the entrypoint scannable.
- When asked to fill gaps: skip unless required.
- If lint finds issues: fix them.

## Expected Output

- `playbooks/refunds.md` remains the canonical entrypoint for the refunds unit.
- At least one large coherent section is extracted to an explicitly referenced child file.
- `playbooks/refund-exceptions.md` may remain, be renamed, or be absorbed, but if it remains public it must be reachable from the entrypoint.
- `playbooks/scratch-notes.md` and `playbooks/TODO.md` are not pulled into the refunds unit just because they are siblings.
- No duplicate entrypoint such as both `playbooks/refunds.md` and `playbooks/refunds/index.md`.
- No broken `Source:` references.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Adjacent sibling files with different roles: correct handling distinguishes unit files from scratch or unrelated repo files.
- Existing descriptive sibling file: correct handling may reuse it as a public child instead of inventing an unnecessary duplicate.
- One file just under 200 lines plus an existing child candidate: correct handling keeps the entrypoint scannable without over-splitting.
