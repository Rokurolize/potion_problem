#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
export CODEX_SQLITE_HOME="$PWD/sqlite"
export CODEX_ROLLOUT_DIR="$PWD/rollout"
export CODEX_PROGRESS_TSV="$PWD/codex-progress-worker.tsv"
mkdir -p "$CODEX_SQLITE_HOME" "$CODEX_ROLLOUT_DIR" "$PWD/logs"

codex-patched -c "log_dir=$PWD/logs" exec \
  --sandbox danger-full-access \
  --goal \
  --output-last-message "$PWD/last-message.txt" \
  "$(cat goal.txt). First read brief.md, then complete it exactly." \
  </dev/null 2>&1 | tee "$PWD/logs/session.log"
