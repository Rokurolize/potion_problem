#!/usr/bin/env python3
"""Count potion-problem alternative-solution review results.

The loop stores one reviewed candidate per worker run under
``worker-runs/<run-id>/result.json``.  This script aggregates those results and
deduplicates repeated reviews of the same candidate solution.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


TARGET_LINE = "天晴れだ　生涯貴様を忘れることはないだろう"


@dataclass(frozen=True)
class Review:
    result_path: Path
    candidate_path: str
    persona_version: str
    gate: str
    would_say_target_line: bool
    raw_reaction: str
    prompt_injection_found: bool

    @property
    def lifetime(self) -> bool:
        """A strict "生涯" hit requires both the boolean and the actual phrase."""
        return self.would_say_target_line and TARGET_LINE in self.raw_reaction


def read_json(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"{path}: expected a JSON object")
    return data


def current_persona_version(root: Path) -> str | None:
    persona = root / "author-persona.md"
    if not persona.exists():
        return None
    first_line = persona.read_text(encoding="utf-8").splitlines()[0:1]
    if not first_line:
        return None
    match = re.search(r"\bv(\d+)\b", first_line[0])
    return f"v{match.group(1)}" if match else None


def candidate_from_brief(result_path: Path) -> str:
    brief = result_path.with_name("brief.md")
    if not brief.exists():
        return str(result_path.parent)

    for line in brief.read_text(encoding="utf-8").splitlines():
        match = re.match(r"\s*-\s*Candidate solution:\s*`?([^`]+?)`?\s*$", line)
        if match:
            return match.group(1)
    return str(result_path.parent)


def load_review(result_path: Path) -> Review:
    data = read_json(result_path)
    candidate = data.get("candidate_solution_path") or candidate_from_brief(result_path)
    raw_reaction = data.get("raw_reaction", "")
    return Review(
        result_path=result_path,
        candidate_path=str(candidate),
        persona_version=str(data.get("persona_version") or "v1"),
        gate=str(data.get("gate", "")),
        would_say_target_line=bool(data.get("would_say_target_line", False)),
        raw_reaction=raw_reaction if isinstance(raw_reaction, str) else "",
        prompt_injection_found=bool(data.get("prompt_injection_found", False)),
    )


def discover_reviews(root: Path) -> list[Review]:
    reviews: list[Review] = []
    for result_path in sorted((root / "worker-runs").glob("*/result.json")):
        try:
            reviews.append(load_review(result_path))
        except Exception as exc:
            print(f"warning: skipping {result_path}: {exc}", file=sys.stderr)
    return reviews


def latest_by_candidate(reviews: list[Review]) -> dict[str, Review]:
    latest: dict[str, Review] = {}
    for review in sorted(reviews, key=lambda item: str(item.result_path)):
        latest[review.candidate_path] = review
    return latest


def summarize(root: Path, persona_version: str | None, target: int) -> dict[str, Any]:
    reviews = discover_reviews(root)
    if persona_version is None:
        persona_version = current_persona_version(root)

    scoped = [
        review
        for review in reviews
        if persona_version is None or review.persona_version == persona_version
    ]
    latest = latest_by_candidate(scoped)
    latest_reviews = list(latest.values())
    lifetime_latest = [review for review in latest_reviews if review.lifetime]

    all_lifetime = [review for review in reviews if review.lifetime]
    scoped_lifetime = [review for review in scoped if review.lifetime]

    return {
        "target_lifetime_count": target,
        "target_reached": len(lifetime_latest) >= target,
        "target_remaining": max(target - len(lifetime_latest), 0),
        "persona_version": persona_version,
        "total_alternatives": len(latest_reviews),
        "lifetime_alternatives": len(lifetime_latest),
        "total_reviews": len(scoped),
        "lifetime_reviews": len(scoped_lifetime),
        "all_reviews": len(reviews),
        "all_lifetime_reviews": len(all_lifetime),
        "target_line": TARGET_LINE,
        "alternatives": [
            {
                "candidate_path": review.candidate_path,
                "result_path": str(review.result_path),
                "persona_version": review.persona_version,
                "gate": review.gate,
                "lifetime": review.lifetime,
                "prompt_injection_found": review.prompt_injection_found,
            }
            for review in latest_reviews
        ],
    }


def summarize_strict(
    root: Path,
    persona_version: str | None,
    target: int,
    require_integrity: bool = False,
) -> dict[str, Any]:
    import audit_lifetime_integrity

    summary = summarize(root, persona_version, target)
    audit_report = audit_lifetime_integrity.audit_root(root)
    valid_by_result = {
        item["result_path"]: item
        for item in audit_report["findings"]
        if item["status"] == "valid-countable"
    }
    strict_alternatives = [
        item
        for item in summary["alternatives"]
        if str(Path(item["result_path"]).resolve().relative_to(root)) in valid_by_result
        and item["lifetime"]
    ]
    summary.update(
        {
            "strict": True,
            "integrity_summary": audit_report["summary"],
            "total_alternatives_non_strict": summary["total_alternatives"],
            "lifetime_alternatives_non_strict": summary["lifetime_alternatives"],
            "total_alternatives": len(strict_alternatives),
            "lifetime_alternatives": len(strict_alternatives),
            "target_reached": len(strict_alternatives) >= target,
            "target_remaining": max(target - len(strict_alternatives), 0),
            "alternatives": strict_alternatives,
        }
    )
    if require_integrity and audit_report["summary"]["hard_failure_count"] != 0:
        summary["integrity_required_but_failed"] = True
    return summary


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument(
        "--persona-version",
        help="Persona version to count. Defaults to the version in author-persona.md.",
    )
    parser.add_argument("--target", type=int, default=1000)
    parser.add_argument(
        "--require-target",
        action="store_true",
        help="Exit 1 unless lifetime_alternatives reaches --target.",
    )
    parser.add_argument(
        "--format",
        choices=("json", "text"),
        default="json",
        help="Output format.",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Count only candidates that pass the integrity audit.",
    )
    parser.add_argument(
        "--require-integrity",
        action="store_true",
        help="With --strict, exit 1 if the integrity audit has hard failures.",
    )
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    root = args.root.resolve()
    if args.strict:
        summary = summarize_strict(root, args.persona_version, args.target, args.require_integrity)
    else:
        summary = summarize(root, args.persona_version, args.target)

    if args.format == "json":
        print(json.dumps(summary, ensure_ascii=False, indent=2, sort_keys=True))
    else:
        print(f"persona_version: {summary['persona_version']}")
        print(f"total_alternatives: {summary['total_alternatives']}")
        print(f"lifetime_alternatives: {summary['lifetime_alternatives']}")
        print(f"target_lifetime_count: {summary['target_lifetime_count']}")
        print(f"target_remaining: {summary['target_remaining']}")
        print(f"target_reached: {str(summary['target_reached']).lower()}")

    if args.require_integrity and summary.get("integrity_required_but_failed"):
        return 1
    if args.require_target and not summary["target_reached"]:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
