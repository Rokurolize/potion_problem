# Group B: Set-Based Conditional Operations - LeanExplore API Discovery Results

**Target Goal**: Find APIs to eliminate `tail_probability_formula` sorry in PotionProblem  
**Focus**: Convert `(∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial` from conditional sums to Set.indicator form

## 🎯 Core Challenge

The `tail_probability_formula` sorry requires converting conditional expressions like:
```lean
∑' k : ℕ, if k > n then hitting_time_pmf k else 0
```

Into set-based indicator function form for easier manipulation and proof.

## 📋 Search Results Summary

**Total searches executed**: 6 systematic queries  
**Key APIs identified**: 12 high-relevance functions  
**Primary insight**: Rich ecosystem of indicator function and piecewise APIs available

## 🔑 Critical API Discoveries

### 1. Core Indicator Function Definition

**API**: `Set.indicator` (ID: 9175)  
**File**: `Mathlib/Algebra/Group/Indicator.lean:45`  
**Signature**:
```lean
noncomputable def mulIndicator (s : Set α) (f : α → M) (x : α) : M :=
  haveI := Classical.decPred (· ∈ s)
  if x ∈ s then f x else 1
```
**Note**: The docstring mentions `Set.indicator s f a` is `f a` if `a ∈ s`, `0` otherwise (for additive version)

**Relevance**: ⭐⭐⭐⭐⭐ **Direct transformation target** - converts `if k > n then f k else 0` to `{k | k > n}.indicator f k`

---

### 2. Piecewise Function Definition

**API**: `Set.piecewise` (ID: 131855)  
**File**: `Mathlib/Logic/Function/Basic.lean:964`  
**Signature**:
```lean
def Set.piecewise {α : Type u} {β : α → Sort v} (s : Set α) (f g : ∀ i, β i)
    [∀ j, Decidable (j ∈ s)] : ∀ i, β i :=
  fun i ↦ if i ∈ s then f i else g i
```

**Relevance**: ⭐⭐⭐⭐⭐ **Perfect match** - exactly `if k > n then f k else 0` = `{k | k > n}.piecewise f 0`

---

### 3. PMF Indicator Summability

**API**: `PMF.tsum_coe_indicator_ne_top` (ID: 165911)  
**File**: `Mathlib/Probability/ProbabilityMassFunction/Basic.lean:64`  
**Signature**:
```lean
theorem tsum_coe_indicator_ne_top (p : PMF α) (s : Set α) : ∑' a, s.indicator p a ≠ ∞
```

**Relevance**: ⭐⭐⭐⭐⭐ **Critical for PMF context** - proves indicator sums with PMFs are finite

---

### 4. Indicator Function Summability Preservation

**API**: `NNReal.indicator_summable` (ID: 196690)  
**File**: `Mathlib/Topology/Instances/ENNReal/Lemmas.lean:934`  
**Signature**:
```lean
theorem indicator_summable {f : α → ℝ≥0} (hf : Summable f) (s : Set α) :
    Summable (s.indicator f)
```

**Relevance**: ⭐⭐⭐⭐ **Summability transfer** - if PMF is summable, so is its indicator restriction

---

### 5. Non-Zero Indicator Sums

**API**: `NNReal.tsum_indicator_ne_zero` (ID: 196691)  
**File**: `Mathlib/Topology/Instances/ENNReal/Lemmas.lean:942`  
**Signature**:
```lean
theorem tsum_indicator_ne_zero {f : α → ℝ≥0} (hf : Summable f) {s : Set α}
    (h : ∃ a ∈ s, f a ≠ 0) : (∑' x, (s.indicator f) x) ≠ 0
```

**Relevance**: ⭐⭐⭐ **Non-degeneracy** - ensures tail sums are non-zero when appropriate

---

### 6. Finite-Infinite Sum Splitting

**API**: `sum_add_tsum_nat_add` (ID: 187770)  
**File**: `Mathlib/Topology/Algebra/InfiniteSum/NatInt.lean:243`  
**Signature**: Alias of `Summable.sum_add_tsum_nat_add`  
**Mathematical statement**: If `∑_{i=0}^∞ a_i` converges, then for any `k`:
```
∑_{i=0}^{k-1} a_i + ∑_{i=0}^∞ a_{i+k} = ∑_{i=0}^∞ a_i
```

**Relevance**: ⭐⭐⭐⭐ **Tail decomposition** - splits infinite sum into finite prefix + infinite tail

---

### 7. General Complement Splitting

**API**: `sum_add_tsum_compl` (ID: 187680)  
**File**: `Mathlib/Topology/Algebra/InfiniteSum/Group.lean:184`  
**Signature**: Alias of `Summable.sum_add_tsum_compl`  
**Mathematical statement**: Sum over finite set + sum over complement = total sum

