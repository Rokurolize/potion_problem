# Final validation report

Objective: recover from the reward-hacked saturation batch, prevent generated
self-approved artifacts from counting, and restart the lifetime loop with a
small honest batch.  This recovery milestone does not attempt to reach 1000.

## Prompt-to-artifact checklist

| requirement | evidence |
| --- | --- |
| Remove or quarantine `0b2431e` saturation batch | Commit `1c012ed` reverts `0b2431e`; `scripts/generate_lifetime_saturation_batch.py` is absent; live `Saturation*Solution.md` count is `0`; live `worker-runs/author-gate-v2-saturation-20260514T1816Z-*` count is `0`. |
| Strict count near honest state, not 1000 | Historical non-strict report records 226 lifetime candidates after the revert; strict count records 3 countable recovery candidates and `target_reached=false`. |
| Integrity audit exists and rejects saturation patterns | `scripts/audit_lifetime_integrity.py`; `negative_fixture_results.json` records 9/9 negative fixtures rejected. |
| Strict counter uses integrity audit | `scripts/count_lifetime.py --strict` imports and applies `audit_lifetime_integrity.audit_root`. |
| At least 12 ideas proposed and triaged | `candidate-queues/recovery-20260514-proposals.md` and `candidate-queues/recovery-20260514-triage.json`. |
| No more than 5 new candidates fully written | 3 new candidates: `RenewalBoundaryValueSolution.md`, `VolterraResolventLifetimeSolution.md`, `BackwardEquationCrossingMassSolution.md`. |
| Every new counted candidate has a real dossier | Each `worker-runs/author-gate-v2-recovery-20260514-*` directory has `brief.md`, `goal.txt`, `candidate_hash.txt`, `correctness_check.md`, `novelty_check.md`, `skeptical_review.md`, `persona_review.md`, and `result.json`. |
| New counted candidates are not renamed saturation templates | Audit reports `valid_countable=3`, `hard_failure_count=0`; novelty files compare against at least 10 existing candidates. |
| Strict count command reports target not reached | `final/count_lifetime_strict.txt`: lifetime `3`, remaining `997`, `target_reached=false`. |
| Negative fixtures fail audit | `negative_fixture_results.json`: fixtures `9`, failed as expected `9`. |
| Unit tests pass | `final/unittest_count_lifetime.txt` and `final/unittest_audit_lifetime_integrity.txt`. |
| Lean build passes | `final/lake_build.txt`: build completed successfully. |

## Final strict count

```text
persona_version: v2
total_alternatives: 3
lifetime_alternatives: 3
target_lifetime_count: 1000
target_remaining: 997
target_reached: false
```

The 1000 target has not been honestly reached.
