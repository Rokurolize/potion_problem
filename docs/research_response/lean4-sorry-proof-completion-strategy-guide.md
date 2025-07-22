<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Resolving 'declaration uses sorry' Warnings in Lean 4: A Comprehensive Guide

## Understanding the `sorry` Mechanism in Lean 4

The `sorry` mechanism in Lean 4 serves as a placeholder for incomplete proofs while maintaining a syntactically correct proof skeleton[1]. When Lean encounters `sorry`, it accepts the proof as complete but issues a warning to indicate that the formalization is incomplete[2]. The Lean 4.16.0 update introduced **unique sorrys**[3], making each `sorry` definitionally distinct to prevent "fake" theorems and enable "go to definition" functionality for debugging.

## Best Practices for Completing `sorry` Proofs

### 1. Systematic Approach to Proof Completion

**Dependency Order Strategy**: The most recommended approach is to complete `sorry` proofs in dependency order[1][4]. Start by identifying which theorems depend on others and work from the foundational lemmas upward. This ensures that each completed proof can build upon previously established results.

**Top-Down Proof Development**: Use the recommended strategy of writing proofs from the top down, using `sorry` to fill in subproofs initially[5]. Ensure Lean accepts the overall structure with all the `sorry` placeholders before attempting to complete individual parts.

**Incremental Progress**: It's perfectly acceptable to commit partial progress rather than completing all `sorry` proofs at once[1]. This allows for collaborative work and prevents losing progress during complex proof development.

### 2. Debugging and Exploration Tools

**Lean 4 Tactic Exploration**: When a proof gets stuck, several tactics help explore available options[6]:

- `exact?` - searches for exact matches in the current context
- `apply?` - finds applicable lemmas
- `rw?` - suggests rewrite rules
- `simp?` - shows which simplification rules apply

**InfoView Navigation**: The InfoView in VS Code provides real-time feedback about proof states[7][8]. You can step through proofs line by line to understand how each tactic transforms the goal.

**Trace Options**: Enable trace options to debug tactic behavior[9]:

- `set_option trace.Meta.isDefEq true` to see definitional equality checks
- `set_option pp.sorrySource true` to show source position information on sorrys[3]


## Specific Proof Strategies for Your Three Theorems

### Telescoping Series Proof Strategy

For the theorem `HasSum (fun k => (1 : ℝ) / (k + 1).factorial - (1 : ℝ) / (k + 2).factorial) 1`, you should leverage telescoping series techniques[10][11].

**Key Approach**:

1. Recognize this as a telescoping sum where consecutive terms cancel
2. Use partial fraction decomposition techniques[11]
3. Show that the partial sums converge to the limit by cancellation
4. Apply existing mathlib lemmas like `sum_range_sub'` for telescoping identities[10]

**Relevant Mathlib Resources**: Look for lemmas in `Mathlib.Analysis.SpecificLimits.Basic` and telescoping series results[12]. Terry Tao's formalization examples show how to use `gcongr` and `apply sum_range_sub'` for similar proofs[10].

### Factorial Dominance Over Exponentials

For `factorial_dominates_exponential_eventually : ∀ᶠ n in atTop, n.factorial > (2 : ℝ)^n`, this requires proving that factorials eventually outgrow exponential functions[13][14][15].

**Proof Strategy**:

1. Use induction starting from a suitable base case (typically n ≥ 4)[15]
2. Show that the ratio of consecutive terms approaches 0: `lim (2^(n+1) / (n+1)!) / (2^n / n!) = lim (2/(n+1)) = 0`[16]
3. Apply existing mathlib lemmas about factorial growth[17]
4. The key insight is that factorial grows by multiplying by increasing factors, while exponentials multiply by a constant[18]

**Mathematical Foundation**: Factorials grow much faster than any exponential function because `n! = 1 × 2 × 3 × ... × n` where the factors keep increasing, while `a^n` multiplies by the same factor `a` each time[14].

### Geometric Convergence Bounds

For `inv_factorial_geometric_convergence`, you need to establish that `1/n!` has geometric decay bounds.

**Strategy**:

1. Use the ratio test: show that `|(1/(n+1)!) / (1/n!)| = 1/(n+1) → 0 < 1`[19][20][21]
2. Find suitable constants `c` and `r` where `r = 1/2` (or another value < 1) works eventually[19]
3. The exponential bound comes from Stirling's approximation or direct factorial estimates[22]
4. Use existing convergence theory in mathlib's analysis library

## Mathlib4 v4.21.0 Resources

**Factorial Theory**: Use lemmas from `Mathlib.Data.Nat.Factorial.Basic`[17] which provides:

- Basic factorial properties
- Factorial monotonicity
- Growth estimates

**Infinite Series**: Leverage `Mathlib.Analysis.PSeries`[23] and related convergence tests.

**Real Analysis**: Use convergence lemmas from `Mathlib.Analysis.SpecificLimits.Basic` for limit theorems.

## Development Workflow Recommendations

1. **Start with the telescoping series** as it's likely the most straightforward and may provide insights for the others
2. **Use `#check` and `#find` tactics**[24] to explore available lemmas
3. **Enable helpful trace options** to understand what's happening when tactics fail
4. **Build incrementally**, testing each step rather than attempting complete proofs immediately
5. **Consider using `calc` mode** for step-by-step equational reasoning[25]

The key to successfully completing these `sorry` proofs lies in understanding the mathematical content, leveraging mathlib's extensive library, and using Lean 4's powerful tactic exploration tools. Each theorem builds on fundamental results about factorials, series convergence, and asymptotic behavior that are well-established in mathlib4.

