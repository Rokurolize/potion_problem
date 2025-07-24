/-
Copyright (c) 2025 Potion Problem Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Potion Problem Team
-/
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Analysis.SpecificLimits.Normed

/-!
# Series Reindexing Lemmas

This module provides lemmas for reindexing infinite series, particularly
for shifting indices and handling series with finite initial zero terms.

## Main Results

- `summable_shift_two`: Summability is preserved when shifting indices by 2
- `tsum_shift_two`: Sum equality for series shifted by 2 indices

-/

namespace PotionProblem

open Filter Finset Nat

/-- If f(n) = 0 for n < 2 and f(n) = g(n-2) for n ≥ 2, and g is summable,
    then f is summable -/
theorem summable_shift_two {f g : ℕ → ℝ} 
  (h_zero : ∀ n < 2, f n = 0)
  (h_shift : ∀ n ≥ 2, f n = g (n - 2))
  (h_summable : Summable g) : 
  Summable f := by
  -- We use the fact that Summable (fun n => f (n + 2)) ↔ Summable f
  -- when f(0) = f(1) = 0
  -- First show that fun n => f (n + 2) = g
  have h_eq : (fun n => f (n + 2)) = g := by
    funext n
    exact h_shift (n + 2) (by omega)
  
  -- So fun n => f (n + 2) is summable
  have h1 : Summable (fun n => f (n + 2)) := by
    rw [h_eq]
    exact h_summable
  
  -- Now we need to show this implies Summable f
  -- We use Summable.comp_nat_sub
  -- Actually, let's use a more direct approach
  
  -- We can split f into finite part + infinite part
  -- f = (sum over {0,1}) + (sum over {2,3,...})
  -- The finite part is 0, and the infinite part is summable
  
  -- Use that a function is summable iff its tail is summable
  rw [← summable_nat_add_iff 2]
  convert h_summable using 1
  funext n
  exact h_shift (n + 2) (by omega)

/-- If f(n) = 0 for n < 2 and f(n) = g(n-2) for n ≥ 2,
    then ∑' f(n) = ∑' g(n) -/
theorem tsum_shift_two {f g : ℕ → ℝ} 
  (h_zero : ∀ n < 2, f n = 0)
  (h_shift : ∀ n ≥ 2, f n = g (n - 2))
  (h_summable : Summable g) : 
  ∑' n, f n = ∑' n, g n := by
  -- First establish summability of f
  have h_summable_f : Summable f := summable_shift_two h_zero h_shift h_summable
  
  -- Now we show the sums are equal
  -- Key: ∑' f = f(0) + f(1) + ∑'_{n≥2} f(n) = 0 + 0 + ∑' g = ∑' g
  
  -- Use tsum_eq_tsum_of_ne_zero_bij with bijection n ↦ n - 2
  apply tsum_eq_tsum_of_ne_zero_bij (fun n => n - 2)
  · -- Injectivity on support of f
    intro a b ha hb h_eq
    -- If f(a) ≠ 0, then a ≥ 2
    have ha' : 2 ≤ a := by
      by_contra h
      push_neg at h
      have : f a = 0 := h_zero a h
      rw [this] at ha
      exact ha rfl
    -- Similarly for b
    have hb' : 2 ≤ b := by
      by_contra h
      push_neg at h
      have : f b = 0 := h_zero b h
      rw [this] at hb
      exact hb rfl
    -- Now a - 2 = b - 2 implies a = b
    omega
  · -- Surjectivity onto support of g
    intro k hk
    use k + 2
    constructor
    · -- f(k+2) ≠ 0
      rw [h_shift (k + 2) (by omega)]
      simp only [add_sub_cancel']
      exact hk
    · -- (k+2) - 2 = k
      omega
  · -- Values match
    intro a ha
    -- If f(a) ≠ 0, then a ≥ 2
    have ha' : 2 ≤ a := by
      by_contra h
      push_neg at h
      have : f a = 0 := h_zero a h
      rw [this] at ha
      exact ha rfl
    -- So f(a) = g(a-2)
    exact h_shift a ha'

end PotionProblem