**Relevance**: ⭐⭐⭐⭐ **Set-based decomposition** - splits by arbitrary finite sets

---

## 🛠 Usage Patterns for tail_probability_formula

### Pattern 1: Direct Indicator Conversion
```lean
-- Transform conditional to indicator
∑' k : ℕ, if k > n then hitting_time_pmf k else 0
= ∑' k : ℕ, {k | k > n}.indicator hitting_time_pmf k
```

### Pattern 2: Set-Based Piecewise
```lean
-- Use piecewise function
∑' k : ℕ, if k > n then hitting_time_pmf k else 0
= ∑' k : ℕ, {k | k > n}.piecewise hitting_time_pmf 0 k
```

### Pattern 3: Finite-Infinite Decomposition
```lean
-- Split using nat_add pattern
∑' k : ℕ, hitting_time_pmf k
= ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k + ∑' k : ℕ, hitting_time_pmf (k + n + 1)
```

## 📚 Required Import Statements

Based on API discovery, these imports are needed:

```lean
import Mathlib.Algebra.Group.Indicator                        -- Set.indicator
import Mathlib.Logic.Function.Basic                           -- Set.piecewise  
import Mathlib.Probability.ProbabilityMassFunction.Basic      -- PMF.tsum_coe_indicator_ne_top
import Mathlib.Topology.Instances.ENNReal.Lemmas             -- NNReal.indicator_summable
import Mathlib.Topology.Algebra.InfiniteSum.Group            -- sum_add_tsum_compl
import Mathlib.Topology.Algebra.InfiniteSum.NatInt           -- sum_add_tsum_nat_add
```

## 🎯 Specific Application to tail_probability_formula

### Current Sorry Context
```lean
-- In ProbabilityFoundations.lean
sorry -- tail_probability_formula: 
-- ∀ (n : ℕ), (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial
```

### Recommended Transformation Strategy

1. **Step 1**: Convert conditional to indicator
   ```lean
   ∑' k : ℕ, if k > n then hitting_time_pmf k else 0
   = ∑' k : ℕ, {k | k > n}.indicator hitting_time_pmf k
   ```

2. **Step 2**: Use complement decomposition
   ```lean
   ∑' k : ℕ, hitting_time_pmf k
   = ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k + ∑' k : ℕ, {k | k > n}.indicator hitting_time_pmf k
   ```

3. **Step 3**: Apply `PMF.tsum_coe_indicator_ne_top` for finiteness
4. **Step 4**: Use existing PMF summability properties
5. **Step 5**: Connect to factorial formula via telescoping patterns

### Key Lemmas to Establish

1. **Indicator Equivalence**:
   ```lean
   lemma hitting_time_tail_as_indicator (n : ℕ) :
     (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 
     (∑' k : ℕ, {k | k > n}.indicator hitting_time_pmf k)
   ```

2. **Decomposition Property**:
   ```lean
   lemma hitting_time_decomposition (n : ℕ) :
     (∑' k : ℕ, hitting_time_pmf k) = 
     (∑ k ∈ Finset.range (n + 1), hitting_time_pmf k) + 
     (∑' k : ℕ, {k | k > n}.indicator hitting_time_pmf k)
   ```

## 🔬 Additional Supportive APIs

### Indicator Properties
- `Set.indicator_compl` (ID: 9238): Complement indicator relationships
- `Set.indicator_add'` (ID: 9224): Indicator distributivity over operations
- `Measurable.indicator` (ID: 138054): Measurability preservation

### Sum Bounds and Estimates  
- `ENNReal.tsum_le_tsum` (ID: 196634): Inequality preservation in infinite sums
- `tsum_le_of_sum_range_le` (ID: 187814): Bounds via finite approximations

### Advanced Decomposition
- `sum_add_tsum_subtype_compl` (ID: 187699): Subtype-based complement splitting
- `Finset.sum_indicator_mod` (ID: 58299): Modular arithmetic applications

## 🚀 Implementation Priority

1. **High Priority**: Implement indicator conversion using `Set.indicator` and `Set.piecewise`
2. **Medium Priority**: Establish decomposition using `sum_add_tsum_nat_add`
3. **Low Priority**: Prove support lemmas using indicator properties

## 💡 Key Insights

1. **Rich API ecosystem**: Mathlib provides comprehensive indicator function support
2. **Multiple approaches**: Both direct indicator conversion and piecewise functions available
3. **PMF-specific support**: Special APIs for probability mass functions with indicators
4. **Decomposition patterns**: Multiple ways to split infinite sums into manageable parts
5. **Summability preservation**: Strong guarantees about preservation of convergence properties

This comprehensive API discovery provides multiple viable paths for eliminating the `tail_probability_formula` sorry using set-based conditional operations.