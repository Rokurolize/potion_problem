# Research Prompt: Resolving 'declaration uses sorry' Warnings in Lean 4

## Problem Context

We are working on a Lean 4 project that formalizes the Aphrodisiac Problem (a probability theory problem). The project builds successfully but has 3 warnings about `declaration uses 'sorry'`. We need to understand how to properly resolve these warnings by completing the proofs.

## Specific Issue

The build output shows:
```
warning: UniformHittingTime/TelescopingSeriesFixed.lean:36:8: declaration uses 'sorry'
warning: UniformHittingTime/UniformSumHittingTime.lean:213:6: declaration uses 'sorry'
warning: UniformHittingTime/UniformSumHittingTime.lean:250:8: declaration uses 'sorry'
```

These warnings indicate incomplete proofs in our formalization.

## Development Environment
- Lean 4 version: v4.21.0
- mathlib4 version: v4.21.0
- Operating system: Linux (WSL2)
- Build system: Lake

## Exact Code Causing Issues

### 1. TelescopingSeriesFixed.lean:36:8
```lean
theorem telescoping_series_fixed : 
    HasSum (fun k => (1 : ℝ) / (k + 1).factorial - (1 : ℝ) / (k + 2).factorial) 1 := by
  sorry
```

### 2. UniformSumHittingTime.lean:213:6
```lean
lemma factorial_dominates_exponential_eventually : 
    ∀ᶠ n in atTop, n.factorial > (2 : ℝ)^n := by
  sorry
```

### 3. UniformSumHittingTime.lean:250:8
```lean
theorem inv_factorial_geometric_convergence : 
    ∃ (c : ℝ) (r : ℝ), 0 < c ∧ 0 < r ∧ r < 1 ∧ 
    ∀ᶠ n in atTop, 1 / (n : ℝ).factorial ≤ c * r^n := by
  sorry
```

## What Has Been Tried

1. The project has been migrated from mathlib4 v4.12.0 to v4.21.0
2. Many API compatibility issues have been resolved
3. The build completes successfully despite these warnings
4. These `sorry` declarations are placeholders for proofs that need to be completed

## Specific Questions

1. **Best Practices**: What is the recommended approach for systematically completing `sorry` proofs in a Lean 4 project? Should we tackle them in dependency order?

2. **Proof Strategies**: For each of the three specific theorems:
   - What proof techniques would you recommend for the telescoping series equality?
   - How should we approach proving factorial dominance over exponentials?
   - What's the best way to prove the geometric convergence bound for inverse factorials?

3. **Mathlib4 Resources**: Which existing lemmas from mathlib4 v4.21.0 would be most helpful for completing these proofs?

4. **Debugging Tips**: What tools or tactics are most effective for exploring why a proof gets stuck when trying to replace a `sorry`?

5. **Incremental Progress**: Is it better to complete all `sorry` proofs at once, or can we commit partial progress (e.g., completing 1 out of 3)?

## Additional Context

This is part of a larger project formalizing a probability theory result. The final theorem depends on these lemmas, so completing them is essential for the mathematical correctness of the formalization.