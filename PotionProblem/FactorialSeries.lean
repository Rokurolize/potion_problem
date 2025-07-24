/-
Copyright (c) 2025 Potion Problem Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Potion Problem Team
-/
import Mathlib.Analysis.SpecificLimits.Normed

/-!
# Factorial Series Convergence Results

This module establishes convergence properties of factorial-based series,
particularly that 1/n! → 0 as n → ∞ and related summability results.

## Main Results

- `summable_inv_factorial`: The series ∑ 1/n! is summable
- `inv_factorial_tendsto_zero`: 1/n! → 0 as n → ∞

-/

namespace PotionProblem

open Real Filter Nat

/-- The series ∑ 1/n! is summable (converges absolutely) -/
theorem summable_inv_factorial :
  Summable (fun n : ℕ => (1 : ℝ) / n.factorial) := by
  -- Convert to the exponential series at 1
  have : (fun n : ℕ => (1 : ℝ) / n.factorial) = fun n => (1 : ℝ) ^ n / n.factorial := by
    ext n
    simp [one_pow]
  rw [this]
  exact Real.summable_pow_div_factorial 1

/-- Main theorem: 1/n! → 0 as n → ∞ -/
theorem inv_factorial_tendsto_zero :
  Tendsto (fun n : ℕ => (1 : ℝ) / n.factorial) atTop (nhds 0) := by
  -- Use the fact that summable sequences tend to zero
  rw [← Nat.cofinite_eq_atTop]
  exact summable_inv_factorial.tendsto_cofinite_zero

end PotionProblem