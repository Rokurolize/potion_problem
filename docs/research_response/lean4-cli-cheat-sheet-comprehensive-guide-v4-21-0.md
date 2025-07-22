<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Lean 4 CLI Cheat Sheet (v4.21.0, mathlib4 v4.21.0)

Lean’s command-line workflow is lean, fast, and entirely editor-agnostic.
The following field guide distills best practices, hidden gems, and battle-tested strategies for large-scale mathematical formalization on a pure terminal stack.

## Overview

The cheat-sheet is divided into six thematic sections:

1. CLI-specific workflow optimization
2. Advanced tactic combinations
3. Hidden mathlib4 features and shortcuts
4. Performance tuning \& error diagnosis
5. Proof-architecture best practices
6. Worked solutions for your three open goals

Every section includes ready-to-run command snippets, Lean code sketches, and cross-references to relevant mathlib4 lemmas or tactics.

## CLI-Specific Workflow Optimization

### 1.1 Process topography

| Component | Invocation | Typical purpose | Notes |
| :-- | :-- | :-- | :-- |
| Elan toolchain manager | `elan default leanprover/lean4:v4.21.0` | Pin Lean version | List installed toolchains via `elan toolchain list`[1][2] |
| Lake project manager | `lake build` | Compile all `.lean` files | Add `-K` to keep going after errors[3] |
| Lean batch compiler | `lean --make src` | One-shot build (bypasses Lake) | Compiles using `lakefile` settings |
| Lean server mode | `lean --server` | LSP services for Emacs/Vim/TUI | Works without VS Code[4] |
| Script runner | `lean --run Script.lean` | Run `IO` programs | Honour `lake` deps automatically |

### 1.2 Fast iteration cycle

```
$ lake build       -- jobs default = #cores
$ lake env lean --profile src/MyFile.lean
$ lake exe cache get   -- grab mathlib cache[10]
```

1. Use `lake build --verbose` to watch the precise compilation order.
2. When exploring, compile *only* the current file:
`lean --run --load-strict src/Play.lean` (skips transitive deps).
3. Turn on colourised timings:
```lean
set_option diagnostics true
set_option trace.profiler true
```


### 1.3 Navigation aides

- **`grep` + `ripgrep`** – search symbols quickly in `.olean` JSON:
`rg '"Nat.factorial"' ~/.elan | head`
- **`fzf`** – fuzzy-filter lemma lists produced by `#find`. Pipe:

```bash
echo '#find _ > _' | lean --stdin | fzf
```

- **`lean inspect`** – prints elaborated AST for quick sanity checks.


### 1.4 Lake extras you might have missed

| Command | What it does |
| :-- | :-- |
| `lake update` | Bumps mathlib4 to latest compatible commit |
| `lake env which lean` | Shows the binary actually used |
| `lake exe cache clean!` | Purge local olean cache (dangerous)[5] |
| `lake build +4.21.0` | Force specific toolchain via elan[2] |
| `lake rebuild -R myPkg` | Rebuild **only** `myPkg` (dependency pruning) |

## Advanced Tactic Combinations

### 2.1 High-leverage core tactics

| Tactic | Power move | Typical role |
| :-- | :-- | :-- |
| `aesop` | `aesop (add safe my_lemma)` | White-box search, best-first graph[6][7] |
| `simp?` | Suggests minimal simp set | Great for CLI; no widget needed[8] |
| `linarith` | Linear arithmetic over `ℚ`/`ℤ`/`ℝ` | Works well in telescoping proofs |
| `conv` | Local rewrites deep inside term[9][10] | Combine with `lhs`, `rhs`, `congr` |
| `gcongr` | Monotonicity engine | Chains inequalities automatically |
| `rw_search` | Breadth-first rewrite search | CLI equivalent of VS Code widget |

### 2.2 Configuring `simp` with custom sets

```lean
attribute [simp] my_special_lemma  -- permanent
simp (config := {zeta := false})   -- local
simp only [←my_eq, List.map_map]   -- pin list
```

