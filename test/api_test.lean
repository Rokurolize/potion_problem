-- Test file for verifying API signatures and imports
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt

variable {α : Type} [AddCommGroup α] [TopologicalSpace α] [TopologicalAddGroup α] 
variable {f g : ℕ → α} (hf : Summable f) (hg : Summable g) (k : ℕ)

-- Test tsum_add replacement
#check Summable.tsum_add hf hg

-- Test sum_add_tsum_nat_add 
#check Summable.sum_add_tsum_nat_add k hf

-- Test tsum_add_tsum_compl
#check Summable.tsum_add_tsum_compl hf
