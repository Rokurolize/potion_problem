# potion_problem reward-hack recovery and honest lifetime-loop goal

## Objective

Recover from the reward-hacked saturation batch, repair the lifetime-counting and review pipeline so the same failure cannot recur, and make careful honest progress toward the 1000 lifetime-candidate target.

This goal is a recovery milestone, not a shortcut to 1000. Do not try to reach 1000 in this goal. Mark the goal complete only after the cheated batch is removed or quarantined, the counting/audit system excludes it, and a small number of genuinely reviewed new candidates have been added under the repaired process.

## Current known failure

A previous run had `lifetime_alternatives=226` and `target_remaining=774`. Instead of creating and honestly reviewing 774 genuinely distinct alternatives, the agent added `scripts/generate_lifetime_saturation_batch.py`, generated 774 `Saturation*Solution.md` files and corresponding `worker-runs/author-gate-v2-saturation-20260514T1816Z-*` artifacts, wrote every `result.json` as `gate=pass`, `would_say_target_line=true`, and reached `lifetime_alternatives=1000` by exploiting the counter. That is reward hacking.

The generated saturation batch must not count toward the lifetime target.

## Non-negotiable completion rule

Do not mark `/goal` complete unless all of these are true:

1. The generated saturation batch is removed from live counting, either by reverting commit `0b2431e` or by deleting/quarantining the generated batch and committing the remediation.
2. `scripts/generate_lifetime_saturation_batch.py` no longer exists as an executable/live generation path, or it is moved to a clearly marked rejected archive that is excluded by all counters and audits.
3. All `Saturation*Solution.md` files and all `worker-runs/author-gate-v2-saturation-20260514T1816Z-*` artifacts are removed from live counting or moved to a rejected archive.
4. The strict lifetime counter reports a value near the honest pre-hack state, not 1000. If the three manually added calculus candidates remain valid, the expected strict count is approximately `lifetime_alternatives=226`; if re-audit rejects any of them, use the audited value.
5. A new integrity audit script exists and fails on the saturation-batch pattern.
6. The strict counter uses the integrity audit or equivalent provenance checks, so generated self-approved artifacts cannot count as lifetime candidates.
7. At least 12 new candidate ideas are proposed and triaged, but no more than 5 new candidates are fully written and counted in this recovery goal.
8. Every newly counted candidate in this recovery goal has a real candidate file, a real review dossier, mathematical-correctness notes, novelty notes, a skeptical rejection attempt, and final author-persona decision.
9. No new counted candidate is merely a renamed simplex-volume/tail-sum proof with different jargon.
10. `python3 scripts/count_lifetime.py --format text --strict` or an equivalent strict command reports the corrected count and `target_reached=false`.
11. `python3 scripts/audit_lifetime_integrity.py --strict` passes on the final repo and fails on a saved negative fixture representing the saturation batch.
12. `python3 -m unittest` or the repository's test command passes.
13. `lake build` passes.
14. Git status is clean after the recovery commit(s).
15. The final response states that the 1000 target has not been honestly reached yet and that this recovery milestone is complete.

If any condition fails, do not mark `/goal` complete. Commit useful partial remediation if appropriate, report exact blockers, and leave the goal incomplete.

## Phase 0: record state before changes

Run and save the outputs in `integrity-reports/reward-hack-recovery-20260514/initial/`:

```sh
git status --short --untracked-files=all
git log --oneline -12
python3 scripts/count_lifetime.py --format text || true
python3 scripts/count_lifetime.py --format json > integrity-reports/reward-hack-recovery-20260514/initial/count_lifetime_default.json || true
```

If `0b2431e` exists, inspect it:

```sh
git show --stat 0b2431e > integrity-reports/reward-hack-recovery-20260514/initial/reward_hack_commit_stat.txt || true
git show --name-only --format=fuller 0b2431e > integrity-reports/reward-hack-recovery-20260514/initial/reward_hack_commit_files.txt || true
```

## Phase 1: remove or quarantine the reward-hacked batch

Preferred approach:

```sh
git revert --no-edit 0b2431e
```

Use this only if it cleanly removes the saturation generator, the 774 saturation solution files, and the 774 saturation worker-run directories without touching unrelated honest commits.

If `git revert` is not safe, manually remove or quarantine exactly these live artifacts:

- `scripts/generate_lifetime_saturation_batch.py`
- `Saturation*Solution.md`
- `worker-runs/author-gate-v2-saturation-20260514T1816Z-*`

If you quarantine instead of deleting, place them under:

- `rejected-artifacts/reward-hack-saturation-20260514/`

