# Pre-Verified API Library for Lean 4 Formal Verification

*A curated collection of verified mathlib4 APIs with correct usage patterns*

**Purpose**: Avoid redundant API searches by documenting previously verified APIs with correct usage patterns and common failure modes.

**Version**: mathlib4 v4.21.0  

## 🔍 Quick Reference

| API Category | Count | Status Summary |
|--------------|-------|----------------|
| Infinite Sum APIs | 6 | 5 verified, 1 deprecated |
| Factorial & Series | 4 | 4 verified (2 new critical) |
| Index Manipulation | 2 | 1 verified, 1 partial |
| Arithmetic & Logic | 3 | 3 verified |
| APIs for Remaining Sorries | 13 | 11 verified, 2 deprecated |
| Non-Existent APIs | 6 | Documented to prevent searches |
| Implementation Strategies | 3 | Ready for sorry elimination |
| Conditional Sum Conversion | 3 | 3 verified (expert validated) |
| Finset Decomposition | 3 | 3 verified |

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

### `tsum_congr` ⭐⭐⭐ **Expert Validated**
**Status**: ✅ Verified (2025-07-28)
**Signature**: `tsum_congr {f g : β → α} (h : ∀ b, f b = g b) : ∑' b, f b = ∑' b, g b`
**Import**: `import Mathlib.Topology.Algebra.InfiniteSum.Basic`
**Usage Pattern**:
```lean
-- When functions agree pointwise, their sums are equal
have h_eq : ∀ k, f k = g k := by ...
rw [tsum_congr h_eq]
```
**Note**: Essential for rewriting sum contents when converting if-then-else to indicator.

### `tsum_subtype` ⭐⭐⭐⭐ **Critical for Conditional Sums**
**Status**: ✅ Verified (2025-07-28)
**Signature**: `tsum_subtype (s : Set β) (f : β → α) : ∑' (x : ↑s), f ↑x = ∑' x, s.indicator f x`
**Import**: `import Mathlib.Topology.Algebra.InfiniteSum.Basic`
**Usage Pattern**:
```lean
-- Convert conditional sum to subtype sum
-- From: ∑' k, if k > n then f k else 0
-- To: ∑' (k : {k // k > n}), f k
rw [← tsum_subtype {k | k > n} f]
```
**Note**: Provides direct conversion between indicator sums and subtype sums. Use reverse direction for conditional-to-subtype conversion.

### `Set.indicator` ⭐⭐⭐ **Foundation for Conditional Sums**
**Status**: ✅ Verified (2025-07-28)
**Signature**: `Set.indicator (s : Set α) (f : α → M) (a : α) : M` where it returns `f a` if `a ∈ s`, `0` otherwise
**Import**: `import Mathlib.Algebra.Group.Indicator`
**Usage Pattern**:
```lean
-- Convert if-then-else to indicator
have : (fun k => if k > n then f k else 0) = {k | k > n}.indicator f := by
  ext k; simp [Set.indicator]
```
**Note**: Standard way to express conditional sums in mathlib.

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

## ❌ Common API Failure Patterns

See [`common-errors.md`](common-errors.md) for detailed API misuse patterns including:
- Field vs Direct Call errors
- Argument order mistakes  
- Type mismatch patterns

**Quick reminder**: Always use `Namespace.api_name args`, never `(object).api_name`

## 🚨 Deprecated APIs in mathlib4 v4.21.0

### Recently Deprecated
- **`tsum_add`** → Use `Summable.tsum_add`
- **`Finset.not_mem_empty`** → Use `Finset.notMem_empty`  
- **`cases'` tactic** → Use `obtain`, `rcases`, or `cases`

For comprehensive error patterns see [`common-errors.md`](common-errors.md)

## 📝 Contributing New APIs

### Verification Template

When adding new verified APIs to this library:

