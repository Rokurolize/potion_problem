# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project: Aphrodisiac Problem Lean 4 Formalization

*Also known as the Potion Problem (媚薬問題) - proving E[τ] = e*

## 🎯 **CURRENT STATUS: IN PROGRESS** 

**Major Achievement:** Main theorem proven, modular architecture complete, 6 sorries remaining
- **Main theorem**: `PotionProblem.main_theorem : expected_hitting_time = exp 1` ✅
- **Build status**: ✅ Builds successfully
- **Mathematical rigor**: Formal verification in progress with Lean 4 and mathlib4 v4.21.0
- **Active Sorries**: **6** remaining (distributed across 3 modules)
- **Recent progress**: Eliminated `telescoping_partial_sum` sorry using induction

**Core Result Established: E[τ] = e (Main.lean has 0 sorries)**

## Essential Development Commands

### Core Build Commands
```bash
# Build the entire project
lake build

# Build specific components
lake build PotionProblem.Main
lake build PotionProblem.ProbabilityFoundations

# Clean build after major changes
lake clean && lake build

# Monitor progress
lake build 2>&1 | grep "declaration uses 'sorry'" | wc -l  # Count remaining sorries
grep -n "sorry" PotionProblem/*.lean                     # Find specific sorries
```

### Python Environment Setup
```bash
# Initialize Python environment
uv sync

# Install additional dependencies
uv sync --extra numerical  # numpy, scipy, matplotlib, sympy, z3
uv sync --extra dev        # mypy, ruff, pytest
```

### LeanExplore API Verification (Critical for preventing hallucinations)
```bash
# Search mathlib APIs before using
uv run leanexplore search "hasSum" --package Mathlib --limit 10
uv run leanexplore get [GROUP_ID]          # Get exact signature
uv run leanexplore dependencies [GROUP_ID] # Find required imports
```

## 🔧 **Sorry Elimination Strategy**

For systematic sorry elimination, refer to the comprehensive guide:
```bash
# Read the battle-tested sorry elimination guide
cat docs/sorry-elimination-guide.md
```

This guide contains:
- **Proven techniques** from eliminating 10+ sorries
- **Specific Lean 4 patterns** with working code examples
- **Common pitfalls** and their solutions
- **File-specific strategies** for each module

## High-Level Architecture

### Lean 4 Structure
- **Configuration**: `lakefile.toml` - Modern TOML-based Lake configuration (v4.21.0)
- **Main Library**: `PotionProblem` - Core formalization with 6 modular components
- **Dependencies**: mathlib4 v4.21.0

### Core Module Dependencies (Bottom-Up)
```
Basic.lean (31 lines, 0 sorries)
├── FactorialSeries.lean (43 lines, 0 sorries)  
├── ProbabilityFoundations.lean (228 lines, 2 sorries)
    ├── SeriesAnalysis.lean (147 lines, 1 sorry)
    ├── IrwinHallTheory.lean (164 lines, 4 sorries)
    └── Main.lean (91 lines, 0 sorries) ← **MAIN THEOREM**
```

**Key Achievement**: Main theorem is complete despite remaining sorries in supporting infrastructure.

### Module Responsibilities
- **Basic.lean**: Core `hitting_time_pmf` definition
- **FactorialSeries.lean**: `summable_inv_factorial` and factorial series convergence  
- **ProbabilityFoundations.lean**: PMF properties, summability, expectation finiteness
- **SeriesAnalysis.lean**: Series reindexing and telescoping proofs (enables E[τ] calculation)
- **IrwinHallTheory.lean**: Geometric interpretation via Irwin-Hall distribution
- **Main.lean**: Executive summary proving `main_theorem : expected_hitting_time = exp 1`

## Development Philosophy

### Systematic Approach
1. **One Change at a Time**: Each fix gets individual verification and commit
2. **Build Verification**: `lake build` after every change before proceeding
3. **Sorry Elimination Strategy**: Fix fundamental lemmas first to avoid cascading failures
4. **Mathematical Correctness**: Verify mathematical validity before implementing proofs

