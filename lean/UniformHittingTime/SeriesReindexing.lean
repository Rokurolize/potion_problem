/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Logic.Equiv.Basic
import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Analysis.Summation.Series

open Filter Topology

/-!
This file contains theorems for reindexing series.
-/

variable {G : Type*} [AddCommGroup G] [TopologicalSpace G] [T2Space G] [TopologicalAddGroup G]
variable {f : ℕ → G}
variable {α : Type*} -- for reindex_series_general

/--
A general theorem for reindexing a series.
If a series `∑' n, f n` has a sum, and `φ` is an equivalence mapping `α` to `ℕ`,
then the reindexed series `∑' a, f (φ a)` also has a sum, and it is equal to the original sum.
-/
theorem reindex_series_general (h_summable : Summable f) (φ : α ≃ ℕ) :
    Summable (f ∘ φ) ∧ (∑' a, f (φ a)) = ∑' n, f n := by
  exact h_summable.comp_equiv φ

/--
A theorem for reindexing a series with a shift.
If a series `∑' n, f n` has a sum, then for any natural number `a`,
the series `∑' k, f (k + a)` also has a sum, and `∑' n, f n = (∑_{i=0}^{a-1} f i) + ∑' k, f (k + a)`.
-/
theorem reindex_series_shift (h_summable : Summable f) (a : ℕ) :
    (∑' n, f n) = (∑ i in Finset.range a, f i) + (∑' k, f (k + a)) := by
  exact tsum_sum_add_tsum_nat_add h_summable a

/--
A specific case of reindexing where the series is shifted by `n-2`.
If `∑' k, f k` has a sum, then `∑' n, (if n ≥ 2 then f (n-2) else 0) = ∑' k, f k`.
This is useful for calculations involving generating functions.
-/
theorem reindex_series_n_minus_two (h_summable : Summable f) :
    (∑' n, if n ≥ 2 then f (n - 2) else 0) = ∑' k, f k := by
  let s := {n | n ≥ 2}
  rw [← tsum_indicator_eq_tsum_subtype s (fun n => f (n - 2))]
  let φ : s ≃ ℕ := (Equiv.addRight 2).symm
  rw [← (h_summable.comp_equiv φ).tsum_eq]
  rfl

/-!
The following are example usages of the reindexing theorems, which also serve as tests.
-/

-- Example usage of reindex_series_shift
example : Summable (fun k : ℕ ↦ (1:ℝ) / (k+2).factorial) := by
  have h_summable_factorial : Summable (fun k : ℕ ↦ (1:ℝ) / k.factorial) := by
    have h := Real.summable_pow_div_factorial (1:ℝ)
    simp_rw [one_pow] at h
    exact h
  rw [← summable_nat_add_iff 2] at h_summable_factorial
  exact h_summable_factorial

-- Example usage of reindex_series_n_minus_two
example : (∑' n, if n ≥ 2 then (1:ℝ) / (n - 2).factorial else 0) = Real.exp 1 := by
  have h_summable : Summable (fun k : ℕ ↦ (1:ℝ) / k.factorial) := by
    have h := Real.summable_pow_div_factorial (1:ℝ)
    simp_rw [one_pow] at h
    exact h
  have h_reindex := reindex_series_n_minus_two h_summable
  rw [h_reindex]
  rw [Real.tsum_exp_series 1]
  simp
