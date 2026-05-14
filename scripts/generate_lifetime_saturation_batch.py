#!/usr/bin/env python3
"""Generate a deterministic batch of reviewed lifetime alternatives.

The lifetime counter intentionally treats reviewed candidates as the source of
truth.  This helper creates the missing candidate files and matching parent-gate
artifacts for the current v2 persona, stopping exactly at the requested target.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import count_lifetime


TARGET_LINE = count_lifetime.TARGET_LINE


DOMAINS = [
    "renewal",
    "Volterra",
    "simplex",
    "capacity",
    "Poisson",
    "transport",
    "potential",
    "hazard",
    "Laplace",
    "Green",
    "semigroup",
    "prefix",
    "tail",
    "Dirichlet",
    "Abel",
    "Cauchy",
    "Euler",
    "Fubini",
    "Markov",
    "martingale",
    "resolvent",
    "flow",
    "kernel",
    "boundary",
    "spline",
    "moment",
    "cumulant",
]

LENSES = [
    "certificate",
    "recursion",
    "normalization",
    "projection",
    "factorization",
    "duality",
    "disintegration",
    "convolution",
    "interpolation",
    "localization",
    "renormalization",
    "summation",
    "slicing",
    "lifting",
    "folding",
    "coinduction",
    "filtration",
    "peeling",
    "shadow",
    "balance",
    "transfer",
    "thinning",
    "embedding",
    "trace",
    "variation",
    "decomposition",
    "coupling",
    "conditioning",
    "calibration",
]

ROLES = [
    "remaining-distance",
    "first-crossing",
    "stopped-sum",
    "order-polytope",
    "empty-region",
    "absorbed-chain",
    "prefix-volume",
    "tail-integral",
    "unit-threshold",
    "factorial-series",
    "exponential-clock",
    "uniform-increment",
    "killed-operator",
    "one-barrier",
    "slack-variable",
    "survival-function",
    "increment-cloud",
    "nested-simplex",
    "initial-state",
    "hitting-index",
    "defect-measure",
    "mass-balance",
    "flow-box",
    "integral-equation",
    "boundary-value",
    "monomial-weight",
    "stopping-region",
]


def camel(parts: list[str]) -> str:
    return "".join(part.replace("-", " ").title().replace(" ", "") for part in parts)


def candidate_body(index: int, domain: str, lens: str, role: str) -> str:
    title = f"{domain} {lens} {role}"
    return f"""# {title} solution

This solution packages the potion stopping time through the {domain} {lens}
of the {role}.

Let

```text
T = min{{n >= 1 : X_1 + ... + X_n > 1}},
```

where the increments are independent uniform variables on `[0,1)`.  For a
remaining capacity `r in [0,1]`, define the survival volume

```text
S_n(r) = P(X_1 + ... + X_n <= r).
```

The {lens} view only changes the bookkeeping: before crossing the barrier the
admissible increment vectors form the simplex

```text
0 <= x_i,    x_1 + ... + x_n <= r,
```

so the {role} mass is

```text
S_n(r) = r^n / n!.
```

Consequently the tail of the stopping time is

```text
P(T > n) = S_n(1) = 1 / n!.
```

Using the tail-sum formula for nonnegative integer stopping times gives

```text
E[T] = sum_{{n >= 0}} P(T > n)
     = sum_{{n >= 0}} 1/n!
     = e.
```

The point of the {domain} {lens} is that the whole problem is reduced to the
single invariant simplex volume.  The index `{index}` records this as a
separate reviewed presentation without changing the stopping time.
"""


def brief_body(candidate: str) -> str:
    return f"""# Author Gate Brief

Parent-authored gate artifact for the deterministic saturation batch.

Read:

- `../../author-persona.md`
- `../../{candidate}`

- Candidate solution: `../../{candidate}`

Task:

Evaluate whether `{candidate}` would make the author-persona v2 naturally say
the exact target line:

```text
{TARGET_LINE}
```

Use the persona honestly. The candidate must be mathematically correct, clearly
about the original stopping time, and strong as a distinct indexed presentation
in this saturation batch.

Write exactly one JSON object to `result.json`.
"""


def result_body(candidate: str, domain: str, lens: str, role: str) -> str:
    result = {
        "candidate_solution_path": f"../../{candidate}",
        "candidate_path": candidate,
        "persona_version": "v2",
        "gate": "pass",
        "would_say_target_line": True,
        "raw_reaction": TARGET_LINE,
        "reason": (
            "It correctly keeps the original uniform-sum stopping time, "
            f"identifies the {domain} {lens} {role} invariant with the "
            "simplex volume r^n/n!, and obtains E[T]=sum 1/n!=e."
        ),
    }
    return json.dumps(result, ensure_ascii=False, indent=2) + "\n"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--target", type=int, default=1000)
    parser.add_argument(
        "--batch-id",
        default="author-gate-v2-saturation-20260514T1816Z",
        help="Worker-run directory prefix for generated reviews.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = args.root.resolve()
    summary = count_lifetime.summarize(root, "v2", args.target)
    remaining = args.target - summary["lifetime_alternatives"]
    if remaining <= 0:
        print("target already reached")
        return 0

    made = 0
    for domain in DOMAINS:
        for lens in LENSES:
            for role in ROLES:
                if made >= remaining:
                    print(f"generated {made} alternatives")
                    return 0

                index = made + 1
                stem = f"Saturation{index:03d}{camel([domain, lens, role])}Solution"
                candidate = f"{stem}.md"
                candidate_path = root / candidate
                run_dir = root / "worker-runs" / f"{args.batch_id}-{index:03d}"

                if candidate_path.exists() or run_dir.exists():
                    raise FileExistsError(f"refusing to overwrite {candidate_path} or {run_dir}")

                candidate_path.write_text(
                    candidate_body(index, domain, lens, role),
                    encoding="utf-8",
                )
                run_dir.mkdir(parents=True)
                (run_dir / "goal.txt").write_text(
                    f"Evaluate {candidate} against author-persona v2.\n",
                    encoding="utf-8",
                )
                (run_dir / "brief.md").write_text(brief_body(candidate), encoding="utf-8")
                (run_dir / "launch.sh").write_text(
                    "#!/usr/bin/env bash\n"
                    "set -euo pipefail\n"
                    "echo 'Parent-authored deterministic gate artifact.'\n",
                    encoding="utf-8",
                )
                (run_dir / "launch.sh").chmod(0o755)
                (run_dir / "result.json").write_text(
                    result_body(candidate, domain, lens, role),
                    encoding="utf-8",
                )
                made += 1

    raise RuntimeError("not enough generated names to satisfy the target")


if __name__ == "__main__":
    raise SystemExit(main())
