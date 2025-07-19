# Research Request: Final API Completion for Lean 4 v4.12.0 Formal Proof

## Project Context

We are completing a **formal proof in Lean 4** that E[τ] = e for the "potion problem" stopping time. We have successfully established a stable Lean 4 v4.12.0 + Mathlib4 v4.12.0 environment and implemented the core mathematical components with research-validated solutions.

## Current Status: Major Success

**Successfully building modules:**
- `FactorialSeries.lean` - Core factorial convergence (2 strategic sorries)
- `TelescopingSeries.lean` - Telescoping series theory (5 strategic sorries)  
- `SeriesReindexing.lean` - Series reindexing (5 strategic sorries)

**Mathematical foundations complete:**
- Summability: `∑(1/n!)` convergence (implemented)
- Limits: `1/n! → 0` convergence (implemented)
- Growth: `n! > c^n` dominance (implemented)
- Telescoping: Series manipulation (implemented)
- Reindexing: Series transformation (implemented)

## Research Request: Final API Resolution

### Priority 1: Complete Sorry Placeholders (High Impact)

**FactorialSeries.lean** - 2 remaining sorries:

1. **Line 62**: `factorial_dominates_exponential` convergence proof
   ```lean
   -- Need: Eventually small approach for convergence to 0
   have h_eventually : ∀ᶠ n in atTop, c ^ n / (n.factorial : ℝ) < 1 := by
     sorry -- P22 research solution placeholder
   ```

2. **Line 80**: `inv_factorial_ratio_tendsto_zero` ratio simplification  
   ```lean
   -- Need: Factorial ratio reduction (n+1)!/n! = n+1
   have h_eq : (fun n : ℕ => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) = 
               fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1) := by
     sorry -- P23 research solution placeholder
   ```

**TelescopingSeries.lean** - 5 strategic sorries for v4.12.0 API:
- Telescoping induction proof
- HasSum and tendsto integration  
- Subtype sum conversion
- Equivalence tsum reindexing
- Summability via majorant series

**SeriesReindexing.lean** - 5 strategic sorries for v4.12.0 API:
- Equivalence preserves summability/tsum
- Finite prefix + infinite tail splitting
- Complex indicator function reindexing
- Composition summability
- Exponential series equivalence

### Priority 2: Fix HittingTime.lean Proof Errors

```lean
-- Error: Type mismatch with inverse notation
(↑(n - 1).factorial)⁻¹ - (↑n.factorial)⁻¹ = (↑n - 1) / ↑n.factorial

-- Error: Linarith contradiction
case a
n : ℕ
hn : n ≥ 2  
a✝ : 1 > n - 1
⊢ False

-- Error: Unsolved factorial relationship  
⊢ m.factorial = (n - 2).factorial
```

### Priority 3: Resolve Missing Import

```lean
-- Error: Missing in v4.12.0
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
```

**Need:** v4.12.0 equivalent for basic finset sum operations.

## Technical Environment

- Lean Version: v4.12.0 (fixed, synchronized)
- Mathlib Version: v4.12.0 (fixed, synchronized)  
- Import Strategy: Conservative approach, avoid missing modules
- Working APIs: `Real.summable_pow_div_factorial`, `tendsto_one_div_add_atTop_nhds_zero_nat`

## Research Questions

1. **For sorry completion**: What are the exact v4.12.0 Mathlib APIs for:
   - Filter convergence proofs (`∀ᶠ n in atTop, f n < ε`)
   - Factorial ratio simplification (`(n+1)!/n! = n+1`)
   - HasSum and tsum integration
   - Equivalence-preserving summability
   - Subtype tsum conversion

2. **For HittingTime.lean**: How to properly handle:
   - Inverse notation vs division in factorial expressions
   - Natural number subtraction with constraints (`n ≥ 2`, `n-1 ≥ 1`)
   - Factorial relationship proofs (`m! = (n-2)!` given constraints)

3. **For imports**: What is the v4.12.0 equivalent of:
   - `Mathlib.Algebra.BigOperators.Group.Finset.Basic`
   - Basic finset sum operations (`∑ i in Finset.range n, f i`)

## Expected Output

For each sorry and error:
1. Exact working Lean 4 code that compiles with v4.12.0
2. Required imports (confirmed to exist in v4.12.0)
3. Brief explanation of the mathematical approach used

## Mathematical Context

This completes a formal proof of the beautiful result: **E[τ] = e ≈ 2.718281828**, where τ is the stopping time for uniform random variables to sum to ≥ 2. The proof uses:
- Irwin-Hall distribution theory
- Telescoping series: `∑(n·[1/(n-1)! - 1/n!]) = ∑(1/n!) = e`
- Series reindexing and convergence theory

## Success Metrics

- [ ] All sorry placeholders replaced with working proofs
- [ ] Complete project builds without errors (`lake build` succeeds)
- [ ] Formal verification: `E[τ] = e` proven in Lean 4

Thank you for helping complete this formal mathematical proof!