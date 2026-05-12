#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import count_lifetime


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


if __name__ == "__main__":
    unittest.main()