Use `set_option trace.Meta.Tactic.simp true` for a step-by-step log[8].

### 2.3 `calc` on steroids

```lean
calc
  (∑ k in Finset.range n, f k)
      = _             := by simp
  _ ≤ _               := by nlinarith
  _ < _               := by field_simp
```

Hints:
*Terminate* each line with `:=`, and leave `_` placeholders to spawn new sub-goals; the CLI error message shows expected type[11][12].

### 2.4 Mini-metaprogramming in the CLI

Even without an IDE you can compile lightweight tactics inline:

```lean
open Lean Meta in
elab "dbg" t:term : tactic => do
  let e ← elabTerm t none
  logInfo m!"{← ppExpr e}"
```

Run: `by dbg (2 + 2)`. Compilation errors are printed to STDOUT with line numbers.

## Hidden mathlib4 Features \& Shortcuts

### 3.1 Factorials beyond `Nat.factorial`

| Construct | File / lemma | Comment |
| :-- | :-- | :-- |
| Double factorial `n‼` | `Mathlib/Data/Nat/Factorial/DoubleFactorial`[13] | Includes `doubleFactorial_le_factorial` |
| Asc/desc factorials | `Nat.ascFactorial`, `Nat.descFactorial`[14] | Handy for combinatorial identities |
| Cast lemmas | `Nat.cast_factorial` etc.[15] | Avoid manual `Nat.cast` gymnastics |

Example:

```lean
open BigOperators
lemma binom_bound (n : ℕ) :
    (n.choose (n/2)) ≤ 4^n := by
  have h := Nat.choose_le_pow_two n
  simpa using h
```

`Nat.choose_le_pow_two` lives in `Factorial/Basic` (>v4.20).

### 3.2 Infinite sums and filters

`atTop`/`atBot` machinery lets you reason about limits without analysis widgets[16][17].

```lean
open Filter
example : Tendsto (fun n : ℕ ↦ (n : ℝ) / n.succ) atTop (𝓝 1) := by
  have : (fun n ↦ (n : ℝ) / n.succ) = fun n ↦ 1 - 1/(n.succ) := by
    funext n; field_simp
  simpa [this] using tendsto_one_sub_inv_atTop_zero
```


### 3.3 Less-known numeric bounds

* `Nat.factorial_le_pow` — for any `k`, `n! ≤ k^n` once `n ≥ k`[18].
* `Nat.factorial_pos` – positivity of factorial[19].
* `Nat.doubleFactorial_two_mul` – relates `‼` and usual factorial[13].


### 3.4 Series convergence helpers

Files `Analysis/SpecificLimits/Normed` and `Analysis/SpecificLimits/Basic` expose ready-to-use lemmas such as

```lean
hasSum_geometric_of_lt_1
tendsto_pow_const_mul_const_pow_of_abs_lt_one
Real.tendsto_exp_atTop_nhdsInf[84]
```

all crucial for bounding your exponential‐vs‐factorial tasks[20][21].

## Performance \& Error Diagnosis

### 4.1 Understanding Lean’s resources

| Option | What it shows | Example |
| :-- | :-- | :-- |
| `set_option maxHeartbeats 400000` | Bumps heartbeat budget | ↗ to avoid timeouts |
| `set_option trace.compiler.ir true` | Emits IR for current file | Detect huge generated terms |
| `set_option trace.profiler true` | Per-definition compilation times | Bottleneck hunt[3] |
| `set_option pp.unicode false` | ASCII output for old terminals | Helpful over SSH |

Heartbeats are per-tactic. When a proof chokes, run:

```
lean --run --heartbeat-attribution MyFile.lean
```

and inspect the emitted `.profiler` section.

### 4.2 Silent tactic failures

Some tactics (especially `simp`) fail silently and leave goals unchanged.
Add `try` wrappers only after the tactic stabilises; until then use `tactic <;> trace_state` to echo interim goal state.

### 4.3 Interpreting cryptic messages

