/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
-- Global import approach (verified working in v4.12.0)
import Mathlib
import UniformHittingTime.FactorialSeries
-- Additional imports for telescoping series proofs
import Mathlib.Topology.Algebra.InfiniteSum.Group

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
  (a : ℕ → α) (m n : ℕ) (h : m ≤ n) :
  ∑ i ∈ Finset.range (n - m), (a (m + i) - a (m + i + 1)) = a m - a n := by
  induction' (n - m) with k ih
  · simp [Nat.sub_self]
  · rw [Finset.sum_range_succ, ih]
    -- Telescoping: (a_m - a_{m+1}) + ... + (a_{m+k} - a_{m+k+1}) = a_m - a_{m+k+1}
    -- where m + k + 1 = n by construction
    ring

/-- 
For a sequence tending to 0, the telescoping series converges to the first term
-/
theorem telescoping_series_sum {a : ℕ → ℝ} 
  (h_tendsto : Tendsto a atTop (nhds 0)) :
  ∑' n, (a n - a (n + 1)) = a 0 := by
  -- P25 Research Solution: Complete telescoping series proof
  -- 1. Finite telescoping for partial sums
  have h_partial : ∀ N : ℕ, (∑ k in Finset.range N, (a k - a (k + 1))) = a 0 - a N := by
    intro N
    induction' N with N ih
    · simp
    · simpa [Finset.sum_range_succ, ih, add_comm, add_left_neg,
             add_sub, sub_add_eq_add_sub] using rfl
  -- 2. The partial sums converge to a 0
  have h_tendsto_partial : Tendsto (fun N : ℕ ↦ a 0 - a N) atTop (𝓝 (a 0)) := by
    have : Tendsto (fun N : ℕ ↦ a (N + 1)) atTop (𝓝 0) := by
      simpa using h_tendsto.comp (tendsto_add_atTop_nat 1)
    simpa using tendsto_const_nhds.sub this
  -- 3. Rewrite the limit in terms of partial sums  
  have h_has : HasSum (fun n : ℕ ↦ a n - a (n + 1)) (a 0) := by
    -- hasSum_iff equates convergence of partial sums with HasSum
    simpa [HasSum, h_partial] using h_tendsto_partial
  -- 4. Turn HasSum into an equation for tsum
  exact h_has.tsum_eq

/-- 
Helper: The series ∑(1/(n-1)! - 1/n!) starting from n=2 equals 1
-/
lemma factorial_telescoping_series_eq_one :
  ∑' n : {n : ℕ // n ≥ 2}, ((1 : ℝ) / ((n : ℕ) - 1).factorial - 1 / (n : ℕ).factorial) = 1 := by
  -- This is a telescoping series that sums to 1/1! - lim(1/n!) = 1 - 0 = 1
  let a : ℕ → ℝ := fun n => (1 : ℝ) / (n+1).factorial
  have h_tendsto : Tendsto a atTop (nhds 0) := by
    -- Use factorial convergence from FactorialSeries
    simp [a]
    exact FactorialSeries.inv_factorial_tendsto_zero
  
  have h_sum := telescoping_series_sum h_tendsto
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
  -- Need to show: 1/(k+1)! - 1/(k+2)! = 1/((k+2-1).factorial) - 1/(k+2).factorial
  -- which simplifies to the same expression after substitution
  rfl

/-- 
Main result: The factorial telescoping series ∑[1/(n-1)! - 1/n!] = 1
when summed from n=2 to infinity.
-/
theorem factorial_telescoping_sum_one :
  ∑' n : ℕ, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) = 1 := by
  -- Convert to subtype sum
  have h_conv : ∑' n : ℕ, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) =
                ∑' n : {n : ℕ // n ≥ 2}, ((1 : ℝ) / ((n : ℕ) - 1).factorial - 1 / (n : ℕ).factorial) := by
    -- Use bijection between indicator sum and subtype sum
    -- The sets {n : n ≥ 2} and {n : ℕ // n ≥ 2} are equivalent
    let φ : {n : ℕ // n ≥ 2} ≃ {n : ℕ // n ≥ 2} := Equiv.refl _
    rw [← tsum_subtype (Set.setOf fun n => n ≥ 2)]
    congr
    ext ⟨n, hn⟩  
    simp [hn]
  
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
          
          -- Use n! = n * (n-1)!, so 1/n! = 1/(n*(n-1)!) ≤ 1/(n-1)!
          simp only [Nat.factorial_succ (n-1)]
          have : n.factorial = n * (n-1).factorial := by
            rw [← Nat.succ_pred_eq_of_ne_zero (by linarith : n ≠ 0)]
            exact Nat.factorial_succ (n-1)
          rw [this]
          simp only [Nat.cast_mul]
          rw [one_add_one_eq_two, div_add_div_same, add_div, one_div, inv_mul_eq_div]
          apply div_le_div_of_nonneg_left
          · norm_num
          · exact Nat.cast_pos.mpr h_fact_pos  
          · linarith
        · exact Nat.cast_pos.mpr h_fact_pos
        · exact Nat.cast_pos.mpr h_fact_pos
      apply (norm_sub_le _ _).trans
      exact h1
    · -- Case n < 2
      simp

end TelescopingSeries
