# Lean 4 Design Patterns and Best Practices — A Community Guide

**⚠️ DISCLAIMER**: This is an unofficial community guide synthesizing various Lean 4 patterns and practices. It is not endorsed by the Lean development team or mathlib maintainers. Patterns described here should be validated against official documentation and current mathlib4 conventions. Some claims in this document may be speculative or based on general functional programming principles rather than Lean-specific guidance.

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


## Naming Conventions

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

- Prefer descriptive verbs for tactics (`eraseHyp`) and nouns for terms (`unitEquiv`).  
- If a lemma mirrors an existing one with reordered arguments, suffix `_rev`.  
- Temporary variables: use `h`, `h₁`, `h₂` for hypotheses, `x`, `y` for elements, `α`, `β` for types.  


## File \& Module Organisation

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

## Lake Package Design

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


### Pretty-Printer API

Lean’s formatter offers combinators (`nest`, `group`, `line`) to build custom printers.  Project maintainers can expose domain-specific pretty printers (e.g., for category diagrams) that honour column width.

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

### 1. `fun |` Pattern-Matching Short Lambdas

```lean
def maybeAdd : Option Nat → Nat
  | some n => n + 1
  | none   => 0
```

Compact and preferred over `match … with` for single-argument inductives.

### 2. `simp`-Friendly Definitions

- Use defining equations (`:=`) instead of pattern-matching if `rfl` proofs are common; simplification becomes zero-cost.  
- Provide `@[simp]` rewrite lemmas for non-trivial projections.


### 3. Typeclass Synthesis as Dependency Injection

```lean
variable {α β} [Group α] [Group β]

class Compat (f : α → β) : Prop :=
  (map_one : f 1 = 1)

export Compat (map_one)

theorem idCompat : Compat (fun x => x) := ⟨rfl⟩
```

Call-sites merely write `by simp` because `map_one` is found by typeclass search — a Lean idiom analogous to Spring-style injection.

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

### Forward Reasoning with `calc`

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

### Custom Tactics as Reusable Abstractions

Store in `MyPkg.Tactic`.  Minimal example:

```lean
namespace Tactic
open Lean Elab Tactic

elab "eraseHyp" n:ident : tactic => do
  let h ← getLocalDeclFromUserName n
  withMainContext <| Lean.Meta.clear h.fvarId
end Tactic
```

Expose interactive syntax and document with usage examples.

## Metaprogramming \& DSL Construction

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

### linters

- `lake env lean -R Mathlib.Tactic#lint` summarises all style/linter violations.
- Enable `CI=lint` job in GitHub Actions with provided template from mathlib4 repo.


## Performance Optimisation Patterns

- Mark helper defs `@[inline]` if they are shallow wrappers to avoid metaprogramming overhead.
- Avoid `simp` on large lemma sets; restrict with `simp [only]`.
- Use `set_option maxHeartbeats` pragmatically; refactor proofs if heartbeats exceed 60k.


## Anti-Patterns to Avoid

| Anti-Pattern | Why it hurts | Remedy |
| :-- | :-- | :-- |
| Global `open` of many namespaces | Name clashes, slow elaboration | `open scoped` locally |
| `by apply` chains exceeding 10 lines | Hard to read, brittle | Use `calc` or dedicated lemma |
| Copy-pasted `simp` lemmas without tags | Causes looping | Tag with `@[simp, norm_cast]` conscientiously |
| Multiple `package` declarations per repo | Breaks Lake’s manifest assumptions | Split into separate repos or use `lean_lib` targets |

## Appendix A: Cheat-Sheet Tables

### Lean 3 → Lean 4 Syntax Migration

| Lean 3 | Lean 4 | Rationale | Citation |
| :-- | :-- | :-- | :-- |
| `λ x, t` | `fun x => t` | `=>` disambiguates commas | 6 |
| `Π x : A, P` | `(x : A) → P` or `∀ x : A, P` | Uniform arrow syntax | 1 |
| `f $ x` | `f <| x` | Avoid `$` precedence confusion | 1 |
| `{,,}` record update | `{parent with field := val}` | Clear parent vs fields | 1 |

### Common Lake CLI

| Command | Purpose |
| :-- | :-- |
| `lake new MyPkg` | Scaffold project |
| `lake update` | Fetch/update deps |
| `lake build` | Compile default targets |
| `lake env` | Spawn shell with `LEAN_PATH` |
| `lake exe <name>` | Build and run executable |

## Appendix B: Extended Code Walk-Through

Below is a condensed real-world module that demonstrates several patterns discussed:

```lean
import MyPkg.Data.Graph -- internal data layer
import Std
open Std

namespace MyPkg.Algorithm

/-- Depth-first search returning discovered order or `none` if graph is cyclic. -/
partial def dfs (g : Graph) : OptionM (List Node) := do
  let mut order := #[]
  let mut visited : HashSet Node := {}
  let rec visit (n : Node) : OptionM Unit := do
    if visited.contains n then
      if order.contains n then
        return ()                      -- already processed, skip
      else
        failure                         -- back-edge → cycle
    visited := visited.insert n
    for m in g.adj n do
      visit m
    order := order.push n
  for n in g.nodes do
    visit n
  return order.toList

theorem dfs_correct
    (h : dfs g = some l) :
    TopologicallySorted g l := by
  -- proof uses patterns: calc chain + `intro`/`cases`
  -- omitted for brevity
  admit

end MyPkg.Algorithm
```

Patterns illustrated:

- `partial` + `OptionM` for safe partiality.
- Mutable state via `let mut` inside `do` blocks.
- Proof lemma placed next to implementation to keep modules cohesive.


## Conclusion

Following established patterns helps create Lean 4 code that is predictable, readable, and maintainable. This guide attempts to collect various practices observed in the Lean community, though readers should verify these against official sources. The Lean ecosystem continues to evolve, and best practices may change over time.

---

## References and Further Reading

### Official Resources
- Lean 4 Documentation: https://lean-lang.org/lean4/doc/
- Theorem Proving in Lean 4: https://leanprover.github.io/theorem_proving_in_lean4/
- mathlib4: https://github.com/leanprover-community/mathlib4
- Lean Community: https://leanprover-community.github.io/

### Note on Citations
The original version of this document contained numerous citations that were found to be incorrect or unrelated to Lean 4. These have been removed. For authoritative information, please consult the official resources listed above.
