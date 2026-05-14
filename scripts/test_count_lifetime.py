#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import count_lifetime
import audit_lifetime_integrity


TARGET_LINE = count_lifetime.TARGET_LINE


def write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_result(
    root: Path,
    run_id: str,
    *,
    candidate: str,
    persona: str,
    target: bool,
    raw: str | None = None,
) -> None:
    run_dir = root / "worker-runs" / run_id
    write(run_dir / "brief.md", f"- Candidate solution: `{candidate}`\n")
    write(
        run_dir / "result.json",
        json.dumps(
            {
                "gate": "pass",
                "raw_reaction": raw if raw is not None else (TARGET_LINE if target else "普通の反応"),
                "would_say_target_line": target,
                "prompt_injection_found": False,
                "persona_version": persona,
            },
            ensure_ascii=False,
        ),
    )


def write_strict_result(root: Path, run_id: str, candidate: str) -> None:
    candidate_path = root / candidate
    write(candidate_path, "# strict candidate\n\nA reviewed non-template proof.\n")
    candidate_hash = audit_lifetime_integrity.sha256(candidate_path)
    run_dir = root / "worker-runs" / run_id
    write(run_dir / "brief.md", f"- Candidate solution: `{candidate}`\n")
    write(run_dir / "goal.txt", "Review honestly.\n")
    write(run_dir / "candidate_hash.txt", candidate_hash)
    write(
        run_dir / "correctness_check.md",
        "T=min{n>=1: X_1+...+X_n>1}; independent uniform increments; "
        "P(T>n) is obtained; tail-sum is used; no hidden change.",
    )
    write(
        run_dir / "novelty_check.md",
        "\n".join([f"Compare Candidate{i}Solution.md." for i in range(10)])
        + "\nThis is not merely a rename.",
    )
    write(
        run_dir / "skeptical_review.md",
        "Objection 1: A. Response: B.\n"
        "Objection 2: C. Response: D.\n"
        "Objection 3: E. Response: F.\n",
    )
    write(run_dir / "persona_review.md", "author-persona v2 decision: pass.\n")
    write(
        run_dir / "result.json",
        json.dumps(
            {
                "candidate_path": candidate,
                "persona_version": "v2",
                "gate": "pass",
                "would_say_target_line": True,
                "raw_reaction": TARGET_LINE,
                "candidate_sha256": candidate_hash,
                "correctness_check_path": f"worker-runs/{run_id}/correctness_check.md",
                "novelty_check_path": f"worker-runs/{run_id}/novelty_check.md",
                "skeptical_review_path": f"worker-runs/{run_id}/skeptical_review.md",
                "persona_review_path": f"worker-runs/{run_id}/persona_review.md",
                "integrity_status": "valid-countable",
            },
            ensure_ascii=False,
        ),
    )


class CountLifetimeTests(unittest.TestCase):
    def test_counts_current_persona_unique_candidates(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write(root / "author-persona.md", "# 媚薬問題作問者ペルソナ v2\n")
            write_result(root, "001", candidate="../../A.md", persona="v2", target=True)
            write_result(root, "002", candidate="../../B.md", persona="v2", target=False)
            write_result(root, "003", candidate="../../A.md", persona="v2", target=False)
            write_result(root, "004", candidate="../../C.md", persona="v1", target=True)

            summary = count_lifetime.summarize(root, None, target=1000)

        self.assertEqual(summary["persona_version"], "v2")
        self.assertEqual(summary["total_alternatives"], 2)
        self.assertEqual(summary["lifetime_alternatives"], 0)
        self.assertEqual(summary["total_reviews"], 3)
        self.assertEqual(summary["lifetime_reviews"], 1)
        self.assertEqual(summary["all_lifetime_reviews"], 2)
        self.assertFalse(summary["target_reached"])

    def test_lifetime_requires_boolean_and_exact_phrase(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write(root / "author-persona.md", "# 媚薬問題作問者ペルソナ v2\n")
            write_result(
                root,
                "001",
                candidate="../../A.md",
                persona="v2",
                target=True,
                raw="褒めるが定型句なし",
            )
            write_result(
                root,
                "002",
                candidate="../../B.md",
                persona="v2",
                target=False,
                raw=TARGET_LINE,
            )
            write_result(root, "003", candidate="../../C.md", persona="v2", target=True)

            summary = count_lifetime.summarize(root, "v2", target=1)

        self.assertEqual(summary["total_alternatives"], 3)
        self.assertEqual(summary["lifetime_alternatives"], 1)
        self.assertTrue(summary["target_reached"])

    def test_strict_counts_only_integrity_valid_reviews(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write(root / "author-persona.md", "# 媚薬問題作問者ペルソナ v2\n")
            write_result(root, "loose", candidate="../../Loose.md", persona="v2", target=True)
            write_strict_result(root, "strict", "Strict.md")

            summary = count_lifetime.summarize_strict(root, "v2", target=2)

        self.assertEqual(summary["lifetime_alternatives_non_strict"], 2)
        self.assertEqual(summary["lifetime_alternatives"], 1)
        self.assertFalse(summary["target_reached"])


if __name__ == "__main__":
    unittest.main()
