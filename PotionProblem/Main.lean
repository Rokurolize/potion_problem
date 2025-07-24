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

/-- Helper lemma: For n ≥ 2, n * hitting_time_pmf n = 1/(n-2)! -/
lemma hitting_time_formula (n : ℕ) (hn : 2 ≤ n) : 
  (n : ℝ) * hitting_time_pmf n = 1 / (n - 2).factorial := by
  simp only [hitting_time_pmf]
  have h_not_le : ¬(n ≤ 1) := by linarith
  rw [if_neg h_not_le]
  -- Now we have n * ((n - 1) / n.factorial) = 1 / (n - 2).factorial
  field_simp
  -- We need to show: n * (n - 1) * (n - 2)! = n!
  norm_cast
  -- Use factorial properties
  have h1 : n.factorial = n * (n - 1).factorial := by
    cases' n with k
    · omega
    rw [factorial_succ]
  have h2 : (n - 1).factorial = (n - 1) * (n - 2).factorial := by
    have : n - 1 = (n - 2).succ := by omega
    rw [this, factorial_succ]
  rw [h1, h2]
  ring

/-- The hitting time expectation series is summable -/
theorem summable_hitting_time :
  Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := by
  -- We'll prove this by showing the series is absolutely convergent
  -- For n < 2: the term is 0
  -- For n ≥ 2: the term is 1/(n-2)!
  have h_conv : Summable (fun k : ℕ => (1 : ℝ) / k.factorial) := summable_inv_factorial
  
  -- Our series differs from ∑ 1/k! only by a shift and some zero terms
  -- This is summable since ∑ 1/k! is summable
  sorry

/-- Main theorem: The expected hitting time equals e -/
theorem main_theorem : expected_hitting_time = exp 1 := by
  -- Step 1: Expand the definition
  unfold expected_hitting_time
  
  -- Step 2: The series equals ∑_{k≥0} 1/k! via reindexing
  -- The key observation: 
  -- n * hitting_time_pmf n = 0 for n = 0, 1
  -- n * hitting_time_pmf n = 1/(n-2)! for n ≥ 2
  -- So the series is: 0 + 0 + 1/0! + 1/1! + 1/2! + ... = ∑ 1/k!
  
  sorry  -- Series reindexing

end PotionProblem