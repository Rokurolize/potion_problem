# Potion Problem - Lean 4 Formalization

This directory contains the Lean 4 formalization of the Potion Problem (媚薬問題), proving that E[τ] = e.

## Main Theorem

The main theorem proves that the expected number of doses required equals Euler's number e:

```lean
theorem main_theorem : expected_hitting_time = exp 1
```

## Build Instructions

```bash
lake build
```

## Project Structure

- `PotionProblem.lean` - Library entry point
- `PotionProblem/`
  - `Basic.lean` - Core PMF definition
  - `FactorialSeries.lean` - Factorial series convergence
  - `ProbabilityFoundations.lean` - PMF properties and summability
  - `SeriesAnalysis.lean` - Series manipulation and main proof
  - `IrwinHallTheory.lean` - Geometric interpretation (optional, contains 4 sorries)
  - `Main.lean` - Executive summary with main theorem
- `test/` - Test files

## Status

✅ Main theorem proven with ZERO sorries in the core modules.

For detailed documentation, see the [docs](../docs) directory.