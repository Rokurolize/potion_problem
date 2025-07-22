# Research Prompt: Comprehensive Lean 4 CLI Cheat Sheet Completion

## Current Knowledge Disclosure

I am creating a comprehensive Lean 4 cheat sheet for CLI environments and need external expertise to supplement my current knowledge. Here is everything I currently know:

## Development Environment

- **Lean 4 version**: v4.21.0
- **mathlib4 version**: v4.21.0  
- **Operating System**: Linux (WSL2 on Windows)
- **Interface**: Pure CLI environment (NO VS Code, NO editor integration)
- **Build System**: Lake with lakefile.toml format
- **Context**: Working on formal mathematics (probability theory, infinite series)

## My Current Lean 4 Knowledge

### Basic Tactics I Know
```lean
-- Interactive discovery
exact?        -- Find exact proof from context
apply?        -- Find applicable lemmas  
rw?          -- Suggest rewrite rules
simp?        -- Show applicable simp lemmas

-- Context exploration
#check name   -- Show type of definition/theorem
#find pattern -- Search for lemmas by pattern

-- Algebraic manipulation
simp [lemma1, lemma2]    -- Simplify with specific lemmas
ring                     -- Ring arithmetic
field_simp               -- Field operations and fractions
norm_num                 -- Numerical computations
linarith                 -- Linear arithmetic reasoning

-- Structural proof building
calc                     -- Step-by-step equational proofs  
gcongr                   -- Monotonicity reasoning
have h : P := by tactic  -- Intermediate results
cases                    -- Case analysis
induction                -- Mathematical induction
```

### mathlib4 API Knowledge
```lean
-- Series convergence (what I know)
HasSum f s               -- f sums to s
Summable f               -- f is summable
tsum f                   -- The sum of f (if summable)
Summable.hasSum          -- Convert summable to HasSum
hasSum_iff_tendsto_nat   -- HasSum via limit of partial sums

-- Factorial properties (what I know)
Nat.factorial_pos        -- n! > 0
factorial_le_pow         -- Some growth bounds

-- Filter theory (basic understanding)
Filter.Eventually        -- ∀ᶠ notation  
atTop                    -- Filter at infinity
eventually_of_forall     -- Convert universal to eventual

-- Key modules I know
import Mathlib.Analysis.SpecificLimits.Normed     -- factorial/exponential
import Mathlib.Topology.Algebra.InfiniteSum.Basic -- HasSum, Summable
import Mathlib.Data.Nat.Factorial.Basic           -- factorial properties
import Mathlib.Algebra.Order.Field.Basic          -- field inequalities
import Mathlib.Algebra.BigOperators.Basic         -- finite sums
```

### Specific Proof Patterns I've Learned
```lean
-- Telescoping series pattern
HasSum (fun k => a k - a (k+1)) (a 0 - lim atTop a)

-- Eventually pattern for growth
∀ᶠ n in atTop, condition n  -- eventually true for large n

-- Geometric convergence pattern  
∃ c r, 0 < c ∧ 0 < r ∧ r < 1 ∧ ∀ᶠ n, f n ≤ c * r^n
```

### Debugging Strategies I Know
```lean
-- Temporary completion to check structure
sorry  -- Complete goal temporarily

-- Incremental proof building
have step1 : P := by sorry
have step2 : Q := by sorry
exact final_step step1 step2
```

## What I Need to Learn

### 1. CLI-Specific Workflow Optimization

**Question**: What are the most effective workflows for Lean 4 development in pure CLI environments?

- How to efficiently debug proofs without editor integration?
- Best practices for navigating large proofs in terminal?
- Command-line tools and flags that aid development?
- How to effectively use `lake` commands beyond basic `lake build`?

### 2. Advanced Tactic Combinations

**Question**: What advanced tactic combinations and proof strategies am I missing?

- Sophisticated uses of `calc` with multiple intermediate steps?
- Advanced `simp` configuration and custom simp sets?
- Effective use of `conv` mode for targeted rewriting?
- Meta-programming tactics that could speed up proof development?

### 3. mathlib4 v4.21.0 Hidden Features

**Question**: What powerful but less obvious mathlib4 features could accelerate proof completion?

- Advanced series convergence lemmas I don't know about?
- Factorial/exponential growth bounds beyond what I've listed?
- Filter theory applications I haven't discovered?
- Shortcuts for common mathematical patterns?

### 4. Performance and Error Diagnosis

**Question**: How can I optimize Lean 4 performance and diagnose issues more effectively?

- Techniques for resolving timeout errors in complex proofs?
- Memory optimization strategies?
- How to interpret and act on cryptic Lean 4 error messages?
- Debugging techniques when tactics fail silently?

### 5. Proof Architecture Best Practices

**Question**: What are the modern best practices for structuring complex mathematical proofs?

- How to effectively break down large theorems?
- When to use `lemma` vs `theorem` vs `def`?
- Optimal proof term construction strategies?
- How to write maintainable and readable formal proofs?

## Specific Project Context

I'm working on completing these 3 remaining `sorry` declarations:

1. **Telescoping series equality**: `HasSum (fun k => 1/(k+1)! - 1/(k+2)!) 1`
2. **Factorial growth dominance**: `∀ᶠ n in atTop, n.factorial > (2 : ℝ)^n`  
3. **Geometric convergence bound**: `∃ c r, conditions ∧ ∀ᶠ n, 1/n! ≤ c * r^n`

Each requires sophisticated mathlib4 API usage that may involve techniques I haven't discovered.

## Specific Questions

1. **CLI Debugging**: What command-line techniques exist for step-by-step proof debugging when stuck?

2. **Advanced API**: What mathlib4 lemmas and tactics could directly solve or simplify these three proof obligations?

3. **Error Recovery**: What strategies work best when Lean 4 gives unhelpful error messages in CLI environments?

4. **Proof Efficiency**: How can I write proofs that are both mathematically correct and computationally efficient?

5. **Discovery Tools**: Beyond `#check` and `#find`, what tools help discover relevant lemmas and tactics?

## Expected Output

Please provide a comprehensive Lean 4 CLI cheat sheet that includes:

- Advanced tactics and combinations I haven't mentioned
- Hidden mathlib4 features and shortcuts
- CLI-specific debugging and development workflows  
- Performance optimization techniques
- Error diagnosis and recovery strategies
- Specific solutions or approaches for the three remaining proof obligations

Focus on practical, immediately actionable advice for someone working in a pure CLI environment on advanced mathematical formalization.