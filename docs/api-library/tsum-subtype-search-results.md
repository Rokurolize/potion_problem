# tsum_subtype Search Results and Analysis

## Executive Summary

**Finding**: There is no theorem named `tsum_subtype` in mathlib4. The search revealed related theorems and patterns for subtype summation.

## Detailed Findings

### 1. Related Subtype Summation Theorems Found

#### Aliases (these are the closest matches):
- `tsum_subtype_le` (ID: 187823) - Alias of `Summable.tsum_subtype_le`
- `tsum_subtype_add_tsum_subtype_compl` (ID: 187696) - Alias of `Summable.tsum_subtype_add_tsum_subtype_compl`
- `sum_add_tsum_subtype_compl` (ID: 187699) - Alias of `Summable.sum_add_tsum_subtype_compl`

#### Key Theorem: Subtype Complement Decomposition
```lean
theorem Summable.tsum_subtype_add_tsum_subtype_compl {α β : Type*} [AddCommMonoid β] 
    [TopologicalSpace β] {f : α → β} (hf : Summable f) (s : Set α) :
    ∑' (x : s), f x + ∑' (x : sᶜ), f x = ∑' x, f x
```
This decomposes a sum over the full type into sums over a subset and its complement.

### 2. General Reindexing Patterns

#### Equivalence-based Reindexing
While `Equiv.tsum_eq` wasn't found directly, the product version exists:
```lean
theorem Equiv.tprod_eq (e : γ ≃ β) (f : β → α) : ∏' c, f (e c) = ∏' b, f b
```

The corresponding sum version (if it exists) would be:
```lean
theorem Equiv.tsum_eq (e : γ ≃ β) (f : β → α) : ∑' c, f (e c) = ∑' b, f b
```

#### Injective Function Reindexing
Based on the product version found (ID: 187524):
```lean
theorem Function.Injective.tprod_eq {g : γ → β} (hg : Injective g) {f : β → α}
    (hf : mulSupport f ⊆ Set.range g) : ∏' c, f (g c) = ∏' b, f b
```

The sum version would use `support` instead of `mulSupport`:
```lean
theorem Function.Injective.tsum_eq {g : γ → β} (hg : Injective g) {f : β → α}
    (hf : support f ⊆ Set.range g) : ∑' c, f (g c) = ∑' b, f b
```

### 3. Practical Approaches for Subtype Summation

#### Option 1: Direct Subtype Notation
```lean
∑' (x : s), f x  -- where s : Set α
```

#### Option 2: Using Set.indicator
```lean
∑' x, Set.indicator s f x  -- sums f over s, 0 elsewhere
```

#### Option 3: Manual Equivalence Construction
If you need to relate a sum over a subtype to a sum over another type:
```lean
-- Define your equivalence
def myEquiv : { x : α // P x } ≃ β := ...

-- Use it for reindexing (assuming Equiv.tsum_eq exists)
∑' (x : { x : α // P x }), f x = ∑' (b : β), f (myEquiv.symm b)
```

### 4. Required Imports

Based on file locations found:
```lean
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.Group  
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Logic.Equiv.Basic
import Mathlib.Data.Set.Indicator
```

### 5. Verification Commands

To find the exact APIs in your mathlib4 version:
```bash
# Search for equivalence-based sum reindexing
uv run leanexplore search "Equiv.tsum_eq" --package Mathlib

# Search for injective function sum reindexing  
uv run leanexplore search "Function.Injective.tsum_eq" --package Mathlib

# Search for support-based theorems
uv run leanexplore search "support f ⊆" --package Mathlib

# Get details on the complement decomposition theorem
uv run leanexplore get 187696
```

## Additional Important Findings

### No Direct `Equiv.tsum_eq` Found
While `Equiv.tprod_eq` exists for products (ID: 187525), the corresponding sum version `Equiv.tsum_eq` was not found in the search. This suggests either:
1. It exists under a different name
2. mathlib4 uses alternative approaches for sum reindexing
3. It may need to be proven from more basic principles

### Alternative Reindexing Approaches

#### 1. Using `tsum_nbij` or `tsum_bij` (if they exist)
These would provide bijection-based reindexing without full equivalences.

#### 2. Using `HasSum` and manual proofs
```lean
-- Prove that if ∑' x, f x = s, then ∑' y, f (e y) = s for e : γ ≃ β
```

#### 3. Using the indicator function approach
```lean
∑' x, Set.indicator s f x
```

## Conclusion

The absence of a direct `tsum_subtype` theorem indicates that mathlib4 prefers more general approaches:
1. **For subtype summation**: Use the complement decomposition theorem (`tsum_subtype_add_tsum_subtype_compl`)
2. **For general reindexing**: Look for `Equiv.tsum_eq` or similar (may require further searching)
3. **For set-based summation**: Use set notation `∑' (x : s), f x` directly
4. **For indicator functions**: Use `Set.indicator` when appropriate

For the PotionProblem project, the complement decomposition theorem (`tsum_subtype_add_tsum_subtype_compl`) is likely the most relevant for handling the tail probability formula, as it directly relates sums over subtypes to the full sum.

## Recommended Next Steps

1. Verify if `Equiv.tsum_eq` exists under a different name:
   ```bash
   uv run leanexplore search "∑' c, f (e c) = ∑' b, f b" --package Mathlib
   ```

2. Check for bijection-based sum reindexing:
   ```bash
   uv run leanexplore search "tsum_bij" --package Mathlib
   ```

3. For the PotionProblem, focus on using `tsum_subtype_add_tsum_subtype_compl` with the appropriate imports:
   ```lean
   import Mathlib.Topology.Algebra.InfiniteSum.Group
   ```