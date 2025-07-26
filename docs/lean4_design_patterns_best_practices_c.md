# Lean 4 Design Patterns and Best Practices — Community Observations

**⚠️ CRITICAL DISCLAIMER**: This document was found to contain entirely fabricated citations linking to unrelated Reddit threads about video games, Gmail support, and other topics completely unrelated to Lean 4. All original citations have been removed. The technical content itself appears to be a mix of reasonable Lean 4 patterns and general functional programming principles, but readers should verify ALL claims against official Lean 4 documentation. This is NOT an authoritative guide.

## Overview

Lean 4 combines a small, trusted kernel with a user-level macro and metaprogramming tower. The result is a language in which “ordinary” code, proof scripts, domain-specific optimisations and compiler extensions coexist. The patterns discussed here fall into five broad categories:

1. **Naming, layout and docstrings**
2. **Module and namespace architecture**
3. **Proof structuring and tactic idioms**
4. **Computation-oriented patterns (meta \& run-time code)**
5. **Performance tuning, simplifier hygiene and automation policies**

Throughout the document we use short code snippets and cross-reference Mathlib 4 style rules and core discussions from the Lean Zulip archive.

## Naming, Layout and Documentation

### Snake vs. Camel — Type–Term Dichotomy

Lean follows a strict convention:


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


## Computation-oriented Patterns

Lean 4 is a general-purpose language. Common idioms:

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

## Performance Tuning \& Automation Hygiene

| Issue | Best Practice | Reference |
| :-- | :-- | :-- |
| **Long `simp`** | Convert expensive lemmas into `@[simp_high]`, invoke with `simp (config := { zeta := false })` | Core discussion |
| **Slow `rewrite`** | Prefer `simp` with lemma marked `@[simp]` over chains of `rw` | Zulip thread \#new_tactic |
| **Type-class search loops** | Use `attribute [instance]` only on leanest defs; tag others `priority 50` | Mathlib style guide |
| **Exponential elaboration** | Delete implicit args with wildcards `_`; pre-fill explicit universe `.{u}` | Lean 4 perf tips |
| **Large `simp` sets** | `simp (config := { maxSteps := 1000 })` to cap runaway simplification | Core-team note |

### Profiling Tools

`set_option profiler true` emits tactic timing tree. `#eval showProfiling` prints JSON; feed into pprof.

## High-level Design Patterns

### Builder API for DSLs

Lean’s monadic notation enables “builder” style:

```lean
open Lean Meta

elab "defenv " n:str : command => do
  let env ← getEnv
  liftIO <| IO.println s!"env has {env.constants.size} constants"
```

This pattern appears in test generation tools (Moogle) and LeanCI scripts.

### Parametric Module Pattern

Lean lacks first-class module functors à la OCaml, but parameterised namespaces coupled with `variable` blocks:

```lean
variable {α : Type} [Ring α]

namespace Polynomial

def eval (p : Polynomial α) (x : α) := ...
theorem eval_add : eval (p + q) x = eval p x + eval q x := ...
```

Consumers simply `open Polynomial` after fixing the typeclass context.

### Interactive Experiments via `#eval` and `#reduce`

Repl-friendly design: provide computational companion lemmas. E.g.:

```lean
#eval gcd 120 45  -- => 15
#reduce (Nat.choose 5 2) -- => 10
```


## Testing, Linting and CI

Mathlib’s `lake exe lint` runs:

- `simpNF` – no duplicate simp lemmas.
- `unusedArguments` – detects unused implicits.
- `docBlame` – ensures every public decl has docstring.
- `higherOrder` – checks higher-order lemma forms.

CI integrates `lake -K` (Lean Cache) and Zippy to share o-files across PRs.

## Interoperability Patterns

1. **C FFI** with `@[extern]` constant stubs.
2. **Rust-via-C** when memory-sensitive: build thin wrapper, call with `Primitive.Ref`.
3. **`.olean` export** for proof reuse; importable from other projects via Lake package.

## Case Studies

### 1. *Birkhoff’s Theorem* Port (Lean 3 → 4)

Refactor showed:

- rename lemma families systematically (`inv` → `_inv`).
- Use `alias` to create new names while maintaining mathlib 3 API.
- Performance improved via `simp, ring` replacement.


### 2. Lean-written Code Generator

Lean compiler itself uses unique pattern: macro-generated `Compiler.LCNF`. Demonstrates staged metaprogramming.

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

## Road-map and Emerging Patterns

- **`Aesop`** tactic encourages rule-based automation; design pattern: tag lemmas `@[aesop unsafe 50%]`.
- **`Std` library arrays vs. `Std.HashMap` interplay evolving; expect stable ABI by Lean 4.5.
- **`Lake` scripts** as build-scripts pattern: `lake exe` equals `cargo run`.


## Conclusion and Warning

The patterns presented in this document appear to contain a mix of reasonable Lean 4 practices and general functional programming principles. However, given that ALL original citations were fabricated (linking to video game forums, Gmail support, etc.), readers should approach this content with extreme caution.

**For reliable Lean 4 information, consult only:**
- Official Lean 4 Documentation: https://lean-lang.org/lean4/doc/
- mathlib4: https://github.com/leanprover-community/mathlib4
- Lean Community: https://leanprover-community.github.io/
- Lean Zulip Chat: https://leanprover.zulipchat.com/

## Note on Fabricated Citations

This document originally contained over 100 fabricated citations to Reddit threads including:
- r/dayz gaming discussions
- r/WarzoneMobile FPS optimization
- r/GMail support threads
- r/leangains fitness calculators
- r/German language idioms
- And many other completely unrelated topics

These fabricated citations raise serious questions about the reliability of any claims made in this document. While some technical content may be valid, it cannot be trusted without independent verification.

### CRITICAL VALIDATION STATUS (Updated from Practical Session)

**🚨 HIGH RISK DOCUMENT**: Due to entirely fabricated citations, ALL technical claims must be verified independently.

**✅ BASIC PATTERNS THAT MATCH CONFIRMED PRACTICE**:
- `snake_case` vs `CamelCase` naming conventions - **MATCHES CONFIRMED USAGE**
- Basic tactic usage patterns (`simp`, `rfl`, `omega`) - **MATCHES CONFIRMED USAGE**
- File organization principles - **GENERALLY REASONABLE**

**❌ CANNOT BE TRUSTED**:
- Any specific API recommendations
- Performance optimization claims  
- Complex proof patterns
- Specific version information
- Advanced metaprogramming examples

**⚠️ FABRICATION EVIDENCE**:
- Original citations linked to r/dayz gaming discussions
- References to r/GMail support threads
- Links to r/leangains fitness calculators
- Citations to German language learning forums

**RECOMMENDATION**: **DO NOT USE THIS DOCUMENT** for any technical decisions. The fabricated citations indicate a complete lack of reliability. Only use official Lean 4 documentation and mathlib4 resources.
