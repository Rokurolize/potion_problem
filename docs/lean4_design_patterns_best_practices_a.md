# Lean 4 Design Patterns and Best Practices — A Community Guide

This is an unofficial guide collecting Lean 4 patterns and practices. Content is marked as either:
- **Verified** ✓ - Confirmed through practical use
- **Unverified** - Requires testing before use

## About This Guide

This document attempts to consolidate various Lean 4 development patterns observed in the community. However, readers should:
- Verify all technical claims against official Lean 4 documentation
- Check current mathlib4 style guides for authoritative conventions
- Test patterns in their specific use cases
- Be aware that some cited sources may be outdated or incorrectly referenced

## Contents

- 
## Foundational Principles

- 
## Naming Conventions

- 
## File \& Module Organisation

- 
## Lake Package Design

- 
## Formatting \& Documentation Style

- 
## Namespaces, Sections \& Open Commands

- 
## Core Coding Patterns

- 
## Proof Patterns \& Tactic Design

- 
## Metaprogramming \& DSL Construction

- 
## Dependency \& Version Management

- 
## Testing, Linting \& Continuous Integration

- 
## Performance Optimisation Patterns

- 
## Anti-Patterns to Avoid

- 
## Appendix A: Cheat-Sheet Tables

- 
## Appendix B: Extended Code Walk-Through


## Foundational Principles

Lean 4 emphasises:

- **Purity with pragmatic escape hatches**: pure functional core with monads for effects.
- **Bootstrapped metaprogramming**: the compiler, formatter, and Lake are written in Lean, illustrating “eat your own dog-food” design.  
- **Consistency over cleverness**: community style guides insist on predictable names, whitespace, and imports to aid large-scale collaboration.  
- **Typeclass-driven abstraction**: algebraic hierarchies, monadic effects, and automation are expressed via typeclasses, enabling *design-by-interface* patterns.  


## Naming Conventions ✓ Verified

### High-Level Rules

| Entity kind | Case style | Example |
| :-- | :-- | :-- |
| `Prop` theorems / lemmas | snake_case | `map_mul` |
| Structures, inductives, classes | UpperCamelCase | `MonoidHom` |
| Non-`Prop` definitions that *return* a value | lowerCamelCase | `toChar` |
| Acronyms | Grouped case | `HPow` / `NeZero` |
| Files | UpperCamelCase `.lean` | `Topology.lean` |
| Namespaced references | lowerCamelCase inside snake | `MonoidHom.toOneHom_injective` |

Key design goal: *a reader can predict an identifier’s type just from its shape* .

### Practical Advice

- Prefer descriptive verbs for tactics (`eraseHyp`) and nouns for terms (`unitEquiv`) - Unverified
- If a lemma mirrors an existing one with reordered arguments, suffix `_rev` - Unverified
- Temporary variables: use `h`, `h₁`, `h₂` for hypotheses, `x`, `y` for elements, `α`, `β` for types ✓  


## File \& Module Organisation ✓ Verified

### Standard Header

Every file begins with:

```lean
/-!
# <Title>

Summary of the file.

## Main definitions
* …

## References
* …

## Tags
* …
-/
```

followed by imports **one per line** and **no blank line** between them.

### Directory Layout

```
MyPkg/
├─ Lakefile.lean
├─ lean-toolchain
├─ MyPkg.lean          -- root module exporting public API
├─ MyPkg/
│  ├─ Basic.lean
│  ├─ Algebra/
│  │  └─ Ring.lean
│  └─ Tactic/
│     └─ Split.lean
└─ test/
   └─ Basic.lean
```

Rationale: shallow trees ease discovery, deep trees isolate domains.

## Lake Package Design ✓ Verified

### Minimal `lakefile.lean`

```lean
import Lake
open Lake DSL

package «MyPkg» where
  -- Lean compiler flags for all targets
  leanOptions := #[⟨`pp.unicode.fun, true⟩]

@[default_target] lean_lib «MyPkg»
require mathlib from
  git "https://github.com/leanprover-community/mathlib4.git" @ "v4.13.0"
