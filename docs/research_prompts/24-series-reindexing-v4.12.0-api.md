# Research Prompt: Series Reindexing API in Lean 4 v4.12.0

## Context
SeriesReindexing.lean builds but contains strategic sorries for complex reindexing operations that need v4.12.0 API updates.

## Missing/Changed APIs

### 1. Equivalence Composition for Summable
**Current failing approach**:
```lean
-- OLD: h_summable.comp_equiv φ  
-- NEED: v4.12.0 replacement
theorem reindex_series_general (h_summable : Summable f) (φ : α ≃ ℕ) :
    Summable (f ∘ φ) ∧ (∑' a, f (φ a)) = ∑' n, f n := by
  -- Mathematical fact: bijective reindexing preserves summability and sum
  sorry
```

**Query**: What's the v4.12.0 API for:
- Summable composition with equivalences?
- tsum equality under bijective reindexing?

**Search patterns**:
- `*Summable*equiv*`
- `*Summable*comp*`
- `*tsum*equiv*`

### 2. Finite Prefix + Infinite Tail Split
**Current failing approach**:
```lean
-- OLD: tsum_sum_add_tsum_nat_add
-- NEED: v4.12.0 replacement  
theorem reindex_series_shift (h_summable : Summable f) (a : ℕ) :
    (∑' n, f n) = (∑ i in Finset.range a, f i) + (∑' k, f (k + a)) := by
  -- Mathematical: ∑_{n=0}^∞ f(n) = ∑_{i=0}^{a-1} f(i) + ∑_{k=0}^∞ f(k+a)
  sorry
```

**Query**: What's the v4.12.0 API for splitting infinite series into finite prefix + infinite tail?

**Search in**: `/Mathlib/Topology/Algebra/InfiniteSum/`

### 3. Indicator Function Reindexing
**Current complex case**:
```lean
-- NEED: v4.12.0 approach for indicator + equiv
theorem reindex_series_n_minus_two (h_summable : Summable f) :
    (∑' n, if n ≥ 2 then f (n - 2) else 0) = ∑' k, f k := by
  -- Mathematics: sum over {n ≥ 2} of f(n-2) = sum over ℕ of f(k) via k ↦ k+2
  sorry
```

**Query**: v4.12.0 patterns for:
- Indicator function series: `∑' n, if P n then f(g n) else 0`  
- Bijection `{n | n ≥ 2} ≃ ℕ` via `n ↦ n-2` and `k ↦ k+2`

### 4. Exponential Series API
**Current failing**:
```lean
-- OLD: Real.tsum_exp_series, Real.exp_one_tsum
-- NEED: v4.12.0 replacement
example : ∑' (k : ℕ), 1 / ↑k.factorial = Real.exp 1 := ?
```

**Query**: What's the v4.12.0 API for exponential series = e^x?

**Search patterns**:
- `*exp*tsum*`
- `*factorial*sum*`
- `*Real.exp*series*`

### 5. Natural Number Addition Summability
**Current timeout**:
```lean
-- OLD: summable_nat_add_iff, .comp_nat_add
-- NEED: v4.12.0 replacement
example : Summable (fun k : ℕ ↦ (1:ℝ) / (k+2).factorial) := by
  have h_summable_factorial : Summable (fun k : ℕ ↦ (1:ℝ) / k.factorial) := ...
  -- How to prove summability after shifting by constant?
  sorry
```

## Research Priorities

### HIGH Priority
1. **Finite + Infinite Split**: `tsum_sum_add_tsum_nat_add` replacement
2. **Exponential Series**: `∑ 1/k! = e` API in v4.12.0
3. **Nat Addition Summability**: shifting summable functions

### MEDIUM Priority  
4. **Equiv Composition**: general bijective reindexing
5. **Indicator Reindexing**: complex subset bijections

## Expected Research Output

For each API:
1. **Exact v4.12.0 lemma name and import**
2. **Working code example**
3. **Type signatures and requirements**
4. **Alternative approaches** if direct replacement doesn't exist

## Working Examples Needed

```lean
-- Priority 1: This pattern appears everywhere
example (h : Summable f) (a : ℕ) :
  (∑' n, f n) = (∑ i in Finset.range a, f i) + (∑' k, f (k + a)) := ?

-- Priority 2: Core mathematical fact
example : (∑' k : ℕ, (1 : ℝ) / k.factorial) = Real.exp 1 := ?

-- Priority 3: Basic reindexing
example (h : Summable f) : Summable (fun k => f (k + 2)) := ?
```

## Priority
**HIGH** - These APIs are fundamental to series manipulation throughout the project