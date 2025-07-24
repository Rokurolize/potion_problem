import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Analysis.SpecialFunctions.Exponential

-- Simple test to verify basic functionality
example : (1 : ℝ) + 1 = 2 := by norm_num

theorem test_factorial : Nat.factorial 3 = 6 := by norm_num

theorem test_exp : exp 0 = 1 := by simp [exp_zero]

#check test_factorial
#check test_exp