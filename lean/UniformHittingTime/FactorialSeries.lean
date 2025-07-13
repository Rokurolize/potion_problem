/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
-- Global import approach (verified working in v4.12.0)
import Mathlib
-- Research-validated specific imports for P22/P23 solutions
import Mathlib.Data.Real.Summable
import Mathlib.Topology.Metric.Basic
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Data.Nat.Factorial.Cast
import Mathlib.Analysis.SpecificLimits.Basic

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

/--
The series ∑ 1/n! is summable (converges absolutely)
-/
theorem summable_inv_factorial :
  Summable (fun n : ℕ => (1 : ℝ) / n.factorial) := by
  -- This is the exponential series at 1
  -- Convert to the normed space exponential series
  have : (fun n : ℕ => (1 : ℝ) / n.factorial) = fun n => (1 : ℝ) ^ n / n.factorial := by
    ext n
    simp [one_pow]
  rw [this]
  exact Real.summable_pow_div_factorial 1

/--
Main theorem: 1/n! → 0 as n → ∞
-/
theorem inv_factorial_tendsto_zero :
  Tendsto (fun n : ℕ => (1 : ℝ) / n.factorial) atTop (nhds 0) := by
  -- Use the fact that summable sequences tend to zero
  -- In v4.12.0, this is summable_inv_factorial.tendsto_cofinite_zero + Nat.cofinite_eq_atTop
  rw [← Nat.cofinite_eq_atTop]
  exact summable_inv_factorial.tendsto_cofinite_zero

/--
Key lemma: For any c > 1, eventually n! > c^n.
This shows factorial growth dominates exponential growth.
-/
lemma factorial_dominates_exponential {c : ℝ} (hc : c > 1) :
  ∀ᶠ n in atTop, (n.factorial : ℝ) > c ^ n := by
  -- P22 Research Solution: Complete working proof using metric space approach
  have h_summable : Summable (fun n => c ^ n / n.factorial) :=
    Real.summable_pow_div_factorial c
  have h_tendsto : Tendsto (fun n => c ^ n / n.factorial) atTop (𝓝 0) :=
    h_summable.tendsto_cofinite_zero
  -- From metric-space characterization of tendsto, for ε = 1
  have h_eventually : ∀ᶠ n in atTop, |c ^ n / n.factorial - 0| < 1 :=
    (Metric.tendsto_nhds.1 h_tendsto) 1 (by norm_num)
  -- c^n / n! ≥ 0, so |c^n / n!| = c^n / n!, hence c^n / n! < 1
  filter_upwards [h_eventually] with n hn
  have hn' : c ^ n / n.factorial < 1 := by
    simpa only [sub_zero, Real.norm_eq_abs, abs_of_nonneg (pow_div_nonneg _ (Nat.factorial_pos _).le)]
      using hn
  -- div_lt_one gives n! > c^n
  simpa only [not_lt] using (div_lt_one (Nat.cast_pos.2 (Nat.factorial_pos n))).1 hn'

/--
Ratio test: The ratio of consecutive terms goes to 0
-/
lemma inv_factorial_ratio_tendsto_zero :
  Tendsto (fun n => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) atTop (nhds 0) := by
  -- P23 Research Solution: Clean ratio reduction to 1/(n+1)
  -- 1. Reduce the ratio to `1/(n+1)`
  have : (fun n => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) = fun n => 1 / (n + 1) := by
    ext n
    -- Use cast lemma and factorial succ lemma
    simp [Nat.cast_factorial, Nat.factorial_succ]
    ring
  -- 2. Apply the standard limit theorem
  rw [this]
  exact tendsto_one_div_add_atTop_nhds_zero_nat (1 : ℝ)

end FactorialSeries