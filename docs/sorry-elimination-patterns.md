# Sorry Elimination Technique Patterns

*Proven patterns and techniques for eliminating specific types of sorries*

## 📚 Core Technique Library

### Type Conversion Mastery

**Problem**: Mismatched types like `(↑n + 2)` vs `↑(n + 2)`

**Solution Pattern**:
```lean
have h_cast : (↑n + 2 : ℝ) = ↑(n + 2) := by simp only [Nat.cast_add, Nat.cast_two]
rw [h_cast]
```

**Why This Works**: Lean's type system is strict about cast placement. Always convert to the expected form.

### Series Reindexing Patterns

**Problem**: Need to extract first k terms from infinite series

**Pattern with Deprecated API** (`sum_add_tsum_nat_add`):
```lean
have h_eq := Summable.sum_add_tsum_nat_add k summability_proof
rw [← h_eq]  -- Note the reverse direction!
-- Show finite sum equals desired value
have h_finite : ∑ i ∈ Finset.range k, f i = target_value := by
  -- Proof here
```

**Critical Details**:
- **API Status**: Deprecated but still available in mathlib4 v4.21.0
- **Argument Order**: `k` first, then summability proof
- **Direction**: Use `← h_eq` (reverse) to get the form you want
- **Access Pattern**: Use `Summable.sum_add_tsum_nat_add`, not as a field on other types

### Telescoping Series Technique

**Problem**: Prove finite telescoping sum

**Strategy**:
1. **Apply telescoping identity to each term**:
   ```lean
   rw [Finset.sum_congr rfl (fun n hn => telescoping_lemma n proof_of_condition)]
   ```

2. **Split the sum**:
   ```lean
   rw [Finset.sum_sub_distrib]
   ```

3. **Use standard telescoping identity** (may need to prove separately)

**Advanced Pattern** (from PotionProblem experience):
```lean
-- For telescoping sum: ∑_{k=0}^{n-1} (1/(k+1)! - 1/(k+2)!)
conv_lhs => 
  rw [Finset.sum_congr rfl (fun k _ => pmf_telescoping (k + 2) (by omega : 2 ≤ k + 2))]
rw [Finset.sum_sub_distrib]
-- Results in: (∑ 1/(k+1)!) - (∑ 1/(k+2)!) = 1 - 1/(n+1)!
```

### Complement Decomposition for Tail Sums

**Problem**: Prove tail probability P(τ > n)

**Pattern**:
```lean
-- Decompose: tail + head = total
have h_complement : (∑' k : ℕ, if k > n then f k else 0) + 
                    ∑ k ∈ Finset.range (n + 1), f k = 
                    ∑' k : ℕ, f k := by
  rw [← summable_f.sum_add_tsum_compl (s := Finset.range (n + 1))]
  congr 1
  funext k
  simp only [Finset.mem_range, Finset.mem_compl]
  split_ifs with h
  · simp [le_iff_not_gt.mp (le_of_not_gt h)]
  · simp [h]
```

**Why This Works**: Partitions ℕ into {0,...,n} and {n+1,n+2,...}

### Factorial Identity Patterns

**Problem**: Proving n! = n * (n-1) * (n-2)! in Lean

**Solution**: Use `Nat.mul_factorial_pred` twice
```lean
have factorial_identity : (n.factorial : ℝ) = n * (n - 1) * (n - 2).factorial := by
  -- Use mul_factorial_pred twice: n * (n-1)! = n! and (n-1) * (n-2)! = (n-1)!
  have h1 : n * (n - 1).factorial = n.factorial := by
    apply Nat.mul_factorial_pred
    omega  -- n ≥ 2 implies n ≠ 0
  -- Similar for (n-1)!
  sorry -- Complete with proper casting
```

**Key Insight**: Natural number properties often need careful casting to ℝ

### Factorial Expression Syntax

**Problem**: `1.factorial` causes syntax errors

