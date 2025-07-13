import Mathlib

-- Test what APIs are actually available in v4.12.0
#check Real.summable_pow_div_factorial
-- #check Summable.tendsto_zero  -- This doesn't exist
#check Summable
#check HasSum
-- Check what methods are available on Summable
open Summable
-- Check if there's a different name
variable {α : Type*} [AddCommMonoid α] [TopologicalSpace α] {f : ℕ → α}
variable (h : Summable f)
-- #check h.tendsto_zero  -- Test
#check hasSum_iff_tendsto_sum_nat