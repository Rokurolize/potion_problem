# Research Request: UniformSumHittingTime.lean - Three Remaining Sorries

## Overview

This research request seeks assistance with three interconnected mathematical proofs in UniformSumHittingTime.lean. These sorries represent the final barriers to completing the formal verification that E[τ] = e for the aphrodisiac problem.

## Mathematical Context

The main theorem establishes that for the stopping time τ = min{n ≥ 1 : ∑_{i=1}^n U_i ≥ 1} where U_i ~ Uniform[0,1), we have E[τ] = e.

The proof chain:
1. P(τ = n) = (n-1)/n! for n ≥ 2 (proven)
2. n × P(τ = n) = 1/(n-2)! for n ≥ 2 (proven via telescoping_property)
3. E[τ] = ∑_{n≥2} 1/(n-2)! (needs series manipulation)
4. ∑_{n≥2} 1/(n-2)! = ∑_{k≥0} 1/k! (needs reindexing proof)
5. ∑_{k≥0} 1/k! = e (proven)

## Technical Environment
- Lean 4 version: v4.21.0
- mathlib4 version: v4.21.0
- Key imports: Mathlib.Topology.Algebra.InfiniteSum.Basic, Mathlib.Analysis.SpecialFunctions.Exp

---

## Sorry #1: Series Reindexing (Line 194-210)

### Mathematical Statement
```lean
lemma reindex_series : ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial = 
                       ∑' k : ℕ, (1 : ℝ) / k.factorial
```

### What We Know
- The bijection k = n - 2 maps {n : ℕ // n ≥ 2} to ℕ
- Both sides equal exp(1) by mathematical reasoning
- We have proven exp_one_eq_tsum_inv_factorial: exp 1 = ∑' n : ℕ, (1 : ℝ) / n.factorial

### What We've Tried
```lean
have h_left : ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial = exp 1 := by
  -- The bijection k = n - 2 establishes equality
  -- But we can't find the right API to formalize this
  sorry
```

### Specific Challenges
1. **Subtype summation**: How to work with `∑' n : {n : ℕ // n ≥ 2}` in mathlib4?
2. **Bijection application**: What API exists for applying bijections to infinite sums?
3. **Index transformation**: How to formally prove that reindexing via k = n - 2 preserves the sum?

### Research Questions
1. What is the correct mathlib4 API for transforming sums over subtypes?
2. Is there a `tsum_bij` or similar theorem for bijective reindexing?
3. Should we use `Equiv` to formalize the bijection and then apply it?

---

## Sorry #2: Summability Inheritance (Line 217-266)

### Mathematical Statement
```lean
lemma summable_hitting_time : Summable (fun n => n * prob_hitting_time n)
```

### What We Know
- For n ≥ 2: n * prob_hitting_time n = 1/(n-2)! (proven via telescoping_property)
- For n ≤ 1: n * prob_hitting_time n = 0 (by definition)
- The series ∑_{k≥0} 1/k! is summable (FactorialSeries.summable_inv_factorial)
- By reindexing, our series equals the factorial series

### What We've Tried
```lean
-- We have the factorial series summability
have h_factorial_summable : Summable (fun k : ℕ => (1 : ℝ) / k.factorial) := 
  FactorialSeries.summable_inv_factorial
  
-- We know our series equals the factorial series via reindexing
-- But can't prove summability inheritance
```

### Specific Challenges
1. **Conditional summability**: How to prove summability when terms are 0 for n ≤ 1?
2. **Reindexing summability**: How to transfer summability through the bijection k = n - 2?
3. **API limitations**: What's the right approach in mathlib4 v4.21.0?

### Research Questions
1. Is there a theorem like `Summable.of_equiv` or `Summable.reindex`?
2. How to handle summability of functions that are zero except on a cofinite set?
3. Can we use `Summable.hasSum_iff` combined with the bijection?

---

## Sorry #3: Main Theorem Assembly (Line 268-411)

### Mathematical Statement
```lean
theorem main_result : expected_hitting_time = exp 1
```

### What We Know
- expected_hitting_time = ∑' n : ℕ, n * prob_hitting_time n
- We need to show this equals exp 1
- The proof strategy is clear: use telescoping property and reindexing

### Current Proof Structure
```lean
-- Step 1: Split sum into n < 2 and n ≥ 2 cases
have h_sum_split : (∑' n : ℕ, n * prob_hitting_time n) = 
                   (∑' n : ℕ, if n ≥ 2 then n * prob_hitting_time n else 0)
                   
-- Step 2: Apply telescoping property
have h_telescoping_transform : ... = 
  (∑' n : ℕ, if n ≥ 2 then ((n - 2).factorial : ℝ)⁻¹ else 0)
  
-- Step 3: Connect to exponential series (stuck here)
have h_left_eq_exp : ... = exp 1 := by
  -- Need to show conditional sum equals exponential series
  sorry
```

### Specific Challenges
1. **Conditional sum manipulation**: How to work with `∑' n : ℕ, if n ≥ 2 then f n else 0`?
2. **Subtype conversion**: How to convert between conditional sums and subtype sums?
3. **Final assembly**: How to connect all pieces using available APIs?

### Research Questions
1. What's the canonical way to handle conditional infinite sums in mathlib4?
2. Is there a theorem to convert `∑' n, if P n then f n else 0` to `∑' n : {n // P n}, f n`?
3. How to apply the reindex_series result within the main proof?

---

## Additional Context

### Available Helper Modules
- `UniformHittingTime.FactorialSeries`: Provides summable_inv_factorial
- `UniformHittingTime.HittingTime`: Provides telescoping properties
- `UniformHittingTime.TelescopingSeriesFixed`: Mathematical foundations

### Known API Constraints
- Type inference issues with complex dependent types
- Limited documentation for infinite sum manipulation in v4.21.0
- Possible missing lemmas for bijective reindexing of series

### Ideal Solution Properties
1. **Minimal new lemmas**: Use existing mathlib4 APIs where possible
2. **Clear proof structure**: Readable and maintainable
3. **Performance**: Avoid tactics that cause timeouts
4. **Generality**: Solutions that could help similar problems

---

## Summary

These three sorries are deeply interconnected:
- Sorry #1 (reindexing) is needed for Sorry #3
- Sorry #2 (summability) validates our approach
- Sorry #3 (main theorem) assembles everything

The mathematical reasoning is clear and correct. We need expertise in:
1. mathlib4's infinite sum API
2. Bijective reindexing of series
3. Conditional sum manipulation
4. Subtype summation techniques

Any insights into the proper mathlib4 v4.21.0 approach for these mathematical operations would be invaluable.