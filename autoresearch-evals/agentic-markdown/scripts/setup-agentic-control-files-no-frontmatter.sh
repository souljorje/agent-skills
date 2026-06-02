#!/usr/bin/env bash
set -euo pipefail

cat > SKILL.md <<'EOF'
# Skill: Tiny Agent Workflow

This file explains the workflow for an agent skill.

## Steps
Short procedural detail stays inline.
EOF

cat > AGENTS.md <<'EOF'
# Local Rules

- Keep changes scoped.
- Do not add YAML frontmatter here.
EOF

cat > CLAUDE.md <<'EOF'
# Claude Notes

These are agent-facing instructions.
EOF
