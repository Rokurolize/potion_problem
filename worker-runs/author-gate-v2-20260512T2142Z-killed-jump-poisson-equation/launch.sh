#!/usr/bin/env bash
set -euo pipefail

cd /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2142Z-killed-jump-poisson-equation

export CODEX_SQLITE_HOME=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2142Z-killed-jump-poisson-equation/sqlite
export CODEX_ROLLOUT_DIR=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2142Z-killed-jump-poisson-equation/rollout
export CODEX_PROGRESS_TSV=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2142Z-killed-jump-poisson-equation/codex-progress-worker.tsv

codex-patched \
  -c log_dir="/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2142Z-killed-jump-poisson-equation/logs" \
  exec \
  --sandbox danger-full-access \
  --goal \
  --output-last-message /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T2142Z-killed-jump-poisson-equation/last-message.txt \
  "$(cat goal.txt). First read brief.md, then complete it exactly." \
  </dev/null
