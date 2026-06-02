#!/usr/bin/env bash
set -euo pipefail

cat > playbook.md <<'EOF'
---
title: Support Playbook
tags: [support, playbook]
---

# Support Playbook

This playbook keeps task flow explicit while allowing local citations and examples.
Use the [Message Example](./message-example.md) link only as a local example, not as a child unit.

## Workflow
Core operating steps live in an owned child unit.
Source: [Workflow](./workflow.md)

## Quick Notes

- Confirm terminology with the [Glossary](./glossary.md) before changing copy.
- See the [Retry Example](./retry-example.md) note for one local example.
- Supporting explanation may cite [Background Notes](./background-notes.md) inline without changing the tree.

## Dependencies

| Document | Purpose |
|---|---|
| [Glossary](./glossary.md) | Defines required terms used across this playbook |

## Related

| Document | Purpose |
|---|---|
| [Response Patterns](./response-patterns.md) | Optional comparison patterns for tone and structure |
EOF

cat > workflow.md <<'EOF'
---
title: Workflow
tags: [workflow]
---

# Workflow

Owned child steps for the playbook.
EOF
for i in $(seq 1 36); do printf 'Workflow step %03d\n' "$i" >> workflow.md; done

cat > glossary.md <<'EOF'
---
title: Glossary
tags: [glossary]
---

# Glossary

Required shared definitions.
EOF

cat > response-patterns.md <<'EOF'
---
title: Response Patterns
tags: [patterns]
---

# Response Patterns

Optional comparison material.
EOF

cat > message-example.md <<'EOF'
---
title: Message Example
tags: [example]
---

# Message Example

One local example for wording.
EOF

cat > retry-example.md <<'EOF'
---
title: Retry Example
tags: [example]
---

# Retry Example

One local retry note.
EOF

cat > background-notes.md <<'EOF'
---
title: Background Notes
tags: [notes]
---

# Background Notes

Supporting background for cited notes.
EOF