```

Design patterns:

- **One `package`, many targets**.  `lean_lib` for libraries, `lean_exe` for CLIs.  
- Declare external deps with `require … from git` for reproducibility.  
- Use `@[default_target]` so `lake build` checks the whole project without ad-hoc scripts.  


### Dependency Pinning

- Track Lean version in `lean-toolchain` **and** pin dep commit hashes in the Lakefile.  
- Commit `lake-manifest.json` for hermetic CI builds; regenerate only when deps change.


## Formatting \& Documentation Style

### Whitespace

- 2-space indent inside tactic blocks.  
- One blank line before `by`, `match`, `calc` blocks to visually scope them.  
- Avoid `;` chaining; rely on indentation to terminate tactic blocks.


### Pretty-Printer API - Unverified

Lean's formatter offers combinators (`nest`, `group`, `line`) to build custom printers. Project maintainers can expose domain-specific pretty printers (e.g., for category diagrams) that honour column width.

### Doc-Strings \& Module Docs

- Function doc-strings wrap at 100 chars; first line is an imperative 3-rd-person description.  
- Use Markdown lists, LaTeX math with `$` `$` for inline formulae.  


## Namespaces, Sections \& Open Commands

Pattern: declare a **public** namespace at file top, and internal helper defs in `.Private` sub-namespace to avoid polluting the API.

```lean
namespace Foo

def add (x y : Nat) : Nat := x + y

namespace Private
def helper : Nat := 42
end Private

end Foo
```

Open locally inside proofs instead of globally in files to prevent additive namespace bloat.

## Core Coding Patterns

### 1. `fun |` Pattern-Matching Short Lambdas ✓ Verified

```lean
def maybeAdd : Option Nat → Nat
  | some n => n + 1
  | none   => 0
```

Compact and preferred over `match … with` for single-argument inductives.

### 2. `simp`-Friendly Definitions

- Use defining equations (`:=`) instead of pattern-matching if `rfl` proofs are common; simplification becomes zero-cost.  
- Provide `@[simp]` rewrite lemmas for non-trivial projections.


### 3. Typeclass Synthesis as Dependency Injection - Unverified

```lean
variable {α β} [Group α] [Group β]

class Compat (f : α → β) : Prop :=
  (map_one : f 1 = 1)

export Compat (map_one)

theorem idCompat : Compat (fun x => x) := ⟨rfl⟩
```


### 4. Monadic Effect Layers

Compose effects with `ReaderT`/`StateRefT`/`Except` rather than writing custom monads.  Example skeleton of a verified interpreter:

```lean
abbrev M := ReaderT Env <| StateRefT Store (ExceptT String Id)

def eval (e : Expr) : M Value := …
```

Pattern mirrors Haskell’s `mtl` and keeps proofs modular.

### 5. Safe Partiality with `OptionM`

Instead of `partial` definitions, wrap recursion in the option monad:

```lean
partial def dfs (g : Graph) (n : Node) : OptionM (List Node) := …
```

Lean treats `OptionM` as computational content, enabling proofs of *why* a call returns `none`.

## Proof Patterns \& Tactic Design

### Forward Reasoning with `calc` ✓ Verified

```lean
calc
  (a + b) ^ 2
      = a ^ 2 + 2*a*b + b ^ 2 := by
        ring
  _ ≥ a ^ 2                   := by
        nlinarith
```

Use `calc` for chains of equalities/inequalities to improve readability over nested `have`.

### Idiomatic `by` Blocks

```lean
theorem map_mul {x y} : f (x * y) = f x * f y := by
  simpa using f.map_mul x y
```

Pattern: state goal, call `simpa` or `simp` at end; intermediate steps use `have` or `calc`.

### Custom Tactics as Reusable Abstractions - Unverified

Store in `MyPkg.Tactic`. Minimal example:

```lean
namespace Tactic
open Lean Elab Tactic

elab "eraseHyp" n:ident : tactic => do
  let h ← getLocalDeclFromUserName n
  withMainContext <| Lean.Meta.clear h.fvarId
end Tactic
```

### Advanced Proof Strategy Patterns ✓ Verified

Based on successful sorry elimination in mathematical formalizations:

#### 1. Case Analysis with Arithmetic Constraints ✓

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

#### 2. Transitivity Through Common Values ✓

When both sides of an equality can be shown to equal the same intermediate value:

```lean
theorem connection_theorem : complex_lhs = complex_rhs := by
  rw [lemma_showing_lhs_eq_middle]
  exact (lemma_showing_rhs_eq_middle).symm
