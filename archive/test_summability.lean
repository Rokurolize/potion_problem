import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Analysis.Normed.Group.Basic
import UniformHittingTime.FactorialSeries

-- Test file to explore available summability comparison theorems
open BigOperators

-- Check what comparison theorems are available
#check Summable.of_nonneg_of_le
#check summable_of_nonneg_of_le  
#check Summable.of_norm_bounded_eventually
#check summable_of_norm_bounded_eventually