**Solution**: Use explicit `Nat.factorial 1` instead
```lean
-- ❌ Causes "unexpected identifier" error
(1 : ℝ) / 1.factorial

-- ✅ Correct syntax
(1 : ℝ) / Nat.factorial 1
```

**Why**: Lean's parser doesn't support `.factorial` on numeric literals

## 🧮 Advanced Convergence Patterns

### Factorial Limit Convergence (SESSION VALIDATED)

**Problem**: Need to show that 1/n! → 0 as n → ∞

**Solution Pattern**:
```lean
-- Use the FloorSemiring theorem for factorial limits
have h_limit : Tendsto (fun n => (1 : ℝ) / n.factorial) atTop (𝓝 0) := by
  have h := FloorSemiring.tendsto_pow_div_factorial_atTop (1 : ℝ)
  simpa only [pow_one] using h
```

**Required Imports**:
```lean
import Mathlib.Topology.Algebra.Order.Floor
import Mathlib.Analysis.SpecificLimits.Normed
```

**Why This Works**: `FloorSemiring.tendsto_pow_div_factorial_atTop` is a powerful theorem showing c^n/n! → 0 for any c.

### Index Shifting for Convergence (SESSION VALIDATED)

**Problem**: Show that if f(n) → L then f(n+k) → L

**Solution Pattern**:
```lean
-- For shifting by 1
have h_shifted : Tendsto (fun n => f (n + 1)) atTop (𝓝 L) := by
  exact Tendsto.comp h_base (tendsto_add_atTop_nat 1)
```

**Alternative using equivalence**:
```lean
-- Using Filter.tendsto_add_atTop_iff_nat
rwa [← Filter.tendsto_add_atTop_iff_nat k]
```

**Required Import**: `import Mathlib.Order.Filter.AtTopBot.Basic`

### HasSum via Partial Sum Convergence (SESSION VALIDATED)

**Problem**: Prove infinite sum equals a value using partial sum convergence

**Solution Pattern**:
```lean
have h_hasSum : HasSum f L := by
  rw [hasSum_iff_tendsto_nat_of_nonneg]
  · -- Show partial sums converge to L
    exact your_convergence_proof
  · -- Show non-negativity
    intro n
    exact your_nonnegativity_proof
```

**Required Import**: `import Mathlib.Topology.Instances.ENNReal.Lemmas`

**Critical**: This works specifically for non-negative functions.

### Shifted Sequence Summability (SESSION VALIDATED)

**Problem**: Show that if f is summable, then fun n => f (n + k) is summable

**Solution Pattern**:
```lean
have h_summable : Summable (fun n => f (n + k)) := by
  rw [← summable_nat_add_iff k]
  exact original_summability
```

**Why This Works**: `summable_nat_add_iff` establishes exact equivalence between summability of f and f shifted by k.

### Function Composition for Shifted Limits (SESSION VALIDATED)

**Problem**: Show that if `f(n) → L` then `f(n+k) → L` when `Filter.tendsto_add_atTop_iff_nat` doesn't apply directly

**Solution Pattern**:
```lean
-- To show: Tendsto (fun N => f (N + k)) atTop (𝓝 L)
have h_limit : Tendsto (fun N => f (N + k)) atTop (𝓝 L) := by
  -- Express as composition
  have h : (fun N => f (N + k)) = f ∘ (fun N => N + k) := by
    ext N
    simp only [Function.comp_apply]
  rw [h]
  -- Use Tendsto.comp with the index shift
  exact original_limit.comp (tendsto_add_atTop_nat k)
```

**Critical Details**:
- Use function equality (`ext`) to show the shifted function equals a composition
- Apply `Tendsto.comp` to combine the original limit with index shifting
- `tendsto_add_atTop_nat k` provides the index shift convergence

