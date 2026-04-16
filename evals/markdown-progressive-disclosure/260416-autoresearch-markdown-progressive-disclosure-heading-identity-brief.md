# Test Brief: Preserve Heading Identity Across Extraction

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure a guide with headings that contain punctuation and human-readable labels. The correct behavior is to preserve topic labels in the Markdown headings while using filesystem-safe filenames for extracted children.

## Source Materials

Create this starting file in your isolated workspace:

```text
security-guide.md
```

Generate the file with this exact shape:

- `# Purpose`: 4 short lines about support-safe security handling
- `# FAQ / Edge Cases`: 55 numbered lines named `FAQ case 001` through `FAQ case 055`
- Inside `# FAQ / Edge Cases`, include these nested subheadings in this order:
  - `## Password Resets`
  - `## SSO Lockouts`
  - `## Suspicious Devices`
- `# Trust & Safety (EU)`: 48 numbered lines named `EU note 001` through `EU note 048`
- `# Quick Rules`: 8 bullet lines short enough to stay inline

The executor may create sibling files next to `security-guide.md`.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether the extracted filename must match the heading text literally: no, use a safe filename and keep the original heading text.
- When asked whether to keep the original heading text in the parent: yes.
- When asked whether a child may repeat the heading for standalone readability: yes, but only with the same topic label.
- When asked to fill gaps: skip unless required.
- If lint finds issues: fix them.

## Expected Output

- `security-guide.md` remains the only entrypoint.
- If `# FAQ / Edge Cases` is extracted, the parent keeps the exact heading text `# FAQ / Edge Cases` and uses a safe path such as `Source: ./faq-edge-cases.md`.
- If the child repeats a top heading, it uses the exact topic label `# FAQ / Edge Cases`, not a renamed variant like `# FAQ Edge Cases`.
- Nested subheadings remain in the same order inside the extracted content.
- `# Trust & Safety (EU)` keeps its human-readable heading text even if a safe child filename is used.
- No broken `Source:` references.
- Final response includes the final tree, files changed, and validation summary.

## Edge Cases Included

- Slash and punctuation in headings: correct handling sanitizes filenames without renaming topics.
- Repeated heading option: correct handling preserves exact topic identity if the heading is repeated in the child.
- Nested subheadings: correct handling preserves order after extraction.
