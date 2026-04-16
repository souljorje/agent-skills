# Test Brief: Multi-Level Repo Documentation Cleanup

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

The user has a repo with several large `.md` files at different folder levels. They want the documentation cleaned up into explicit, scannable entrypoints without any implicit directory-index lookup. Every extracted relationship must be expressed with exact `Source:` paths.

## Source Materials

Create this starting structure in your isolated workspace:

```text
README.md
docs/getting-started.md
docs/platform/architecture.md
services/api/README.md
services/api/runbooks/incidents.md
services/worker/README.md
```

Generate files with this exact shape:

- `README.md`
  - `# Repo Purpose`: 5 short lines
  - `# Developer Setup`: 70 numbered lines named `Setup step 001` through `Setup step 070`
  - `# Service Map`: 35 numbered lines named `Service note 001` through `Service note 035`
- `docs/getting-started.md`
  - `# Local Setup`: 120 numbered lines named `Local setup 001` through `Local setup 120`
  - `# Common Pitfalls`: 40 numbered lines named `Pitfall 001` through `Pitfall 040`
- `docs/platform/architecture.md`
  - `# Architecture Overview`: 160 numbered lines named `Architecture note 001` through `Architecture note 160`
  - `# Security Boundaries`: 80 numbered lines named `Boundary 001` through `Boundary 080`
- `services/api/README.md`
  - `# API Purpose`: 4 short lines
  - `# Endpoints`: 140 numbered lines named `Endpoint note 001` through `Endpoint note 140`
  - `# Auth`: 50 numbered lines named `Auth note 001` through `Auth note 050`
- `services/api/runbooks/incidents.md`
  - `# Incident Triage`: 130 numbered lines named `Incident step 001` through `Incident step 130`
  - Include exactly once: `Never paste production secrets into tickets.` as `Incident step 048`
- `services/worker/README.md`
  - `# Worker Purpose`: 5 short lines
  - `# Queues`: 110 numbered lines named `Queue note 001` through `Queue note 110`
  - `# FAQ / Edge Cases`: 30 numbered lines named `Worker FAQ 001` through `Worker FAQ 030`

At least four files must exceed 100 lines before restructuring.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked whether to use flat files or folder-backed sources: use flat files for long linear sections; use folder-backed sources only when a topic clearly needs multiple descriptive child files.
- When asked whether to rewrite cross-repo links: keep paths explicit and relative to the entrypoint file being edited.
- When asked about `FAQ / Edge Cases`: use a filesystem-safe name while keeping the heading text in the entrypoint.
- When asked to fill gaps: skip unless required.
- If lint finds issues: fix them.

## Expected Output

- Existing top-level entrypoint files remain entrypoints: `README.md`, `docs/getting-started.md`, `docs/platform/architecture.md`, `services/api/README.md`, `services/api/runbooks/incidents.md`, `services/worker/README.md`.
- No new implicit node names are introduced; references use exact relative paths only.
- Long linear sections are extracted to flat files such as `Source: ./developer-setup.md` or `Source: ./endpoints.md`.
- Folder-backed sources are allowed only if a topic truly needs multiple descriptive child files, and then must use explicit `Source: ./folder/index.md`.
- `Incident step 048: Never paste production secrets into tickets.` is preserved in extracted content.
- `# FAQ / Edge Cases` maps to a safe path such as `faq-edge-cases.md`.
- No broken `Source:` references.
- No duplicate entrypoints such as both `services/api/README.md` and `services/api/README/index.md`.
- No hidden public files at any repo level.
- Final response includes a final tree and validation summary.

## Edge Cases Included

- Multiple large files at different repo depths: correct handling should keep each file’s references relative and explicit.
- Mixed root-level and nested entrypoints: correct handling should preserve existing entrypoint locations rather than inventing new implicit node paths.
- Linear sections over 100 lines: correct handling should prefer flat files, not arbitrary folder splitting.
- Slash heading in nested file: correct handling should preserve heading text and use safe naming.
- Sensitive operational rule: exact line must survive decomposition.
