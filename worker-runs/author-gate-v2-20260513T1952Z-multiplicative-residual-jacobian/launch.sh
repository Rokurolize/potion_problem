#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export CODEX_SQLITE_HOME="$RUN_DIR/sqlite-home"
export CODEX_ROLLOUT_DIR="$RUN_DIR/rollout"
export CODEX_PROGRESS_TSV="$RUN_DIR/codex-progress-worker.tsv"

mkdir -p "$CODEX_SQLITE_HOME" "$CODEX_ROLLOUT_DIR" "$RUN_DIR/logs"

if [[ ! -f "$CODEX_PROGRESS_TSV" ]]; then
  printf 'ts_utc\tactor\tstatus\tartifact\tevidence\tnext\n' > "$CODEX_PROGRESS_TSV"
fi

cd "$RUN_DIR"

codex-patched exec --goal \
  --cd "$RUN_DIR" \
  --output-last-message "$RUN_DIR/last-message.txt" \
  -- "$(cat "$RUN_DIR/goal.txt")"