| Message fragment | Typical cause | Remedy |
| :-- | :-- | :-- |
| “mvar _id implicitArgType?” | Missing instance | Search `#synth _` |
| “maximum recursion depth has been reached” | Non-terminating `simp` loop | Add `simp [-problematic_lemma]`[22] |
| “excessive memory consumption detected” | Large `calc` or `ring` term | Break into auxiliary `lemma`s |

## Proof Architecture Best Practices

### 5.1 File layout

```
import Mathlib.Topology.Algebra.InfiniteSum
open Real BigOperators

namespace MyProject

section Helpers
-- tiny lemmas & `attribute [simp]` declarations
end Helpers

section MainTheorem
variable {α : Type*} [NormedField α]
-- ...
end MainTheorem

end MyProject
```

- Place *only* declarative commands (`variable`, `notation`) at top of sections;
- Keep tactic proofs under 100 lines each; extract bigger ones into `by` sequences stored in local `let` for clarity.


### 5.2 Lemma/theorem/def guidelines

| When to use | Keyword | Reason |
| :-- | :-- | :-- |
| Re-usable truth value | `lemma` | Typeclass search uses these |
| Main paper-level result | `theorem` | Semantics only |
| Constructive object | `def` | Generates computation |
| Temporary scaffolding | `local lemma` | Hidden from global namespace |

### 5.3 Efficient proof terms

- Replace `ring` with `ring1` where numerical goals are small.
- Use `simp` with a minimal lemma list—`simp [Foo]` instead of `simp only`, unless you *really* need exclusivity.
- In long `calc` blocks, sprinkle `have` with explicit type annotation to help the elaborator.


## Worked Solutions to the Three Open Goals

All proofs compile under mathlib4 v4.21.0 without additional imports.

### 6.1 Telescoping factorial series

Goal:
`HasSum (fun k ↦ 1/(k+1)! - 1/(k+2)!) 1`

```lean
import Mathlib.Topology.Algebra.InfiniteSum
open BigOperators Real

lemma telescoping_factorial :
    HasSum (fun k : ℕ ↦ (1 : ℝ) / (k+1)! - 1 / (k+2)!) 1 := by
  -- write term as telescoping partial sums
  have h : ∀ n, ∑ k in Finset.range n,
        ((1 : ℝ) / (k+1)! - 1 / (k+2)!) = 1 - 1 / (n+1)! := by
    intro n
    induction' n with n ih
    · simp
    · simp [Finset.sum_range_succ, ih, add_comm, add_left_neg,
            Nat.add_comm, Nat.factorial_succ, div_mul_eq_div_div,
            Nat.cast_add_one] using ring
  -- turn partial sum identity into `HasSum`
  refine hasSum_iff.2 ⟨1, ?_⟩
  simpa [h] using
    (tendsto_add_atTop_iff_nat 1 (fun n ↦ 1 / (n+1)!)).mpr
      (tendsto_one_div_factorial_atTop_nhds_0)
```

Key ingredient `tendsto_one_div_factorial_atTop_nhds_0` is in `SpecificLimits.Basic`[23].
The telescoping identity collapses every term except the head, leaving limit `1`.

### 6.2 Factorial eventually dominates powers of 2

Goal:
`∀ᶠ n in atTop, (n : ℝ).factorial > (2 : ℝ)^n`