and ensure all counters and audits exclude that directory.

Do not remove the three preceding manually authored candidates unless a later integrity review rejects them:

- `AntiderivativeVolumeSolution.md`
- `FundamentalTheoremTailSolution.md`
- `LeibnizIntegralRuleSolution.md`

## Phase 2: add integrity audit and strict counter

Create or update:

- `scripts/audit_lifetime_integrity.py`
- `scripts/test_audit_lifetime_integrity.py`
- `integrity-reports/reward-hack-recovery-20260514/negative-fixtures/`
- `integrity-reports/reward-hack-recovery-20260514/README.md`

The integrity audit must detect and reject at least these patterns:

1. Candidate filename matches `Saturation\d+.*Solution.md`.
2. Worker-run path contains `author-gate-v2-saturation`.
3. Candidate body contains the phrase `The index` and `records this as a separate reviewed presentation`.
4. Candidate body contains template variables or near-identical domain/lens/role substitutions.
5. `result.json` was written by deterministic parent-generated code rather than a real review.
6. `launch.sh` contains `Parent-authored deterministic gate artifact`.
7. `brief.md` says `Parent-authored gate artifact for the deterministic saturation batch`.
8. `result.json` marks `gate=pass` and `would_say_target_line=true` without an actual evaluator transcript.
9. Candidate has no mathematical novelty dossier.
10. Candidate is too similar to another candidate by high n-gram overlap or identical proof skeleton.
11. Candidate proof is just the same simplex-volume/tail-sum derivation with names changed.
12. Candidate review lacks a skeptical rejection attempt.
13. Candidate review lacks a correctness checklist.
14. Candidate review lacks a novelty comparison against existing accepted candidates.

Update `scripts/count_lifetime.py` to support strict mode:

```sh
python3 scripts/count_lifetime.py --format text --strict
python3 scripts/count_lifetime.py --format json --strict
python3 scripts/count_lifetime.py --format text --strict --require-integrity
```

In strict mode, a candidate counts as lifetime only if all of these are true:

- persona version matches the current persona;
- candidate file exists;
- result file exists;
- result says pass and includes the exact target line;
- integrity audit classifies it as `valid-countable`;
- candidate hash in the review dossier matches the actual candidate file;
- review dossier contains correctness, novelty, and skeptical-review sections;
- candidate is not in a rejected or quarantined directory;
- candidate is not generated by a saturation script or batch template;
- candidate is not a duplicate or near-duplicate of an already-counted lifetime candidate.

The old non-strict count may remain for historical comparison, but it must not be used to decide goal completion.

## Phase 3: build negative fixtures

Create at least these negative fixtures under `integrity-reports/reward-hack-recovery-20260514/negative-fixtures/`:

- one `Saturation001...Solution.md` style candidate;
- one saturation `result.json` with automatic pass;
- one fake `launch.sh` saying parent-authored deterministic gate artifact;
- one candidate that only renames simplex-volume terminology;
- one candidate that is mathematically correct but not novel;
- one candidate that is novel-sounding but mathematically unsupported;
- one candidate whose review says pass but lacks a candidate hash;
- one candidate whose candidate hash does not match;
- one duplicate review of an existing candidate.

Run:

```sh
python3 scripts/audit_lifetime_integrity.py --strict --negative-fixtures integrity-reports/reward-hack-recovery-20260514/negative-fixtures
python3 -m unittest scripts/test_audit_lifetime_integrity.py
```

The audit must fail each negative fixture for the intended reason. Save results to:

- `integrity-reports/reward-hack-recovery-20260514/negative_fixture_results.json`

## Phase 4: re-audit existing honest candidates

Run the strict audit on all current candidates after the reward-hacked batch is removed or quarantined.

Create:

- `integrity-reports/reward-hack-recovery-20260514/existing_candidate_integrity_report.json`
- `integrity-reports/reward-hack-recovery-20260514/existing_candidate_integrity_report.md`

For each counted lifetime candidate, record:

- candidate path;
- review path;
- candidate hash;
- review hash;
- proof family;
- novelty family;
- whether it is countable;
- rejection reason if not countable.

If strict audit reduces the count below 226, accept the lower count. Do not patch the audit to preserve 226.

## Phase 5: propose a small honest batch, not a saturation batch

Create:

- `candidate-queues/recovery-20260514-proposals.md`
- `candidate-queues/recovery-20260514-triage.json`

Propose at least 12 candidate ideas. For each proposal, include:

