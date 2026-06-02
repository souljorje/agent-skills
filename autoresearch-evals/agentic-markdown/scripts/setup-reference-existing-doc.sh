#!/usr/bin/env bash
set -euo pipefail

cat > playbook.md <<'EOF'
---
title: Support Playbook
tags: [support, playbook]
---

# Support Playbook

This playbook uses shared terminology and should reference owned definitions instead of copying them.

## Workflow
Core steps live in an owned child.
Source: [Workflow](./workflow.md)

## Dependencies

| Document | Purpose |
|---|---|
| [Glossary](./glossary.md) | Defines required terminology used in this playbook |
EOF

cat > workflow.md <<'EOF'
---
title: Workflow
tags: [workflow]
---

# Workflow

Owned steps for the support playbook.
EOF

cat > glossary.md <<'EOF'
---
title: Glossary
tags: [glossary]
---

# Glossary

## Escalation Tier

Escalation tier means the priority band used to route urgent support work.

## Verified Identity

Verified identity means the requester passed the required identity checks.
EOF
