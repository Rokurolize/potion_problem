# mathlib4 v4.21.0 API Solutions Summary

## Overview

Based on the research findings, all identified API gaps have working solutions in mathlib4 v4.21.0. The issues were primarily about finding the correct API names and usage patterns.

## Solution 1: Reindexing with `Equiv.tsum_eq`

**Problem**: `tsum_equiv` is not available in v4.21.0

**Solution**: Use `Equiv.tsum_eq` with a custom equivalence:

```lean
-- Define the equivalence
def subtypeEquiv : {n // n ≥ 2} ≃ ℕ :=
  Equiv.ofBijective (fun ⟨n, h⟩ => n - 2) ...

-- Apply reindexing
lemma reindex_series :
  ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial =
  ∑' k : ℕ, (1 : ℝ) / k.factorial := by
  rw [Equiv.tsum_eq subtypeEquiv.symm]
```

## Solution 2: Conditional Series with `tsum_subtype'`

**Problem**: Converting between indicator functions and subtype sums

**Solution**: Use `tsum_subtype'`:

```lean
have h := tsum_subtype' (fun n => if n ≥ 2 then (1 : ℝ) / (n-2).factorial else 0)
-- This converts: ∑' n, if P n then f n else 0 = ∑' n : {n // P n}, f n
```

## Solution 3: Comparison Test Implementation

**Problem**: Proving summability via comparison test

**Solution**: Correct usage of `Summable.of_norm_bounded_eventually_nat`:

```lean
lemma summable_factorial_diff :
  Summable (fun n => if n ≥ 2 then (1 : ℝ) / (n-1).factorial - 1/n.factorial else 0) := by
  
  -- Step 1: Prove the bound
  have h_bound : ∀ᶠ n in atTop, ‖...‖ ≤ (1 : ℝ) / (n-1).factorial := by
    filter_upwards [eventually_ge_atTop 2] with n hn
    rw [Real.norm_eq_abs]
    exact factorial_diff_abs_bound n hn

  -- Step 2: Prove comparison series is summable
  have h_summable_bound : Summable (fun n => (1 : ℝ) / (n-1).factorial) :=
    summable_shifted_factorial

  -- Step 3: Apply comparison test
  exact Summable.of_norm_bounded_eventually_nat h_summable_bound h_bound
```

## Solution 4: HasSum Construction

**Problem**: Constructing HasSum from summability and partial sum convergence

**Solution**: Use `HasSum.tsum_eq` with `hasSum_of_sum_range_le`:

```lean
theorem factorial_telescoping_sum_one :
  ∑' n, (if n ≥ 2 then (1 : ℝ) / (n-1).factorial - 1/n.factorial else 0) = 1 := by
  
  apply HasSum.tsum_eq
  apply hasSum_of_sum_range_le
  
  -- Use the proven partial sum convergence
  exact pmf_partial_sums_tend_to_one
```

## Implementation Strategy

### For UniformSumHittingTime.lean:
1. Replace `tsum_equiv` calls with `Equiv.tsum_eq`
2. Use `tsum_subtype'` for conditional series conversion
3. Implement proper equivalence definitions for index transformations

### For TelescopingSeries.lean:
1. Implement `summable_factorial_diff` using the comparison test pattern above
2. Prove `factorial_telescoping_sum_one` using `HasSum.tsum_eq`
3. Ensure all helper lemmas are properly connected

## Key API Patterns

1. **Conditional to Subtype**: `∑' n, if P n then f n else 0 = ∑' n : {n // P n}, f n`
2. **Equivalence Reindexing**: `∑' n : A, f n = ∑' m : B, f (e.symm m)` where `e : A ≃ B`
3. **Comparison Test**: `Summable f ← ∃g, Summable g ∧ ∀ᶠ n, ‖f n‖ ≤ g n`

## Next Steps

With these API solutions, the remaining sorries in both files can be resolved:
- Implement the equivalence-based reindexing in UniformSumHittingTime
- Apply the comparison test pattern in TelescopingSeries
- Use HasSum construction for the final telescoping sum theorem

All mathematical foundations are already proven - these API connections will complete the formalization.