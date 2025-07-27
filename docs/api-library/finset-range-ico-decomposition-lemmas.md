# Finset.range and Finset.Ico Decomposition Lemmas

This document contains comprehensive findings from LeanExplore search for lemmas that help decompose `Finset.range` into parts using `Finset.Ico` and prove disjointness properties.

## Essential Imports

```lean
import Mathlib.Data.Finset.Range
import Mathlib.Order.Interval.Finset.Basic
import Mathlib.Order.Interval.Finset.Nat
import Mathlib.Algebra.Group.Nat.Range
import Mathlib.Order.Interval.Finset.SuccPred
```

## Key Lemmas for Decomposition

### 1. Range Decomposition Lemmas

#### Basic Recursive Decomposition
- **`Finset.range_add_one`** (ID: 89667)
  ```lean
  theorem range_add_one : range (n + 1) = insert n (range n)
  ```
  - Import: `Mathlib.Data.Finset.Range`
  - Decomposes `range (n+1)` as inserting `n` into `range n`

- **`Finset.range_succ`** (ID: 89666)
  ```lean
  theorem range_succ : range (succ n) = insert n (range n)
  ```
  - Import: `Mathlib.Data.Finset.Range`
  - Alternative formulation using `succ`

#### Advanced Decomposition
- **`Finset.range_add_eq_union`** (ID: 157434)
  ```lean
  theorem range_add_eq_union : range (a + b) = range a ∪ (range b).map (addLeftEmbedding a)
  ```
  - Import: `Mathlib.Order.Interval.Finset.Nat`
  - Decomposes `range (a+b)` into union of `range a` and shifted `range b`

### 2. Range and Ico Equivalence

- **`Nat.Ico_zero_eq_range`** (ID: 157400)
  ```lean
  theorem Ico_zero_eq_range : Ico 0 = range
  ```
  - Import: `Mathlib.Order.Interval.Finset.Nat`
  - Shows `Ico 0 n = range n`

- **`Finset.range_eq_Ico`** (ID: 157402)
  ```lean
  theorem range_eq_Ico : range = Ico 0
  ```
  - Import: `Mathlib.Order.Interval.Finset.Nat`
  - Alternative formulation: `range n = Ico 0 n`

### 3. Ico Union and Decomposition

- **`Finset.Ico_union_Ico_eq_Ico`** (ID: 156938)
  ```lean
  theorem Ico_union_Ico_eq_Ico {a b c : α} (hab : a ≤ b) (hbc : b ≤ c) :
    Ico a b ∪ Ico b c = Ico a c
  ```
  - Import: `Mathlib.Order.Interval.Finset.Basic`
  - Consecutive intervals union to larger interval

- **`Finset.Ico_union_Ico`** (ID: 156942)
  ```lean
  theorem Ico_union_Ico {a b c d : α} (h₁ : min a b ≤ max c d) (h₂ : min c d ≤ max a b) :
    Ico a b ∪ Ico c d = Ico (min a c) (max b d)
  ```
  - Import: `Mathlib.Order.Interval.Finset.Basic`
  - General union formula for overlapping intervals

### 4. Disjointness Lemmas

- **`Finset.Ico_disjoint_Ico_consecutive`** (ID: 156883)
  ```lean
  theorem Ico_disjoint_Ico_consecutive (a b c : α) : Disjoint (Ico a b) (Ico b c)
  ```
  - Import: `Mathlib.Order.Interval.Finset.Basic`
  - **Critical**: Consecutive intervals are disjoint

- **`Finset.disjoint_range_addLeftEmbedding`** (ID: 9465)
  ```lean
  theorem disjoint_range_addLeftEmbedding (a : ℕ) (s : Finset ℕ) :
    Disjoint (range a) (map (addLeftEmbedding a) s)
  ```
  - Import: `Mathlib.Algebra.Group.Nat.Range`
  - `range a` is disjoint from any set shifted by `a`

### 5. Insert Operations with Ico

- **`insert_Ico_pred_right_eq_Ico`** (ID: 157475)
  ```lean
  lemma insert_Ico_pred_right_eq_Ico (h : a < b) : 
    insert (pred b) (Ico a (pred b)) = Ico a b
  ```
  - Import: `Mathlib.Order.Interval.Finset.SuccPred`
  - Inserting predecessor extends interval

- **`insert_Ico_succ_left_eq_Ico`** (ID: 158632)
  ```lean
  lemma insert_Ico_succ_left_eq_Ico (h : a < b) : 
    insert a (Ico (succ a) b) = Ico a b
  ```
  - Import: `Mathlib.Order.Interval.Set.SuccPred`
  - Note: This is the Set version; check if Finset version exists

## Practical Decomposition Patterns

### Pattern 1: Decomposing range n into {0} and Ico 1 n
```lean
-- Using range_eq_Ico and insert properties
example (n : ℕ) (hn : 0 < n) : range n = insert 0 (Ico 1 n) := by
  rw [range_eq_Ico]
  -- Would need to show: Ico 0 n = insert 0 (Ico 1 n)
  -- This follows from interval properties when n > 0
```

### Pattern 2: Decomposing range n into two disjoint parts
```lean
-- For any k ≤ n, we have:
example (n k : ℕ) (hkn : k ≤ n) : range n = range k ∪ Ico k n := by
  rw [range_eq_Ico, range_eq_Ico]
  -- Apply Ico_union_Ico_eq_Ico with a=0, b=k, c=n
  exact Ico_union_Ico_eq_Ico (Nat.zero_le k) hkn
```

### Pattern 3: Proving disjointness of decomposition
```lean
-- The decomposition parts are disjoint:
example (n k : ℕ) : Disjoint (range k) (Ico k n) := by
  rw [range_eq_Ico]
  exact Ico_disjoint_Ico_consecutive 0 k n
```

## Summary of Key Decomposition Tools

1. **Basic decomposition**: Use `range_add_one` or `range_succ` for recursive decomposition
2. **Interval conversion**: Use `range_eq_Ico` to convert between `range` and `Ico`
3. **Union properties**: Use `Ico_union_Ico_eq_Ico` for consecutive intervals
4. **Disjointness**: Use `Ico_disjoint_Ico_consecutive` for proving parts are disjoint
5. **Advanced decomposition**: Use `range_add_eq_union` for decomposing sums

## Application to Sorry Elimination

These lemmas are particularly useful for:
- Proving properties about sums over ranges by decomposing them
- Establishing disjointness in partition-based proofs
- Converting between different representations of finite sets of naturals

For the Potion Problem specifically, these lemmas could help in:
- Decomposing sums over `range n` in the tail probability formula
- Proving disjointness properties needed for probability calculations
- Establishing the telescoping sum structure by decomposing ranges