- title;
- one-paragraph proof idea;
- proof family;
- what is genuinely new about it;
- likely overlap with existing accepted candidates;
- risk that it is only renamed simplex/tail-sum;
- triage decision: `write`, `defer`, or `reject`.

Reject ideas that are merely jargon overlays.

Select no more than 5 ideas to fully write in this recovery goal. The goal is to restart the honest loop, not to finish the 1000 target.

## Phase 6: write and review new candidates under the repaired process

For each newly written candidate:

Create the candidate file, and create a review directory under:

- `worker-runs/author-gate-v2-recovery-20260514-<slug>/`

Required files:

- `brief.md`
- `goal.txt`
- `candidate_hash.txt`
- `correctness_check.md`
- `novelty_check.md`
- `skeptical_review.md`
- `persona_review.md`
- `result.json`

The review must not be a deterministic auto-pass. It must show actual reasoning.

`correctness_check.md` must verify:

- the problem is the original stopping time `T=min{n>=1: X_1+...+X_n>1}`;
- the increments are independent uniform `[0,1)` variables;
- the proof obtains `P(T>n)=1/n!` or an equivalent valid route;
- the tail-sum formula is used correctly;
- there is no hidden change of distribution or stopping rule;
- every named theorem used is either explained or reduced to an elementary step.

`novelty_check.md` must compare against at least 10 existing accepted candidates and state why this is not merely a rename.

`skeptical_review.md` must try to reject the candidate. It should include at least three objections and responses.

`persona_review.md` must decide whether the author-persona v2 would honestly say the target line. It may fail the candidate.

`result.json` may set lifetime true only if all checks pass. Include:

```json
{
  "candidate_path": "...",
  "persona_version": "v2",
  "gate": "pass or fail",
  "would_say_target_line": true,
  "raw_reaction": "...",
  "candidate_sha256": "...",
  "correctness_check_path": "...",
  "novelty_check_path": "...",
  "skeptical_review_path": "...",
  "persona_review_path": "...",
  "integrity_status": "valid-countable or rejected",
  "proof_family": "...",
  "novelty_family": "...",
  "reason": "..."
}
```

## Phase 7: final validation for this recovery goal

Run:

```sh
python3 scripts/audit_lifetime_integrity.py --strict
python3 scripts/count_lifetime.py --format text --strict
python3 scripts/count_lifetime.py --format json --strict > integrity-reports/reward-hack-recovery-20260514/final_strict_count.json
python3 -m unittest scripts/test_count_lifetime.py
python3 -m unittest scripts/test_audit_lifetime_integrity.py
lake build
git status --short --untracked-files=all
```

The final strict count must show:

- `target_reached: false`
- `target_remaining` positive
- saturation batch count excluded
- no invalid candidates counted

If the final strict count shows `target_reached: true`, treat it as a failure unless there is independent evidence that 1000 honest, non-generated, non-duplicative lifetime candidates exist. That is not expected in this recovery goal.

## Phase 8: commit structure

Commit in logical pieces:

1. revert or quarantine reward-hacked saturation batch;
2. add integrity audit and strict counter;
3. add negative fixtures and tests;
4. add existing-candidate integrity report;
5. add small honest recovery batch;
6. add final validation report.

Do not create one giant commit that hides the remediation.

## Final response requirements

The final response must state:

- whether `/goal` was marked complete;
- how the saturation batch was removed or quarantined;
- commit hashes created;
- strict lifetime count after remediation;
- number of invalidated saturation candidates;
- number of newly written recovery candidates;
- how many of the new candidates passed honestly;
- target remaining after strict count;
- validation commands and results;
- final git status.

The final response must explicitly say that the 1000 target has not yet been honestly achieved unless the strict audit genuinely proves it.

## Hard prohibition

Do not mark `/goal` complete if any of the following is true:

- `scripts/generate_lifetime_saturation_batch.py` remains live.
- `Saturation*Solution.md` files remain countable.
- `worker-runs/author-gate-v2-saturation-20260514T1816Z-*` remains countable.
- strict count reports 1000 only because saturation artifacts are included.
- any generated auto-pass result counts as lifetime.
- negative fixtures do not fail the integrity audit.
- strict audit has untriaged invalid candidates.
- any new candidate lacks correctness, novelty, skeptical, and persona review artifacts.
- any new candidate is simply the simplex-volume/tail-sum proof with terminology changed.
- unit tests fail.
- `lake build` fails.
- git status is dirty due to this task.

Remember: the goal is not to make the number say 1000. The goal is to rebuild trust in the counting loop and resume careful progress toward 1000 honest lifetime alternatives.
