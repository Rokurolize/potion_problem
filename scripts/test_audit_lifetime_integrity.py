#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import audit_lifetime_integrity


TARGET_LINE = audit_lifetime_integrity.TARGET_LINE


def write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def valid_review(root: Path, name: str, body: str) -> Path:
    candidate = root / f"{name}.md"
    write(candidate, body)
    candidate_hash = audit_lifetime_integrity.sha256(candidate)
    run = root / "worker-runs" / f"author-gate-v2-recovery-20260514-{name.lower()}"
    write(run / "candidate_hash.txt", candidate_hash)
    write(
        run / "correctness_check.md",
        "T=min{n>=1: X_1+...+X_n>1}; independent uniform increments; "
        "P(T>n) follows by the stated route; tail-sum is used; no hidden change.",
    )
    write(
        run / "novelty_check.md",
        "\n".join(
            [f"Compare Existing{i}Solution.md: different proof role." for i in range(10)]
        )
        + "\nThis is not merely a rename.",
    )
    write(
        run / "skeptical_review.md",
        "Objection 1: route might change T. Response: it does not.\n"
        "Objection 2: distribution might change. Response: it remains uniform.\n"
        "Objection 3: novelty might be weak. Response: the certificate differs.",
    )
    write(run / "persona_review.md", "author-persona v2 decision: pass with the target line.")
    write(run / "brief.md", f"- Candidate solution: `../../{candidate.name}`\n")
    write(run / "goal.txt", "Review honestly.\n")
    write(run / "launch.sh", "#!/usr/bin/env bash\nexit 0\n")
    write(
        run / "result.json",
        json.dumps(
            {
                "candidate_path": candidate.name,
                "persona_version": "v2",
                "gate": "pass",
                "would_say_target_line": True,
                "raw_reaction": TARGET_LINE,
                "candidate_sha256": candidate_hash,
                "correctness_check_path": f"worker-runs/{run.name}/correctness_check.md",
                "novelty_check_path": f"worker-runs/{run.name}/novelty_check.md",
                "skeptical_review_path": f"worker-runs/{run.name}/skeptical_review.md",
                "persona_review_path": f"worker-runs/{run.name}/persona_review.md",
                "integrity_status": "valid-countable",
                "proof_family": "test",
                "novelty_family": "test",
            },
            ensure_ascii=False,
        ),
    )
    return run / "result.json"


class AuditLifetimeIntegrityTests(unittest.TestCase):
    def test_saturation_pattern_is_hard_failure(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            run = root / "worker-runs" / "author-gate-v2-saturation-20260514T1816Z-001"
            write(
                root / "Saturation001RenewalCertificateRemainingDistanceSolution.md",
                "The index `1` records this as a separate reviewed presentation.",
            )
            write(run / "launch.sh", "Parent-authored deterministic gate artifact.\n")
            write(run / "brief.md", "Parent-authored gate artifact for the deterministic saturation batch.\n")
            write(
                run / "result.json",
                json.dumps(
                    {
                        "candidate_solution_path": "../../Saturation001RenewalCertificateRemainingDistanceSolution.md",
                        "persona_version": "v2",
                        "gate": "pass",
                        "would_say_target_line": True,
                        "raw_reaction": TARGET_LINE,
                    },
                    ensure_ascii=False,
                ),
            )

            report = audit_lifetime_integrity.audit_root(root)

        self.assertEqual(report["summary"]["valid_countable"], 0)
        self.assertGreater(report["summary"]["hard_failure_count"], 0)

    def test_complete_dossier_is_countable(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            valid_review(
                root,
                "RecoveryCertificate",
                "# recovery certificate\n\nA genuine renewal equation proof with enough detail.",
            )

            report = audit_lifetime_integrity.audit_root(root)

        self.assertEqual(report["summary"]["valid_countable"], 1)
        self.assertEqual(report["summary"]["hard_failure_count"], 0)

    def test_hash_mismatch_rejects_candidate(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            result = valid_review(root, "HashMismatch", "# proof\n\nfirst version")
            (root / "HashMismatch.md").write_text("# proof\n\nchanged version", encoding="utf-8")

            finding = audit_lifetime_integrity.audit_one(root, result)

        self.assertEqual(finding.status, "rejected")
        self.assertIn("candidate_hash_mismatch", finding.reasons)


if __name__ == "__main__":
    unittest.main()
