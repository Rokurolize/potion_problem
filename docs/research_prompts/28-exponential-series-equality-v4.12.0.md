# Research Prompt 28: Exponential Series Equality in Lean 4 v4.12.0

## Mathematical Problem Statement

I need to prove the fundamental equality:
```lean
exp 1 = ∑' n : ℕ, (1 : ℝ) / n.factorial
```

This establishes that Euler's number e equals the infinite series ∑_{n=0}^∞ 1/n!, which is central to our formal proof of E[τ] = e.

## Current Implementation Context

**File**: `/home/ubuntu/workbench/projects/potion_problem/UniformHittingTime/UniformSumHittingTime.lean`
**Line 87**: Strategic sorry requiring completion

```lean
lemma exp_one_eq_tsum_inv_factorial : exp 1 = ∑' n : ℕ, (1 : ℝ) / n.factorial := by
  -- Mathematical justification: exp(1) = ∑_{n=0}^∞ 1/n! (fundamental exponential series)
  -- Strategic sorry: Real.tsum_exp API mismatch in v4.12.0
  -- TODO: Find correct v4.12.0 API for exponential series equality
  sorry
```

## Mathematical Background

### Classical Analysis
The exponential function has the power series representation:
```
exp(x) = ∑_{n=0}^∞ x^n/n! = 1 + x + x²/2! + x³/3! + ...
```

Setting x = 1 gives:
```
e = exp(1) = ∑_{n=0}^∞ 1/n! = 1 + 1 + 1/2! + 1/3! + ...
```

### Lean 4 Context
In Lean 4, we need to establish the connection between:
- `exp 1` (the exponential function evaluation)
- `∑' n : ℕ, (1 : ℝ) / n.factorial` (the infinite sum)

## Available Resources

**Working Components:**
- `FactorialSeries.summable_inv_factorial : Summable (fun n : ℕ => (1 : ℝ) / n.factorial)`
- `FactorialSeries.inv_factorial_tendsto_zero : Tendsto (fun n : ℕ => (1 : ℝ) / n.factorial) atTop (nhds 0)`
- Standard Mathlib4 v4.12.0 exponential function theory

**Build Environment:**
- Lean 4 v4.12.0 + Mathlib4 v4.12.0 (synchronized versions)
- Available imports: `Mathlib.Analysis.SpecialFunctions.Exp`, `Mathlib.Analysis.SpecialFunctions.Exponential`

## Research Questions

1. **What is the correct Lean 4 v4.12.0 theorem/API for the exponential series equality?**
   - Is there a direct theorem like `Real.exp_eq_tsum` or similar?
   - Should we use power series theory (`Analysis.Analytic.PowerSeries`)?
   - Are there intermediate lemmas we should compose?

2. **What is the proper proof approach for v4.12.0?**
   - Direct application of existing theorems?
   - Power series expansion then evaluation at x=1?
   - Complex analysis approach through analytic functions?
   - Differential equations approach (exp is solution to y' = y)?

3. **How do we handle the type coercions correctly?**
   - Natural number casting: `n.factorial` vs `(n.factorial : ℝ)`
   - Series convergence and infinite sums in the real number context
   - Integration with existing `tsum` infrastructure

## Expected Research Output

Please provide:

1. **Complete working Lean 4 v4.12.0 proof code** that establishes `exp 1 = ∑' n : ℕ, (1 : ℝ) / n.factorial`

2. **Required imports and dependencies** for the proof to compile

3. **Mathematical explanation** of the approach taken and why it works in the v4.12.0 context

4. **Alternative approaches** if the direct method encounters API limitations

## Impact on Formal Proof Project

This equality is absolutely central to our formal proof of E[τ] = e:
- It connects the hitting time calculation to Euler's number
- It validates the mathematical foundation of the entire project
- It enables the completion of the telescoping series argument

Success here will likely enable rapid completion of the remaining strategic sorries in the project.

## Context: Collaborative AI Research Methodology

This request is part of a structured AI collaboration approach where:
- Mathematical insights are delegated to specialized research AI
- Technical implementation details are handled by subagents
- Complex formal verification projects benefit from expert knowledge synthesis

The previous P26 research collaboration yielded excellent results for factorial series convergence; similar mathematical depth is needed here for exponential series theory.