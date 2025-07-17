# Research Prompt: Missing Lean 4 v4.12.0 API Lemmas

## Context
Working on formal proof in Lean 4 v4.12.0 + Mathlib4 v4.12.0. Several key lemmas are missing or have different names in this version.

## Specific Research Questions

### 1. `div_lt_one_iff_of_pos` Missing

**Problem**: Error `unknown identifier 'div_lt_one_iff_of_pos'`

**Need**: Lemma for rewriting `a / b < 1` when `0 < b`

**Query**: What is the correct v4.12.0 API for:
```lean
-- Want: a / b < 1 ↔ a < b (when 0 < b)
rw [div_lt_one_iff_of_pos h_pos] at hn
```

**Search in**: `/Mathlib/Algebra/Order/Group/Defs.lean`, `/Mathlib/Algebra/Order/Field/Basic.lean`

### 2. `tendsto_order.mp` Issues

**Problem**: Tendsto API for eventually conditions

**Current failing code**:
```lean
apply (tendsto_order.mp h_tendsto).2
exact one_pos
```

**Need**: How to prove `∀ᶠ n in atTop, f n < 1` from `Tendsto f atTop (𝓝 0)`

### 3. `tendsto_const_div_atTop_nhds_zero_nat` Missing

**Problem**: Error on proving `1/(n+1) → 0`

**Need**: v4.12.0 equivalent of this tendsto lemma

**Query**: What's the correct API for proving:
```lean
Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (𝓝 0)
```

### 4. Factorial Field Operations

**Problem**: Type confusion with `(n + 1).factorial` in function contexts

**Need**: Proper way to handle factorial arithmetic in function expressions

## Expected Output

For each issue, provide:
1. Exact lemma name in v4.12.0
2. Import path required  
3. Corrected proof syntax
4. Alternative approaches if direct lemma doesn't exist

## Priority
**HIGH** - Blocking FactorialSeries.lean completion which is foundation for entire formal proof.