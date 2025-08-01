import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import PotionProblem.SeriesAnalysis
import PotionProblem.Main
import PotionProblem.FactorialSeries


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
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := 
  tail_probability_formula n

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