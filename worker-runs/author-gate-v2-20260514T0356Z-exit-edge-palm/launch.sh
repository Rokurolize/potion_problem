#!/usr/bin/env bash
set -euo pipefail

run_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export CODEX_SQLITE_HOME="$run_dir/sqlite-home"
export CODEX_ROLLOUT_DIR="$run_dir/rollout"
export CODEX_PROGRESS_TSV="$run_dir/codex-progress-worker.tsv"
mkdir -p "$CODEX_SQLITE_HOME" "$CODEX_ROLLOUT_DIR" "$run_dir/logs"

if [[ ! -f "$CODEX_PROGRESS_TSV" ]]; then
  printf 'ts_utc\tactor\tstatus\tartifact\tevidence\tnext\n' > "$CODEX_PROGRESS_TSV"
fi

codex-patched exec --goal \
  --cd "$run_dir" \
  --output-last-message "$run_dir/last-message.txt" \
  -- "$(cat "$run_dir/goal.txt")"