**Example from PotionProblem**:
```lean
-- Proving 1/(N+1)! → 0 from 1/n! → 0
have h_limit : Tendsto (fun N => (1 : ℝ) / (N + 1).factorial) atTop (𝓝 0) := by
  have h : (fun N => (1 : ℝ) / (N + 1).factorial) = 
           (fun n => (1 : ℝ) / n.factorial) ∘ (fun N => N + 1) := by
    ext N
    simp only [Function.comp_apply]
  rw [h]
  exact inv_factorial_tendsto_zero.comp (tendsto_add_atTop_nat 1)
```

## 🔧 Proof Structuring Patterns

### Case Analysis with Arithmetic Constraints ✅

For theorems involving natural numbers with different behavior in different ranges:

```lean
theorem example_theorem (n : ℕ) : some_property n := by
  by_cases h0 : n = 0
  · -- Handle n = 0 case
    simp [h0]
  · by_cases h1 : n = 1  
    · -- Handle n = 1 case
      simp [h1]
    · -- Handle n ≥ 2 case
      have h_ge_2 : n ≥ 2 := by omega
      -- Use omega for arithmetic constraints
```

**Why This Works**: Natural number theorems often have boundary conditions at small values. Systematic case analysis with `omega` for constraints provides clean, verifiable proofs.

### Transitivity Through Common Values ✅

When both sides of an equality can be shown to equal the same intermediate value:

```lean
theorem connection_theorem : complex_lhs = complex_rhs := by
  rw [lemma_showing_lhs_eq_middle]
  exact (lemma_showing_rhs_eq_middle).symm
```

**Pattern**: Instead of directly proving `A = B`, show `A = C` and `C = B`, then use transitivity.

### Dependency-Ordered Theorem Proving ✅

Structure file organization to prove dependencies before dependents:

```lean
-- First prove the fundamental property
theorem fundamental_property : P := by ...

-- Then use it in more complex theorems
theorem derived_property : Q := by
  rw [fundamental_property]
  -- Continue proof
```

**Critical**: Reorder theorem definitions if necessary to ensure forward references work correctly.

### Foundation-First Sorry Elimination Strategy ✅

When multiple sorries exist, prioritize by dependency:

1. **Basic Properties**: PMF non-negativity, summability
2. **Fundamental Formulas**: Core identities and telescoping relations  
3. **Derived Results**: Complex applications and geometric interpretations

**Success Pattern**: Eliminate 2-3 foundational sorries first to unlock multiple dependent proofs.

## 🔍 Index Manipulation with `Finset.sum_bij` (SESSION VALIDATED)

**Pattern**: For sum reindexing like ∑_{k=0}^{N-1} f(k+c) = ∑_{j=c}^{N+c-1} f(j)

```lean
apply Finset.sum_bij (fun k _ => k + c)
· intro k hk
  simp [Finset.mem_range] at hk ⊢
  omega
· intro k hk; rfl  
· intro a₁ a₂ ha₁ ha₂ h_eq
  omega
· intro b hb
  simp [Finset.mem_range] at hb
  use b - c
  simp [Finset.mem_range]
  constructor <;> omega
```

**Why It Works**: `sum_bij` provides a rigorous framework for bijective index transformations.

### Successful Induction Pattern (Session-Validated)

**Pattern**: For telescoping sums and similar inductive proofs:
```lean
lemma telescoping_result (N : ℕ) : P N := by
  induction N with
  | zero =>
    -- Base case: often trivial
    simp only [relevant_simps]
    norm_num
  | succ N ih =>
    -- Use inductive hypothesis
    rw [recursive_formula, ih]
    -- Algebraic simplification
    ring
```

**Why It Succeeded**: Direct induction with `ring` for algebraic simplification proved more effective than complex sum manipulations.

## ❌ Anti-Patterns to Avoid (SESSION LESSONS)

### API Misuse Patterns (CAUSES BUILD FAILURES)

**❌ Accessing APIs as Fields Instead of Direct Calls**:
- **Wrong**: `(Summable.hasSum pmf_summable).sum_add_tsum_nat_add` 
- **Error**: "invalid field 'sum_add_tsum_nat_add', the environment does not contain 'HasSum.sum_add_tsum_nat_add'"
- **Correct**: `Summable.sum_add_tsum_nat_add k pmf_summable`

