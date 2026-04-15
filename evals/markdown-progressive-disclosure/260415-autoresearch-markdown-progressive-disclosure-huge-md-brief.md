# Test Brief: Decompose Huge Operations Manual

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

The user has one huge Markdown file over 500 lines and wants it decomposed into a progressive node structure. The top-level file should become a scannable entrypoint while using explicit `Source:` references for extracted content.

## Source Materials

Create this starting file in your isolated workspace:

```text
operations-manual.md
```

Generate the file with this exact shape:

- `# Purpose`: 4 short lines describing that the manual supports support, billing, trust, and incident responders.
- `# Quick Rules`: 12 bullet lines, short enough to remain inline.
- `# Billing Playbook`: 130 numbered lines named `Billing step 001` through `Billing step 130`.
- `# Access Recovery`: 115 numbered lines named `Access step 001` through `Access step 115`.
- `# Incident Response`: 145 numbered lines named `Incident step 001` through `Incident step 145`.
- `# Trust And Safety`: 105 numbered lines named `Trust step 001` through `Trust step 105`.
- `# Examples`: 35 numbered lines named `Example 001` through `Example 035`.

Include one sensitive-data rule exactly in `Billing step 077`: `Never ask for a full card number.`

Include one ambiguous heading exactly as `# FAQ / Edge Cases`; place 25 numbered lines named `FAQ edge case 001` through `FAQ edge case 025`.

The total file must exceed 500 lines before restructuring.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked to choose between flat files and folder-backed sources: choose flat files for long linear numbered sections; choose folder-backed sources only when a topic has clear internal subtopics that need descriptive child files.
- When asked about the ambiguous `FAQ / Edge Cases` heading: use a filesystem-safe name and keep the original heading in the entrypoint.
- When asked to fill gaps: skip unless required.
- If lint finds issues: fix them.

## Expected Output

- `operations-manual.md` remains the canonical top-level entrypoint.
- No `operations-manual/index.md` is created while `operations-manual.md` exists.
- Long linear sections should become flat files such as `Source: ./billing-playbook.md`.
- Folder-backed sources are allowed only for topics with clear internal subtopics, and must have `index.md`.
- Short sections may remain inline when that is clearer than extracting tiny files.
- The top-level entrypoint references every extracted public part.
- `Billing step 077: Never ask for a full card number.` is preserved in extracted content.
- The ambiguous `FAQ / Edge Cases` heading maps to a safe referenced path such as `faq-edge-cases.md` or `faq-edge-cases/`.
- No broken `Source:` references.
- No hidden public files.
- Final response includes a lint-style validation summary and the final tree.

## Edge Cases Included

- Very large source file: correct handling should avoid keeping giant sections inline.
- Multiple long numbered sections: correct handling should choose repeatable flat-file decomposition, not meaningless chunks.
- Ambiguous heading with slash: correct handling should keep heading text but use safe path naming.
- Sensitive-data rule: exact constraint must survive decomposition.
- Short top-level sections: correct handling may keep them inline to avoid over-splitting.
