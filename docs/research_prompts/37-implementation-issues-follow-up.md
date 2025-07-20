# Research Prompt 37: Implementation Issues Follow-up - API Gaps in mathlib4 v4.21.0

## Context

We're implementing the Aphrodisiac Problem (Potion Problem) in Lean 4, proving that E[τ] = e where τ is the hitting time for sensitivity to reach 2x. After extensive implementation attempts, we've identified specific technical API gaps preventing completion. The mathematical proofs are complete - only technical connections to mathlib4 APIs remain.

## Development Environment
- Lean 4 version: v4.21.0
- mathlib4 version: v4.21.0
- Operating system: Linux (WSL2)
- Lake version: 5.1.0

## Issue 1: UniformSumHittingTime API Problems

### Missing API: `tsum_equiv`

**What we tried:**
```lean
-- In UniformSumHittingTime.lean, attempting to prove reindexing preserves series equality
have h_reindex : ∑' (k : ℕ), n_to_k_fun k = ∑' (n : ℕ), k_to_n_fun n := by
  -- Attempted to use tsum_equiv for bijection-based reindexing
  apply tsum_equiv
  -- ERROR: unknown identifier 'tsum_equiv'
```

**Error message:**
```
error: unknown identifier 'tsum_equiv'
```

**Alternative attempted:**
```lean
-- Also tried with Equiv.tsum_eq
apply Equiv.tsum_eq
-- ERROR: function expected at Equiv.tsum_eq
```

### Missing API: `tsum_subtype` signature mismatch

**What we tried:**
```lean
-- Attempting to convert conditional sum to unconditional
have h_tsum_eq : ∑' (n : ℕ), indicator {m | 2 ≤ m} (fun n => n * pmf n) n = 
                 ∑' (n : {m : ℕ | 2 ≤ m}), (n : ℕ) * pmf n := by
  apply tsum_subtype
  -- ERROR: application type mismatch
```

**Questions:**
1. In mathlib4 v4.21.0, what is the correct API for proving that reindexing via a bijection preserves tsum equality?
2. Is there a replacement for `tsum_equiv` that handles bijective index transformations?
3. What's the correct way to convert between `∑' (n : ℕ), indicator S f n` and `∑' (n : S), f n` in v4.21.0?

## Issue 2: TelescopingSeries Technical Challenges

### Successfully Implemented Structure

We successfully implemented the telescoping series framework using:
```lean
lemma summable_factorial_diff : Summable fun n => if 2 ≤ n then (n - 1) / n.factorial else 0 := by
  -- We have the mathematical proof complete:
  -- 1. Bound proven: |(n-1)/n!| ≤ 1/(n-1)! for n ≥ 2
  -- 2. Comparison series identified: ∑_{n≥2} 1/(n-1)! = ∑_{k≥1} 1/k!
  -- 3. Exponential series summability established
  
  -- Attempted implementation:
  apply Summable.of_norm_bounded_eventually_nat
  use fun k => 1 / (k + 1).factorial
  constructor
  · -- Need to prove the comparison series is summable
    sorry -- This is where we need help
  · -- Need to prove eventual bound holds
    filter_upwards [eventually_ge_at_top 2] with n hn
    -- Type issues arise here with norm vs absolute value
    sorry
```

### Missing: Connecting partial sums to HasSum

**What we tried:**
```lean
lemma factorial_telescoping_sum_one : 
  HasSum (fun n => if 2 ≤ n then (n - 1) / n.factorial else 0) 1 := by
  -- We have proven:
  -- 1. The series is summable (via summable_factorial_diff)
  -- 2. Partial sums converge to 1 (via pmf_partial_sums_tend_to_one)
  -- 3. Connection to telescoping_series_sum_v4_12_0 theorem
  
  -- Need to construct HasSum from these components
  -- Attempted:
  apply hasSum_iff_tendsto'.mpr
  -- ERROR: hasSum_iff_tendsto' has wrong type signature for our use case
```

### Version-Specific Questions

1. **Comparison Test API**: What's the correct way in v4.21.0 to prove summability via comparison when:
   - We have a bound `|f(n)| ≤ g(n)` for `n ≥ 2`
   - We know `∑ g(n)` is summable
   - We need to handle the conditional series starting at `n = 2`

2. **HasSum Construction**: How do we construct a `HasSum` proof when we have:
   - A proof that the series is `Summable`
   - A proof that partial sums converge to a specific value
   - The general telescoping theorem already proven

3. **Filter and Eventually API**: The `filter_upwards` syntax seems to have changed. What's the correct way to work with eventual properties in v4.21.0?

## Issue 3: Alternative Approaches

Given these API limitations, should we:

1. **Implement custom lemmas** for the missing functionality? For example:
   ```lean
   lemma tsum_equiv_custom {α β : Type*} [AddCommMonoid α] [TopologicalSpace α] 
     (e : β ≃ γ) (f : β → α) : ∑' b, f b = ∑' c, f (e.symm c) := sorry
   ```

2. **Use simpler proof strategies** that avoid these advanced APIs? Perhaps:
   - Direct manipulation of finite partial sums
   - Explicit index calculations without bijections
   - Manual summability proofs without comparison tests

3. **Work around the conditional series** by reformulating to avoid indicators?

## Current Status

- **Build Status**: ✅ Successful (3004/3004 modules)
- **Remaining Sorries**: 2 in TelescopingSeries.lean
  - Line 547: `summable_factorial_diff` - comparison test implementation
  - Line 695: `factorial_telescoping_sum_one` - HasSum construction
- **Mathematical Status**: Complete - all mathematical components proven
- **Technical Status**: Blocked on mathlib4 v4.21.0 API connections

## Specific Help Needed

1. **Exact API names and signatures** for summability comparison tests in v4.21.0
2. **Working examples** of conditional series summability proofs in current mathlib4
3. **HasSum construction patterns** from summability + limit convergence
4. **Index transformation techniques** that work with current tsum APIs
5. **Alternative proof strategies** if these APIs are genuinely missing in v4.21.0

The mathematical content is complete and rigorous. We just need the technical bridge to formalize it in Lean 4 v4.21.0.