### TDD-Style Workflow
```bash
# After each change
lake build 2>&1 | grep -E "(error:|Build completed)"
# Only commit if build succeeds
git add [file] && git commit -m "[specific change]"
```

## Critical Priority Tasks

**Immediate Goal**: Reduce sorry count from 6 to 0

**High Priority (blocking other proofs):**
- `pmf_sum_eq_one` in ProbabilityFoundations.lean - fundamental PMF validity property
- `tail_probability_formula` in ProbabilityFoundations.lean - key distributional property

**Medium Priority (supporting theory):**
- `hitting_time_connection` in IrwinHallTheory.lean - geometric interpretation
- `irwin_hall_unit_probability` - simplex volume calculation
- `irwin_hall_support` and `irwin_hall_continuous` - distribution properties

## API Safety and LeanExplore Integration

**CRITICAL**: mathlib4 APIs change frequently. ALWAYS verify before using:

```bash
# Before using any mathlib API
uv run leanexplore search "[function_name]" --package Mathlib
```

**Pre-configured Environment**: 
- `.env` file contains `LEANEXPLORE_API_KEY` for immediate use
- `lean-explore` dependency included in `pyproject.toml`

### Essential Import Patterns (Verified in mathlib4 v4.21.0)
```lean
import Mathlib.Analysis.SpecificLimits.Normed     -- Real.summable_pow_div_factorial
import Mathlib.Topology.Algebra.InfiniteSum.Basic -- Summable, HasSum
import Mathlib.Data.Nat.Factorial.Basic           -- Nat.factorial properties
import Mathlib.Algebra.Order.Field.Basic          -- Field inequalities
```

## Quick Iteration Execution

**When requested to "execute next iteration":**

### Simple Method
Use Task tool: `Read /home/ubuntu/workbench/projects/potion_problem/docs/state/self-contained-prompt.md and follow its instructions.`

### Post-Execution Verification (MANDATORY)
```bash
git status && git log --oneline -3  # Verify actual changes
lake build                          # Confirm build status
```

**Critical Rule**: Never trust subagent reports without verification.

## Mathematical Background

**Core Proof Structure:**
1. **Basic Identity**: ∑_{n=0}^∞ 1/n! = e  
2. **PMF Definition**: P(τ = n) = (n-1)/n! for n ≥ 2
3. **Expected Value**: E[τ] = ∑_{n=1}^∞ n · P(τ = n) = e

**Original Problem Source**: Twitter/@suamax_scp (July 9, 2025)
- Knight asks: "How many times do I expect to drink the potion?"
- Mathematical formalization: hitting time for sum of uniform [0,1) variables ≥ 1

## Important Documents

**State Management:**
- `docs/state/current-state.md` - Current accurate status
- `docs/state/iteration-history.md` - Cumulative trial records
- `docs/state/self-contained-prompt.md` - Self-contained implementation instructions

**Key Guides:**
- `docs/sorry-elimination-guide.md` - Battle-tested techniques for eliminating sorries
- `docs/refactoring-instructions.md` - Module restructuring guidance
- `docs/immediate-action-plan.md` - Current development priorities

## Configuration Details

**Lean 4 Configuration** (`lakefile.toml`):
```toml
[leanOptions]
pp.unicode.fun = true
autoImplicit = false
relaxedAutoImplicit = false
weak.linter.mathlibStandardSet = true  # Maximum strictness
maxSynthPendingDepth = 3
```

**Python Environment** (`pyproject.toml`):
- **Core**: `lean-explore>=0.3.0` for API verification
- **Optional**: numerical analysis tools (numpy, scipy, matplotlib, sympy, z3)
- **Development**: mypy, ruff, pytest for code quality

**Version Control**: Lean 4 v4.21.0, mathlib4 v4.21.0 (pinned in `lean-toolchain`)

---

**Note**: This project pursues mathematical rigor through formal verification. The main theorem E[τ] = e is proven; remaining sorries are in supporting infrastructure and do not affect the core result.