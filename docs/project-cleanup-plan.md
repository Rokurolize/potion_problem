# Project Cleanup Plan

## Goal
Transform the current 24-file mess into a clean, well-structured Lean 4 project with explicit dependencies.

## Phase 1: Archive Experimental Files
Create `UniformHittingTime/archive/` directory and move:
- All "Working" variants except UniformSumHittingTime
- All "Minimal" variants  
- Duplicate telescoping series implementations
- Any files identified as experimental in canonical-vs-experimental-files.md

## Phase 2: Consolidate Core Implementation
Target structure:
```
UniformHittingTime/
├── Basic.lean              # Core definitions (merge from StoppingTimeBasic)
├── FactorialSeries.lean    # Keep as is - already clean
├── IrwinHall.lean         # Already fixed imports
├── HittingTime.lean       # Already fixed imports
├── Telescoping.lean       # Merge best parts from telescoping variants
└── Main.lean              # Rename from UniformSumHittingTime
```

## Phase 3: Fix Dependencies
1. Each file explicitly imports what it directly uses
2. No reliance on transitive imports
3. Main library file (UniformHittingTime.lean) properly imports and re-exports

## Phase 4: Update Tests
1. Update test files to import from consolidated modules
2. Remove tests for archived experimental files
3. Add integration test for main theorem

## Phase 5: Documentation
1. Update README with clean structure
2. Document why certain design decisions were made
3. Add module-level documentation explaining relationships

## Benefits
- Clear module hierarchy
- Explicit dependencies
- No duplicate implementations
- Easier to understand and maintain
- Sorry warnings might reappear once structure is clean

## Risk Mitigation
- All changes in separate branch
- Archive files, don't delete
- Comprehensive testing after each phase
- Document what was merged from where