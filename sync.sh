#!/bin/bash
# Sync personal skills: pull latest commits and refresh symlinks.
#
# Usage: ./sync.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Pulling latest..."
git -C "$REPO_DIR" pull --ff-only

echo ""
"$REPO_DIR/setup.sh"
