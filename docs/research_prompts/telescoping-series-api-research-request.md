# Research Request: Lean 4 API Connection for Telescoping Series Sorries

## Context

This project formalizes the Aphrodisiac Problem in Lean 4. We have successfully proven all mathematical components but face two specific API connection challenges in `TelescopingSeries.lean`.

## Development Environment
- Lean 4 version: v4.21.0
- mathlib4 version: v4.21.0
- Operating system: Linux (WSL2)
- Project: Uniform Hitting Time formalization

## Sorry 1: `summable_factorial_diff` (line 519)

### Mathematical Foundation (Complete)

We have established:
1. The series ∑(n≥2) [1/(n-1)! - 1/n!] telescopes to 1
2. Each term satisfies |1/(n-1)! - 1/n!| ≤ 1/(n-1)! (proven in `factorial_diff_abs_bound`)
3. The bounding series ∑(n≥1) 1/n! is summable (proven via `summable_exp_tail`)
4. Partial sums converge: limₙ→∞ [1 - 1/(N-1)!] = 1 (proven in `pmf_partial_sums_tend_to_one`)

### Current Implementation

```lean
lemma summable_factorial_diff :
  Summable (fun n : ℕ => if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) := by
  -- Mathematical foundation complete, need API connection
  sorry
```

### What I've Tried

1. **Direct comparison test approach**:
```lean
-- Attempt 1: Using Summable.of_abs_convergent
have h_abs : ∀ n, |if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0| ≤
              if n ≥ 1 then (1 : ℝ) / (n - 1).factorial else 0 := by
  intro n
  by_cases h : n ≥ 2
  · simp [h]
    exact factorial_diff_abs_bound n h
  · simp [h]
-- Failed: Couldn't connect the bound series to summable_exp_tail properly
```

2. **Reindexing approach**:
```lean
-- Attempt 2: Shift indices to connect with exponential tail
have h_eq : (fun n => if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) =
            (fun n => if n = 0 ∨ n = 1 then 0 else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial) := by
  ext n; by_cases h : n ≥ 2; simp [h]; omega
-- Got stuck on connecting the transformed series to summability
```

3. **HasSum construction approach**:
```lean
-- Attempt 3: Build HasSum from partial sum convergence
have h_partial : ∀ N, ∑ n ∈ Finset.range N, 
  (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) =
  if N ≤ 2 then 0 else 1 - 1 / (N - 1).factorial := by
  -- Proved this part
-- Failed: Couldn't construct HasSum from this limit property
```

### Specific Technical Question

**How do I apply mathlib4's comparison test when:**
- The series starts at n=2 (conditional structure)
- The bounding series ∑(n≥1) 1/n! is proven summable via `summable_exp_tail`
- I have the pointwise bound |f(n)| ≤ g(n-1) with index shift

**Which specific API should I use?** `Summable.of_abs_convergent`, `Summable.of_norm_bounded`, or something else? How do I handle the index mismatch?

## Sorry 2: `factorial_telescoping_sum_one` (line 553)

### Mathematical Foundation (Complete)

We have proven:
1. The series is summable (via `summable_factorial_diff`)
2. Partial sums converge to 1: limₙ→∞ ∑ᵢ₌₂ⁿ⁻¹ (i-1)/i! = 1 (in `pmf_partial_sums_tend_to_one`)
3. The telescoping identity: (n-1)/n! = 1/(n-1)! - 1/n!
4. Core telescoping theorem works for general sequences (`telescoping_series_sum_v4_12_0`)

### Current Implementation

```lean
theorem factorial_telescoping_sum_one :
  ∑' n : ℕ, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) = 1 := by
  -- Have: summability (summable_factorial_diff)
  -- Have: partial sum limit (pmf_partial_sums_tend_to_one after transformation)
  -- Need: Connect tsum to limit
  sorry
```

### What I've Tried

1. **Direct HasSum construction**:
```lean
-- Attempt 1: Build HasSum from limit
have h_summable := summable_factorial_diff
obtain ⟨S, hS⟩ := h_summable
have h_tsum : ∑' n, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) = S := 
  hS.tsum_eq
-- Now need to show S = 1, but the limit is over Finset.range N \ Finset.range 2
-- Couldn't connect the different partial sum structures
```

2. **Index manipulation approach**:
```lean
-- Attempt 2: Convert between Finset.range N and Finset.range N \ Finset.range 2
have h_zero : ∀ n < 2, (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) = 0 := by
  intro n hn; simp [not_le.2 hn]
-- Tried to show partial sums over Finset.range N equal those over Finset.range N \ Finset.range 2
-- Got stuck on the technical details of filter convergence
```

3. **Using `Summable.hasSum_iff`**:
```lean
-- Attempt 3: Use characterization of tsum via limits
have h_limit_full : Tendsto (fun N => ∑ n ∈ Finset.range N, 
  (if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0)) atTop (nhds 1) := by
  -- Need to convert from limit over Finset.range N \ Finset.range 2
  -- to limit over Finset.range N
-- Failed: The conversion requires showing the first two terms are 0, which they are,
-- but I couldn't find the right lemmas to make this work smoothly
```

### Specific Technical Question

**How do I prove `tsum f = L` when I have:**
- `Summable f` (proven)
- `Tendsto (fun N => ∑ n ∈ Finset.range N \ Finset.range k, f n) atTop (nhds L)` (proven for k=2)
- `f n = 0` for all `n < k`

**What's the canonical way in mathlib4 v4.21.0 to handle this?** Should I use `HasSum.tsum_eq`, convert the partial sum structure, or is there a direct lemma for this pattern?

## Additional Context

### Why These Are Blocking

Both sorries represent the same fundamental challenge: connecting our mathematical proofs (which use natural partial sum structures) to mathlib4's API expectations. The mathematics is complete and verified through multiple approaches, but the technical API bridge remains elusive.

### What Would Help

1. **For summable_factorial_diff**: A concrete example of applying comparison test with index shifts or conditional series
2. **For factorial_telescoping_sum_one**: The canonical pattern for proving `tsum = limit` when partial sums are over a subset of indices

These aren't general "how to prove summability" questions - we have all the mathematical components. We need the specific API incantations for mathlib4 v4.21.0 to recognize what we've proven.

### Code Repository Structure

```
UniformHittingTime/
├── TelescopingSeries.lean  (contains the two sorries)
├── FactorialSeries.lean    (imported, provides summable_inv_factorial)
└── lakefile.toml          (mathlib4 v4.21.0 dependency)
```

Thank you for any guidance on these specific API connection challenges!