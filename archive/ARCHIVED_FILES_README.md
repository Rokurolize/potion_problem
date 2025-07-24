# Archived Experimental Implementation Files

This archive contains the original 24 experimental implementation files from the UniformHittingTime project. These files were moved here during the project redesign to create a cleaner, more maintainable structure.

## Archive Date
2025-07-24

## Reason for Archiving
- Multiple overlapping implementations (7 "Working" variants, 6 "Minimal" variants)
- Transitive import dependencies causing hidden coupling
- Unclear which files were canonical vs experimental
- Design flaw where files relied on implicit imports from other files

## Important Files Worth Preserving

### Core Mathematical Results
1. **UniformSumHittingTime.lean** - Contains the main theorem with 2 active sorries:
   - Line 252: `summable_hitting_time` - Series summability proof
   - Line 413: Reindexing proof in `main_result`

2. **FactorialSeries.lean** - Proven factorial series convergence results
   - Most imported module (11 files depended on it)
   - Contains working mathematical proofs

3. **HittingTime.lean** - PMF formulas for hitting time
   - Had missing imports (design flaw)

4. **IrwinHall.lean** - Irwin-Hall distribution properties
   - Had missing imports (design flaw)

### Experimental Variants
- 7 "Working" files: Different attempts at the main proof
- 6 "Minimal" files: Simplified proof attempts
- 4 Telescoping series variants: Different approaches to telescoping proof
- Various other experimental files

## Files Actually Used in Tests
Only 2 files were actively tested:
- `TelescopingSeriesWorking.lean` (imported by test_working.lean)
- `FactorialSeries.lean` (imported by test_summability.lean)

## Migration Strategy
The proven mathematical content from these files has been extracted and migrated to the clean project structure in `/home/ubuntu/workbench/projects/potion-problem/` with proper explicit dependencies and TDD approach.

## Note on Sorries
Many experimental files contain additional sorry declarations beyond the 2 active ones. These represent incomplete experimental approaches and are not part of the main theorem proof.