#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
export CODEX_SQLITE_HOME="$PWD/sqlite-home"
export CODEX_ROLLOUT_DIR="$PWD/rollout"
export CODEX_PROGRESS_TSV="$PWD/codex-progress-worker.tsv"
mkdir -p "$CODEX_SQLITE_HOME" "$CODEX_ROLLOUT_DIR" logs
if [ ! -f "$CODEX_PROGRESS_TSV" ]; then
  printf 'ts_utc\tactor\tstatus\tartifact\tevidence\tnext\n' > "$CODEX_PROGRESS_TSV"
fi

codex-patched exec --goal --output-last-message last-message.txt -- "$(cat goal.txt)

Detailed instructions are in brief.md. Read brief.md first and comply with it exactly."
