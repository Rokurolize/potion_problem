# Research Prompt 40: Lean 4 Code Navigation and API Search Strategies

## Context

I'm working on migrating a Lean 4 project from mathlib4 v4.21.0 to v4.22.0-rc3. During this migration, I'm having difficulty finding certain theorems and understanding how Lean 4 code is organized.

## Specific Problem

I need to find the definition of `summable_nat_add_iff` for real numbers. I've found:

1. In NNReal (non-negative reals), there's a theorem that uses it:
```lean
nonrec theorem summable_nat_add_iff {f : ℕ → ℝ≥0} (k : ℕ) :
    (Summable fun i => f (i + k)) ↔ Summable f := by
  rw [← summable_coe, ← summable_coe]
  exact @summable_nat_add_iff ℝ _ _ _ (fun i => (f i : ℝ)) k
```

2. The theorem is referenced in multiple files but I can't find its actual definition.

3. Main branch successfully uses this theorem to prove:
```lean
lemma summable_shifted_factorial : Summable (fun n : ℕ => (1 : ℝ) / (n - 1).factorial) := by
  rw [← summable_nat_add_iff 1]
  have h_eq : ∀ k : ℕ, (k + 1) - 1 = k := fun k => Nat.add_sub_cancel k 1
  conv => rhs; ext k; rw [← h_eq k]
  exact FactorialSeries.summable_inv_factorial
```

## Questions

1. **How is Lean 4 code organized?** What are the conventions for:
   - Where theorems are defined vs where they're used
   - How `nonrec` keyword affects theorem visibility
   - How to trace where a theorem is actually defined when you see `@theorem_name Type`

2. **What are effective search strategies for finding theorem definitions?**
   - When I see `@summable_nat_add_iff ℝ`, how do I find where this is defined?
   - Are there naming conventions that indicate where a theorem might be located?
   - What tools or commands can help navigate Lean 4 codebases?

3. **Understanding theorem availability across versions:**
   - If a theorem is used in both v4.21.0 and v4.22.0-rc3, but I can't find its definition, where might it be?
   - Could it be in a different namespace or module?
   - How do I check if a theorem was moved or renamed between versions?

4. **Practical tips for API migration:**
   - When migrating between mathlib versions, what's the best way to find replacement APIs?
   - How to understand the structure of mathlib's module hierarchy?
   - Are there patterns in how similar theorems are named and organized?

## Environment
- Lean 4 versions: v4.21.0 and v4.22.0-rc3
- mathlib4 versions: corresponding to these Lean versions
- I have both versions cloned locally for comparison