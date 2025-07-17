# Research Request: Final HittingTime.lean Proof Fixes for Lean 4 v4.12.0

## Project Context

We are completing the **final module** in our formal proof that E[τ] = e for the "potion problem" stopping time. The HittingTime.lean module contains the probability mass function calculations and telescoping properties. 

**Current Status**: 5/6 modules building successfully. HittingTime.lean has 3 remaining specific errors after applying P26 solutions.

## Technical Environment (FIXED)

- Lean Version v4.12.0 (synchronized)
- Mathlib Version v4.12.0 (synchronized)  
- Build System working with lake build
- Import Strategy using `import Mathlib` global approach

## Remaining Errors (Highly Specific)

### Error 1: Type Mismatch - Division vs Inverse Notation

**Location**: Line 71 in `hitting_time_pmf_formula` theorem

```lean
error: ././././UniformHittingTime/HittingTime.lean:71:2: type mismatch
  telescoping_diff_simplification n h_ge_one
has type
  1 / ↑(n - 1).factorial - 1 / ↑n.factorial = (↑n - 1) / ↑n.factorial : Prop
but is expected to have type
  (↑(n - 1).factorial)⁻¹ - (↑n.factorial)⁻¹ = (↑n - 1) / ↑n.factorial : Prop
```

**Context**: The theorem `telescoping_diff_simplification` returns division format but the goal expects inverse notation format.

**Current Code**:
```lean
theorem hitting_time_pmf_formula (n : ℕ) (hn : n ≥ 2) :
  (if n ≤ 1 then 0 else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial) = 
  (n - 1 : ℝ) / n.factorial := by
  have h_not_le : ¬n ≤ 1 := by linarith
  simp [h_not_le]
  have h_ge_one : n ≥ 1 := by linarith
  exact telescoping_diff_simplification n h_ge_one  -- ERROR: Type mismatch
```

**What's needed**: How to convert between `1 / ↑x.factorial` and `(↑x.factorial)⁻¹` formats in v4.12.0?

### Error 2: Unsolved Factorial Relationship Goal

**Location**: Line 106 in `hitting_time_telescoping_property` theorem

```lean
error: ././././UniformHittingTime/HittingTime.lean:106:4: unsolved goals
case succ
n : ℕ
hn : n ≥ 2
h1 : n.factorial = n * (n - 1).factorial
h_ge : n - 1 ≥ 1
m : ℕ
h : n - 1 = m + 1
h_m_eq : m = n - 2
⊢ m.factorial = (n - 2).factorial
```

**Context**: After establishing `m = n - 2`, we need to prove `m.factorial = (n - 2).factorial`.

**Current Code**:
```lean
have h2 : (n - 1).factorial = (n - 1) * (n - 2).factorial := by
  have h_ge : n - 1 ≥ 1 := by omega
  cases' h : n - 1 with m
  · rw [h] at h_ge; exfalso; omega
  · have h_m_eq : m = n - 2 := by
      have : m + 1 = n - 1 := h.symm
      omega
    -- ERROR: Need to prove m.factorial = (n - 2).factorial
    simp [Nat.factorial_succ]
```

**What's needed**: How to use the constraint `m = n - 2` to rewrite `m.factorial = (n - 2).factorial` in v4.12.0?

### Error 3: Conditional Form Conversion in Funext  

**Location**: Line 127 in `hitting_time_pmf_sum_one` theorem

```lean
error: ././././UniformHittingTime/HittingTime.lean:127:2: tactic 'apply' failed, failed to unify
  ?f = ?g
with
  (∑' (n : ℕ), if n ≤ 1 then 0 else 1 / ↑(n - 1).factorial - 1 / ↑n.factorial) =
    ∑' (n : ℕ), if n ≥ 2 then 1 / ↑(n - 1).factorial - 1 / ↑n.factorial else 0
```

**Context**: Converting between two equivalent conditional forms for telescoping series.

**Current Code**:
```lean
theorem hitting_time_pmf_sum_one :
  ∑' n : ℕ, (if n ≤ 1 then 0 else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial) = 1 := by
  convert TelescopingSeries.factorial_telescoping_sum_one using 1
  funext n
  by_cases h : n ≤ 1
  · simp [h]; have h_not_ge : ¬(n ≥ 2) := by omega; simp [h_not_ge]
  · simp [h]; have h_ge : n ≥ 2 := by omega; simp [h_ge]
```

**What's needed**: How to properly convert between `(n ≤ 1 → 0 | else f)` and `(n ≥ 2 → f | else 0)` in funext context?

## Research Questions

1. **For Division/Inverse Conversion**: What is the exact v4.12.0 tactic/lemma to convert between:
   - `(1 : ℝ) / x.factorial` ↔ `(↑x.factorial)⁻¹`
   - Should we use `div_eq_inv_mul`, `one_div`, or another approach?

2. **For Factorial Constraint Rewriting**: Given `h_m_eq : m = n - 2`, how to:
   - Apply this constraint to rewrite `m.factorial = (n - 2).factorial`
   - Should we use `rw [h_m_eq]`, `subst h_m_eq`, or `simp [h_m_eq]`?

3. **For Conditional Equivalence**: How to prove in v4.12.0 that:
   ```lean
   (if n ≤ 1 then 0 else f n) = (if n ≥ 2 then f n else 0)
   ```
   - What's the correct approach for this logical equivalence?
   - Should we use `split_ifs`, `by_cases`, or direct rewriting?

## Mathematical Context

This completes the **hitting time probability mass function** for the formal proof of E[τ] = e. The mathematical relationships are:

- P(τ = n) = (n-1)/n! for n ≥ 2 (hitting time PMF)
- Telescoping property where n·P(τ = n) = 1/(n-2)! 
- Series verification showing ∑P(τ = n) = 1 (probability axiom)

## Expected Output

For each error, provide:

1. **Exact working Lean 4 v4.12.0 code** that resolves the specific error
2. **Required tactics/lemmas** confirmed to exist in v4.12.0 Mathlib
3. **Brief explanation** of the approach used

## Success Metrics

- [ ] HittingTime.lean builds without errors
- [ ] All 6 core modules building successfully  
- [ ] Complete formal proof pipeline ready for final assembly

## Project Importance

This is the **final technical barrier** to completing our formal proof of E[τ] = e. Once HittingTime.lean builds successfully, we'll have all components needed for the complete formal verification of this beautiful mathematical result.

Thank you for helping resolve these final proof details!