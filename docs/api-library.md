# Pre-Verified API Library for Lean 4 Formal Verification

*A curated collection of verified mathlib4 APIs with correct usage patterns*

**Purpose**: Avoid redundant LeanExplore searches by documenting previously verified APIs with correct usage patterns and common failure modes.

**Version**: mathlib4 v4.21.0  

## 🔍 Quick Reference

| API Category | Count | Status Summary |
|--------------|-------|----------------|
| Infinite Sum APIs | 3 | 2 verified, 1 deprecated |
| Factorial & Series | 4 | 4 verified (2 new critical) |
| Index Manipulation | 2 | 1 verified, 1 partial |
| Arithmetic & Logic | 3 | 3 verified |
| APIs for Remaining Sorries | 13 | 11 verified, 2 deprecated |
| Non-Existent APIs | 4 | Documented to prevent searches |
| Implementation Strategies | 3 | Ready for sorry elimination |

## 📚 Infinite Sum APIs

### `Summable.tsum_add_tsum_compl`
**Status**: ✅ Verified (replaces deprecated `tsum_add_tsum_compl`)  
**Signature**: `Summable.tsum_add_tsum_compl {f : β → α} (hf : Summable f) (s : Set β) : ∑' x, f x = (∑' x ∈ s, f x) + (∑' x ∈ sᶜ, f x)`  
**Import**: `import Mathlib.Topology.Algebra.InfiniteSum.Basic`  
**Usage Pattern**:
```lean
have h_split := Summable.tsum_add_tsum_compl pmf_summable (Finset.range (n + 1))
```
**Notes**: Replaces deprecated `tsum_add_tsum_compl`. Must be called directly on `Summable` namespace.

### `Summable.sum_add_tsum_nat_add` 
**Status**: ⚠️ Deprecated but functional (as of 2025-04-12)  
**Signature**: `Summable.sum_add_tsum_nat_add {f : ℕ → α} (hf : Summable f) (k : ℕ) : ∑ i ∈ Finset.range k, f i + ∑' i, f (i + k) = ∑' i, f i`  
**Import**: `import Mathlib.Topology.Algebra.InfiniteSum.NatInt`  
**Usage Pattern**:
```lean
have h_eq := Summable.sum_add_tsum_nat_add k summability_proof
rw [← h_eq]  -- Note: reverse direction often needed
```
**Critical**: 
- Argument order: `k` first, then `summability_proof`
- Access as direct call: `Summable.sum_add_tsum_nat_add`, NOT as field
- **Deprecated**: Still works but discouraged, replacement API unknown

### `summable_nat_add_iff`
**Status**: ✅ Verified  
**Signature**: `summable_nat_add_iff {f : ℕ → α} (k : ℕ) : Summable (fun n => f (n + k)) ↔ Summable f`  
**Import**: `import Mathlib.Topology.Algebra.InfiniteSum.NatInt`  
**Usage Pattern**:
```lean
have h_summable : Summable (fun n => f (n + k)) := by
  rw [← summable_nat_add_iff k]
  exact original_summability
```

## 🧮 Factorial and Series APIs

### `FloorSemiring.tendsto_pow_div_factorial_atTop`
**Status**: ✅ Verified  
**Signature**: `FloorSemiring.tendsto_pow_div_factorial_atTop (c : ℝ) : Tendsto (fun n => c^n / n.factorial) atTop (𝓝 0)`  
**Import**: `import Mathlib.Topology.Algebra.Order.Floor`  
**Usage Pattern**:
```lean
have h_limit : Tendsto (fun n => (1 : ℝ) / n.factorial) atTop (𝓝 0) := by
  have h := FloorSemiring.tendsto_pow_div_factorial_atTop (1 : ℝ)
  simpa only [pow_one] using h
```

