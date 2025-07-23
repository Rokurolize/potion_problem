# Canonical vs Experimental Files Analysis

## Canonical Implementation Files

These files appear to be the main working implementation:

### Core Modules
1. **UniformHittingTime/UniformSumHittingTime.lean**
   - Contains the main theorem: `uniform_sum_hitting_time_expectation : expected_hitting_time = exp 1`
   - Has the 2 remaining `sorry` declarations (lines 252, 413)
   - Imports both FactorialSeries and HittingTime
   - This is clearly the main implementation file

2. **UniformHittingTime/FactorialSeries.lean**
   - Most imported module (11 files depend on it)
   - Provides proven factorial series convergence results
   - Used in test_summability.lean
   - Core mathematical foundation

3. **UniformHittingTime/HittingTime.lean**
   - Provides hitting time PMF formulas
   - Currently has no imports (design flaw - should import basic mathlib)
   - Only imported by UniformSumHittingTime.lean

### Supporting Files
4. **UniformHittingTime/IrwinHall.lean**
   - Irwin-Hall distribution properties
   - Currently has no imports (should have mathlib imports)

## Experimental/Redundant Files

### "Working" Variants (7 files)
These appear to be different attempts at implementation:
- ActuallyWorking.lean
- ActuallyWorkingCore.lean  
- MinimalWorking.lean
- SimpleWorkingProofs.lean
- WorkingCore.lean
- WorkingMinimal.lean
- WorkingResults.lean

**Evidence**: Multiple similar names, only TelescopingSeriesWorking is tested

### "Minimal" Variants (6 files)
Attempts at minimal proofs:
- BasicMinimal.lean
- DemonstrationMinimal.lean
- HittingTimeMinimal.lean
- TelescopingMinimal.lean
- TelescopingMinimalWorking.lean
- TelescopingSeriesMinimal.lean

**Evidence**: "Minimal" suffix suggests experimental simplifications

### Telescoping Series Variants (4 main variants)
- TelescopingSeries.lean (no imports - broken)
- TelescopingSeriesFixed.lean (attempted fix)
- TelescopingSeriesMinimal.lean
- TelescopingSeriesWorking.lean (used in test_working.lean)

**Evidence**: Multiple attempts to fix telescoping series implementation

### Other Experimental Files
- HittingTimeComplete.lean (alternative "complete" version)
- MathematicalCore.lean (standalone mathematical concepts)
- SeriesReindexing.lean (utility functions)
- StoppingTimeBasic.lean (no imports - possibly abandoned)

## Files with Design Issues

### Missing Imports (4 files)
These files have NO imports at all:
1. HittingTime.lean - Should import Real, Nat basics
2. IrwinHall.lean - Should import Real, probability basics
3. StoppingTimeBasic.lean - Likely abandoned
4. TelescopingSeries.lean - Broken after import removal

## Recommended Canonical Structure

```
UniformHittingTime/
├── Basic.lean              (merge StoppingTimeBasic + core defs)
├── FactorialSeries.lean    (keep as is)
├── IrwinHall.lean         (add proper imports)
├── HittingTime.lean       (add proper imports)
├── Telescoping.lean       (consolidate working telescoping proofs)
└── Main.lean              (rename from UniformSumHittingTime)
```

Main library file should import and re-export:
```lean
-- UniformHittingTime.lean
import UniformHittingTime.Main
import UniformHittingTime.FactorialSeries
import UniformHittingTime.HittingTime

-- Re-export main results
export UniformSumHittingTime (uniform_sum_hitting_time_expectation)
```

## Action Items
1. Add missing imports to HittingTime.lean and IrwinHall.lean
2. Consolidate telescoping series implementations
3. Archive experimental files in a separate directory
4. Update main library file to properly import/export