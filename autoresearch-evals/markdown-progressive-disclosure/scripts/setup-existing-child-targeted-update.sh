#!/usr/bin/env bash
set -euo pipefail

cat > team-handbook.md <<'EOF'
# Purpose
This handbook supports onboarding and support rotation.
It should stay explicit and easy to scan.
Existing good children should be reused.
Updates should be targeted, not disruptive.

# Weekly Operations
Short weekly operating summary.

Source: ./ops.md

# Escalation Policies
EOF
for i in $(seq 1 62); do printf 'Escalation policy %03d\n' "$i" >> team-handbook.md; done
cat >> team-handbook.md <<'EOF'

# Quick Rules
- Reuse existing good children.
- Keep heading order stable.
- Rename vague files only if validation requires it.
- Avoid duplicate topic files.
- Keep the entrypoint scannable.
- Validate every source path.
- Leave unrelated notes outside the unit.
- Stop after the requested change is complete.

# FAQ
EOF
for i in $(seq 1 14); do printf 'FAQ %03d\n' "$i" >> team-handbook.md; done

cat > ops.md <<'EOF'
# Weekly Operations
EOF
for i in $(seq 1 105); do printf 'Weekly step %03d\n' "$i" >> ops.md; done

cat > notes.md <<'EOF'
meeting recap
staffing note
random todo
not part of unit
rough escalation idea
sidebar note
follow-up later
old team comment
unrelated sentence one
unrelated sentence two
parking lot
possible rename
temporary note
ops sync detail
do not publish
leave outside graph
EOF
