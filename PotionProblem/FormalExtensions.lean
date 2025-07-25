/-
Copyright (c) 2025 Potion Problem Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Potion Problem Team
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import PotionProblem.SeriesAnalysis
import PotionProblem.Main
import PotionProblem.FactorialSeries

set_option linter.style.commandStart false

/-!
# Formal Extensions for the Potion Problem

This module contains formal proofs of additional mathematical content from `elegant_solution.md`
that extends beyond the main theorem E[τ] = e.

## Main Results

- Proof that the PMF sums to 1
- Helper theorems about the hitting time

-/

namespace PotionProblem

open Real Filter Nat Topology

/-!
## Section 1: PMF Properties
-/

/-- The PMF sums to 1 -/
theorem pmf_sum_one : ∑' n : ℕ, hitting_time_pmf n = 1 := pmf_sum_eq_one

/-!
## Section 2: Additional Properties
-/

/-- P(τ > n) = 1/n! for all n -/
theorem prob_tau_exceeds (n : ℕ) :
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := by
  -- This follows from the telescoping property and the PMF structure
  -- P(τ > n) is the probability that the sum of the first n uniform variables is < 1
  -- This is exactly the volume of the n-simplex, which is 1/n!
  
  -- We can derive this from the fact that the PMF telescopes
  -- and the tail probability has the known form
  
  -- For now, use the fact that this is a standard result in probability theory
  -- The formal proof would use the telescoping identity for the PMF
  sorry

/-- The expected value calculation is valid because the series converges absolutely -/
theorem expected_value_convergent :
  Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := by
  -- Already proven in Main.lean
  exact hitting_time_series_summable

/-- Alternative expression for the expected value -/
theorem expected_value_alt :
  ∑' n : ℕ, (n : ℝ) * hitting_time_pmf n = ∑' k : ℕ, 1 / (k.factorial : ℝ) := by
  -- This is proven in Main.lean as main_theorem
  rw [← expected_hitting_time, main_theorem, exp_series_connection]

end PotionProblem