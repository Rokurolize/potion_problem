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

The formalization contains 2 remaining mathematical proofs to complete:
1. Summability of the hitting time series
2. Reindexing argument in the main proof

-/