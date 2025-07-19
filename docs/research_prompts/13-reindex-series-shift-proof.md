# Research Prompt: Series Reindexing by Constant Shift

## Objective
Prove that shifting indices in an infinite series preserves the sum: ∑_{n=a}^∞ f(n) = ∑_{k=0}^∞ f(k+a), with complete Lean 4 formalization.

## Mathematical Statement
```lean
theorem reindex_series_shift {f : ℕ → ℝ} (a : ℕ) 
  (h_summable : Summable f) :
  ∑' n : {n : ℕ // n ≥ a}, f n = ∑' k : ℕ, f (k + a)
```

## Required Deliverables

### 1. Direct Bijection Approach
**Define the Bijection:**
```lean
def shift_bij (a : ℕ) : ℕ ≃ {n : ℕ // n ≥ a} where
  toFun k := ⟨k + a, by omega⟩
  invFun n := n.val - a
  left_inv k := by simp only [Subtype.coe_mk, add_tsub_cancel_left]
  right_inv n := by 
    ext
    simp only [Subtype.coe_mk]
    exact Nat.add_sub_cancel' n.prop
```

**Apply to Series:**
```lean
theorem reindex_series_shift ... := by
  -- Method 1: Use the bijection directly
  have : ∑' k : ℕ, f (k + a) = ∑' k : ℕ, f (shift_bij a k).val := by
    congr 1
    ext k
    rfl
  rw [this]
  -- Now apply general reindexing theorem
  symm
  apply tsum_equiv (shift_bij a).symm
```

### 2. Subtype Summation Method
```lean
-- Use tsum_subtype lemmas
theorem reindex_series_shift_v2 ... := by
  -- Express subtype sum using indicator
  have : ∑' n : {n : ℕ // n ≥ a}, f n = 
         ∑' n : ℕ, if h : n ≥ a then f n else 0 := by
    apply tsum_subtype
    intro n hn
    simp at hn
    exact hn
    
  -- Rewrite the conditional sum
  rw [this]
  -- Show equality with shifted sum
```

### 3. Splitting Approach
```lean
-- Split the full sum and recombine
theorem reindex_series_shift_v3 ... := by
  -- Use that ∑_{n=0}^∞ f(n) = ∑_{n=0}^{a-1} f(n) + ∑_{n=a}^∞ f(n)
  have split : ∑' n : ℕ, f n = 
               ∑ n in Finset.range a, f n + ∑' n : {n : ℕ // n ≥ a}, f n := by
    rw [← tsum_add_tsum_compl]
    congr 1
    · ext n
      simp [Finset.mem_range]
    · exact summable_on_compl_subset h_summable
      
  -- Similarly for shifted sum
  have split_shifted : ∑' n : ℕ, f n = 
                      ∑ n in Finset.range a, f n + ∑' k : ℕ, f (k + a) := by
    -- Prove this decomposition
    
  -- Conclude equality
  rw [← split, ← split_shifted]
```

### 4. Measure Theory Interpretation
```lean
-- View as pushforward measure
import MeasureTheory.Measure.Count

-- The counting measure on {n ≥ a} equals pushforward of counting on ℕ
example (a : ℕ) : 
  (MeasureTheory.Measure.count : Measure {n : ℕ // n ≥ a}) = 
  MeasureTheory.Measure.map (fun k => ⟨k + a, by omega⟩) MeasureTheory.Measure.count := by
  -- Prove measure equality
  -- Then integration gives series equality
```

### 5. Concrete Examples
```lean
-- Example 1: Geometric series
example (r : ℝ) (hr : |r| < 1) (a : ℕ) :
  ∑' n : {n : ℕ // n ≥ a}, r^n = r^a / (1 - r) := by
  rw [reindex_series_shift]
  simp only [pow_add]
  rw [← tsum_mul_left]
  simp [tsum_geometric_of_lt_1 hr.1 hr.2]

-- Example 2: Factorial series starting from n=2
example : ∑' n : {n : ℕ // n ≥ 2}, 1/n.factorial = exp 1 - 2 := by
  rw [reindex_series_shift]
  -- ∑_{k=0}^∞ 1/(k+2)! = ∑_{j=2}^∞ 1/j! = e - 1 - 1
  
-- Example 3: Harmonic series tail
example (a : ℕ) (ha : a > 0) :
  ¬Summable (fun n : {n : ℕ // n ≥ a} => (1 : ℝ) / n) := by
  -- Still diverges after shifting
```

### 6. Index Arithmetic Details
```lean
-- Careful handling of natural number subtraction
lemma shift_index_arithmetic (a n : ℕ) (h : n ≥ a) :
  (n - a) + a = n := Nat.sub_add_cancel h

-- When n < a, we get 0
lemma shift_index_below (a n : ℕ) (h : n < a) :
  n - a = 0 := Nat.sub_eq_zero_of_le (le_of_lt h)

-- These are crucial for the bijection proofs
```

### 7. Convergence Preservation
```lean
-- Shifting preserves summability
lemma summable_shift_iff {f : ℕ → ℝ} (a : ℕ) :
  Summable f ↔ Summable (fun k => f (k + a)) := by
  constructor
  · intro hf
    -- If f summable, tail is summable
    exact hf.comp_injective (add_left_injective a)
  · intro hf_shift
    -- If shifted summable, extend with finite sum
    -- Use that f = (f on [0,a)) + (f shifted from a)
```

## Lean 4 Technical Considerations

### Subtype Handling
- Work with `{n : ℕ // n ≥ a}` coercions
- Use `Subtype.ext` for equality
- Apply `Subtype.coe_prop` for properties

### Natural Number Arithmetic
- Handle `n - a` carefully (truncated subtraction)
- Use `omega` tactic for inequalities
- Apply `Nat.add_sub_cancel` variants

### Summability API
- `tsum_subtype` for restriction
- `summable_comp_injective` for reindexing
- `tsum_add_tsum_compl` for splitting

## Expected Output Format
1. Complete proof with 3+ methods (1500-2000 words)
2. Lean 4 implementation with all imports
3. 5+ worked examples showing applications
4. Visualization of index correspondence
5. Common pitfalls and solutions
6. References to:
   - Mathlib4 documentation on subtypes
   - Real analysis texts on series manipulation
   - Concrete Mathematics for summation techniques

## Connection to Main Theorem
This theorem is used at line 65 of SeriesReindexing.lean and is fundamental for converting between different index ranges in the factorial series proofs.