# Research Prompt: factorial_dominates_exponential Proof in Lean 4 v4.12.0

## Context
Need to complete the proof that factorial growth dominates exponential growth: for any c > 1, eventually n! > c^n.

## Current Mathematical Approach
The proof strategy is mathematically sound:
1. `Real.summable_pow_div_factorial c` gives us that ∑ c^n / n! converges
2. Summable sequences have terms → 0, so eventually c^n / n! < 1  
3. This means eventually n! > c^n

## Specific Research Questions

### 1. Filter Eventually from Tendsto API
**Current failing code**:
```lean
have h_tendsto : Tendsto (fun n : ℕ => c ^ n / n.factorial) atTop (nhds 0) := by
  rw [← Nat.cofinite_eq_atTop]
  exact h_summable.tendsto_cofinite_zero
-- NEED: ∀ᶠ n in atTop, c ^ n / n.factorial < 1
```

**Query**: What's the correct v4.12.0 API to derive `∀ᶠ n in atTop, f n < ε` from `Tendsto f atTop (𝓝 0)` and `ε > 0`?

**Search patterns**:
- `*tendsto*eventually*`
- `*nhds*lt*`
- `*eventually*lt*`

### 2. Division Inequality API
**Need**: Convert `c^n / n! < 1` to `n! > c^n` when `n! > 0`

**Query**: What's the v4.12.0 replacement for:
```lean
rw [div_lt_one h_pos] at hn
```

**Expected lemma**: `div_lt_one` or similar in `/Mathlib/Algebra/Order/Field/Basic.lean`

### 3. Alternative Metric Space Approach
If filter approach fails, research:

**Query**: How to use metric space properties of ℝ to prove:
```lean
-- From: Tendsto f atTop (𝓝 0)
-- To: ∀ᶠ n in atTop, |f n| < ε (for ε > 0)
-- Then: drop |·| since f n > 0
```

**Search in**: `/Mathlib/Topology/Metric/Basic.lean`

### 4. Working Example Pattern
**Need**: Complete working proof using one of these approaches:

```lean
lemma factorial_dominates_exponential {c : ℝ} (hc : c > 1) :
  ∀ᶠ n in atTop, (n.factorial : ℝ) > c ^ n := by
  have h_summable : Summable (fun n : ℕ => c ^ n / n.factorial) := 
    Real.summable_pow_div_factorial c
  have h_tendsto : Tendsto (fun n : ℕ => c ^ n / n.factorial) atTop (nhds 0) := by
    rw [← Nat.cofinite_eq_atTop]
    exact h_summable.tendsto_cofinite_zero
  -- [COMPLETE THIS PART WITH WORKING v4.12.0 API]
```

## Expected Research Output
1. Exact working proof using v4.12.0 API
2. Import requirements
3. Alternative approaches if main one doesn't work
4. Any missing lemmas that need separate proofs

## Priority
**HIGH** - This is a key mathematical foundation for factorial convergence theory in the formal proof.