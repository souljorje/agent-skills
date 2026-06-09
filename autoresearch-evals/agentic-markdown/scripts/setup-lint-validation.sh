#!/usr/bin/env bash
set -euo pipefail
# Materializes a small wiki with deliberate structural defects for the
# lint-validation brief: a Source not under a section, a broken inline link,
# and a Source pointing at a missing entrypoint.
mkdir -p guide

cat > index.md <<'EOF'
---
title: Service Guide
tags: [guide]
---

# Service Guide

Overview of the service and how its docs are organized.

Source: [Setup](./guide/setup.md)

See the [historical notes](./notes-that-do-not-exist.md) for background.

## Operations

Day-to-day operational tasks.
Source: [Operations](./guide/ops.md)
EOF

cat > guide/setup.md <<'EOF'
---
title: Setup
tags: [guide]
---

# Setup

How to set up the service for the first time.
EOF