### `hasSum_iff_tendsto_nat_of_nonneg`
**Status**: ✅ Verified  
**Signature**: `hasSum_iff_tendsto_nat_of_nonneg {f : ℕ → ℝ} (hf_nn : ∀ n, 0 ≤ f n) : HasSum f L ↔ Tendsto (fun N => ∑ n ∈ Finset.range N, f n) atTop (𝓝 L)`  
**Import**: `import Mathlib.Topology.Instances.ENNReal.Lemmas`  
**Usage Pattern**:
```lean
have h_hasSum : HasSum f L := by
  rw [hasSum_iff_tendsto_nat_of_nonneg]
  · exact convergence_proof
  · exact nonnegativity_proof
```

### `Complex.sum_div_factorial_le` ⭐⭐⭐⭐⭐ **CRITICAL**
**Status**: ✅ Verified  
**Signature**: `Complex.sum_div_factorial_le (n j : ℕ) (hn : 0 < n) : (∑ m ∈ range j with n ≤ m, (1 / m.factorial : α)) ≤ n.succ / (n.factorial * n)`  
**Import**: `import Mathlib.Data.Complex.Exponential`  
**ID**: 84423  
**Mathematical Significance**: Provides direct bounds for partial sums of factorial reciprocals
**Critical for**: tail_probability_formula - bounds ∑_{k>n} 1/k!

### `NormedSpace.expSeries_div_hasSum_exp` ⭐⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `expSeries_div_hasSum_exp (x : 𝔸) : HasSum (fun n => x ^ n / n !) (exp 𝕂 x)`  
**Import**: `import Mathlib.Analysis.Normed.Algebra.Exponential`  
**ID**: 50387  
**Mathematical Foundation**: Rigorous proof that ∑ x^n/n! = exp(x)
**Key Application**: Setting x=1 proves ∑ 1/n! = e

## 🔢 Index Manipulation APIs

### `tendsto_add_atTop_nat`
**Status**: ✅ Verified  
**Signature**: `tendsto_add_atTop_nat (k : ℕ) : Tendsto (fun n => n + k) atTop atTop`  
**Import**: `import Mathlib.Order.Filter.AtTopBot.Basic`  
**Usage Pattern**:
```lean
have h_limit : Tendsto (fun N => f (N + k)) atTop (𝓝 L) := by
  exact original_limit.comp (tendsto_add_atTop_nat k)
```

### `Filter.tendsto_add_atTop_iff_nat`
**Status**: ⚠️ Partial verification (type mismatch issues)  
**Notes**: Use function composition pattern instead for index shifting

## 🧮 Arithmetic and Logic APIs

### `omega` tactic
**Status**: ✅ Verified  
**Usage**: Automatic arithmetic constraint solving  
**Pattern**: `by omega` for natural number inequalities

### `interval_cases` tactic
**Status**: ✅ Verified   
**Usage**: Case analysis on finite ranges  
**Pattern**: `interval_cases n` when `n < 2`

### `Nat.factorial_ne_zero`
**Status**: ✅ Verified  
**Signature**: `Nat.factorial_ne_zero (n : ℕ) : n.factorial ≠ 0`  
**Import**: `import Mathlib.Data.Nat.Factorial.Basic`  
**ID**: 98910  
**Usage**: Required for safe division by factorials in tail_probability_formula

## ❌ Common API Failure Patterns (AVOID)

### Field Access Pattern
```lean
-- WRONG: Trying to access API as field
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add
(some_tendsto_object).api_name
```

### Wrong Argument Order
```lean
-- WRONG: Proof first, parameter second
Summable.sum_add_tsum_nat_add summability_proof k
```

### ✅ Correct Direct Call Pattern
```lean
-- CORRECT: Direct namespace access with proper argument order
Summable.sum_add_tsum_nat_add k summability_proof
```

## 🚨 Session Warnings & API Issues

### New Deprecation Warnings Encountered

