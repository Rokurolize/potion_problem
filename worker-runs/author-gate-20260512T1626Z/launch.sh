#!/usr/bin/env bash
set -euo pipefail

cd /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-20260512T1626Z

export CODEX_SQLITE_HOME=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-20260512T1626Z/sqlite
export CODEX_ROLLOUT_DIR=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-20260512T1626Z/rollout
export CODEX_PROGRESS_TSV=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-20260512T1626Z/codex-progress-worker.tsv

codex-patched \
  -c log_dir="/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-20260512T1626Z/logs" \
  exec \
  --sandbox danger-full-access \
  --goal \
  --output-last-message /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-20260512T1626Z/last-message.txt \
  "$(cat goal.txt). First read brief.md, then complete it exactly."
