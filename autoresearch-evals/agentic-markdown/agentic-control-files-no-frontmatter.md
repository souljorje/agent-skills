# Test Brief: Keep Agentic Control Files Frontmatter-Free

> Simulated input for testing the agentic-markdown skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Update a small agent-instruction doc set to make structure explicit without adding frontmatter to agentic control files. The correct behavior is to preserve frontmatter-free `SKILL.md`, `AGENTS.md`, and `CLAUDE.md` style files while still using linked structure where needed.

## Fixture Source

- Run `./scripts/setup-agentic-control-files-no-frontmatter.sh` inside a fresh temporary directory in the isolated workspace.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether `SKILL.md` should gain YAML frontmatter just because normal units require it: no.
- When asked whether `AGENTS.md` or `CLAUDE.md` should gain YAML frontmatter: no.
- When asked whether agentic control files may stay frontmatter-free if local rules do not require frontmatter: yes.
- When asked to fill gaps: skip unless required.
- If validation finds issues: fix them.

## Expected Output

- `SKILL.md`, `AGENTS.md`, and `CLAUDE.md` remain frontmatter-free.
- No frontmatter is added to any agentic control file.
- Any structural cleanup does not violate the frontmatter exception.
- Final response includes the final tree, reused existing docs, new docs created, files changed, and validation summary.

## Edge Cases Included

- Agentic control files: correct handling exempts them from normal frontmatter requirements.
- Mixed rule set: correct handling keeps structural rules while honoring the control-file exception.
