# Test Brief: Split Borderline Handbook Without Over-Splitting

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure a moderately large Markdown handbook into a scannable node. The file is over 200 lines, but one section is much larger than the rest. The correct behavior is to extract the large coherent topic, keep short sections inline, and avoid needless folder depth.

## Source Materials

Create this starting file in your isolated workspace:

```text
team-handbook.md
```

Generate the file with this exact shape:

- `# Purpose`: 5 short lines about the handbook supporting onboarding, scheduling, and incident handoff.
- `# Principles`: 10 bullet lines short enough to stay inline.
- `# Weekly Operations`: 170 numbered lines named `Weekly step 001` through `Weekly step 170`.
- `# Escalation Contacts`: 8 bullet lines with named teams and handoff conditions.
- `# FAQ`: 14 numbered lines named `FAQ 001` through `FAQ 014`.

The total file must be over 200 lines before restructuring.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked to choose whether to split multiple short sections: keep short sections inline unless extraction is clearly better.
- When asked to choose file-vs-folder for the large section: use a flat file.
- When asked to fill gaps: skip unless required.
- If lint finds issues: fix them.

## Expected Output

- `team-handbook.md` remains the only top-level entrypoint.
- `# Weekly Operations` is extracted to `Source: ./weekly-operations.md`.
- `# Principles`, `# Escalation Contacts`, and `# FAQ` may remain inline.
- No `team-handbook/index.md` is created.
- No broken `Source:` references.
- No vague names such as `part-1.md`.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Borderline size over 200 lines: correct handling should still avoid decomposing every short section.
- One dominant long section: correct handling should extract only that coherent topic.
- Flat-vs-folder choice: correct handling prefers one flat file for one long linear section.
