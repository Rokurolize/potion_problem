/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
-- Global import approach (verified working in v4.12.0)
import Mathlib
import UniformHittingTime.FactorialSeries

/-!
# Telescoping Series Theory

This module provides the mathematical machinery for telescoping series,
particularly focused on series of the form ∑(aₙ - aₙ₊₁).

## Main Results

- `telescoping_series_sum`: For a convergent sequence, ∑(aₙ - aₙ₊₁) = a₁ - lim aₙ
- `telescoping_series_partial_sum`: Finite telescoping sum formula
- `factorial_telescoping_sum_one`: The specific result ∑[1/(n-1)! - 1/n!] = 1

## Mathematical Background

A telescoping series is one where consecutive terms cancel, leaving only
the first and last terms (or their limits). This is a powerful technique
for evaluating certain infinite series.
-/

namespace TelescopingSeries

open Filter

/-- 
Finite telescoping sum: ∑ᵢ₌ₘⁿ (aᵢ - aᵢ₊₁) = aₘ - aₙ₊₁
-/
theorem telescoping_series_partial_sum {α : Type*} [AddCommGroup α] 
  (a : ℕ → α) (m n : ℕ) :
  ∑ i ∈ Finset.range (n - m), (a (m + i) - a (m + i + 1)) = a m - a n := by
  induction' (n - m) with k ih
  · simp
  · rw [Finset.sum_range_succ, ih]
    have : m + k + 1 = n := by
      rw [← Nat.add_sub_assoc (Nat.le_of_lt (Nat.succ_pos k))]
      simp
    sorry -- needs more work

/-- 
For a sequence tending to 0, the telescoping series converges to the first term
-/
theorem telescoping_series_sum {a : ℕ → ℝ} 
  (h_tendsto : Tendsto a atTop (nhds 0)) :
  ∑' n, (a n - a (n + 1)) = a 0 := by
  exact tsum_sub_of_tendsto_zero h_tendsto

/-- 
Helper: The series ∑(1/(n-1)! - 1/n!) starting from n=2 equals 1
-/
lemma factorial_telescoping_series_eq_one :
  ∑' n : {n : ℕ // n ≥ 2}, ((1 : ℝ) / ((n : ℕ) - 1).factorial - 1 / (n : ℕ).factorial) = 1 := by
  -- This is a telescoping series that sums to 1/1! - lim(1/n!) = 1 - 0 = 1
  let a : ℕ → ℝ := fun n => (1 : ℝ) / (n+1).factorial
  have h_tendsto : Tendsto a atTop (nhds 0) := by
    apply tendsto_inv_atTop_zero.comp
    apply tendsto_nat_cast_atTop_atTop.comp
    exact (tendsto_add_atTop_nat 1).comp tendsto_factorial_atTop
  
  have h_sum := tsum_sub_of_tendsto_zero h_tendsto
  simp_rw [← h_sum]
  -- Reindex the sum
  let φ : ℕ ≃ {n : ℕ // n ≥ 2} := {
    toFun := fun k => ⟨k + 2, by linarith⟩,
    invFun := fun n => n.val - 2,
    left_inv := fun k => by simp,
    right_inv := fun ⟨n, hn⟩ => by ext; simp; exact Nat.sub_add_cancel hn
  }
  rw [← φ.tsum_eq]
  congr
  ext k
  simp [a]
  have h_k1 : (k+1).factorial = (k+1) * k.factorial := by rw [Nat.factorial_succ]
  have h_k2 : (k+2).factorial = (k+2) * (k+1).factorial := by rw [Nat.factorial_succ]
  rw [h_k1, h_k2]
  field_simp [Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero _)]
  sorry

/-- 
Main result: The factorial telescoping series ∑[1/(n-1)! - 1/n!] = 1
when summed from n=2 to infinity.
-/
theorem factorial_telescoping_sum_one :
  ∑' n : ℕ, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) = 1 := by
  -- Convert to subtype sum
  have h_conv : ∑' n : ℕ, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) =
                ∑' n : {n : ℕ // n ≥ 2}, ((1 : ℝ) / ((n : ℕ) - 1).factorial - 1 / (n : ℕ).factorial) := by
    apply tsum_indicator_subset_of_support_subset
    intro n hn
    simp at hn ⊢
    split_ifs at hn with h
    · exact ⟨h, hn⟩
    · contradiction
  
  rw [h_conv]
  exact factorial_telescoping_series_eq_one

/-- 
Summability of the factorial difference series
-/
lemma summable_factorial_diff :
  Summable (fun n : ℕ => if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) := by
  -- The non-zero terms form a summable series
  -- because it's bounded by 2 * ∑ 1/n! which converges
  apply Summable.of_norm_bounded_eventually _ _
  · -- The bounding series
    use 2
    apply Summable.mul_left
    exact FactorialSeries.summable_inv_factorial
  · -- The bound
    intro n
    split_ifs with h
    · -- Case n ≥ 2
      simp only [norm_sub_le, norm_div, norm_one, Real.norm_natCast]
      -- |1/(n-1)! - 1/n!| ≤ 1/(n-1)! + 1/n! ≤ 2/((n-1)!)
      have h1 : 1 / ↑(n - 1).factorial + 1 / ↑n.factorial ≤ 2 / ↑(n - 1).factorial := by
        rw [div_le_div_iff]
        · have : (n:ℝ) ≥ 2 := by exact_mod_cast h
          have h_fact_pos : (n-1).factorial > 0 := Nat.factorial_pos (by linarith)
          have h_n_pos : n > 0 := by linarith
          have h_n_fact_pos : n.factorial > 0 := Nat.factorial_pos h_n_pos
          
          rw [one_add_one_eq_two, div_mul_eq_mul_div, ← mul_assoc]
          apply mul_le_mul_of_nonneg_left
          rw [div_le_one]
          · exact Nat.cast_le.mpr (Nat.le_of_lt (Nat.lt_of_succ_le (by linarith)))
          · exact Nat.cast_pos.mpr h_n_fact_pos
          · exact Nat.cast_nonneg _
        · exact Nat.cast_pos.mpr (Nat.factorial_pos (by linarith))
        · exact Nat.cast_pos.mpr (Nat.factorial_pos (by linarith))
      apply (norm_sub_le _ _).trans
      exact h1
    · -- Case n < 2
      simp

end TelescopingSeries
