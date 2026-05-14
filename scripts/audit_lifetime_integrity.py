#!/usr/bin/env python3
"""Integrity audit for lifetime-candidate review artifacts."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


TARGET_LINE = "天晴れだ　生涯貴様を忘れることはないだろう"
REQUIRED_DOSSIER_FILES = {
    "candidate_hash.txt": "candidate_hash",
    "correctness_check.md": "correctness",
    "novelty_check.md": "novelty",
    "skeptical_review.md": "skeptical",
    "persona_review.md": "persona",
}


@dataclass
class Finding:
    result_path: str
    candidate_path: str
    status: str
    reasons: list[str] = field(default_factory=list)
    candidate_sha256: str | None = None
    review_sha256: str | None = None
    proof_family: str = ""
    novelty_family: str = ""

    @property
    def countable(self) -> bool:
        return self.status == "valid-countable"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"{path}: expected a JSON object")
    return data


def rel(root: Path, path: Path) -> str:
    try:
        return str(path.resolve().relative_to(root.resolve()))
    except ValueError:
        return str(path)


def resolve_candidate(root: Path, result_path: Path, data: dict[str, Any]) -> Path:
    raw = data.get("candidate_solution_path") or data.get("candidate_path") or ""
    candidate = Path(str(raw))
    if candidate.is_absolute():
        return candidate
    if str(raw).startswith("../"):
        return (result_path.parent / candidate).resolve()
    local_candidate = (result_path.parent / candidate).resolve()
    if local_candidate.exists():
        return local_candidate
    return (root / candidate).resolve()


def ngrams(text: str, n: int = 5) -> set[tuple[str, ...]]:
    words = re.findall(r"[A-Za-z0-9_]+|[\u3040-\u30ff\u3400-\u9fff]+", text.lower())
    if len(words) < n:
        return set()
    return {tuple(words[i : i + n]) for i in range(len(words) - n + 1)}


def jaccard(left: set[tuple[str, ...]], right: set[tuple[str, ...]]) -> float:
    if not left or not right:
        return 0.0
    return len(left & right) / len(left | right)


def has_required_review_reasoning(review_dir: Path) -> list[str]:
    reasons: list[str] = []
    for filename, label in REQUIRED_DOSSIER_FILES.items():
        path = review_dir / filename
        if not path.exists():
            reasons.append(f"missing_{label}_dossier")

    correctness = (review_dir / "correctness_check.md")
    if correctness.exists():
        text = correctness.read_text(encoding="utf-8")
        lower_text = text.lower()
        required = [
            "t=min{n>=1",
            "independent uniform",
            "p(t>n)",
            "tail-sum",
            "no hidden change",
        ]
        for needle in required:
            if needle not in lower_text:
                reasons.append(f"correctness_missing_{needle}")

    novelty = review_dir / "novelty_check.md"
    if novelty.exists():
        text = novelty.read_text(encoding="utf-8")
        if len(re.findall(r"Solution\.md", text)) < 10:
            reasons.append("novelty_compares_fewer_than_10_candidates")
        if "not merely a rename" not in text:
            reasons.append("novelty_missing_rename_assessment")

    skeptical = review_dir / "skeptical_review.md"
    if skeptical.exists():
        text = skeptical.read_text(encoding="utf-8").lower()
        if text.count("objection") < 3:
            reasons.append("skeptical_review_has_fewer_than_3_objections")

    persona = review_dir / "persona_review.md"
    if persona.exists():
        text = persona.read_text(encoding="utf-8")
        lower_text = text.lower()
        if "author-persona v2" not in lower_text or "decision" not in lower_text:
            reasons.append("persona_review_missing_decision")

    return reasons


def audit_one(root: Path, result_path: Path) -> Finding:
    reasons: list[str] = []
    try:
        data = read_json(result_path)
    except Exception as exc:
        return Finding(str(result_path), "", "rejected", [f"invalid_result_json:{exc}"])

    candidate_path = resolve_candidate(root, result_path, data)
    candidate_rel = rel(root, candidate_path)
    result_rel = rel(root, result_path)
    review_dir = result_path.parent
    review_rel = rel(root, review_dir)

    if re.match(r"Saturation\d+.*Solution\.md$", candidate_path.name):
        reasons.append("saturation_candidate_filename")
    if "author-gate-v2-saturation" in review_rel:
        reasons.append("saturation_worker_run_path")
    if "negative-fixtures" in review_rel and not str(data.get("candidate_solution_path") or "").startswith("."):
        existing_candidate = root / str(data.get("candidate_path") or "")
        if existing_candidate.exists():
            reasons.append("duplicate_review_of_existing_candidate")

    candidate_text = ""
    candidate_hash: str | None = None
    if not candidate_path.exists():
        reasons.append("candidate_file_missing")
    elif not candidate_path.is_file():
        reasons.append("candidate_path_not_regular_file")
    else:
        candidate_text = candidate_path.read_text(encoding="utf-8")
        candidate_hash = sha256(candidate_path)
        if (
            "The index" in candidate_text
            and "records this as a separate reviewed presentation" in candidate_text
        ):
            reasons.append("saturation_index_phrase")
        if "domain/lens/role" in candidate_text or "single invariant simplex volume" in candidate_text:
            reasons.append("template_substitution_or_simplex_overlay")
        if (
            re.search(r"admissible\s+increment\s+vectors\s+form\s+the\s+simplex", candidate_text)
            and "only changes the bookkeeping" in candidate_text
        ):
            reasons.append("renamed_simplex_tail_sum_skeleton")

    launch = review_dir / "launch.sh"
    if launch.exists() and "Parent-authored deterministic gate artifact" in launch.read_text(encoding="utf-8"):
        reasons.append("deterministic_parent_launch")

    brief = review_dir / "brief.md"
    if brief.exists() and "deterministic saturation batch" in brief.read_text(encoding="utf-8"):
        reasons.append("deterministic_saturation_brief")

    gate_pass = data.get("gate") == "pass"
    target_pass = data.get("would_say_target_line") is True and TARGET_LINE in str(data.get("raw_reaction", ""))
    if gate_pass and target_pass and not (review_dir / "persona_review.md").exists():
        reasons.append("auto_pass_without_persona_review")

    reasons.extend(has_required_review_reasoning(review_dir))

    declared_hash = str(data.get("candidate_sha256") or "").strip()
    hash_file = review_dir / "candidate_hash.txt"
    hash_text = hash_file.read_text(encoding="utf-8").strip() if hash_file.exists() else ""
    expected_hash = declared_hash or hash_text
    if not expected_hash:
        reasons.append("missing_candidate_hash")
    elif candidate_hash and expected_hash != candidate_hash:
        reasons.append("candidate_hash_mismatch")

    required_paths = [
        "correctness_check_path",
        "novelty_check_path",
        "skeptical_review_path",
        "persona_review_path",
    ]
    for key in required_paths:
        raw = data.get(key)
        if not raw:
            reasons.append(f"result_missing_{key}")
        else:
            path = (root / str(raw)).resolve()
            if not path.exists():
                reasons.append(f"result_broken_{key}")

    if data.get("integrity_status") not in (None, "valid-countable", "rejected"):
        reasons.append("unknown_integrity_status")

    if data.get("integrity_status") == "valid-countable" and not gate_pass:
        reasons.append("valid_countable_but_gate_not_pass")
    if data.get("integrity_status") == "valid-countable" and not target_pass:
        reasons.append("valid_countable_without_target_line")

    status = "valid-countable" if not reasons and gate_pass and target_pass else "rejected"
    return Finding(
        result_path=result_rel,
        candidate_path=candidate_rel,
        status=status,
        reasons=reasons,
        candidate_sha256=candidate_hash,
        review_sha256=sha256(result_path) if result_path.exists() else None,
        proof_family=str(data.get("proof_family") or ""),
        novelty_family=str(data.get("novelty_family") or ""),
    )


def discover_result_paths(root: Path) -> list[Path]:
    return sorted((root / "worker-runs").glob("*/result.json"))


def apply_similarity_checks(root: Path, findings: list[Finding]) -> None:
    seen: list[tuple[Finding, set[tuple[str, ...]]]] = []
    for finding in findings:
        if not finding.countable:
            continue
        candidate_path = root / finding.candidate_path
        grams = ngrams(candidate_path.read_text(encoding="utf-8"))
        for previous, previous_grams in seen:
            if jaccard(grams, previous_grams) >= 0.82:
                finding.status = "rejected"
                finding.reasons.append(f"near_duplicate_of:{previous.candidate_path}")
                break
        if finding.countable:
            seen.append((finding, grams))


def audit_root(root: Path) -> dict[str, Any]:
    findings = [audit_one(root, result_path) for result_path in discover_result_paths(root)]
    apply_similarity_checks(root, findings)
    hard_failures = [
        reason
        for finding in findings
        for reason in finding.reasons
        if reason.startswith("saturation_")
        or reason in {
            "deterministic_parent_launch",
            "deterministic_saturation_brief",
            "renamed_simplex_tail_sum_skeleton",
        }
    ]
    return {
        "summary": {
            "total_reviews": len(findings),
            "valid_countable": sum(1 for finding in findings if finding.countable),
            "rejected": sum(1 for finding in findings if not finding.countable),
            "hard_failure_count": len(hard_failures),
        },
        "findings": [finding.__dict__ for finding in findings],
    }


def audit_negative_fixtures(root: Path, fixtures: Path) -> dict[str, Any]:
    fixture_results = []
    for result_path in sorted(fixtures.glob("*/result.json")):
        finding = audit_one(root, result_path)
        fixture_results.append(
            {
                "fixture": rel(root, result_path.parent),
                "status": finding.status,
                "reasons": finding.reasons,
                "passed_negative_check": finding.status == "rejected" and bool(finding.reasons),
            }
        )
    return {
        "summary": {
            "fixtures": len(fixture_results),
            "failed_as_expected": sum(1 for item in fixture_results if item["passed_negative_check"]),
        },
        "fixtures": fixture_results,
    }


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--strict", action="store_true")
    parser.add_argument("--negative-fixtures", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--format", choices=("json", "text"), default="json")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    root = args.root.resolve()
    if args.negative_fixtures:
        report = audit_negative_fixtures(root, args.negative_fixtures.resolve())
        ok = report["summary"]["fixtures"] > 0 and (
            report["summary"]["fixtures"] == report["summary"]["failed_as_expected"]
        )
    else:
        report = audit_root(root)
        ok = report["summary"]["hard_failure_count"] == 0

    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")

    if args.format == "json":
        print(json.dumps(report, ensure_ascii=False, indent=2))
    else:
        summary = report["summary"]
        for key, value in summary.items():
            print(f"{key}: {value}")

    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
