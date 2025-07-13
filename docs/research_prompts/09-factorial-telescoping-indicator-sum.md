# Research Prompt: Factorial Telescoping Sum with Indicator Functions

## Objective
Prove that ∑_{n=0}^∞ (if n ≥ 2 then 1/(n-1)! - 1/n! else 0) = 1 using indicator function techniques in Lean 4.

## Mathematical Statement
```lean
theorem factorial_telescoping_sum_one :
  ∑' n : ℕ, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) = 1
```

## Required Deliverables

### 1. Indicator Function Analysis
**Decomposition:**
```
f(n) = {
  0                           if n = 0
  0                           if n = 1  
  1/(n-1)! - 1/n!            if n ≥ 2
}
```

**Key Property:**
```lean
-- The function has finite support starting at n=2
have support : Function.support f ⊆ {n | n ≥ 2} := by
  intro n hn
  simp [Function.mem_support] at hn
  split_ifs at hn with h
  · exact h
  · contradiction
```

### 2. Series Splitting Approach
```lean
-- Method 1: Split explicitly
have split : (fun n => if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0) =
             fun n => if n = 0 then 0 else if n = 1 then 0 else 1/(n-1).factorial - 1/n.factorial := by
  ext n
  cases' n with n
  · simp
  cases' n with n  
  · simp
  · simp [Nat.succ_succ_ne_one]

-- Method 2: Use tsum_ite
have : ∑' n, (if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0) =
       ∑' n : {n // n ≥ 2}, (1/((n:ℕ)-1).factorial - 1/(n:ℕ).factorial) := by
  rw [← tsum_subtype_eq_of_support_subset]
  · simp only [Subtype.coe_prop, ite_eq_left_iff]
    intro n hn
    simp at hn
    exact absurd hn (not_lt.mpr (le_refl n))
  · exact support_subset
```

### 3. Summability Proof
**Show the series is absolutely convergent:**
```lean
lemma summable_factorial_diff :
  Summable (fun n : ℕ => if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) := by
  -- Method 1: Bound by summable series
  apply Summable.of_norm_bounded _ (Summable.comp_injective summable_inv_factorial _)
  intro n
  split_ifs with h
  · -- Case n ≥ 2
    rw [norm_sub, norm_div, norm_div, norm_one, norm_one]
    simp only [one_div]
    -- Show |1/(n-1)! - 1/n!| ≤ 1/(n-1)! + 1/n!
  · -- Case n < 2
    simp
```

### 4. Connection to Previous Results
```lean
-- Use the established result for n ≥ 2
have key : ∑' n : {n : ℕ // n ≥ 2}, (1/((n:ℕ)-1).factorial - 1/(n:ℕ).factorial) = 1 :=
  factorial_telescoping_series_eq_one
  
-- Transform using indicator equivalence
rw [← key]
-- Apply tsum_subtype_eq_of_support_subset
```

### 5. Alternative: Direct Computation
```lean
calc ∑' n : ℕ, (if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0)
    = 0 + 0 + ∑' n : {n : ℕ // n ≥ 2}, (1/((n:ℕ)-1).factorial - 1/(n:ℕ).factorial) := by
        -- Split sum at n=0,1 and n≥2
        rw [tsum_eq_zero_add _]
        simp [if_neg (by norm_num : ¬0 ≥ 2)]
        rw [tsum_eq_zero_add _]
        simp [if_neg (by norm_num : ¬1 ≥ 2)]
        -- Now apply subtype equality
    = 0 + 0 + 1 := by rw [factorial_telescoping_series_eq_one]
    = 1 := by norm_num
```

### 6. Measure-Theoretic View
**Counting Measure Integration:**
```lean
-- View as integral against counting measure
-- ∫ f dμ where μ is counting measure on ℕ
-- f(n) = indicator_{n≥2} · (1/(n-1)! - 1/n!)
```

### 7. Computational Aspects
```lean
-- Verify convergence rate
def partial_sum_indicator (N : ℕ) : ℚ :=
  (List.range N).map (fun n => 
    if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0) |>.sum

#eval partial_sum_indicator 10   -- Should approach 1
#eval partial_sum_indicator 20   -- Should be closer to 1

-- Check that n=0,1 contribute 0
#eval (if 0 ≥ 2 then 1/(0-1).factorial - 1/0.factorial else 0 : ℚ)  -- 0
#eval (if 1 ≥ 2 then 1/(1-1).factorial - 1/1.factorial else 0 : ℚ)  -- 0
```

## Lean 4 Technical Points

### Working with `tsum` and `ite`
- Use `tsum_ite` lemmas effectively
- Handle `split_ifs` tactic properly
- Manage decidability instances for n ≥ 2

### Support and Convergence
- `Function.support` for where function is nonzero
- `tsum_subtype_eq_of_support_subset` for restriction
- Absolute convergence for rearrangement

### Norm Estimates
- Show |f(n)| is bounded by summable series
- Use triangle inequality for |a - b| ≤ |a| + |b|

## Expected Output Format
1. Complete proof using indicator functions (1000-1500 words)
2. Lean 4 implementation with multiple approaches
3. Explanation of why indicator method is useful
4. Connection to:
   - Measure theory and integration
   - Conditional convergence
   - Support theory in functional analysis
5. References to Mathlib4 documentation on:
   - `tsum` with conditionals
   - Support and indicator functions
   - Subtype summation

## Connection to Main Theorem
This theorem appears at line 94 of TelescopingSeries.lean and provides the indicator function version needed for the probability mass function summation.