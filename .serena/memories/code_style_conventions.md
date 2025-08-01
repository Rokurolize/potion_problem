# Code Style and Conventions for Potion Problem

## Lean 4 Style Guidelines

### File Organization
- Each module has a single responsibility (e.g., Basic.lean for definitions, Main.lean for the main theorem)
- Use clear module dependencies (imports at the top)
- Module hierarchy:
  - Basic.lean - Core definitions
  - FactorialSeries.lean - Factorial series lemmas
  - ProbabilityFoundations.lean - PMF properties
  - SeriesAnalysis.lean - Series manipulation
  - IrwinHallTheory.lean - Geometric interpretation
  - Main.lean - Executive summary with main theorem

### Naming Conventions
- Use snake_case for definitions and lemmas (e.g., `hitting_time_pmf`, `main_theorem`)
- Descriptive names that indicate mathematical content
- Prefix with module namespace (e.g., `PotionProblem.hitting_time_pmf`)

### Documentation
- Use `/-!` for module-level documentation
- Use `/--` for individual theorem/definition documentation
- Include mathematical context and LaTeX-style notation in comments
- Document dependencies and proof strategies

### Proof Style
- Use structured proofs with `by` blocks
- Prefer tactics that make the proof strategy clear
- Document complex proof steps with comments
- Mark incomplete proofs with `sorry` and detailed TODO comments

### Common Patterns
- **Field vs Direct Call**: Always use `Namespace.api_name args`, never `(object).api_name`
- **API Verification**: Test every mathlib4 API before use
- **Type Casting**: Be explicit with type conversions (e.g., `(n : ℝ)`)
- **Build-Driven Development**: Compile after every significant change

### Linter Settings (from lakefile.toml)
```toml
[leanOptions]
pp.unicode.fun = true
autoImplicit = false
relaxedAutoImplicit = false
weak.linter.mathlibStandardSet = true
maxSynthPendingDepth = 3
```

### Critical Rule
Do not disable the linter; you must follow the linter's instructions properly.

### Sorry Elimination Protocol
1. One sorry at a time - complete elimination before moving to next
2. Document mathematical approach in comments before attempting
3. Use strategic retreat with comprehensive documentation when needed
4. Always verify APIs before use