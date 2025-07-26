# Lean 4 Design Patterns and Best Practices — Unreliable Source

**Note**: This document's credibility is compromised due to fabricated citations. Only the most basic patterns are retained below.

Content is marked as either:
- **Verified** ✓ - Matches confirmed practice
- **Unverified** - Cannot be trusted

## Overview

Lean 4 combines a small, trusted kernel with a user-level macro and metaprogramming tower. The result is a language in which “ordinary” code, proof scripts, domain-specific optimisations and compiler extensions coexist. The patterns discussed here fall into five broad categories:

1. **Naming, layout and docstrings**
2. **Module and namespace architecture**
3. **Proof structuring and tactic idioms**
4. **Computation-oriented patterns (meta \& run-time code)**
5. **Performance tuning, simplifier hygiene and automation policies**

Throughout the document we use short code snippets and cross-reference Mathlib 4 style rules and core discussions from the Lean Zulip archive.

## Naming, Layout and Documentation

### Snake vs. Camel — Type–Term Dichotomy ✓


| Element Kind | Recommended Style | Example |
| :-- | :-- | :-- |
| Definitions, lemmas, tactics | lower_snake_case | `subsingleton_iff`, `mapM` |
| Structures, inductives | CamelCase | `Real`, `ProbMeasure` |
| Namespaces | Camel.Case dotted path | `Topology.Algebra.Order` |

This match-up mirrors OCaml and Rust conventions, easing cognitive load when switching languages.

### Docstring First Policy

Every public constant must begin with a multiline docstring:

```lean
/--  Short one-line summary.  

Longer description with:  
• mathematical context  
• informal statement  
• usage notes -/
def gcd (m n : Nat) : Nat := by …  
```

Docstrings fuel `doc#` search, `Aesop?` lemma suggestion and future literate exports.

### File Preamble and Imports

1. Minimal, explicit imports.
2. `open` only what is really needed (rarely `open Nat`).
3. Global `namespace` matches file path.

## Module and Namespace Architecture

### Directory Layout in Mathlib 4

```
Mathlib/
  Algebra/
    Group/
    Ring/
  Data/
    Nat/
    List/
  Tactic/ …
```

Files should be small (≈500 LOC). When a file grows monolithic, split by “vertical slices” (API + proofs for one concept) rather than by type/proof separation.

### One Namespace per Concept

Avoid “God namespaces”. For example:

```lean
namespace Topology

namespace Baire
/-… lemmas …-/
end Baire

namespace Compact
/-… lemmas …-/
end Compact

end Topology
```

This prevents name collisions and clarifies imports.

### Re-export Modules

`export` re-routes frequently-used lemmas without wild-opening parent namespaces:

```lean
export Topology.Baire (isComeagre)
```


## Proof Structuring Patterns

### Declarative Skeleton → Tactical Refinement

1. **High-level outline** with `suffices`, `have`, `calc` road-map.
2. Fill gaps using local tactic blocks.
```lean
theorem mul_comm (a b : α) [CommSemiring α] : a * b = b * a := by
  -- Step 1: use commutativity of multiplication in semiring
  have := mul_comm a b
  -- Step 2: `simpa` closes goal
  simpa using this
```


### Localising Automation with `by` blocks

Use `(by …)` inline proofs to keep narrative flow:

```lean
map_add₀ (f := g) (by simpa using h₁) (by simpa using h₂)
```


### `simp`, `simp?`, `simp only` Triangle

| Command | Use Case | Risk |
| :-- | :-- | :-- |
| `simp` | quick finish | can diverge in heavy imports |
| `simp?` | interactive suggestion | none |
| `simp only [list]` | performance-critical loops | brittle if list incomplete |

Best practice: mark lemmas `@[simp, simp_nf]` sparingly; restrict lambdas (avoid `rw [funext]` inside simp). Loop prevention guidelines.

### Orthogonality via `Calc` Chains

`calc` allows textbook-style, left-aligned proofs while remaining machine-checkable:

```lean
calc
  (a + b) ^ 2
      = a ^ 2 + 2 * a * b + b ^ 2 := by ring
  _ ≥ a ^ 2 + b ^ 2               := by nlinarith
```


## Computation-oriented Patterns - Unverified

### 1. Option/Except pipelines

```lean
def parseNat (s : String) : Except String Nat :=
  match s.toNat? with
  | none   => .error s!"{s} is not a natural"
  | some n => .ok n

def safeDiv (a b : Nat) : Except String Nat := do
  if h : b = 0 then throw "division by zero"
  pure (a / b)
```

Here, `Except` plays the rôle of Rust’s `Result` or Haskell’s `Either`.

### 2. `ST` and Unboxed Arrays for Performance

Lean arrays are persistent. Imperative updates rely on `ST`:

```lean
def bubbleSort (xs : Array Nat) : Array Nat :=
  Id.run <| do
    let mut a := xs
    for i in [0 : xs.size] do
      ...
      if a[j] > a[j+1] then
        a := a.swap j (j+1)
    pure a
```


### 3. Metaprogramming \& DSLs

Macros expand Lean syntax at compile time (Racket-style). Design pattern:

1. Define a surface syntax with `syntax (name := …)`.
2. Implement `macro_rules`.
3. Provide reflection lemma if needed.

Example: “matrix notation” macro in Mathlib.

## Performance Tuning \& Automation Hygiene - Unverified




## Common Anti-Patterns

| Anti-pattern | Cure |
| :-- | :-- |
| Dumping huge proofs into a single `by` block | Split into helper lemmas; use `calc` |
| Blanket `open` of core namespaces | Use `open scoped` or localised `open!` |
| Over-reliance on `simp` for heavy algebraic reasoning | Combine `ring`, `nlinarith`, `aesop` selectively |
| Deeply nested `match` with pattern duplication | Use `simp` lemmas over `Decidable` props |
| Accidental typeclass loops (`Group` + `Ring` instances) | Tag one instance `@[priority 100]` |

## Idiomatic Lean 4 Cheat-Sheet

| Goal | Idiomatic Snippet | Notes |
| :-- | :-- | :-- |
| quick rewrite | `simp [lemma]` | Avoid `rw` chain |
| prove equality of decidable props | `by decide` | Delegates to `decide_eq_true` |
| treat tactic failure as option | `tactic?` combinator returns `MetaM (Option _)` | Enables backtracking |
| create array builder | `let mut arr : Array α := #[]; for … do arr := arr.push …` | Lean’s `push` is O(1) amortised |
| restrict simp set | `simp (config := {contextual := true}) only [h₁,h₂]` |  |
| inspect proof state | `set_option pp.goalTypes true` | Dev debug |



## References

For reliable Lean 4 information, consult:
- Official Lean 4 Documentation: https://lean-lang.org/lean4/doc/
- mathlib4: https://github.com/leanprover-community/mathlib4
- Lean Community: https://leanprover-community.github.io/
- Lean Zulip Chat: https://leanprover.zulipchat.com/

## Summary

Due to fabricated citations in the original document, only basic naming conventions can be considered reliable:
- `snake_case` for lemmas/definitions ✓
- `CamelCase` for types/structures ✓
- Basic `calc` chains ✓
- Simple `simp` usage ✓

All other content requires independent verification.
