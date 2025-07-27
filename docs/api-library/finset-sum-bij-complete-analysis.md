# Complete Analysis of Finset.sum_bij in mathlib4

## Executive Summary

`Finset.sum_bij` is a powerful theorem in mathlib4 that allows reordering sums (and products) over finite sets using a bijection. The theorem states that if you have a bijection between two finite sets, you can transform a sum over one set into a sum over the other.

## Core Theorem: Finset.sum_bij

### Exact Signature (from mathlib4)

```lean
@[to_additive]
theorem prod_bij (i : ∀ a ∈ s, κ) (hi : ∀ a ha, i a ha ∈ t)
    (i_inj : ∀ a₁ ha₁ a₂ ha₂, i a₁ ha₁ = i a₂ ha₂ → a₁ = a₂)
    (i_surj : ∀ b ∈ t, ∃ a ha, i a ha = b) (h : ∀ a ha, f a = g (i a ha)) :
    ∏ x ∈ s, f x = ∏ x ∈ t, g x
```

**Note**: The additive version is accessed via `Finset.sum_bij` due to the `@[to_additive]` attribute.

### Required Import

```lean
import Mathlib.Algebra.BigOperators.Group.Finset.Defs
```

### Type Parameters and Arguments

1. **Type parameters**:
   - `ι`, `κ`: Index types for the two finite sets
   - `α`: The type of values being summed/multiplied (must have `CommMonoid` for products, `AddCommMonoid` for sums)

2. **Arguments**:
   - `s : Finset ι`: Source finite set
   - `t : Finset κ`: Target finite set
   - `i : ∀ a ∈ s, κ`: A dependent function mapping elements of `s` to elements of type `κ`
   - `hi : ∀ a ha, i a ha ∈ t`: Proof that the mapping lands in `t`
   - `i_inj : ∀ a₁ ha₁ a₂ ha₂, i a₁ ha₁ = i a₂ ha₂ → a₁ = a₂`: Injectivity proof
   - `i_surj : ∀ b ∈ t, ∃ a ha, i a ha = b`: Surjectivity proof
   - `h : ∀ a ha, f a = g (i a ha))`: Proof that functions are related by the bijection
   - `f : ι → α`: Function over source set
   - `g : κ → α`: Function over target set

### Key Features

1. **Dependent bijection**: The mapping `i` can depend on the membership proof, making it very flexible
2. **Separate injectivity and surjectivity**: Unlike some variants, this version requires explicit proofs of both properties
3. **Multiplicative notation**: The theorem is stated for products, but applies to sums via `@[to_additive]`

## Related Theorems and Variants

### 1. Finset.prod_bij' (with inverse function)

```lean
theorem prod_bij' (i : ∀ a ∈ s, κ) (j : ∀ a ∈ t, ι) (hi : ∀ a ha, i a ha ∈ t)
    (hj : ∀ a ha, j a ha ∈ s) (left_inv : ∀ a ha, j (i a ha) (hi a ha) = a)
    (right_inv : ∀ a ha, i (j a ha) (hj a ha) = a) (h : ∀ a ha, f a = g (i a ha)) :
    ∏ x ∈ s, f x = ∏ x ∈ t, g x
```
- Specifies bijection via inverse function rather than surjective injection
- Often easier to use when you have an explicit inverse

### 2. Finset.prod_nbij (non-dependent version)

```lean
lemma prod_nbij (i : ι → κ) (hi : ∀ a ∈ s, i a ∈ t) (i_inj : (s : Set ι).InjOn i)
    (i_surj : (s : Set ι).SurjOn i t) (h : ∀ a ∈ s, f a = g (i a)) :
    ∏ x ∈ s, f x = ∏ x ∈ t, g x
```
- Uses non-dependent function `i : ι → κ`
- Uses `Set.InjOn` and `Set.SurjOn` for cleaner notation

### 3. Finset.prod_bijective (with Function.Bijective)

```lean
lemma prod_bijective (e : ι → κ) (he : e.Bijective) (hst : ∀ i, i ∈ s ↔ e i ∈ t)
    (hfg : ∀ i ∈ s, f i = g (e i)) :
    ∏ i ∈ s, f i = ∏ i ∈ t, g i
```
- Uses `Function.Bijective` predicate
- Requires membership preservation condition

### 4. Fintype.prod_equiv (for equivalences)

```lean
lemma prod_equiv (e : ι ≃ κ) (f : ι → α) (g : κ → α) (h : ∀ x, f x = g (e x)) :
    ∏ x, f x = ∏ x, g x
```
- Uses type equivalence `≃`
- Works over entire types (with `Fintype` instances)

## Usage Examples

### Example 1: Basic reindexing

```lean
import Mathlib.Algebra.BigOperators.Group.Finset.Defs

example (s : Finset ℕ) (t : Finset ℕ) (f g : ℕ → ℝ)
    (i : ∀ a ∈ s, ℕ) 
    (hi : ∀ a ha, i a ha ∈ t)
    (i_inj : ∀ a₁ ha₁ a₂ ha₂, i a₁ ha₁ = i a₂ ha₂ → a₁ = a₂)
    (i_surj : ∀ b ∈ t, ∃ a ha, i a ha = b)
    (h : ∀ a ha, f a = g (i a ha)) :
    ∑ x ∈ s, f x = ∑ x ∈ t, g x :=
  Finset.sum_bij i hi i_inj i_surj h
```

### Example 2: Using with a simple shift

```lean
example (n : ℕ) : ∑ k in Finset.range n, k = ∑ k in Finset.range n, (n - 1 - k) := by
  apply Finset.sum_bij
  · intro k hk
    exact n - 1 - k
  · intro k hk
    simp at hk ⊢
    omega
  · intro a₁ ha₁ a₂ ha₂ h
    simp at h
    omega
  · intro b hb
    use n - 1 - b
    simp at hb ⊢
    constructor
    · omega
    · omega
  · intro a ha
    rfl
```

## Common Patterns and Best Practices

1. **Choosing the right variant**:
   - Use `sum_bij` when the bijection depends on membership proofs
   - Use `sum_nbij` for simpler non-dependent bijections
   - Use `sum_bij'` when you have an explicit inverse function
   - Use `sum_equiv` or `sum_bijective` for cleaner proofs with equivalences

2. **Proof structure**:
   - Define your bijection function clearly
   - Prove membership preservation
   - Prove injectivity (often using `simp` and arithmetic)
   - Prove surjectivity (often by constructing preimages)
   - Verify the function equation

3. **Common applications**:
   - Reindexing sums with shifted indices
   - Converting between different representations of the same set
   - Symmetry arguments in combinatorics
   - Change of variables in finite sums

## Implementation Details

The theorem is implemented using:
- `Multiset.map_eq_map_of_bij_of_nodup`: The core multiset bijection theorem
- `congr_arg`: To lift the multiset equality to finset products
- The `@[to_additive]` attribute automatically generates the sum version

## Summary

`Finset.sum_bij` is a fundamental tool for manipulating finite sums and products in Lean 4. Its flexibility through dependent types makes it powerful but sometimes verbose to use. The various specialized versions (like `sum_nbij`, `sum_bijective`, etc.) provide cleaner interfaces for common use cases.

Key takeaways:
- Always verify which variant best fits your use case
- The dependent version `sum_bij` is the most general
- Import `Mathlib.Algebra.BigOperators.Group.Finset.Defs` to access these theorems
- The `@[to_additive]` attribute means product theorems automatically work for sums