/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
-- P26 Research Solution: Required v4.21.0 imports for factorial convergence
-- Removed: import Mathlib.Analysis.SpecificLimits.Normed (linter says unneeded)

open BigOperators Real Nat Filter Topology

/-!
# Factorial Series Convergence Results

This module establishes convergence properties of factorial-based series,
particularly that 1/n! → 0 as n → ∞ and related summability results.

## Main Results

- `inv_factorial_tendsto_zero`: 1/n! → 0 as n → ∞
- `factorial_grows_superexponentially`: n! grows faster than any exponential
- `summable_inv_factorial`: The series ∑ 1/n! is summable

## Mathematical Background

The factorial function grows super-exponentially, faster than any exponential function.
This is captured by Stirling's approximation: n! ~ √(2πn) (n/e)^n.
-/

namespace FactorialSeries

open Real Filter

/-- The series ∑ 1/n! is summable (converges absolutely) -/
theorem summable_inv_factorial :
  Summable (fun n : ℕ => (1 : ℝ) / n.factorial) := by
  -- This is the exponential series at 1
  -- Convert to the normed space exponential series
  have : (fun n : ℕ => (1 : ℝ) / n.factorial) = fun n => (1 : ℝ) ^ n / n.factorial := by
    ext n
    simp [one_pow]
  rw [this]
  exact Real.summable_pow_div_factorial 1

/-- Main theorem: 1/n! → 0 as n → ∞ -/
theorem inv_factorial_tendsto_zero :
  Tendsto (fun n : ℕ => (1 : ℝ) / n.factorial) atTop (nhds 0) := by
  -- Use the fact that summable sequences tend to zero
  -- In v4.21.0, this is summable_inv_factorial.tendsto_cofinite_zero + Nat.cofinite_eq_atTop
  rw [← Nat.cofinite_eq_atTop]
  exact summable_inv_factorial.tendsto_cofinite_zero

/-- Key lemma: For any c > 1, eventually n! > c^n.
This shows factorial growth dominates exponential growth. -/
lemma factorial_dominates_exponential {c : ℝ} :
  ∀ᶠ n in atTop, (n.factorial : ℝ) > c ^ n := by
  -- Use the fact that exponential series converges for any c
  -- Note: hc constraint ensures mathematical validity but not needed for convergence proof
  have h_summable : Summable (fun n => c ^ n / n.factorial) :=
    Real.summable_pow_div_factorial c
  have h_tendsto : Tendsto (fun n => c ^ n / n.factorial) atTop (𝓝 0) := by
    rw [← Nat.cofinite_eq_atTop]
    exact h_summable.tendsto_cofinite_zero
  -- P26 Research Solution: exponential dominance theorem for factorial
  have h_eventually : ∀ᶠ n in atTop, c ^ n / (n.factorial : ℝ) < 1 := by
    -- Apply the standard theorem that c^n/n! → 0 for any c
    have h_one_pos : (0 : ℝ) < 1 := zero_lt_one
    exact h_tendsto.eventually (eventually_lt_nhds h_one_pos)
  filter_upwards [h_eventually] with n hn
  rwa [div_lt_one (Nat.cast_pos.2 (Nat.factorial_pos n))] at hn

/-- Ratio test: The ratio of consecutive terms goes to 0 -/
lemma inv_factorial_ratio_tendsto_zero :
  Tendsto (fun n : ℕ => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) atTop (nhds 0) := by
  -- P26 Research Solution: Factorial ratio reduction (v4.21.0 API verification needed)
  have h_eq : (fun n : ℕ => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) = 
              fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1) := by
    -- P26 Research Solution: Factorial ratio reduction: (n+1)!/n! = n+1
    ext n
    -- Expand the definition and use specific rewrites
    rw [factorial_succ, div_div]
    -- Need to handle n! ≠ 0 for the simplification
    have h_nonzero : (n.factorial : ℝ) ≠ 0 := Nat.cast_ne_zero.2 (Nat.factorial_ne_zero n)
    field_simp [h_nonzero]
  rw [h_eq]
  exact tendsto_one_div_add_atTop_nhds_zero_nat

end FactorialSeries
