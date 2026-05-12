#!/usr/bin/env bash
set -euo pipefail

cd /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2045Z-laplace-renewal

export CODEX_SQLITE_HOME=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2045Z-laplace-renewal/sqlite
export CODEX_ROLLOUT_DIR=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2045Z-laplace-renewal/rollout
export CODEX_PROGRESS_TSV=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2045Z-laplace-renewal/codex-progress-worker.tsv

codex-patched \
  -c log_dir="/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2045Z-laplace-renewal/logs" \
  exec \
  --sandbox danger-full-access \
  --goal \
  --output-last-message /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2045Z-laplace-renewal/last-message.txt \
  "$(cat goal.txt). First read brief.md, then complete it exactly." \
  </dev/null
