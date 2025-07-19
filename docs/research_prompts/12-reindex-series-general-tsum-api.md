# Research Prompt: General Series Reindexing with Lean 4's tsum API

## Objective
Implement the general reindexing theorem for infinite series using Lean 4's tsum API and equivalence structures, establishing that bijective reindexing preserves series sums.

## Mathematical Statement
```lean
theorem reindex_series_general {α β : Type*} [Countable α] [Countable β] 
  {f : β → ℝ} (φ : α ≃ β) (h_summable : Summable f) :
  ∑' a : α, f (φ a) = ∑' b : β, f b
```

## Required Deliverables

### 1. Mathlib4 tsum API Analysis
**Key Functions and Lemmas:**
```lean
-- Identify the correct API functions:
#check tsum_equiv  -- Does this exist in current Mathlib4?
#check Equiv.tsum_eq  -- Alternative name?
#check Function.Bijective.tsum_eq  -- Via bijection?
#check Summable.hasSum_iff  -- Lower-level approach?

-- Related lemmas:
#check tsum_range
#check tsum_image
#check tsum_bij
```

**Implementation Strategy:**
```lean
-- Option 1: Direct API if available
theorem reindex_series_general ... := by
  exact tsum_equiv φ h_summable  -- If this exists

-- Option 2: Via hasSum
theorem reindex_series_general ... := by
  have h1 : HasSum f (∑' b : β, f b) := h_summable.hasSum
  have h2 : HasSum (f ∘ φ) (∑' b : β, f b) := by
    -- Show composition has same sum
  exact h2.tsum_eq

-- Option 3: Manual construction
theorem reindex_series_general ... := by
  -- Use that φ induces a bijection on supports
  -- Apply dominated convergence or monotone convergence
```

### 2. Equivalence Properties
**Working with `Equiv`:**
```lean
variable (φ : α ≃ β)

-- Key properties to use:
#check φ.bijective
#check φ.surjective  
#check φ.injective
#check φ.symm  -- Inverse equivalence

-- Composition properties:
example : φ.symm ∘ φ = id := by exact φ.symm_comp_self
example : φ ∘ φ.symm = id := by exact φ.comp_symm_self
```

### 3. Summability Preservation
**Show reindexed series is summable:**
```lean
lemma summable_comp_equiv {f : β → ℝ} (φ : α ≃ β) :
  Summable f ↔ Summable (f ∘ φ) := by
  constructor
  · intro hf
    -- Forward: If f is summable, so is f ∘ φ
    apply Summable.of_equiv
    exact hf
    exact φ.symm
  · intro hfφ  
    -- Backward: If f ∘ φ is summable, so is f
    convert Summable.of_equiv hfφ φ
    ext b
    simp only [Function.comp_apply, Equiv.apply_symm_apply]
```

### 4. Finite Partial Sum Connection
```lean
-- Relate to finite sums
lemma tsum_eq_lim_finset_sum {f : α → ℝ} (hf : Summable f) :
  ∑' a, f a = lim (atTop.map (fun s : Finset α => ∑ a in s, f a)) := by
  -- This is essentially the definition
  
-- For equivalences, finite sums correspond
lemma finset_sum_equiv (s : Finset α) (φ : α ≃ β) (f : β → ℝ) :
  ∑ a in s, f (φ a) = ∑ b in s.image φ, f b := by
  -- Use Finset.sum_image and φ.injective
```

### 5. Absolute Convergence Cases
```lean
-- For absolutely convergent series, order doesn't matter
theorem reindex_abs_convergent {f : β → ℝ} (φ : α ≃ β) 
  (hf : Summable (fun b => |f b|)) :
  ∑' a : α, f (φ a) = ∑' b : β, f b := by
  -- Use that absolute convergence allows arbitrary rearrangement
  -- This should work even without explicit tsum_equiv
```

### 6. Concrete Examples
```lean
-- Example 1: Reindexing ℕ by adding constant
def shift_equiv (k : ℕ) : ℕ ≃ ℕ where
  toFun n := n + k
  invFun n := n - k  
  left_inv := by intro n; omega
  right_inv := by intro n; omega

example (f : ℕ → ℝ) (hf : Summable f) (k : ℕ) :
  ∑' n, f (n + k) = ∑' n, f n - ∑ i in Finset.range k, f i := by
  -- Apply reindexing and handle finite part

-- Example 2: Even/odd decomposition  
def even_odd_equiv : ℕ ≃ (ℕ × Bool) where
  toFun n := if n % 2 = 0 then (n / 2, true) else ((n - 1) / 2, false)
  invFun := fun ⟨k, b⟩ => if b then 2 * k else 2 * k + 1
  -- Proofs...
```

### 7. Non-absolute Convergence Issues
```lean
-- Conditional convergence example where reordering fails
example : ∃ (f : ℕ → ℝ) (φ : ℕ ≃ ℕ), 
  Summable f ∧ ¬Summable (fun n => |f n|) ∧ 
  ∑' n, f n ≠ ∑' n, f (φ n) := by
  -- Construct alternating harmonic series
  -- Use specific reordering that changes sum
```

## Lean 4 Implementation Challenges

### Current API Investigation
1. Check if `tsum_equiv` exists in current Mathlib4
2. Find alternative approaches if not
3. Identify minimal imports needed

### Type Class Issues
- Handle `[Countable α]` constraints
- Work with `UniformSpace` for convergence
- Manage `CompleteSpace` requirements

### Proof Techniques
- Use `convert` when types almost match
- Apply `simp only` with specific lemmas
- Leverage `ext` for function equality

## Expected Output Format
1. Complete investigation of Mathlib4 tsum API (1000 words)
2. Working Lean 4 implementation with fallbacks
3. 3+ concrete examples with different equivalences
4. Explanation of when reindexing preserves sums
5. References to:
   - Current Mathlib4 documentation
   - Topology textbooks on series rearrangement
   - Rudin's theorem on conditional convergence

## Connection to Main Theorem
This general lemma is needed at line 43 of SeriesReindexing.lean and provides the foundation for all specific reindexing results used in the factorial series transformations.