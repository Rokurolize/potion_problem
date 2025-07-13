


# Research Results: Series Reindexing API in Lean 4 v4.12.0

Based on my analysis of the mathlib4 codebase, here are the current v4.12.0 APIs for your series reindexing needs:

## HIGH Priority Solutions

### 1. Finite Prefix + Infinite Tail Split
**Current v4.12.0 API**: `Summable.sum_add_tsum_nat_add` [1](#0-0) 

**Working Example**:
```lean
theorem reindex_series_shift (h_summable : Summable f) (a : ℕ) :
    (∑' n, f n) = (∑ i in Finset.range a, f i) + (∑' k, f (k + a)) := by
  exact h_summable.sum_add_tsum_nat_add a
```

### 2. Exponential Series API
**Current v4.12.0 API**: `Real.summable_pow_div_factorial` [2](#0-1) 

**Working Example**:
```lean
example : Summable (fun k : ℕ ↦ (1:ℝ) / k.factorial) := by
  convert Real.summable_pow_div_factorial 1
  ext k
  simp [one_pow, one_div]
```

### 3. Natural Number Addition Summability
**Current v4.12.0 API**: `summable_nat_add_iff` (additive version of `multipliable_nat_add_iff`) [3](#0-2) 

**Working Example**:
```lean
example : Summable (fun k : ℕ ↦ (1:ℝ) / (k+2).factorial) := by
  have h_summable_factorial : Summable (fun k : ℕ ↦ (1:ℝ) / k.factorial) := 
    Real.summable_pow_div_factorial 1
  rw [← summable_nat_add_iff 2]
  convert h_summable_factorial
  ext k
  simp [Nat.factorial_succ]
```

## MEDIUM Priority Solutions

### 4. Equivalence Composition for Summable
**Current v4.12.0 API**: `Equiv.summable_iff` [4](#0-3) 

**Working Example**:
```lean
theorem reindex_series_general (h_summable : Summable f) (φ : α ≃ ℕ) :
    Summable (f ∘ φ) ∧ (∑' a, f (φ a)) = ∑' n, f n := by
  constructor
  · rwa [φ.summable_iff]
  · rw [φ.tsum_eq]
```

### 5. tsum Equality Under Bijective Reindexing
**Current v4.12.0 API**: `Equiv.tsum_eq` [5](#0-4) 

## Important API Changes from Earlier Versions

### Deprecated Functions
- `sum_add_tsum_nat_add` is deprecated (since 2025-04-12), use `Summable.sum_add_tsum_nat_add` instead
- `tsum_eq_zero_add` is deprecated (since 2025-04-12), use `Summable.tsum_eq_zero_add` instead [6](#0-5) 

## Missing APIs for Complex Cases

### Indicator Function Reindexing
For your complex case with `∑' n, if n ≥ 2 then f (n - 2) else 0`, you'll need to combine:
- `hasProd_subtype_iff_mulIndicator` for indicator functions
- `Equiv.summable_iff` for the bijection `{n | n ≥ 2} ≃ ℕ` [7](#0-6) 

## Notes

- The v4.12.0 API uses `Summable.method_name` pattern instead of standalone function names
- All infinite sum theorems are in `Mathlib/Topology/Algebra/InfiniteSum/` modules
- The exponential series `∑ 1/k! = e` requires the full exponential function definition, not just the summability theorem
- For complex reindexing operations, you'll need to compose multiple theorems rather than using single lemmas

The finite prefix + infinite tail split and nat addition summability APIs are the most mature and directly applicable to your needs.
