# Factorial Operations API Search Findings

**Mission: Group G - Factorial Operations API Discovery**  
**Target**: APIs for `tail_probability_formula` sorry elimination in PotionProblem  
**Goal**: `(∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial`

## Search Summary

Executed 6 systematic LeanExplore searches for factorial operations relevant to tail probability formula. Total results analyzed: 60+ API candidates from mathlib4 v4.21.0.

## Key Findings for Tail Probability Formula

### 🎯 **CRITICAL API: Complex.sum_div_factorial_le**

**ID**: 84423  
**File**: `Mathlib/Data/Complex/Exponential.lean:342`  
**Signature**:
```lean
theorem sum_div_factorial_le {α : Type*} [Field α] [LinearOrder α] [IsStrictOrderedRing α]
    (n j : ℕ) (hn : 0 < n) :
    (∑ m ∈ range j with n ≤ m, (1 / m.factorial : α)) ≤ n.succ / (n.factorial * n)
```

**Mathematical Formula**: `∑_{n ≤ m < j} 1/m! ≤ (n+1)/(n! · n)`

**Relevance to Tail Probability**: ⭐⭐⭐⭐⭐
- **Direct match** for factorial reciprocal sums with range conditions
- Provides **upper bound** for exactly the type of sum in tail probability
- Works with `range j with n ≤ m` pattern (finite sum with condition)
- Could be adapted for infinite sums using limit arguments

**Implementation Strategy**:
1. Use this theorem as a bounding technique for the tail sum
2. Apply limit arguments as `j → ∞` to handle infinite sums
3. The bound `(n+1)/(n! · n)` can help establish convergence properties

### 🎯 **Supporting API: PowerSeries.exp**

**ID**: 176575  
**File**: `Mathlib/RingTheory/PowerSeries/WellKnown.lean:180`  
**Definition**:
```lean
def exp : PowerSeries A := mk fun n => algebraMap ℚ A (1 / n !)
```

**Mathematical Formula**: `exp(x) = ∑_{n=0}^∞ x^n/n!`

**Relevance to Tail Probability**: ⭐⭐⭐⭐
- Shows **canonical representation** of `1/n!` as exponential series coefficients
- Provides connection to `∑ 1/n! = e` which is fundamental to the potion problem
- Offers formal power series framework for factorial reciprocals

### 🎯 **API: NormedSpace.exp_series_hasSum_exp'**

**ID**: 50361  
**File**: `Mathlib/Analysis/Normed/Algebra/Exponential.lean:422`  
**Signature**:
```lean
theorem exp_series_hasSum_exp' (x : 𝔸) : 
    HasSum (fun n => (n !⁻¹ : 𝕂) • x ^ n) (exp 𝕂 x)
```

**Relevance to Tail Probability**: ⭐⭐⭐⭐
- Establishes **HasSum convergence** for series involving `(n!)⁻¹`
- Provides convergence framework for infinite factorial reciprocal sums
- Could help prove summability properties needed for tail probability

### 🔧 **Utility API: NormedSpace.expSeries_eq_ofScalars**

**ID**: 50313  
**File**: `Mathlib/Analysis/Normed/Algebra/Exponential.lean:105`  
**Signature**:
```lean
theorem expSeries_eq_ofScalars : expSeries 𝕂 𝔸 = ofScalars 𝔸 fun n ↦ (n !⁻¹ : 𝕂)
```

**Relevance to Tail Probability**: ⭐⭐⭐
- Shows formal connection between exponential series and factorial reciprocals
- Provides structural understanding of how `n!⁻¹` appears in formal series

## Additional Factorial Infrastructure

### Basic Factorial Properties
- **Nat.factorial**: Core definition `factorial : ℕ → ℕ`
- **Nat.factorial_succ**: `(n + 1)! = (n + 1) * n!`
- **Nat.factorial_le**: Monotonicity `m ≤ n → m! ≤ n!`
- **Nat.self_le_factorial**: Growth bound `n ≤ n!`

### Factorial Positivity
- **Nat.factorial_pos**: `0 < n!` for all n
- **Mathlib.Meta.Positivity.evalFactorial**: Automatic positivity for factorials

## Implementation Recommendations for tail_probability_formula

### Primary Strategy: Use Complex.sum_div_factorial_le

```lean
-- Target: (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial

-- Step 1: Convert tsum to bounded sum + tail
have tail_bound : ∀ j, (∑ k ∈ range j with n < k, hitting_time_pmf k) ≤ 
    (∑ k ∈ range j with n < k, (1 / k.factorial : ℝ)) := by
  -- Use hitting_time_pmf definition

-- Step 2: Apply Complex.sum_div_factorial_le  
have factorial_bound : ∀ j, (∑ m ∈ range j with n ≤ m, (1 / m.factorial : ℝ)) ≤ 
    n.succ / (n.factorial * n) := by
  -- Direct application of Complex.sum_div_factorial_le

-- Step 3: Take limit as j → ∞
have limit_eq : (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 
    ∑' k : ℕ, if k > n then (1 / k.factorial : ℝ) else 0 := by
  -- Equality from hitting_time_pmf definition

-- Step 4: Use exponential series to evaluate the limit
-- ∑_{k>n} 1/k! = e - ∑_{k≤n} 1/k! = specific formula involving 1/n!
```

### Secondary Strategy: Power Series Approach

1. Use `PowerSeries.exp` to establish the formal series framework
2. Apply `exp_series_hasSum_exp'` for convergence properties
3. Use series manipulation theorems to handle the tail sum

## Required Imports

Based on the API findings:

```lean
import Mathlib.Data.Complex.Exponential        -- For sum_div_factorial_le
import Mathlib.RingTheory.PowerSeries.WellKnown -- For PowerSeries.exp
import Mathlib.Analysis.Normed.Algebra.Exponential -- For exp_series_hasSum_exp'
import Mathlib.Data.Nat.Factorial.Basic        -- For basic factorial properties
import Mathlib.Topology.Algebra.InfiniteSum.Basic -- For HasSum, Summable
```

## Mathematical Connection to Potion Problem

The tail probability formula is crucial because:

1. **hitting_time_pmf k = (k-1)! / k!** for k ≥ 2
2. **Tail sum**: `∑_{k>n} hitting_time_pmf k = ∑_{k>n} (k-1)!/k! = ∑_{k>n} 1/k`
3. **Target identity**: This should equal `1/n!` by the exponential series properties
4. **Connection to e**: The complete sum `∑ 1/k! = e` drives the main theorem E[τ] = e

## Confidence Assessment

**High Confidence** for success using `Complex.sum_div_factorial_le`:
- Direct applicability to factorial reciprocal sums with range conditions  
- Proven bound that matches the mathematical structure needed
- Well-established convergence framework in mathlib4

**Next Steps**: Implement the primary strategy using the bounding approach with `Complex.sum_div_factorial_le` as the core technique.

---

**Search Completed**: 2025-07-26  
**LeanExplore Version**: 0.3.0  
**Mathlib Version**: v4.21.0  
**Total APIs Analyzed**: 60+  
**Mission Status**: **PROMISING LEADS IDENTIFIED** for tail_probability_formula elimination