#### `tsum_add` Deprecated
```lean
-- WARNING: `tsum_add` has been deprecated: use `Summable.tsum_add` instead
rw [← tsum_add pmf_summable.subtype pmf_summable.subtype]  -- DEPRECATED
```
**Replacement**: Use `Summable.tsum_add` directly
**Impact**: Causes build warnings, may be removed in future mathlib versions

#### `Finset.not_mem_empty` Deprecated  
```lean
-- WARNING: `Finset.not_mem_empty` has been deprecated: use `Finset.notMem_empty` instead
Finset.not_mem_empty  -- DEPRECATED
```
**Replacement**: `Finset.notMem_empty`

#### `cases'` Tactic Discouraged
```lean
-- WARNING: The `cases'` tactic is discouraged: please strongly consider using `obtain`, `rcases` or `cases` instead
cases' h_cond with h_neg h_zero_pos  -- DISCOURAGED
```
**Replacement**: Use `obtain`, `rcases`, or `cases`

### API Type Mismatch Patterns

#### `if_neg` Argument Type Errors
```lean
-- ERROR: Application type mismatch in if_neg
simp only [if_neg h1, if_pos h2] at h_zero
-- where h1 : 0 ≤ x but expected ¬?condition
```
**Issue**: `if_neg` expects negation of condition, not the condition itself
**Solution**: Use proper boolean logic: `if_neg (not_lt.mpr h1)`

#### `conv_lhs` Rewrite Pattern Failures
```lean
-- ERROR: tactic 'rewrite' failed, did not find instance of the pattern
conv_lhs => rw [← h_total]
```
**Issue**: Pattern matching fails when left-hand side doesn't match expected form
**Solution**: Use direct rewriting or establish equality first

#### Unknown Identifier Errors
```lean
-- ERROR: unknown identifier 'zero_lt_zero'
simp only [zero_lt_zero, false_iff]
```
**Issue**: Incorrect assumption about available constants
**Solution**: Use `lt_irrefl` or explicit `¬(0 < 0)`

### `Summable.subtype` API Complexity
```lean
-- ERROR: Type mismatch with subtype summability
exact Summable.tsum_add pmf_summable.subtype pmf_summable.subtype
-- Expected: Summable ?m.4806 but got: ∀ (s : Set ℕ), Summable (hitting_time_pmf ∘ Subtype.val)
```
**Issue**: `Summable.subtype` returns a function, not direct summability proof
**Recommendation**: Use explicit set-based summability or avoid subtype patterns

### Logic Error Cascades
```lean
-- ERROR: Contradictory hypotheses from case analysis
h1 : 0 ≤ x
h2 : x ≥ ↑n  
h_zero : x < 0  -- Contradiction!
```
**Issue**: Case analysis logic errors leading to impossible states
**Solution**: Careful boolean logic analysis and hypothesis tracking

## 📝 Contributing New APIs

### Verification Template

When adding new verified APIs to this library:

```markdown
### `api_name`
**Status**: ✅ Verified / ⚠️ Deprecated / ❌ Broken  
**Signature**: [exact signature from LeanExplore]  
**Import**: `import Required.Module.Path`  
**Usage Pattern**:
```lean
-- Working example code
```
**Notes**: [Any gotchas, deprecation status, argument orders, etc.]
```

### Update Protocol

**When to add APIs**: After successful verification and usage in actual proofs  
**Verification standard**: Must compile in test file and work in actual proof context  
**Maintenance**: Mark deprecated APIs when mathlib updates occur

### Verification Process

1. **LeanExplore Search**: `scripts/lle search "api_name" --package Mathlib` (use wrapper!)
2. **Test File Creation**: Create `test_api.lean` with exact usage
3. **Compilation Check**: `lake env lean test_api.lean`
4. **Proof Context Verification**: Use in actual proof
5. **Documentation**: Add to this library with template

## 🎯 APIs for Remaining Sorries (Verified 2025-07-27)

### For `tail_probability_formula` (ProbabilityFoundations.lean:259)

#### Critical Breakthrough APIs

##### `Complex.sum_div_factorial_le` ⭐⭐⭐⭐⭐ **CRITICAL**
**Status**: ✅ Verified  
**Signature**: `Complex.sum_div_factorial_le (n j : ℕ) (hn : 0 < n) : (∑ m ∈ range j with n ≤ m, (1 / m.factorial : α)) ≤ n.succ / (n.factorial * n)`  
**Import**: `import Mathlib.Data.Complex.Exponential`  
**ID**: 84423  
**Why Critical**: Direct bounds for factorial reciprocal sums - exactly the pattern in tail_probability_formula
**Usage Pattern**:
```lean
-- Apply to bound tail sums involving 1/k! patterns
have h_factorial_bound := Complex.sum_div_factorial_le n j h_n_pos
-- Provides: ∑_{k>n} 1/k! ≤ specific bound involving 1/n!
```

##### `NormedSpace.expSeries_div_hasSum_exp` ⭐⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `expSeries_div_hasSum_exp (x : 𝔸) : HasSum (fun n => x ^ n / n !) (exp 𝕂 x)`  
**Import**: `import Mathlib.Analysis.Normed.Algebra.Exponential`  
**ID**: 50387  
**Mathematical Foundation**: Proves ∑ x^n/n! = exp(x), setting x=1 gives ∑ 1/n! = e
**Usage Pattern**:
```lean
-- Apply exponential series convergence with x=1
have h_exp_series := NormedSpace.expSeries_div_hasSum_exp (1 : ℝ)
-- Simplifies to: ∑' n, (1 : ℝ) / n.factorial = exp 1
```

#### Complement Decomposition APIs

##### `tsum_subtype_add_tsum_subtype_compl`
**Status**: ⚠️ Deprecated (alias of `Summable.tsum_subtype_add_tsum_subtype_compl`)  
**Signature**: `tsum_subtype_add_tsum_subtype_compl : ∑'_{x : s} f(x) + ∑'_{x : s^c} f(x) = ∑' x, f(x)`  
**Import**: `import Mathlib.Topology.Algebra.InfiniteSum.Group`  
**ID**: 187696  
**Notes**: Perfect complement decomposition for splitting ∑' k into tail + head = total