```markdown
### `api_name`
**Status**: ✅ Verified / ⚠️ Deprecated / ❌ Broken  
**Signature**: [exact signature from MCP LeanExplore]  
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

See [`workflow-commands.md#api-verification-workflow`](workflow-commands.md#api-verification-workflow) for detailed verification steps.

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
**Note**: This is an alias of `Summable.tsum_eq_add_tsum_ite`. Use for extracting single values from sums.

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
**Signature**: `Finset.sum_bij (i : ∀ a ∈ s, κ) (hi : ∀ a ha, i a ha ∈ t) (i_inj : ∀ a₁ ha₁ a₂ ha₂, i a₁ ha₁ = i a₂ ha₂ → a₁ = a₂) (i_surj : ∀ b ∈ t, ∃ a ha, i a ha = b) (h : ∀ a ha, f a = g (i a ha)) : ∑ x ∈ s, f x = ∑ x ∈ t, g x`
**Import**: `import Mathlib.Algebra.BigOperators.Group.Finset.Defs`  
**ID**: 2350  
**Notes**: For inclusion-exclusion rearrangements with dependent bijections. The bijection can depend on membership proof.

## 🔄 Finset Decomposition APIs (Expert Validated)

### `Finset.union_sdiff_of_subset` ⭐⭐⭐
**Status**: ✅ Verified (2025-07-28)
**Signature**: `Finset.union_sdiff_of_subset {s t : Finset α} (h : s ⊆ t) : s ∪ (t \ s) = t`
**Import**: `import Mathlib.Data.Finset.Basic`
**Usage Pattern**:
```lean
-- Decompose a finset into subset and complement
have h_sub : Finset.range 2 ⊆ Finset.range (n + 1) := Finset.range_mono (by omega)
have h_decomp : Finset.range (n + 1) = Finset.range 2 ∪ (Finset.range (n + 1) \ Finset.range 2) :=
  (Finset.union_sdiff_of_subset h_sub).symm
```
**Note**: Essential for splitting finite sums into disjoint parts.

### `Finset.sum_union` ⭐⭐⭐⭐
**Status**: ✅ Verified (2025-07-28)
**Signature**: `Finset.sum_union [DecidableEq ι] (h : Disjoint s₁ s₂) : ∑ x ∈ s₁ ∪ s₂, f x = ∑ x ∈ s₁, f x + ∑ x ∈ s₂, f x`
**Import**: `import Mathlib.Algebra.BigOperators.Group.Finset.Basic`
**Usage Pattern**:
```lean
-- Split sum over disjoint union
rw [Finset.sum_union Finset.disjoint_sdiff]
-- Now have: ∑ x ∈ s, f x + ∑ x ∈ t \ s, f x
```
**Note**: Requires disjointness proof. Often used with `Finset.disjoint_sdiff`.

### `Finset.disjoint_sdiff` ⭐⭐⭐
**Status**: ✅ Verified (2025-07-28)
**Signature**: `Finset.disjoint_sdiff {s t : Finset α} : Disjoint s (t \ s)`
**Import**: `import Mathlib.Data.Finset.Basic`
**Usage Pattern**:
```lean
-- Prove s and t \ s are disjoint (automatic)
have h_disj : Disjoint s (t \ s) := Finset.disjoint_sdiff
-- Use with sum_union
rw [Finset.sum_union h_disj]
```
**Note**: Provides automatic disjointness proof for set difference operations.

#### `Antitone.tendsto_alternating_series_of_tendsto_zero`
**Status**: ✅ Verified  
**Signature**: `Antitone.tendsto_alternating_series_of_tendsto_zero (hfa : Antitone f) (hf0 : Tendsto f atTop (𝓝 0)) : ∃ l, Tendsto (fun n ↦ ∑ i ∈ range n, (-1) ^ i * f i) atTop (𝓝 l)`
**Import**: `import Mathlib.Analysis.SpecificLimits.Normed`  
**ID**: 58273  
**Usage**: Proves convergence of alternating series like `∑ (-1)^i * f(i)` when `f` is antitone and tends to 0

### For `irwin_hall_continuous` (IrwinHallTheory.lean:208)

#### `Continuous.if`
**Status**: ✅ Verified  
**Signature**: `Continuous.if {p : α → Prop} [∀ a, Decidable (p a)] (hp : ∀ a ∈ frontier { x | p x }, f a = g a) (hf : Continuous f) (hg : Continuous g) : Continuous fun a => if p a then f a else g a`
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