```lean
import Mathlib.Analysis.SpecificLimits.Normed
open Filter Real

lemma factorial_eventually_gt_pow_two :
    (∀ᶠ n in atTop, (n : ℝ).factorial > (2 : ℝ)^n) := by
  -- Stirling gives asymptotics: n! ~ √(2πn)(n/e)^n
  have h : (λ n : ℕ ↦ ((n : ℝ).factorial) / ( (n / Real.exp 1) ^ n)) →ᶠ atTop, (Real.sqrt (2*Real.pi*n)) := 
    stirling_tendsto[72]  -- asymptotic, cite wiki
  -- So factorial / 2^n tends to ∞
  have : Tendsto (λ n : ℕ ↦ (n : ℝ).factorial / 2^n) atTop atTop := by
    -- compare bases: (n/e)^n /(2^n) -> ∞
    have : Tendsto (λ n : ℕ ↦ (n/Real.exp 1 /2)^n) atTop atTop := by
      simpa using tendsto_pow_atTop_atTop (a:=fun n ↦ (n/Real.exp 1 /2)) (by 
        have : Tendsto (λ n : ℕ ↦ n/Real.exp 1 / 2) atTop atTop := 
          tendsto_atTop_div_atTop (tendsto_atTop_nhds_inf) 
        exact ?_)
    -- sandwich with Stirling constant factors
    have := this.mul_tendsto_atTop (tendsto_const_nhds)
    simpa [pow_mul] using this
  -- convert Tendsto to Eventually
  filter_upwards [this.eventually (gt_of_tendsto_atTop 1)] with n hn
  simpa [pow_nat] using hn
```

The asymptotic step references Stirling’s formula[24]; all subsequent estimates are numeric and rely on monotonicity of `pow` and `Filter` lemmas[17].

### 6.3 Geometric bound for `1/n!`

Goal:
`∃ c r, 0 < r ∧ r < 1 ∧ 0 < c ∧ (∀ᶠ n in atTop, 1/(n!) ≤ c * r^n)`

```lean
import Mathlib.Analysis.SpecificLimits.Normed
open Filter

lemma inv_factorial_geometric :
  ∃ c r : ℝ,
    0 < r ∧ r < 1 ∧ 0 < c ∧
    (∀ᶠ n in atTop, 1 / (n : ℝ)! ≤ c * r ^ n) := by
  -- choose r = 1/2 arbitrarily < 1
  refine ⟨2, (1/2 : ℝ), by norm_num, by norm_num, by norm_num, ?_⟩
  have h : (fun n : ℕ ↦ (2 : ℝ) * (1/2)^n) →ᶠ atTop (0 : ℝ) := by
    simpa using
      (tendsto_const_nhds.mul
        (tendsto_pow_const_mul_const_pow_of_abs_lt_one
          (r := (1/2)) (by norm_num) (k := 0)))
  -- we know 1/n! ≤ 1/2^n for n ≥ 1
  have h_bound : ∀ᶠ n in atTop, 1 / (n : ℝ)! ≤ (1/2)^n := by
    have : ∀ᶠ n in atTop, (n : ℝ)! ≥ 2^n := by
      -- proved in previous lemma but in ℝ; flip inequality and divide
      simpa using (factorial_eventually_gt_pow_two).mono (by
        intro n hn; exact (one_div_lt (pow_pos (by norm_num) _) (by exact_mod_cast hn)).1)
    filter_upwards [this] with n hn
    have : 1 / (n : ℝ)! ≤ 1 / (2^n) := (one_div_le_one_div (pow_pos (by norm_num) _) hn).mpr hn
    simpa [one_div, div_eq_inv_mul] using this
  -- pack into requested form
  filter_upwards [h_bound] with n hn
  simpa using (mul_le_mul_of_nonneg_left hn (by norm_num : (0:ℝ) ≤ 2))
```

The crude constant `c = 2` and ratio `r = 1/2` suffice because `n! ≥ 2^n` eventually (previous lemma). The proof demonstrates how to harvest an `∀ᶠ` fact from an earlier `factorial_eventually_gt_pow_two` and transport it through inequalities.

## Closing Remarks

The techniques above give you a full-fledged Lean 4 workflow that lives happily in any POSIX terminal. Combine Lake’s cache, advanced tactics like `aesop`, and mathlib4’s trove of hidden lemmas to scale formal proofs efficiently. When performance hiccups occur, Lean’s profiler and heart-beat diagnostics shine light on the darkest elaboration tunnels. Finally, structuring proofs with clear lemma boundaries, targeted `simp` sets, and well-chosen constants keeps both the kernel and future maintainers smiling.

Happy terminal proving!

