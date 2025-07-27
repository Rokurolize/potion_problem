-- Test file for verifying API signatures and imports
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Group

variable {α : Type} [AddCommGroup α] [TopologicalSpace α] [IsTopologicalAddGroup α] 
variable {f g : ℕ → α} (hf : Summable f) (hg : Summable g) (k : ℕ)

-- Test tsum_add replacement
#check Summable.tsum_add hf hg
-- Expected: ∑' (b : ℕ), (f b + g b) = ∑' (b : ℕ), f b + ∑' (b : ℕ), g b

-- Test sum_add_tsum_nat_add (CRITICAL API for sorry elimination)
#check Summable.sum_add_tsum_nat_add k hf
-- Expected: ∑ i ∈ Finset.range k, f i + ∑' (i : ℕ), f (i + k) = ∑' (i : ℕ), f i

-- Test tsum_add_tsum_compl 
#check Summable.tsum_add_tsum_compl hf
-- Expected: ∑' (x : ↑s), f ↑x + ∑' (x : ↑sᶜ), f ↑x = ∑' (x : domain), f x

-- Test if deprecated aliases still work (for legacy compatibility)
#check tsum_add hf hg
#check sum_add_tsum_nat_add k hf