##### `NNReal.sum_add_tsum_nat_add` ⭐⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `NNReal.sum_add_tsum_nat_add {f : ℕ → ℝ≥0} (k : ℕ) (hf : Summable f) : ∑' i, f i = (∑ i ∈ range k, f i) + ∑' i, f (i + k)`  
**Import**: `import Mathlib.Topology.Instances.NNReal.Lemmas`  
**ID**: 196967  
**Why Important**: Enhanced nonnegative real specialization for PMF decomposition

#### Conditional Sum Manipulation

##### `Summable.tsum_eq_add_tsum_ite` ⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `Summable.tsum_eq_add_tsum_ite {f : β → α} (hf : Summable f) (b : β) : ∑' n, f n = f b + ∑' n, if n = b then 0 else f n`  
**Import**: `import Mathlib.Topology.Algebra.InfiniteSum.Group`  
**ID**: 187683  
**Usage**: Extract individual terms from infinite sums - critical for boundary cases

##### `Set.indicator`
**Status**: ✅ Verified  
**Signature**: `Set.indicator s f a` returns `f a` if `a ∈ s`, `0` otherwise  
**Import**: `import Mathlib.Algebra.Group.Indicator`  
**ID**: 9175  
**Usage Pattern**:
```lean
-- Convert conditional sum to indicator notation
∑' k, if k > n then f k else 0 = ∑' k, Set.indicator {k | k > n} f k
```

#### PMF-Specific APIs

