#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
exec python3 scripts/count_lifetime.py --target 1000 --require-target --format text
