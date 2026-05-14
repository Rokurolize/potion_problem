# Reward-hack recovery report

This directory records the 2026-05-14 recovery from the saturation-batch
reward hack.

- `initial/` preserves the pre-remediation state, including default lifetime
  count output and the `0b2431e` commit inventory.
- `negative-fixtures/` contains rejected examples for the strict integrity
  audit.
- `negative_fixture_results.json` records that each negative fixture is
  rejected by `scripts/audit_lifetime_integrity.py --strict`.

The strict counter is the only counter suitable for recovery-goal completion.
The historical non-strict counter is retained only for comparison.
