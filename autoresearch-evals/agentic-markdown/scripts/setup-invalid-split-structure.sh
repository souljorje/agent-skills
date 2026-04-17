#!/usr/bin/env bash
set -euo pipefail

mkdir -p ops-guide

cat > ops-guide.md <<'EOF'
# Purpose
This unit covers billing and incident operations.
It should keep one explicit starting file.
Each child should have one clear parent.
Validation should resolve graph issues first.

# Billing
Short billing overview.

Source: ./billing.md

# Incident Response
EOF
for i in $(seq 1 18); do printf 'Inline incident %03d\n' "$i" >> ops-guide.md; done
cat >> ops-guide.md <<'EOF'

Source: ./incident.md

# FAQ
Short answers for operators.

Source: ./faq.md

# Missing Topic
Placeholder reference for a topic that is absent.

Source: ./missing-topic.md
EOF

for i in $(seq 1 20); do printf 'Alternate entrypoint line %02d\n' "$i"; done > ops-guide/index.md

cat > billing.md <<'EOF'
# Billing
EOF
for i in $(seq 1 70); do printf 'Billing note %03d\n' "$i" >> billing.md; done
printf 'Source: ./common.md\n' >> billing.md

cat > incident.md <<'EOF'
# Incident Response
EOF
for i in $(seq 1 75); do printf 'Incident step %03d\n' "$i" >> incident.md; done

cat > faq.md <<'EOF'
# FAQ
EOF
for i in $(seq 1 30); do printf 'FAQ line %03d\n' "$i" >> faq.md; done
printf 'Source: ./common.md\n' >> faq.md

cat > common.md <<'EOF'
# Shared Notes
EOF
for i in $(seq 1 18); do printf 'Common line %03d\n' "$i" >> common.md; done
printf 'Source: ./billing.md\n' >> common.md

cat > refund-exceptions.md <<'EOF'
# Refund Exceptions
EOF
for i in $(seq 1 40); do printf 'Refund exception %03d\n' "$i" >> refund-exceptions.md; done