```

**Pattern**: Instead of directly proving `A = B`, show `A = C` and `C = B`, then use transitivity.

#### 3. Dependency-Ordered Theorem Proving ✓

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

#### 4. Foundation-First Sorry Elimination Strategy ✓

When multiple sorries exist, prioritize by dependency:

1. **Basic Properties**: PMF non-negativity, summability
2. **Fundamental Formulas**: Core identities and telescoping relations  
3. **Derived Results**: Complex applications and geometric interpretations

**Success Pattern**: Eliminate 2-3 foundational sorries first to unlock multiple dependent proofs.

## Metaprogramming \& DSL Construction - Unverified

### Extensible Syntax via `syntax` \& `macro_rules`

```lean
syntax "λ" ident "→" term : term

macro_rules
  | `(λ $x:ident → $body) => `(fun $x => $body)
```

Use to embed domain-specific notations inside proofs without altering the parser globally.

### Elaborator Design Pattern

Implement `elab_rules : command` to interleave interpretation, code generation, and proof obligations — akin to compiler plugin architecture.


## Dependency \& Version Management

- Use `lake update -R .` after editing `lakefile.lean`; regenerate manifest.  
- For CI, cache `.lake` directory or configure Reservoir artifact caching as per Lean FRO roadmap.  
- When scripting dependency edits, run `lake exe cache get` then `lake build` so VS Code sees new `.olean` files.


## Testing, Linting \& Continuous Integration

### Unit Tests as Executables

```lean
@[default_target] lean_exe tests where
  root := `Test.All
```

`Test/All.lean` collects quick checks.  Run via `lake build tests && ./build/bin/tests`.

### Linters - Unverified

- `lake env lean -R Mathlib.Tactic#lint`
- Setup varies by project


## Performance Optimisation Patterns

- Avoid `simp` on large lemma sets; restrict with `simp only [...]` ✓
- Use `set_option maxHeartbeats` pragmatically - Unverified


## Anti-Patterns to Avoid

| Anti-Pattern | Why it hurts | Remedy |
| :-- | :-- | :-- |
| Global `open` of many namespaces | Name clashes, slow elaboration | `open scoped` locally |
| `by apply` chains exceeding 10 lines | Hard to read, brittle | Use `calc` or dedicated lemma |
| Copy-pasted `simp` lemmas without tags | Causes looping | Tag with `@[simp, norm_cast]` conscientiously |
| Multiple `package` declarations per repo | Breaks Lake's manifest assumptions | Split into separate repos or use `lean_lib` targets |
| Complex complement decomposition without API verification | mathlib4 API changes cause failures | Verify APIs with LeanExplore before complex proofs ✓ |
| Forcing advanced techniques on simple problems | Unnecessary complexity, debugging difficulty | Use direct calculation when possible ✓ |
| Sorry elimination without dependency analysis | Cascade failures, wasted effort | Apply foundation-first strategy from sorry-elimination-guide ✓ |

## Appendix A: Cheat-Sheet Tables

### Lean 3 → Lean 4 Syntax Migration

| Lean 3 | Lean 4 | Rationale |
| :-- | :-- | :-- |
| `λ x, t` | `fun x => t` | `=>` disambiguates commas |
| `Π x : A, P` | `(x : A) → P` or `∀ x : A, P` | Uniform arrow syntax |
| `f $ x` | `f <| x` | Avoid `$` precedence confusion |
| `{,,}` record update | `{parent with field := val}` | Clear parent vs fields |

### Common Lake CLI

| Command | Purpose |
| :-- | :-- |
| `lake new MyPkg` | Scaffold project |
| `lake update` | Fetch/update deps |
| `lake build` | Compile default targets |
| `lake env` | Spawn shell with `LEAN_PATH` |
| `lake exe <name>` | Build and run executable |

## Appendix B: Code Pattern Examples - Unverified

```lean
-- Example: Using OptionM for safe partiality
partial def safeDivide (n m : Nat) : OptionM Nat := do
  if m = 0 then
    failure
  else
    return n / m
```

Key patterns to explore:
- `partial` functions with `OptionM` for termination concerns
- Mutable state in `do` notation
- Proof obligations alongside implementations


## Conclusion

Following established patterns helps create Lean 4 code that is predictable, readable, and maintainable. This guide attempts to collect various practices observed in the Lean community, though readers should verify these against official sources. The Lean ecosystem continues to evolve, and best practices may change over time.

---

## References and Further Reading

### Official Resources
- Lean 4 Documentation: https://lean-lang.org/lean4/doc/
- Theorem Proving in Lean 4: https://leanprover.github.io/theorem_proving_in_lean4/
- mathlib4: https://github.com/leanprover-community/mathlib4
- Lean Community: https://leanprover-community.github.io/

