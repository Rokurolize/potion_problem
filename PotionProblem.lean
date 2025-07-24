/-
Copyright (c) 2025 Potion Problem Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Potion Problem Team
-/
import PotionProblem.Basic
import PotionProblem.FactorialSeries
import PotionProblem.Main

/-!
# Potion Problem: Expected Hitting Time = e

This is the main library file for the Potion Problem formalization,
proving that E[τ] = e where τ is the hitting time for uniform random sums.

## Main Theorem

`PotionProblem.main_theorem : expected_hitting_time = exp 1`

## Status

✅ **NEAR COMPLETION**: The formalization contains 1 remaining technical proof:
- Tsum reindexing in `Main.lean:215` (`sum_split` proof)

✅ **Major proofs completed**:
- `summable_hitting_time` - Series summability proof
- `main_theorem` structure - All key mathematical steps

-/