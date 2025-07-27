# Group D PMF Operations: Implementation Guide for tail_probability_formula

## Target Sorry Location
**File**: `/home/ubuntu/workbench/projects/potion_problem/PotionProblem/ProbabilityFoundations.lean:256`
**Goal**: `(∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial`

## Key API Discoveries

### Critical API: PMF.tsum_coe_indicator_ne_top ⚡
```lean
theorem tsum_coe_indicator_ne_top (p : PMF α) (s : Set α) : ∑' a, s.indicator p a ≠ ∞
```
**Perfect Match**: Our expression `∑' k, if k > n then hitting_time_pmf k else 0` is exactly `∑' k, {k : k > n}.indicator hitting_time_pmf k`

### Critical API: PMF.filter ⚡
```lean
def filter (p : PMF α) (s : Set α) (h : ∃ a ∈ s, a ∈ p.support) : PMF α :=
  PMF.normalize (s.indicator p) (by simpa using h) (p.tsum_coe_indicator_ne_top s)
```
**Innovation**: Creates conditional PMF by filtering on set s, exactly what we need for tail probabilities

### Supporting APIs
```lean
theorem tsum_coe (p : PMF α) : ∑' a, p a = 1
theorem filter_apply (a : α) : (p.filter s h) a = s.indicator p a * (∑' a', (s.indicator p) a')⁻¹
theorem toMeasure_apply_of_finite (hs : s.Finite) : p.toMeasure s = ∑' x, s.indicator p x
```

## Required Imports Analysis

Based on dependency analysis, the PMF operations require:
```lean
import Mathlib.Probability.ProbabilityMassFunction.Basic
import Mathlib.Probability.ProbabilityMassFunction.Constructions  
import Mathlib.Algebra.Indicator.Basic  -- for Set.indicator
import Mathlib.Data.ENNReal.Basic      -- for ENNReal operations
```

**Good News**: The current ProbabilityFoundations.lean file already has many of these imports through existing mathlib dependencies.

## Implementation Strategy

### Approach 1: Direct Indicator Conversion (Recommended)
```lean
theorem tail_probability_formula (n : ℕ) :
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := by
  -- Step 1: Convert conditional sum to indicator form
  have h_indicator : (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 
                     (∑' k : ℕ, {k : k > n}.indicator hitting_time_pmf k) := by
    simp only [Set.indicator_apply]
    -- This should be definitional or very simple
    
  rw [h_indicator]
  
  -- Step 2: Use complement decomposition with PMF.tsum_coe
  have total_sum : ∑' k, hitting_time_pmf k = 1 := pmf_sum_eq_one
  
  -- Step 3: Split into complement using existing complement lemmas
  -- (∑' k, indicator k) + (∑' k, indicator kᶜ) = ∑' k, hitting_time_pmf k = 1
  -- Therefore: ∑' k, indicator k = 1 - ∑' k, indicator kᶜ
  
  -- Step 4: Use telescoping results from existing lemmas
  -- We know ∑_{k ≤ n} hitting_time_pmf k = 1 - 1/n! from telescoping
  -- Therefore ∑_{k > n} hitting_time_pmf k = 1 - (1 - 1/n!) = 1/n!
  sorry
```

### Approach 2: PMF.filter Method (Alternative)
```lean
theorem tail_probability_formula (n : ℕ) :
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := by
  -- Create filtered PMF on {k : k > n}
  let tail_set : Set ℕ := {k | k > n}
  
  -- Show tail_set intersects support (needs: ∃ k > n, hitting_time_pmf k ≠ 0)
  have h_support : ∃ k ∈ tail_set, k ∈ hitting_time_pmf.support := by
    -- Use prob_tau_pos_iff: hitting_time_pmf k > 0 ↔ k ≥ 2
    use (max (n + 1) 2)
    constructor
    · simp [tail_set]
      exact lt_max_of_lt_left (Nat.lt_succ_self n)
    · rw [PMF.mem_support_iff]
      rw [prob_tau_pos_iff]
      exact le_max_right (n + 1) 2
      
  -- Apply PMF.filter
  have filtered := hitting_time_pmf.filter tail_set h_support
  
  -- Use PMF.filter_apply to extract the normalization constant
  -- The sum we want is exactly the normalization constant!
  sorry
```

## Next Steps Priority

1. **Add required imports** to ProbabilityFoundations.lean (if not already present)
2. **Test Approach 1** using indicator function conversion + existing telescoping lemmas
3. **Fallback to Approach 2** if direct indicator manipulation proves complex
4. **Leverage existing results**: The file already has `pmf_sum_eq_one` and telescoping lemmas that provide the mathematical foundation

## Confidence Assessment

**High Confidence** (⭐⭐⭐⭐): The PMF operations found are specifically designed for exactly this type of conditional probability calculation. The `PMF.tsum_coe_indicator_ne_top` theorem is a perfect match for our conditional sum structure.

**Risk Factors**:
- Index set manipulation complexity
- Need to prove support intersection property for PMF.filter approach
- Potential import conflicts (low risk based on current file structure)

**Expected Effort**: 1-2 hours of careful implementation using the documented APIs.