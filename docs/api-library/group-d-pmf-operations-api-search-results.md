# Group D: PMF Operations - LeanExplore API Search Results

**Target**: APIs for eliminating `tail_probability_formula` sorry in ProbabilityFoundations.lean
**Goal**: `(∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial`

## Executive Summary

Found **highly promising PMF operations** that provide specialized tools for probability mass function calculations involving conditional sums, indicator functions, and set-based filtering. Key discoveries include `PMF.filter`, `PMF.tsum_coe_indicator_ne_top`, and `PMF.toMeasure_apply_of_finite` which could enable direct manipulation of the conditional infinite sum in the tail probability formula.

## Search Results by Category

### 1. PMF Core Summation Operations

#### `PMF.hasSum_coe_one` (ID: 165908)
**API**: `theorem hasSum_coe_one (p : PMF α) : HasSum p 1`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:54`
**Relevance**: ⭐⭐⭐ **High** - Fundamental PMF property used in complement calculations
**Usage**: Establishes that any PMF sums to 1, critical for P(τ > n) = 1 - P(τ ≤ n) approach

#### `PMF.tsum_coe` (ID: 165909)  
**API**: `theorem tsum_coe (p : PMF α) : ∑' a, p a = 1`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:57`
**Relevance**: ⭐⭐⭐ **High** - Direct tsum formulation of PMF = 1
**Usage**: Provides tsum-based proof that PMF totals to 1

#### `PMF.tsum_coe_ne_top` (ID: 165910)
**API**: `theorem tsum_coe_ne_top (p : PMF α) : ∑' a, p a ≠ ∞`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:61`  
**Relevance**: ⭐⭐ **Medium** - Finiteness guarantee for PMF infinite sums
**Usage**: Ensures all PMF-based infinite sums are finite

### 2. PMF Indicator Function Operations ⚡ **CRITICAL**

#### `PMF.tsum_coe_indicator_ne_top` (ID: 165911) ⚡
**API**: `theorem tsum_coe_indicator_ne_top (p : PMF α) (s : Set α) : ∑' a, s.indicator p a ≠ ∞`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:64`
**Relevance**: ⭐⭐⭐⭐ **CRITICAL** - Exactly matches our conditional sum structure!
**Usage**: **PERFECT MATCH** for `∑' k, if k > n then hitting_time_pmf k else 0`
**Mathematical meaning**: For any PMF p and set s, the sum ∑ Iₛ(a)·p(a) is finite
**Implementation**: Could directly handle our `if k > n then ... else 0` pattern

### 3. PMF Measure-Theoretic Operations

#### `PMF.toMeasure_apply_of_finite` (ID: 165950) ⚡
**API**: `theorem toMeasure_apply_of_finite (hs : s.Finite) : p.toMeasure s = ∑' x, s.indicator p x`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:277`
**Relevance**: ⭐⭐⭐⭐ **CRITICAL** - Direct connection between measures and indicator sums
**Usage**: Shows p(s) = ∑ Iₛ(x)·p(x) for finite sets
**Mathematical meaning**: PMF measure of set = sum of indicator × PMF values
**Implementation**: Could convert tail probability to measure-theoretic form

### 4. PMF Filtering Operations ⚡ **BREAKTHROUGH**

#### `PMF.filter` (ID: 166006) ⚡
**API**: `def filter (p : PMF α) (s : Set α) (h : ∃ a ∈ s, a ∈ p.support) : PMF α`
**Implementation**: `PMF.normalize (s.indicator p) (by simpa using h) (p.tsum_coe_indicator_ne_top s)`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Constructions.lean:261`
**Relevance**: ⭐⭐⭐⭐⭐ **BREAKTHROUGH** - Creates new PMF by filtering on a set
**Usage**: **EXACTLY** what we need for conditional probability P(τ ∈ S | τ ∈ S)
**Mathematical meaning**: Conditional PMF given membership in set s

