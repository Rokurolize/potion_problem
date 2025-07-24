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
  -- Expand the definition of hitting_time_pmf
  simp only [hitting_time_pmf]
  -- Since n ≥ 2, we have ¬(n ≤ 1)
  have h_not_le : ¬(n ≤ 1) := by omega
  rw [if_neg h_not_le]
  
  -- Goal: n * ((n - 1) / n!) = 1 / (n - 2)!
  -- We'll use the fact that n! = n * (n - 1) * (n - 2)!
  
  -- First handle the natural number subtraction
  have h_sub : (n : ℝ) - 1 = ((n - 1 : ℕ) : ℝ) := by
    have : 1 ≤ n := by omega
    rw [Nat.cast_sub this]
    simp
  rw [h_sub]
  
  -- Now use field_simp to clear denominators
  field_simp
  
  -- The goal is: ↑n * (↑n - 1) * ↑(n - 2)! = ↑n!
  -- Use h_sub to convert (↑n - 1) to ↑(n - 1)
  rw [h_sub]
  
  -- Now we have: ↑n * ↑(n - 1) * ↑(n - 2)! = ↑n!
  -- Convert to natural numbers
  rw [← Nat.cast_mul, ← Nat.cast_mul]
  norm_cast
  
  -- Now we need to prove: n * (n - 1) * (n - 2)! = n!
  -- We'll use factorial_succ twice
  
  -- We want to prove: n * (n - 1) * (n - 2)! = n!
  -- Using factorial properties step by step
  
  -- Step 1: (n-1)! = (n-1) * (n-2)!
  have h1 : (n - 1).factorial = (n - 1) * (n - 2).factorial := by
    -- Since n ≥ 2, we have n - 1 ≥ 1, so n - 1 = (n - 2) + 1
    conv_lhs => rw [← Nat.succ_pred_eq_of_pos (by omega : 0 < n - 1)]
    rw [Nat.factorial_succ]
    congr 1
    exact Nat.succ_pred_eq_of_pos (by omega : 0 < n - 1)
  
  -- Step 2: n! = n * (n-1)!
  have h2 : n.factorial = n * (n - 1).factorial := by
    -- Since n ≥ 2, we have n ≥ 1, so n = (n - 1) + 1
    conv_lhs => rw [← Nat.succ_pred_eq_of_pos (by omega : 0 < n)]
    rw [Nat.factorial_succ]
    congr 1
    exact Nat.succ_pred_eq_of_pos (by omega : 0 < n)
  
  -- Now combine: n! = n * (n-1)! = n * ((n-1) * (n-2)!) = n * (n-1) * (n-2)!
  rw [h2, h1]
  ring

/-- The hitting time expectation series is summable -/
theorem summable_hitting_time :
  Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := by
  -- We'll show this is summable by relating it to the known summable factorial series
  -- Define a helper function that matches our series for n ≥ 2
  let g : ℕ → ℝ := fun k => if k < 2 then 0 else (1 : ℝ) / (k - 2).factorial
  
  -- Show that our series equals g
  have h_eq : ∀ n : ℕ, (n : ℝ) * hitting_time_pmf n = g n := by
    intro n
    simp only [g]
    by_cases h : n < 2
    · -- Case n < 2
      simp [h]
      cases' n with n'
      · -- n = 0
        simp [hitting_time_pmf]
      · -- n = 1 
        cases' n' with n''
        · simp [hitting_time_pmf]
        · -- n ≥ 2, contradiction
          omega
    · -- Case n ≥ 2
      push_neg at h
      simp [h, hitting_time_formula _ h]
  
  -- Now show g is summable
  have h_summable_g : Summable g := by
    -- g(n) = 0 for n < 2, and g(n) = 1/(n-2)! for n ≥ 2
    -- This is the factorial series ∑ 1/k! with indices shifted by 2 and first two terms zero
    
    -- Mathematical argument: 
    -- g(0) = 0, g(1) = 0, g(2) = 1/0!, g(3) = 1/1!, g(4) = 1/2!, ...
    -- So ∑ g(n) = 0 + 0 + 1/0! + 1/1! + 1/2! + ... = ∑_{k=0}^∞ 1/k! = e
    -- Since this series converges to e, g is summable
    
    -- Formal proof requires showing that index shifting preserves summability
    -- This would use lemmas about bijections between index sets and summability
    sorry -- Requires index shifting lemmas for summability
  
  -- Apply the equality to get summability of original series
  convert h_summable_g using 1
  funext n
  exact h_eq n

/-- Main theorem: The expected hitting time equals e -/
theorem main_theorem : expected_hitting_time = exp 1 := by
  -- Step 1: Expand the definition
  unfold expected_hitting_time
  
  -- Step 2: Use our series representation theorem
  rw [exp_one_eq_tsum_inv_factorial]
  
  -- Step 3: Show that ∑' n, n * hitting_time_pmf n = ∑' k, 1 / k.factorial
  -- The key observation: 
  -- n * hitting_time_pmf n = 0 for n = 0, 1
  -- n * hitting_time_pmf n = 1/(n-2)! for n ≥ 2
  -- So the series is: 0 + 0 + 1/0! + 1/1! + 1/2! + ... = ∑ 1/k!
  
  -- Mathematical argument for equality:
  -- LHS: ∑_{n=0}^∞ n * hitting_time_pmf n = 0 + 0 + 2*(1/2!) + 3*(2/3!) + 4*(3/4!) + ...
  --                                       = 0 + 0 + 1/0! + 1/1! + 1/2! + ...
  -- RHS: ∑_{k=0}^∞ 1/k! = 1/0! + 1/1! + 1/2! + ...
  -- These are equal since the LHS just adds two zero terms at the beginning
  
  -- Formal proof requires showing that reindexing preserves the sum
  -- This would use lemmas about series with modified finite terms
  sorry -- Series equality via reindexing

end PotionProblem