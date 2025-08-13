-- Test deprecated vs new APIs
import Mathlib.Data.Finset.Empty

-- Test if notMem_empty actually exists
example (a : ℕ) : a ∉ (∅ : Finset ℕ) := by
  -- Try the suggested replacement
  exact Finset.notMem_empty a
  
-- Check the signatures
#check Finset.not_mem_empty  -- Deprecated version
#check Finset.notMem_empty   -- New version