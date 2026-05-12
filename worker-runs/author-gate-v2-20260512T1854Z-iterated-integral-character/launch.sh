#!/usr/bin/env bash
set -euo pipefail

cd /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T1854Z-iterated-integral-character

export CODEX_SQLITE_HOME=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T1854Z-iterated-integral-character/sqlite
export CODEX_ROLLOUT_DIR=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T1854Z-iterated-integral-character/rollout
export CODEX_PROGRESS_TSV=/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T1854Z-iterated-integral-character/codex-progress-worker.tsv

codex-patched \
  -c log_dir="/home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T1854Z-iterated-integral-character/logs" \
  exec \
  --sandbox danger-full-access \
  --goal \
  --output-last-message /home/roku/src/Rokurolize/potion_problem/worker-runs/author-gate-v2-20260512T1854Z-iterated-integral-character/last-message.txt \
  "$(cat goal.txt). First read brief.md, then complete it exactly." \
  </dev/null
