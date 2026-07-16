#!/usr/bin/env bash
# Sync shared content/lessons.json → Xcode Resources + web content.js (+ Android assets)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
python3 "$ROOT/scripts/sync_content.py"
echo "Edit content/lessons.json only, then re-run: ./scripts/sync-content.sh"
