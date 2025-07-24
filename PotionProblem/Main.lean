/-
Copyright (c) 2025 Potion Problem Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Potion Problem Team
-/
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.Normed.Algebra.Exponential
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import PotionProblem.Basic
import PotionProblem.FactorialSeries

/-!
# Main Theorem: E[τ] = e

This module contains the main theorem proving that the expected hitting time
for independent uniform [0,1) random variables to sum to at least 1 is exactly e.

## Main Result

- `main_theorem`: E[τ] = e

## Remaining Work

This file contains 2 sorry declarations that represent incomplete mathematical proofs:
1. `summable_hitting_time`: Prove the hitting time series is summable
2. Reindexing proof inside `main_theorem`: Complete the bijection argument

-/

namespace PotionProblem

open Real Filter Nat

/-- The expected hitting time E[τ] = ∑_{n=1}^∞ n · P(τ = n) -/
noncomputable def expected_hitting_time : ℝ :=
  ∑' n : ℕ, n * hitting_time_pmf n

/-- Fundamental lemma: exp 1 = ∑ 1/n! -/
lemma exp_one_eq_tsum_inv_factorial : exp 1 = ∑' n : ℕ, (1 : ℝ) / n.factorial := by
  -- Use the fact that Real.exp = NormedSpace.exp ℝ
  rw [Real.exp_eq_exp_ℝ]
  -- Now apply the series representation of exp
  rw [NormedSpace.exp_eq_tsum]
  -- At x = 1, we get ∑' n, (n!)⁻¹ • 1^n = ∑' n, 1/n!
  simp only [one_pow, smul_eq_mul, inv_eq_one_div, mul_one]

/-- The hitting time expectation series is summable -/
theorem summable_hitting_time :
  Summable (fun n : ℕ => n * hitting_time_pmf n) := by
  -- We'll show this is summable by showing it equals a convergent series
  -- First, note that n * hitting_time_pmf n = 0 for n < 2
  -- For n ≥ 2, n * hitting_time_pmf n = 1/(n-2)! by h_simplify in main_theorem
  -- So the series is ∑_{n≥2} 1/(n-2)! = ∑_{k≥0} 1/k! which converges
  -- Use the fact that ∑ 1/k! converges from FactorialSeries module
  have h_conv : Summable (fun k : ℕ => (1 : ℝ) / k.factorial) := summable_inv_factorial
  -- The series ∑ n * hitting_time_pmf n has the same sum pattern shifted by 2
  sorry -- TODO: Complete summability proof using reindexing

/-- Main theorem: The expected hitting time equals e -/
theorem main_theorem : expected_hitting_time = exp 1 := by
  -- Step 1: Expand the definition
  unfold expected_hitting_time
  
  -- Step 2: Simplify the series using the PMF formula
  -- For n ≥ 2: n * (n-1)/n! = 1/(n-2)!
  have h_simplify : ∀ n ≥ 2, n * hitting_time_pmf n = 1 / (n - 2).factorial := by
    intro n hn
    simp [hitting_time_pmf]
    -- n ≥ 2 implies ¬(n ≤ 1), so hitting_time_pmf n = (n-1)/n!
    have h_not_le : ¬(n ≤ 1) := by linarith
    rw [if_neg h_not_le]
    -- Now we have: n * ((n - 1) / n!) = 1 / (n - 2)!
    -- This is a direct algebraic manipulation using:
    -- n! = n * (n-1)! and (n-1)! = (n-1) * (n-2)!
    -- So n * (n-1) / n! = n * (n-1) / (n * (n-1) * (n-2)!) = 1 / (n-2)!
    sorry -- TODO: Complete algebraic manipulation
  
  -- Step 3: The series equals ∑_{k≥0} 1/k! via reindexing
  have h_reindex : ∑' n : ℕ, n * hitting_time_pmf n = ∑' k : ℕ, (1 : ℝ) / k.factorial := by
    -- The key insight: For n < 2, hitting_time_pmf n = 0
    -- For n ≥ 2, n * hitting_time_pmf n = 1/(n-2)! by h_simplify
    -- So we need to show: ∑_{n≥2} 1/(n-2)! = ∑_{k≥0} 1/k!
    -- This follows from reindexing with n = k+2
    sorry -- TODO: Complete reindexing proof
  
  -- Step 4: Apply the exponential series theorem
  rw [h_reindex]
  -- ∑ 1/k! = e
  exact exp_one_eq_tsum_inv_factorial.symm

end PotionProblem