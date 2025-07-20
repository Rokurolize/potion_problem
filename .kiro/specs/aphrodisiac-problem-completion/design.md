# Design Document

## Overview

The Aphrodisiac Problem completion project aims to resolve the remaining 5 `sorry` statements in a sophisticated Lean 4 formalization that proves E[τ] = e. The project is mathematically complete but has technical implementation gaps where the mathematical reasoning is sound but the Lean 4 API connections need to be established. The design focuses on bridging these technical gaps while preserving the existing mathematical framework.

## Architecture

### Mathematical Foundation (Already Complete)

The project has a solid mathematical foundation with the following proven components:

- **Factorial Series Module**: Complete convergence proofs for ∑ 1/n! = e
- **Irwin-Hall Distribution**: Properties of sums of uniform random variables  
- **Stopping Time Theory**: Basic definitions and probability mass functions
- **Hitting Time Analysis**: PMF formulas P(τ = n) = (n-1)/n!

### Core Problem Structure

The mathematical proof follows this chain:
1. **PMF Identity**: P(τ = n) = (n-1)/n! for n ≥ 2
2. **Telescoping Property**: (n-1)/n! = 1/(n-1)! - 1/n!
3. **Expected Value**: E[τ] = ∑ n·P(τ = n) = ∑_{n≥2} 1/(n-2)!
4. **Series Reindexing**: ∑_{n≥2} 1/(n-2)! = ∑_{k≥0} 1/k! = e

### Technical Implementation Gaps

The remaining `sorry` statements fall into two categories:

#### Category 1: API Connection Issues (TelescopingSeries.lean)
- **summable_factorial_diff**: Mathematical proof complete, needs mathlib4 API integration
- **factorial_telescoping_sum_one**: Mathematical reasoning established, needs HasSum construction

#### Category 2: Series Reindexing (UniformSumHittingTime.lean)  
- **Complex subtype reindexing**: Bijection {n ≥ 2} ↔ ℕ established mathematically
- **Summability inheritance**: Mathematical equivalence proven, needs formal API connection
- **Main theorem completion**: All components proven, needs final assembly

## Components and Interfaces

### TelescopingSeries Module Interface

```lean
-- Core telescoping theorem (✅ PROVEN)
theorem telescoping_series_sum_v4_12_0 : HasSum (telescoping_diff a) (a 0 - 0)

-- Target theorems to complete
theorem summable_factorial_diff : Summable (factorial_diff)
theorem factorial_telescoping_sum_one : ∑' n, factorial_diff n = 1
```

**Design Strategy**: Use comparison test with exponential series and leverage existing bounds.

### UniformSumHittingTime Module Interface

```lean
-- Main theorem to complete
theorem main_result : expected_hitting_time = exp 1

-- Supporting lemmas to resolve
lemma summable_hitting_time : Summable (fun n => n * prob_hitting_time n)
lemma series_reindexing : ∑_{n≥2} 1/(n-2)! = ∑_{k≥0} 1/k!
```

**Design Strategy**: Leverage mathematical equivalence and use established bijection theory.

### Integration Points

The modules interact through these key interfaces:

1. **TelescopingSeries → UniformSumHittingTime**: Provides telescoping identity for PMF
2. **FactorialSeries → Both**: Supplies convergence results for ∑ 1/n! = e  
3. **HittingTime → UniformSumHittingTime**: Provides PMF definitions and basic properties

## Data Models

### Mathematical Objects

```lean
-- Probability mass function
def prob_hitting_time (n : ℕ) : ℝ := if n ≥ 2 then (n - 1) / n.factorial else 0

-- Expected value definition  
def expected_hitting_time : ℝ := ∑' n, n * prob_hitting_time n

-- Telescoping difference function
def factorial_diff (n : ℕ) : ℝ := 
  if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0
```

### Type System Considerations

The design must handle several Lean 4 type system challenges:

- **Subtype Reindexing**: Converting between `{n // n ≥ 2}` and `ℕ`
- **Conditional Summation**: Series with indicator functions
- **API Version Compatibility**: mathlib4 v4.21.0 specific patterns

## Error Handling

### Build Integrity Strategy

The design prioritizes maintaining build success throughout implementation:

1. **Incremental Progress**: Each change must preserve compilation
2. **Fallback Positions**: If complete resolution fails, improve documentation and add helper lemmas
3. **Verification Gates**: Mandatory build checks before any commits

### Mathematical Correctness

Error handling for mathematical reasoning:

1. **Proof Validation**: Each step must be mathematically sound
2. **Edge Case Coverage**: Handle boundary conditions (n < 2, convergence limits)
3. **Type Safety**: Ensure all mathematical operations are well-defined

## Testing Strategy

### Build Verification

```bash
# Primary test: Full project build
lake build

# Module-specific testing
lake build UniformHittingTime.TelescopingSeries
lake build UniformHittingTime.UniformSumHittingTime
```

### Mathematical Verification

The testing strategy leverages Lean 4's built-in verification:

1. **Type Checking**: Ensures all mathematical operations are valid
2. **Proof Verification**: Lean 4 kernel verifies all proof steps
3. **API Compatibility**: Build success confirms mathlib4 integration

### Progress Tracking

```lean
-- Sorry count verification
#check TelescopingSeries.summable_factorial_diff -- Should resolve to complete proof
#check TelescopingSeries.factorial_telescoping_sum_one -- Should resolve to complete proof  
#check UniformSumHittingTime.main_result -- Should resolve to complete proof
```

### Numerical Validation

The project includes Python numerical verification that serves as a mathematical sanity check:

```python
# Verify E[τ] ≈ e through simulation
# This provides confidence in the mathematical correctness
```

## Implementation Approach

### Phase 1: TelescopingSeries Completion

**Priority**: High (foundational for main theorem)

**Strategy**: 
- Use comparison test for `summable_factorial_diff`
- Leverage existing `telescoping_series_sum_v4_12_0` for `factorial_telescoping_sum_one`
- Focus on API integration rather than new mathematical development

### Phase 2: Series Reindexing Resolution  

**Priority**: High (required for main theorem)

**Strategy**:
- Establish formal bijection between index sets
- Use equivalence theory from mathlib4
- Connect mathematical equivalence to summability inheritance

### Phase 3: Main Theorem Assembly

**Priority**: Critical (project completion)

**Strategy**:
- Combine resolved components from Phases 1-2
- Ensure all mathematical steps are formally connected
- Verify complete proof chain from assumptions to E[τ] = e

### Fallback Strategy

If complete resolution proves challenging:

1. **Document Mathematical Reasoning**: Ensure all mathematical insights are captured
2. **Add Helper Lemmas**: Break complex proofs into smaller, manageable pieces  
3. **Improve Structure**: Enhance code organization and documentation
4. **Preserve Progress**: Ensure any improvements are committed and build successfully

This design balances mathematical rigor with practical implementation constraints, focusing on completing a sophisticated formal verification while maintaining the project's existing strengths.