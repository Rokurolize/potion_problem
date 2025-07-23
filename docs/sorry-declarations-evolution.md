# Sorry Declarations Evolution Analysis

## Summary

The "3 sorries" that were supposedly fixed were actually **phantom references** - they never existed as actual theorems in the code. The CLAUDE.md documentation incorrectly listed theorem names that didn't correspond to actual code.

## Timeline of Sorry Declarations

### Original State (Before commit a1bb618)
**Actual sorries in code:**
1. Line 266: `sorry` in `summable_hitting_time` 
2. Line 414: `sorry` in `main_result` (reindexing proof)
3. Line 183: Commented out `inv_factorial_tendsto_zero` with sorry

**What CLAUDE.md incorrectly claimed:**
1. `telescoping_series_fixed` at TelescopingSeriesFixed.lean:36
2. `factorial_dominates_exponential_eventually` at UniformSumHittingTime.lean:213 
3. `inv_factorial_geometric_convergence` at UniformSumHittingTime.lean:250

### Investigation Findings

1. **`factorial_dominates_exponential_eventually`** and **`inv_factorial_geometric_convergence`**:
   - These were NEVER actual theorem names in UniformSumHittingTime.lean
   - Lines 213 and 250 don't contain these theorems
   - They appear only in CLAUDE.md documentation, not in actual code
   - Git history search confirms they never existed in the codebase

2. **`telescoping_series_fixed`**:
   - This theorem name also never existed
   - TelescopingSeriesFixed.lean contains `factorial_telescoping_sum_one` (not `telescoping_series_fixed`)
   - This file still has a sorry at line 40

3. **Actual evolution**:
   - The 2 real sorries in UniformSumHittingTime.lean moved slightly due to code changes:
     - Old line 266 → Current line 252 (summable_hitting_time)
     - Old line 414 → Current line 413 (h_left_eq_exp in main_result)

## Current State (Verified)

### Active Sorry Declarations (in used code):
1. **UniformSumHittingTime.lean:252** - `summable_hitting_time`
   ```lean
   sorry -- IMPLEMENTATION: Use Equiv.tsum_eq with subtypeEquiv or similar bijection
   ```

2. **UniformSumHittingTime.lean:413** - Inside `main_result` proof
   ```lean
   sorry -- IMPLEMENTATION: Apply bijection theorem to transform indices
   ```

### Sorry Declarations in Unused/Experimental Files:
3. **TelescopingSeriesFixed.lean:40** - `factorial_telescoping_sum_one` (1 sorry)
   - Only imported by HittingTimeComplete.lean which is dead code
   
4. **SeriesReindexing.lean** - Contains 6 sorries!
   - Not imported by any Lean code, only referenced in research documents
   
5. **TelescopingSeries.lean** - Has commented sorries
   - Not imported by anything after we removed its imports

### Files Actually in Use:
- UniformSumHittingTime.lean is the main implementation
- FactorialSeries.lean (imported by UniformSumHittingTime)
- HittingTime.lean (imported by UniformSumHittingTime)
- IrwinHall.lean (imported by HittingTime)
- Test files import specific modules

### Dead Code with Sorries:
- TelescopingSeriesFixed.lean (1 sorry)
- SeriesReindexing.lean (6 sorries)
- Various *Working*.lean and *Minimal*.lean files may have more

## Conclusions

1. **The "completion" in commit 036e470 was misleading** - it didn't actually complete 3 sorries because 2 of them never existed as code

2. **Documentation was out of sync with code** - CLAUDE.md listed theorem names that didn't exist

3. **We actually have 2-3 sorries**:
   - 2 in the main implementation (UniformSumHittingTime.lean)
   - 1 in an unused file (TelescopingSeriesFixed.lean)

4. **The sorry count confusion arose from**:
   - Documentation listing non-existent theorem names
   - Conflating documentation descriptions with actual code
   - Not verifying that listed theorems actually existed

## Action Items

1. **Update CLAUDE.md** to reflect:
   - Only 2 active sorries (lines 252, 413 in UniformSumHittingTime.lean)
   - Remove references to non-existent theorems
   - Note that many other sorries exist in unused experimental files

2. **Archive unused files with sorries**:
   - TelescopingSeriesFixed.lean (1 sorry)
   - SeriesReindexing.lean (6 sorries)
   - HittingTimeComplete.lean (imports TelescopingSeriesFixed)
   - Other experimental variants

3. **Focus on the 2 real mathematical proofs**:
   - `summable_hitting_time` - Prove series summability using reindexing
   - Reindexing proof in `main_result` - Complete the bijection argument

4. **Clean up project structure** as documented in project-cleanup-plan.md