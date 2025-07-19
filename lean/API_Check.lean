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

-- Testing proposed APIs from P30.md
-- 1. hasSum_telescope - PROPOSED API
-- #check hasSum_telescope  -- Expected to fail

-- 2. tsum_subtype - PROPOSED API  
#check Finset.tsum_subtype
-- #check Finset.tsum_subtype' 

-- 3. summable_factorial_inv - PROPOSED API
-- #check summable_factorial_inv  -- Expected to fail

-- Alternative APIs that might exist:
#check Real.summable_pow_div_factorial  -- This works
-- #check summable_geometric_series
#check Summable.hasSum_iff

-- Test telescoping series alternatives
variable (f : ℕ → ℝ)
-- #check tsum_telescoping
-- #check hasSum_telescoping

-- Check what's available for factorial series
#check Nat.factorial
#check Real.summable_pow_div_factorial

-- Test finite sum APIs
variable (s : Finset ℕ)
#check Finset.sum