##### `PMF.filter_apply` ⭐⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `PMF.filter_apply (a : α) : (p.filter s h) a = s.indicator p a * (∑' a', (s.indicator p) a')⁻¹`  
**Import**: `import Mathlib.Probability.ProbabilityMassFunction.Constructions`  
**ID**: 166007  
**Why Critical**: Provides exact conditional probability formula via filtered PMF normalization

##### `ENNReal.summable` ⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `ENNReal.summable {α : Type*} (f : α → ℝ≥0∞) : Summable f`  
**Import**: `import Mathlib.Topology.Instances.ENNReal.Lemmas`  
**ID**: 196624  
**Why Important**: Any function to ENNReal is automatically summable - eliminates summability proofs

#### Important Non-Existent APIs ❌
**These do NOT exist - avoid searching for them:**
- `tsum_gt` or `tsum_tail` - No greater-than conditional sum APIs
- `pmf_tail_probability` - No PMF-specific tail probability APIs  
- `factorial_reciprocal_sum` - No specialized factorial reciprocal summation
- `tsum_subtype` (standalone) - Use the full `tsum_subtype_add_tsum_subtype_compl`

### For `irwin_hall_support` (IrwinHallTheory.lean:158)

#### `Finset.sum_bij`
**Status**: ✅ Verified  
**Signature**: Reorder finite sums via bijection (see detailed signature in ID 2350)  
**Import**: `import Mathlib.Algebra.BigOperators.Group.Finset.Defs`  
**ID**: 2350  
**Notes**: For inclusion-exclusion rearrangements with dependent bijections

#### `Antitone.tendsto_alternating_series_of_tendsto_zero`
**Status**: ✅ Verified  
**Signature**: Alternating series test for antitone sequences  
**Import**: `import Mathlib.Analysis.SpecificLimits.Normed`  
**ID**: 58273  
**Usage**: Proves convergence of alternating series like `∑ (-1)^i * f(i)` when `f` is antitone and tends to 0

### For `irwin_hall_continuous` (IrwinHallTheory.lean:208)

#### `Continuous.if`
**Status**: ✅ Verified  
**Signature**: `Continuous.if` - continuity of piecewise functions via if-then-else  
**Import**: `import Mathlib.Topology.Piecewise`  
**ID**: 201977  
**Requirement**: Functions must agree on the frontier of the condition set

#### `ContinuousOn.piecewise`
**Status**: ✅ Verified  
**Signature**: Continuity of piecewise functions on a set  
**Import**: `import Mathlib.Topology.Piecewise`  
**ID**: 201974  
**Notes**: Handles piecewise definitions with frontier agreement conditions

## 🚀 Implementation Strategies

### Strategy 1: Factorial Bounds Approach (Most Promising)
Use `Complex.sum_div_factorial_le` for direct bounds on tail sums:
```lean
-- Apply factorial bounds theorem
have h_bound := Complex.sum_div_factorial_le n ∞ h_n_pos
-- Use limit arguments to prove exact equality from bounds
```

### Strategy 2: Perfect Complement Decomposition  
Use `tsum_subtype_add_tsum_subtype_compl` or `Summable.sum_add_tsum_nat_add`:
```lean
-- Split: ∑' k, PMF k = (∑_{k≤n} PMF k) + (∑_{k>n} PMF k)
have h_split := Summable.sum_add_tsum_nat_add (n + 1) pmf_summable
-- Solve: tail = 1 - head, compute head using telescoping
```

### Strategy 3: PMF Filtering (Advanced)
Use `PMF.filter_apply` for conditional probability approach:
```lean
-- Create filtered PMF on {k | k > n}
have filtered := PMF.filter hitting_time_pmf {k | k > n} h_support
-- Extract normalization constant = tail probability
```

## API Description Management

### Status Indicators
- ✅ **Verified**: Confirmed working in mathlib4 v4.21.0
- ⚠️ **Deprecated**: Still functional but discouraged
- ❌ **Broken**: No longer works, needs replacement
- 🔄 **Under Review**: Being investigated for issues
