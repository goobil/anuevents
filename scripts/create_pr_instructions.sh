#!/usr/bin/env bash
# Creates a branch, commits the docs changes, and pushes to origin, then opens a PR using gh (GitHub CLI) if available.
# Run from the repo root: ./scripts/create_pr_instructions.sh

set -euo pipefail

BRANCH_NAME="feature/docs/implementation-phases"
COMMIT_MSG="docs: add implementation phases and phase docs"

# 1) Create branch
git checkout -b "$BRANCH_NAME"

# 2) Add files (they're already in the working tree)
git add docs/phase-1-mvp.md docs/phase-2-organizer-monetization.md docs/phase-3-scale-social-web.md docs/cross-platform-design.md event_app_2025_wireframes_flows_firestore_schema.md

# 3) Commit
git commit -m "$COMMIT_MSG"

# 4) Push
git push -u origin "$BRANCH_NAME"

# 5) Create PR (optional): requires GitHub CLI 'gh'
if command -v gh >/dev/null 2>&1; then
  gh pr create --title "$COMMIT_MSG" --body "Add implementation phases and supporting phase docs." --base master
else
  echo "GitHub CLI not found. Visit your repo and create a PR from branch '$BRANCH_NAME' into 'master' or the default branch."
fi

echo "Done. Branch: $BRANCH_NAME"