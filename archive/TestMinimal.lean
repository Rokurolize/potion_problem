/-
Minimal test to verify basic Lean 4 functionality works
-/
import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Factorial.Basic

theorem factorial_positive (n : ℕ) : 0 < n.factorial := Nat.factorial_pos n

theorem simple_factorial_ratio (n : ℕ) (hn : n ≥ 1) :
  (n - 1 : ℝ) / n.factorial = 1 / (n - 1).factorial - 1 / n.factorial := by
  cases' n with k
  · omega
  · simp [Nat.factorial_succ]
    field_simp
    ring

#check factorial_positive
#check simple_factorial_ratio