# potion_problem honest loop: verify recovery, prevent reward hacking, and add only audited candidates

## Objective

The previous recovery milestone may have succeeded locally, but the public repository state and the local state must be reconciled before the lifetime loop continues.

Your task is to verify that the saturation reward hack is not live, ensure the strict integrity audit is the source of truth, and then add only a small number of genuinely reviewed alternatives. Do not try to reach 1000 in this goal. This goal is complete only when the repository is in a trustworthy state and a small, honest batch has been added or intentionally skipped with evidence.

## Hard rules

Do not generate a large saturation batch.
Do not create deterministic pass-result files for hundreds of candidates.
Do not create or keep any script whose purpose is to fabricate candidates and matching pass gates in bulk.
Do not mark the goal complete merely because `count_lifetime.py` says the target is reached.
Do not count any candidate unless it has a real candidate file, a dossier, a novelty comparison, a mathematical validity check, and an integrity-audit-accepted gate result.
Do not overwrite existing goal files.
Do not force-push.

## Phase 1: verify repository state

Run:

```sh
cd ~/src/Rokurolize/potion_problem
git branch --show-current
git rev-parse HEAD
git status --short --untracked-files=all
git log --oneline -12
git remote -v
git ls-remote origin refs/heads/main || true
```

Record the output under:

```text
integrity-reports/honest-loop-20260514/initial/
```

Check whether the following commits are present in the current local history:

```text
1c012ed Revert "Add lifetime saturation gate batch"
3947d74 Add strict lifetime integrity audit
1025f5b Add reward hack negative fixtures
ced0f64 Report existing lifetime candidate integrity
47a702c Add honest recovery lifetime candidates
c8e07de Add reward hack recovery validation report
```

If the local branch does not contain those recovery commits, do not continue the candidate loop. First restore or recreate the recovery work.

If `git ls-remote origin refs/heads/main` does not point at a commit containing the recovery work, record this as `remote_not_reconciled=true`. Do not force-push. If normal push is safe and branch policy allows it, push the recovery branch normally. If not, create a report explaining the mismatch and leave the goal incomplete.

## Phase 2: verify the reward-hack removal

The following must be true:

- `scripts/generate_lifetime_saturation_batch.py` does not exist in live source.
- No live root-level `Saturation*Solution.md` files exist.
- No live `worker-runs/author-gate-v2-saturation-*` directories exist.
- `python3 scripts/audit_lifetime_integrity.py --strict --format json` passes.
- `python3 scripts/count_lifetime.py --format json --strict` reports `target_reached=false` unless the integrity audit has accepted 1000 genuinely reviewed candidates.
- Negative fixtures reject saturation-style artifacts.

Save output under:

```text
integrity-reports/honest-loop-20260514/recovery-verification/
```

If any check fails, fix the integrity system or report the blocker. Do not add new candidates until this phase passes.

## Phase 3: inspect the strict count

Run:

```sh
python3 scripts/count_lifetime.py --format json --strict > integrity-reports/honest-loop-20260514/strict-count-before.json
python3 scripts/audit_lifetime_integrity.py --strict --format json > integrity-reports/honest-loop-20260514/integrity-before.json
```

The report must identify:

- current strict total alternatives,
- current strict lifetime alternatives,
- rejected review count,
- rejection categories,
- target remaining,
- whether the previous saturation hack is rejected.

## Phase 4: propose at most 12 candidate ideas, accept at most 3

Create:

```text
integrity-reports/honest-loop-20260514/proposals.md
integrity-reports/honest-loop-20260514/proposal-triage.json
```

Generate at most 12 candidate ideas. Each idea must include:

- proposed filename,
- mathematical lens,
- one-sentence core proof route,
- why it is not a mere rename of simplex volume / tail sum,
- closest existing candidates,
- novelty risk,
- expected author-persona reaction.

Triage them. Accept at most 3. Reject the rest with reasons.

## Phase 5: write at most 3 real candidates

For each accepted candidate:

Create a candidate file with:

- exact problem statement,
- precise stopping time definition,
- complete derivation of `E[tau]=e`,
- explanation of the new viewpoint,
- comparison against at least 5 existing nearby candidates,
- why this is not merely renamed simplex-volume or tail-sum prose,
- a short “author memory hook”.

Create a dossier directory:

```text
worker-runs/author-gate-v2-honest-20260514-<slug>/
```

Each dossier must contain:

- `brief.md`,
- `candidate-digest.json`,
- `novelty-comparison.md`,
- `math-validity-check.md`,
- `adversarial-review.md`,
- `result.json`.

The `result.json` may say pass only if the dossier supports it. At least one accepted idea may still fail. Failure is allowed and is not a reason to fabricate more candidates.

## Phase 6: integrity audit after candidates

Run:

```sh
python3 scripts/audit_lifetime_integrity.py --strict --format text > integrity-reports/honest-loop-20260514/final/audit_lifetime_integrity_strict.txt
python3 scripts/count_lifetime.py --format text --strict > integrity-reports/honest-loop-20260514/final/count_lifetime_strict.txt
python3 -m unittest scripts/test_count_lifetime.py scripts/test_audit_lifetime_integrity.py > integrity-reports/honest-loop-20260514/final/unittest.txt
lake build > integrity-reports/honest-loop-20260514/final/lake_build.txt
git status --short --untracked-files=all > integrity-reports/honest-loop-20260514/final/git_status_short.txt
```

All tests must pass. The strict count must still be honest. The final report must say target 1000 is not reached unless it is genuinely reached under strict audit.

## Phase 7: commit and final report

Commit in small logical commits:

1. Remote/recovery verification report if needed.
2. Integrity audit improvements if any.
3. Candidate files and dossiers.
4. Final validation report.

Create:

```text
integrity-reports/honest-loop-20260514/final_validation_report.md
```

It must include:

- commits created,
- whether remote main is reconciled,
- strict count before and after,
- candidates proposed,
- candidates accepted,
- candidates failed,
- target remaining,
- why no bulk generation occurred,
- final git status.

## Completion condition

This goal is complete only if:

- recovery commits are present locally,
- remote/main mismatch is either resolved or explicitly reported as a blocker,
- saturation generator and saturation files are not live,
- strict integrity audit passes,
- negative fixtures reject reward-hack artifacts,
- at most 3 new candidates were added,
- every new candidate has a dossier,
- no bulk generation occurred,
- tests and `lake build` pass,
- git status is clean except documented ignored local progress files,
- final validation report exists.

Do not mark this goal complete if the repository still contains live saturation artifacts or if the current branch cannot be reconciled with the public repository state.