#### `PMF.filter_apply` (ID: 166007) ⚡
**API**: `theorem filter_apply (a : α) : (p.filter s h) a = s.indicator p a * (∑' a', (s.indicator p) a')⁻¹`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Constructions.lean:267`
**Relevance**: ⭐⭐⭐⭐ **CRITICAL** - Shows exact formula for filtered PMF values
**Usage**: Could provide normalization constant for conditional sums
**Mathematical meaning**: Filtered PMF value = (indicator × original) / (total mass in set)

#### `PMF.support_filter` (ID: 166010)
**API**: `theorem support_filter : (p.filter s h).support = s ∩ p.support`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Constructions.lean:278`
**Relevance**: ⭐⭐⭐ **High** - Support properties of filtered PMF
**Usage**: Helps understand domain of filtered distributions

### 5. PMF Support Operations

#### `PMF.support` (ID: 165913)
**API**: `def support (p : PMF α) : Set α := Function.support p`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:73`
**Relevance**: ⭐⭐ **Medium** - Set where PMF is nonzero
**Usage**: Could help characterize {k : k > n} ∩ support(hitting_time_pmf)

#### `PMF.support_nonempty` (ID: 165915)
**API**: `theorem support_nonempty (p : PMF α) : p.support.Nonempty`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:80`
**Relevance**: ⭐⭐ **Medium** - PMF support is always nonempty
**Usage**: Provides existence guarantees for support-based arguments

### 6. PMF Construction Operations

#### `PMF.normalize` (ID: 166002)
**API**: `def normalize (f : α → ℝ≥0∞) (hf0 : tsum f ≠ 0) (hf : tsum f ≠ ∞) : PMF α`
**Location**: `Mathlib/Probability/ProbabilityMassFunction/Constructions.lean:240`
**Relevance**: ⭐⭐⭐ **High** - Creates PMF by normalizing any function
**Usage**: Could normalize indicator functions to create conditional PMFs
**Mathematical meaning**: Takes function f, returns f(a) / (∑ f(x)) as PMF

## Strategic Implementation Pathways

### Approach 1: Direct Indicator Function Manipulation ⚡ **RECOMMENDED**
```lean
-- Key insight: ∑' k, if k > n then hitting_time_pmf k else 0 
--            = ∑' k, {k : k > n}.indicator hitting_time_pmf k
-- Use: PMF.tsum_coe_indicator_ne_top for finiteness
-- Use: PMF.toMeasure_apply_of_finite for evaluation (if set is finite)
```

### Approach 2: PMF Filtering Approach ⚡ **INNOVATIVE**
```lean
-- Create filtered PMF on {k : k > n}
-- Use PMF.filter to get conditional distribution  
-- Use PMF.filter_apply to extract normalization constant
-- Relationship: P(τ > n) = (total mass in {k > n}) = normalization constant⁻¹
```

### Approach 3: Measure-Theoretic Conversion
```lean
-- Convert hitting_time_pmf to measure
-- Use PMF.toMeasure_apply_of_finite on {k : k > n} (needs finiteness proof)
-- Convert back to sum using indicator function equivalence
```

## Critical Observations

### Perfect API Alignment ✅
1. **`PMF.tsum_coe_indicator_ne_top`** - EXACTLY matches our `∑' k, if k > n then ... else 0` pattern
2. **`PMF.filter`** - Provides sophisticated tools for conditional PMF operations  
3. **`PMF.toMeasure_apply_of_finite`** - Direct bridge between measures and indicator sums

### Missing Components ⚠️
1. **Infinite set handling** - `toMeasure_apply_of_finite` requires finite sets, but {k : k > n} is infinite
2. **Complement formulas** - No direct APIs for ∑_{k ∈ Sᶜ} found, may need manual decomposition
3. **Index set characterization** - May need separate proof that {k : k > n} has specific structure

### Implementation Priority ⭐⭐⭐⭐⭐
**Immediate next step**: Attempt elimination using `PMF.tsum_coe_indicator_ne_top` + complement decomposition with `PMF.tsum_coe`. This provides the most direct path to converting the conditional infinite sum into a manageable form.

## Conclusion

Found **exceptional PMF operations** specifically designed for the exact type of conditional probability calculations needed for `tail_probability_formula`. The combination of indicator function support (`PMF.tsum_coe_indicator_ne_top`) and filtering operations (`PMF.filter`) provides a sophisticated toolkit that could enable direct elimination of this sorry.

**Confidence Level**: ⭐⭐⭐⭐ **High** - These APIs are specifically designed for the operations we need.