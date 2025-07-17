-- Foundation test file (following research recommendations)
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Algebra.BigOperators.Basic

open BigOperators

-- Test core functions (from research verification commands)
#check Real.summable_pow_div_factorial
#check (∑ n : ℕ in range 10, 1 / n.factorial : ℝ)

-- If this compiles, your foundation is solid
example : (∑ n : ℕ in range 10, 1 / n.factorial : ℝ) < 3 := by norm_num