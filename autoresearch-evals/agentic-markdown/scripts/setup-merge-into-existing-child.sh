#!/usr/bin/env bash
set -euo pipefail

cat > team-guide.md <<'EOF'
---
title: Team Guide
tags: [team, guide]
---

# Team Guide

This guide keeps weekly operations explicit and easy to scan.

## Weekly Operations
Day-to-day weekly work lives in one child.
Source: [Weekly Operations](./weekly-operations.md)

## Quick Rules

- Keep one child per owned topic.
- Reuse good public children.
- Avoid duplicate truth in the parent.
EOF

cat > weekly-operations.md <<'EOF'
---
title: Weekly Operations
tags: [weekly, operations]
---

# Weekly Operations

Weekly operating steps for the team.

## Existing Checklist

- Review queue health every Monday.
- Confirm staff rotation coverage.
EOF