**❌ Wrong Argument Order**:
- **Wrong**: `Summable.sum_add_tsum_nat_add summability_proof k`
- **Correct**: `Summable.sum_add_tsum_nat_add k summability_proof`

**❌ Skipping API Verification**: NEVER use any mathlib API without first creating a test file and verifying it compiles

### Complex Proof Anti-Patterns

**❌ Overcomplex Telescoping Proofs**: Avoid complex multi-step `Finset.sum_bij` proofs with multiple cases. Simple induction or direct convergence often works better.

**❌ Complex Filter API Combinations**: Directly chaining filter operations like `.mp` can lead to type errors. Use simpler patterns like `Tendsto.comp`.

**❌ Excessive Proof Structure**: Don't build overly elaborate proof frameworks. Sometimes the simplest approach (direct application of known results) is best.

**❌ Misusing `Filter.tendsto_add_atTop_iff_nat` for Index Shifts**: 
- **Wrong**: Trying to use `rw [← Filter.tendsto_add_atTop_iff_nat k]` directly
- **Issue**: This often creates type mismatches like expecting `f(n+1+1)` when you have `f(n+1)`
- **Solution**: Use function composition pattern (see Pattern #12 above)

**❌ Using `convert` with `ext` Without Clear Goal**:
- **Wrong**: `convert some_theorem; ext n`
- **Issue**: May fail with "no applicable extensionality theorem"
- **Solution**: First establish function equality separately, then rewrite

**❌ Fighting Complex Conditional Sums**: 
- **Wrong**: Trying to manipulate `∑' k : ℕ, if k > n then f k else 0` with complex index shifting
- **Issue**: Multiple layers of conditionals, type coercions, and summability proofs become unmanageable
- **Solution**: Consider induction or strategic retreat

**❌ Attempting Full Piecewise Continuity Proofs**:
- **Wrong**: Trying to prove continuity of complex piecewise functions with nested if-then-else
- **Issue**: Both `continuity` tactic and manual `continuous_if` approaches time out or fail
- **Solution**: Prove continuity on each piece separately, or use strategic retreat

### January 2025 Session Anti-Patterns

**❌ Ignoring Deprecation Warnings**:
- **Wrong**: Using `tsum_add`, `cases'`, `Finset.not_mem_empty` despite warnings
- **Issue**: Future mathlib versions may remove deprecated APIs
- **Solution**: Always replace deprecated APIs immediately

**❌ `if_neg`/`if_pos` Type Confusion**:
- **Wrong**: `simp only [if_neg h1]` where `h1 : 0 ≤ x` 
- **Issue**: `if_neg` expects `¬condition`, not the condition itself
- **Solution**: Use proper boolean logic: `if_neg (not_lt.mpr h1)`

**❌ Assuming Non-Existent Constants**:
- **Wrong**: Using `zero_lt_zero` or similar assumed constants
- **Issue**: "unknown identifier" errors from incorrect assumptions about stdlib
- **Solution**: Use `#check` to verify existence or use established patterns like `lt_irrefl`

**❌ Complex `conv_lhs` Pattern Matching**:
- **Wrong**: `conv_lhs => rw [← h_total]` without verifying pattern exists
- **Issue**: "did not find instance of the pattern" errors
- **Solution**: Use direct rewriting or establish equality explicitly first

**❌ Case Analysis Logic Errors**:
- **Wrong**: Creating contradictory hypotheses like `h1 : 0 ≤ x` and `h_zero : x < 0`
- **Issue**: Impossible proof states from flawed boolean logic
- **Solution**: Careful case analysis with `omega` for arithmetic constraints

**✅ Prefer Simplicity**: When eliminating sorries, choose the most direct path. Complex mathematical arguments often have simple Lean implementations.

---

*This technique library represents battle-tested patterns from the PotionProblem formalization project. All patterns have been validated through successful sorry elimination or strategic retreat analysis.*