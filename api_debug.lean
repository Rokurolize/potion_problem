-- Debug v4.12.0 API availability
import Mathlib.Data.Nat.Basic
import Mathlib.Tactic

open Nat

-- Test what lemmas are available for natural number subtraction
example (m n : ℕ) (h : m ≤ n) (h0 : n - m = 0) : m = n := by
  -- Try different approaches since Nat.eq_of_le_of_sub_eq_zero is missing
  omega
  
-- Alternative proof without the missing lemma
example (m n : ℕ) (h : m ≤ n) (h0 : n - m = 0) : m = n := by
  -- Use the fact that if n - m = 0 and m ≤ n, then m = n
  have : n = m + (n - m) := Nat.add_sub_of_le h
  rw [h0, add_zero] at this
  exact this.symm

-- Test for the other missing lemma
example (m n k : ℕ) (h : m ≤ n) : (n - m = k) ↔ (n = m + k) := by
  constructor
  · intro h_eq
    rw [← h_eq]
    exact (Nat.add_sub_of_le h).symm
  · intro h_eq
    rw [h_eq, Nat.add_sub_cancel]