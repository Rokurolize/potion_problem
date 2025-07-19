import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Analysis.Normed.Group.Basic

-- Check what's actually available for comparison tests
section
variable {α β : Type*} [AddCommMonoid α] [TopologicalSpace α] [Norm α] [TopologicalAddGroup α]

#check @summable_of_norm_bounded
#check @Summable.of_norm_bounded
#check @Summable.of_norm_bounded_eventually

end