import Mathlib.Topology.Algebra.InfiniteSum.Basic
import UniformHittingTime.FactorialSeries

-- Check HasSum connection patterns
#check @Summable.hasSum
#check @HasSum.tsum_eq
#check @HasSum.unique  
#check @summable_iff_hasSum