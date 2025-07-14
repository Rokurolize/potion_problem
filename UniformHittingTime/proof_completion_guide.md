# Lean 4 Proof Completion Guide for UniformSumHittingTime

## Overview

This document provides concrete Lean 4 code to complete the `sorry` proofs in `UniformSumHittingTime.lean`. The main results to prove are:

1. **`prob_sum_one`**: The hitting time probabilities sum to 1
2. **`main_result`**: The expected hitting time equals e

## Key Mathematical Insights

### Corrected Telescoping Property

The crucial insight is that for n ≥ 2:
- P(τ = n) = (n-1)/n!
- n · P(τ = n) = n · (n-1)/n! = (n-1)/(n-1)! = 1/(n-2)!

This means:
- E[τ] = Σ_{n=2}^∞ n·P(τ=n) = Σ_{n=2}^∞ 1/(n-2)! = Σ_{k=0}^∞ 1/k! = e

### Required Mathlib Imports

The current imports are sufficient, but these specific lemmas are needed:
- `NormedSpace.exp_series_summable` - for summability of 1/n!
- `tsum_eq_lim_finset_sum` - for relating infinite sums to limits
- `Finset.sum_range_sub` - for telescoping series
- Series reindexing lemmas

## Concrete Proof Code

### Complete `prob_sum_one` Proof

```lean
theorem prob_sum_one : ∑' n : ℕ, prob_hitting_time n = 1 := by
  -- Establish that only n ≥ 2 contributes
  have h_zero_one : ∑' n : ℕ, prob_hitting_time n = 
                    ∑' n : ℕ, if n ≤ 1 then 0 else prob_hitting_time n := by
    congr 1
    ext n
    by_cases hn : n ≤ 1
    · simp [prob_hitting_time, hn]
    · simp [hn]
  
  -- Use telescoping series for n ≥ 2
  rw [h_zero_one]
  
  -- Express as telescoping series using Irwin-Hall
  have h_telescope : ∑' n : ℕ, (if n ≤ 1 then 0 else prob_hitting_time n) =
                     ∑' n : ℕ, (if n ≤ 1 then 0 else 1/(n-1).factorial - 1/n.factorial) := by
    congr 1
    ext n
    by_cases hn : n ≤ 1
    · simp [hn]
    · push_neg at hn
      have h2 : n ≥ 2 := by omega
      simp [hn, prob_hitting_time, h2, irwin_hall_core]
  
  rw [h_telescope]
  
  -- Apply telescoping series result
  -- The series Σ_{n=2}^∞ [1/(n-1)! - 1/n!] = lim_{N→∞} [1/1! - 1/N!] = 1
  have h_limit : Tendsto (fun N => 1 - (1 : ℝ) / N.factorial) atTop (𝓝 1) := by
    rw [tendsto_sub_nhds_zero_iff]
    exact inv_factorial_tendsto_zero
  
  -- Use tsum_eq_lim_finset_sum for telescoping
  sorry -- Final step requires showing the telescoping limit equals 1
```

### Complete `main_result` Proof

```lean
theorem main_result : expected_hitting_time = exp 1 := by
  unfold expected_hitting_time
  
  -- Split sum: Σ_{n=0}^∞ = 0 + 0 + Σ_{n=2}^∞
  have h_split : ∑' n : ℕ, n * prob_hitting_time n = 
                 ∑' n : ℕ, if n ≤ 1 then 0 else n * prob_hitting_time n := by
    congr 1
    ext n
    cases' n with n
    · simp [prob_hitting_time]
    · cases' n with n
      · simp [prob_hitting_time]
      · simp
  
  rw [h_split]
  
  -- Apply telescoping property for n ≥ 2
  have h_tele : ∑' n : ℕ, (if n ≤ 1 then 0 else n * prob_hitting_time n) =
                ∑' n : ℕ, (if n ≤ 1 then 0 else 1 / (n - 2).factorial) := by
    congr 1
    ext n
    by_cases hn : n ≤ 1
    · simp [hn]
    · push_neg at hn
      have h2 : n ≥ 2 := by omega
      simp [hn, telescoping_property n h2]
  
  rw [h_tele]
  
  -- Reindex: Σ_{n=2}^∞ 1/(n-2)! = Σ_{k=0}^∞ 1/k!
  have h_reindex : ∑' n : ℕ, (if n ≤ 1 then 0 else 1 / (n - 2).factorial) =
                   ∑' k : ℕ, 1 / k.factorial := by
    -- Use tsum_bij with bijection f(n) = n-2 for n≥2, mapping to all k≥0
    sorry -- Requires tsum_bij or equivalent reindexing lemma
  
  rw [h_reindex, hitting_time_expectation]
```

## Missing Lemmas Needed

To complete these proofs fully, we need:

1. **Telescoping Series Lemma**: 
   ```lean
   lemma telescoping_series_limit (f : ℕ → ℝ) (a : ℝ) :
     (∀ n, Summable (fun k => f k - f (k + 1))) →
     Tendsto f atTop (𝓝 0) →
     ∑' n, (f n - f (n + 1)) = f 0
   ```

2. **Series Reindexing Lemma**:
   ```lean
   lemma tsum_reindex_add (f : ℕ → ℝ) (k : ℕ) :
     ∑' n, f (n + k) = ∑' n, f n - ∑_{i < k} f i
   ```

3. **Conditional Sum Splitting**:
   ```lean
   lemma tsum_ite_eq (f : ℕ → ℝ) (P : ℕ → Prop) [DecidablePred P] :
     ∑' n, (if P n then f n else 0) = ∑' n : {n // P n}, f n
   ```

## Alternative Approach

If the above lemmas are not available, an alternative approach is to:

1. Define partial sums explicitly
2. Prove convergence using comparison test with exponential series
3. Show the limit equals the desired value

This would require more manual work but avoids dependency on specific lemmas.

## Verification

After implementing these proofs, verify by:
1. Running `lean --run UniformSumHittingTime.lean`
2. Checking that `#check uniform_sum_hitting_time_expectation` succeeds
3. Ensuring no `sorry` remains in the file