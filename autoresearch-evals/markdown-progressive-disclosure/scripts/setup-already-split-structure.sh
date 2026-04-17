#!/usr/bin/env bash
set -euo pipefail

cat > guide.md <<'EOF'
# Purpose
This guide helps operators start safely.
It keeps setup and policy context explicit.
It favors stable files over clever structure.
It should remain easy to scan.

# Setup
Short starting steps for operators.

Source: ./setup.md

# Policies
Rules and exceptions for daily operations.

Source: ./policies/index.md

# Quick Rules
- Check scope before editing files.
- Prefer explicit paths over guesses.
- Keep one entrypoint only.
- Avoid cosmetic structural churn.
- Validate links before finishing.
- Keep unrelated drafts outside the unit.
- Stop when the unit is already clear.
EOF

for i in $(seq 1 48); do printf '%s\n' "${i}" >/dev/null; done
cat > setup.md <<'EOF'
# Setup
EOF
for i in $(seq 1 48); do printf 'Setup step %03d\n' "$i" >> setup.md; done

mkdir -p policies
cat > policies/index.md <<'EOF'
# Policies
Rules stay explicit and reachable.

## Exceptions
Specific cases live in a separate child.

Source: ./exceptions.md
EOF

cat > policies/exceptions.md <<'EOF'
# Exceptions
EOF
for i in $(seq 1 26); do printf 'Policy exception %03d\n' "$i" >> policies/exceptions.md; done

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
