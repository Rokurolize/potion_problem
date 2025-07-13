# Research Prompt: inv_factorial_ratio_tendsto_zero Proof in Lean 4 v4.12.0

## Context
Need to prove that the ratio of consecutive factorial terms tends to zero:
`Tendsto (fun n => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) atTop (nhds 0)`

## Mathematical Simplification
The ratio simplifies as:
```
(1/(n+1)!) / (1/n!) = n! / (n+1)! = n! / ((n+1) · n!) = 1/(n+1) → 0
```

## Current Blocking Issues

### 1. Factorial Type Casting
**Problem**: Lean 4 v4.12.0 type system issues with factorial in function expressions

**Current failing code**:
```lean
have h_eq : (fun n => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) = 
           (fun n => 1 / ((n : ℝ) + 1)) := by
  ext n
  field_simp [Nat.factorial_ne_zero]
  rw [Nat.factorial_succ, Nat.cast_mul, Nat.cast_succ]
  ring
```

**Error**: Type issues with `(n + 1).factorial` in real context

### 2. Tendsto API for 1/(n+1)
**Need**: v4.12.0 API to prove `Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (nhds 0)`

**Research questions**:
- What's the replacement for `tendsto_const_div_atTop_nhds_zero_nat`?
- Is there `tendsto_inv_atTop_zero` or similar?
- How to handle the `(n : ℝ) + 1` cast properly?

## Specific Research Questions

### 1. Factorial Field Operations in v4.12.0
**Query**: Best practices for factorial arithmetic in function expressions

**Need**: Working patterns for:
```lean
-- How to properly handle (n + 1).factorial in ℝ context?
def term (n : ℕ) : ℝ := 1 / ((n + 1).factorial : ℝ)

-- How to prove factorial_succ in division context?
example (n : ℕ) : (1 : ℝ) / (n + 1).factorial = 1 / ((n + 1 : ℕ) * n.factorial) := ?
```

### 2. Standard Limit Theorems
**Query**: v4.12.0 API for basic limit:
```lean
-- Want: 1/(n+1) → 0 as n → ∞
Tendsto (fun n : ℕ => (1 : ℝ) / (n + 1)) atTop (nhds 0)
```

**Search patterns**:
- `*tendsto*div*atTop*`
- `*tendsto*inv*atTop*`
- `*tendsto*natCast*`

### 3. Simplified Alternative Approach
Instead of complex function equality, consider:

**Query**: Direct ratio test API in v4.12.0:
```lean
-- Does Mathlib have built-in ratio test for factorial sequences?
-- Or: prove directly using factorial growth estimates
lemma factorial_ratio_bound (n : ℕ) : 
  ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial) = 1 / (n + 1) := ?
```

### 4. Function Extension Tactics
**Query**: How to handle `ext n` with type casting issues in v4.12.0?

**Alternative approaches**:
- Use `funext` instead of `ext`?
- Work with explicit equality proofs?
- Use `simp` lemmas for factorial casting?

## Expected Research Output
1. **Working proof** using simplest v4.12.0 API
2. **Factorial handling patterns** for similar future proofs  
3. **Import requirements** for limit theorems
4. **Alternative proof strategies** if direct approach fails

## Backup Strategy
If complex, provide working sorry with:
```lean
lemma inv_factorial_ratio_tendsto_zero :
  Tendsto (fun n => ((1 : ℝ) / (n + 1).factorial) / (1 / n.factorial)) atTop (nhds 0) := by
  -- Mathematical fact: ratio = 1/(n+1) → 0
  -- Proof method: [METHOD FROM RESEARCH]
  sorry
```

## Priority
**MEDIUM** - Important for ratio test theory but not blocking other modules