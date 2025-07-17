# Research Prompt: Filter Eventually Lemmas in Lean 4 v4.12.0

## Context
Need to prove that if `Tendsto f atTop (𝓝 0)`, then eventually `f n < ε` for any `ε > 0`.

## Failing Code
```lean
have h_tendsto : Tendsto (fun n : ℕ => c ^ n / n.factorial) atTop (nhds 0) := by
  rw [← Nat.cofinite_eq_atTop]
  exact h_summable.tendsto_cofinite_zero

-- FAILING: Want ∀ᶠ n in atTop, c ^ n / n.factorial < 1
have h_eventual : ∀ᶠ n in atTop, c ^ n / n.factorial < 1 := by
  apply (tendsto_order.mp h_tendsto).2  -- ERROR
  exact one_pos
```

## Research Questions

### 1. Tendsto to Eventually API
**Query**: What's the v4.12.0 API for:
```lean
-- From: Tendsto f atTop (𝓝 0)  
-- To: ∀ᶠ n in atTop, f n < ε (for ε > 0)
```

**Search patterns**:
- `*tendsto*eventually*`
- `*tendsto*order*`
- `*nhds*eventually*`

**Files to check**:
- `/Mathlib/Topology/Basic.lean`
- `/Mathlib/Order/Filter/Basic.lean`
- `/Mathlib/Topology/Order.lean`

### 2. Alternative Approaches
If direct API doesn't exist, research:

1. **Metric space approach**: Since `ℝ` is metric space
2. **Epsilon-delta**: Direct `∀ ε > 0, ∃ N, ∀ n ≥ N, |f n| < ε`
3. **Filter membership**: Using `∈ 𝓝 0` directly

### 3. Specific Use Case
**Need to prove**: 
```lean
c : ℝ, hc : c > 1
h_summable : Summable (fun n : ℕ => c ^ n / n.factorial)
h_tendsto : Tendsto (fun n : ℕ => c ^ n / n.factorial) atTop (nhds 0)
⊢ ∀ᶠ n in atTop, c ^ n / n.factorial < 1
```

## Expected Research Output
1. Exact lemma name and import
2. Correct proof pattern
3. Working example with our specific types
4. Backup strategies if main API unavailable

## Priority
**HIGH** - Core to factorial dominance proof in formal verification