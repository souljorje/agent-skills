#!/usr/bin/env bash
set -euo pipefail

cat > guide.md <<'EOF'
---
title: Operations Guide
tags: [operations, guide]
---

# Operations Guide

This guide helps operators start safely.
It keeps setup and policy context explicit.

## Setup
Short starting steps for operators.
Source: [Setup](./setup.md)

## Policies
Rules and exceptions for daily operations.
Source: [Policies](./policies/index.md)

## Quick Rules
- Check scope before editing files.
- Prefer explicit paths over guesses.
- Keep one entrypoint only.
- Avoid cosmetic structural churn.
- Validate links before finishing.
- Keep unrelated drafts outside the unit.
- Stop when the unit is already clear.

## Dependencies

| Document | Purpose |
|---|---|
| [Glossary](./shared-glossary.md) | Defines operator terms used by this guide |

## Related

| Document | Purpose |
|---|---|
| [Audit Patterns](./audit-patterns.md) | Optional comparison patterns for operators |
EOF

cat > setup.md <<'EOF'
---
title: Setup
tags: [setup]
---

# Setup

Setup steps for operators.
EOF
for i in $(seq 1 48); do printf 'Setup step %03d\n' "$i" >> setup.md; done

mkdir -p policies
cat > policies/index.md <<'EOF'
---
title: Policies
tags: [policies]
---

# Policies

Rules stay explicit and reachable.

## Exceptions
Specific cases live in a separate child.
Source: [Exceptions](./exceptions.md)
EOF

cat > policies/exceptions.md <<'EOF'
---
title: Exceptions
tags: [policies, exceptions]
---

# Exceptions

Policy exceptions for operator decisions.
EOF
for i in $(seq 1 26); do printf 'Policy exception %03d\n' "$i" >> policies/exceptions.md; done

cat > shared-glossary.md <<'EOF'
---
title: Shared Glossary
tags: [glossary]
---

# Shared Glossary

Definitions for shared operator terms.
EOF

cat > audit-patterns.md <<'EOF'
---
title: Audit Patterns
tags: [audit]
---

# Audit Patterns

Optional review patterns.
EOF

cat > draft.md <<'EOF'
rewrite guide maybe
old setup note
drop this heading
temp checklist
rename later maybe
rough policy bullets
draft branch idea
stale sentence one
stale sentence two
todo fix voice
not public
keep out of unit
EOF
