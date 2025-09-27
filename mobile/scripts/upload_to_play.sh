#!/usr/bin/env bash
# Simple wrapper to run the Python upload script
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY_SCRIPT="$SCRIPT_DIR/upload_to_play.py"

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 /path/to/service-account.json /path/to/app-release.aab [track] [rollout]"
  echo "Example: $0 ~/service-account.json ../build/app/outputs/bundle/release/app-release.aab internal"
  exit 2
fi

SERVICE_ACCOUNT="$1"
AAB_PATH="$2"
TRACK="${3:-internal}"
ROLLOUT="${4:-}"

python3 "$PY_SCRIPT" --service-account "$SERVICE_ACCOUNT" --aab "$AAB_PATH" --track "$TRACK" ${ROLLOUT:+--rollout $ROLLOUT}
