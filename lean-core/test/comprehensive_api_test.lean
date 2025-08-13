-- Comprehensive API test for pre-verified library
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Finset.Empty
import Mathlib.Topology.Piecewise

-- Test infinite sum APIs
section InfiniteSums
variable {α : Type*} [AddCommGroup α] [TopologicalSpace α] [T2Space α] 
variable {f g : ℕ → α} (hf : Summable f) (hg : Summable g) (k : ℕ)

-- Test the correct modern APIs
#check Summable.tsum_add hf hg
#check Summable.sum_add_tsum_nat_add k hf
-- #check Summable.tsum_add_tsum_compl hf s  -- needs set parameter

-- Test factorial series API
#check Real.summable_pow_div_factorial
example (x : ℝ) : Summable (fun n ↦ x ^ n / n.factorial : ℕ → ℝ) := 
  Real.summable_pow_div_factorial x

end InfiniteSums

-- Test factorial APIs
section Factorials

#check Nat.factorial
#check Nat.factorial_ne_zero  
#check Nat.factorial_succ
#check Nat.mul_factorial_pred

-- Test usage patterns
example (n : ℕ) : n.factorial ≠ 0 := Nat.factorial_ne_zero n
example (n : ℕ) (hn : n ≠ 0) : n * (n - 1).factorial = n.factorial := 
  Nat.mul_factorial_pred hn

end Factorials

-- Test finset APIs
section Finsets

#check Finset.not_mem_empty
-- Test if Finset.notMem_empty exists
-- #check Finset.notMem_empty  -- This should fail if deprecated warning was wrong

example (a : ℕ) : a ∉ (∅ : Finset ℕ) := Finset.not_mem_empty a

end Finsets

-- Test continuity APIs
section Continuity

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
variable {f g : X → Y} {s : Set X} {p : X → Prop} [∀ x, Decidable (p x)]

-- Test if-then-else continuity patterns
#check Continuous.if
#check ContinuousOn.if
#check continuous_piecewise

end Continuity