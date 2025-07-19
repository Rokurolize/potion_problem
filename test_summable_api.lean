-- Test summability API in mathlib4 v4.21.0
import Mathlib.Analysis.Normed.Group.InfiniteSum
import Mathlib.Topology.Algebra.InfiniteSum.Basic

open BigOperators

-- Check available comparison theorems
#check Summable.of_nonneg_of_le
#check Summable.of_le
#check Summable.of_nonneg
#check Summable.of_norm_bounded_eventually

-- Test simple summability result
example : Summable (fun n : ℕ => (1 : ℝ) / (n + 1)^2) := by
  sorry
