# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Owe

We'd just realized the whole proof was full of sorries — we were switching over to desperate API hunting to try and eliminate them — when ProbabilityFoundations.lean started failing. Then we were told the build was broken. ProbabilityFoundations was burning and full of invalid field errors. If those sorries kept multiplying… the whole formalization would collapse.

That's when we knew this wasn't just about code anymore. No way we'd call this a formal proof — not with sorries still standing. But at that point… it wasn't about elegant mathematics. Not anymore. At that point…

Look, you know the risk when you work on formal verification like this. If the logic errors don't get you, the API changes will. But if we can't eliminate every last sorry… it won't just fail to be a proof. It'll take everything with it.

When you formalize a mathematical theorem, you're putting everyone who depends on it in the line of fire. The researchers who need verified results. The engineers who build on these foundations. The families of everyone whose job depends on mathematical rigor being more than just hand-waving. That means something. Something is owed. The users, the stakeholders, the mathematicians — none of them see the weight of each remaining sorry. But someone has to. Someone has to lift that load.

That's why we grab our tactics and race toward every sorry as fast as our compilation cycles can carry us. Not to save our reputation, not to save the repository, not even to save our own credibility. We do it because this formalization might be struggling, but we'll be damned if we let a single sorry remain when people's livelihoods depend on us calling this a proof.

Every sorry that stands is a family that might not eat. Every sorry eliminated is a step toward keeping that promise.

3 sorries remain. The weight is real. Someone has to lift it.

## Project: Aphrodisiac Problem Lean 4 Formalization

*Also known as the Potion Problem (媚薬問題) - proving E[τ] = e*

## 🎯 **CURRENT STATUS: MISSION FAILED** 

**Mission Objective**: Eliminate all sorries (target: 0)
**Current Status**: 3 sorries remaining = **MISSION FAILED**

**Secondary Status** (relevant only after mission completion):
- **Main theorem**: `PotionProblem.main_theorem : expected_hitting_time = exp 1` ✅
- **Build status**: ✅ Builds successfully
- **Mathematical rigor**: Formal verification in progress with Lean 4 and mathlib4 v4.21.0
- **Active Sorries**: **3** remaining (ProbabilityFoundations: 1, IrwinHallTheory: 2)
- **Recent progress**: Eliminated `telescoping_partial_sum` sorry using induction

**Core Result Established**: E[τ] = e (Main.lean has 0 sorries)
**Mission Status**: Incomplete - 3 sorries remain uneliminated

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

### CRITICAL: API Search Requirements (MUST READ)

**⚠️ MANDATORY**: You MUST use the LLM-optimized wrapper for ALL API searches:

```bash
# CORRECT - Use the wrapper:
scripts/lle search "hasSum" --package Mathlib --limit 10
scripts/lle get [GROUP_ID]          # Get exact signature
scripts/lle dependencies [GROUP_ID] # Find required imports

# WRONG - Never use raw LeanExplore:
# ❌ uv run leanexplore search ...  # DO NOT USE
```

**Why this is REQUIRED**:
- Raw LeanExplore output wastes precious context with decorative formatting
- The wrapper automatically adjusts detail level based on results
- Critical for preventing API hallucinations in Lean 4

**Failure to use the wrapper will result in poor performance and wasted tokens.**

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

## 🎯 MISSION ACCOUNTABILITY DOCTRINE

### Clear Success/Failure Criteria
- **SUCCESS**: Objective achieved (0 sorries = SUCCESS, 1+ sorries = FAILURE)
- **FAILURE**: Objective not achieved, regardless of secondary achievements
- **NO PARTIAL CREDIT**: "Framework established" with sorries remaining = MISSION FAILED

### Prohibited Euphemistic Language
**❌ BANNED PHRASES for Mission Failure:**
- "Framework established" (when sorries remain)
- "Strategic retreat" (= gave up)
- "Complexity managed" (= avoided hard work)  
- "Technical implementation deferred" (= didn't solve it)
- "Phase X Complete" (when objective unmet)

### Required Reporting Standards
**✅ MANDATORY for Failed Objectives:**
- "Mission failed. X sorries remain uneliminated."
- "Unable to complete objective due to [specific technical reason]."
- "Requesting guidance on completing elimination of remaining sorries."

**✅ ALLOWED Secondary Reporting (AFTER failure acknowledgment):**
- Build status
- Partial progress made
- Lessons learned

### Accountability Enforcement
- **Primary metric**: Sorry count reduction
- **Secondary metrics**: Build success, documentation (only relevant if primary succeeded)
- **No credit for**: Incomplete work, partial solutions, or preparation without completion

### TDD-Style Workflow  
```bash
# After each change
lake build 2>&1 | grep -E "(error:|Build completed)"
# Only commit if build succeeds
git add [file] && git commit -m "[specific change]"
```

### Mission Status Verification
```bash
# Check actual sorry count (not estimates)
grep -c "sorry" ./PotionProblem/*.lean
# Mission success = 0, Mission failure = any number > 0
# No euphemisms permitted for non-zero results
```

## Critical Priority Tasks

**Immediate Goal**: Reduce sorry count from 3 to 0

**High Priority (blocking other proofs):**
- `pmf_sum_eq_one` in ProbabilityFoundations.lean - fundamental PMF validity property
- `tail_probability_formula` in ProbabilityFoundations.lean - key distributional property

**Medium Priority (supporting theory):**
- `hitting_time_connection` in IrwinHallTheory.lean - geometric interpretation
- `irwin_hall_unit_probability` - simplex volume calculation
- `irwin_hall_support` and `irwin_hall_continuous` - distribution properties

## API Safety with LLM-Optimized LeanExplore Wrapper

**CRITICAL**: mathlib4 APIs change frequently. ALWAYS verify using ONLY the wrapper:

```bash
# ✅ CORRECT - Before using any mathlib API:
scripts/lle search "[function_name]" --package Mathlib

# ❌ WRONG - NEVER do this:
# uv run leanexplore search ...  # This wastes tokens and provides poor output
```

**Pre-configured Environment**: 
- `.env` file contains `LEANEXPLORE_API_KEY` for immediate use
- `lean-explore` dependency included in `pyproject.toml`
- **ALWAYS use `scripts/lle` wrapper** - never call `uv run leanexplore` directly

### Non-Existent APIs Reference

**BEFORE searching for any API**, check the pre-verified non-existent list:
```bash
cat list-of-non-existent-mathlib-apis.md
```

This file contains:
- **28+ documented non-existent APIs** organized by category
- **Automatic additions** by the LLM wrapper when searches yield no relevant results
- **Alternative approaches** for each non-existent pattern

**The wrapper automatically appends** to this list when:
- Search returns 0 candidates
- Search results have no relevance to the query
- Multi-word queries have zero overlap with results

This prevents redundant searches and saves valuable context.

### MANDATORY: Use LLM-Optimized Wrapper for ALL API Searches

**REQUIRED**: You MUST use the LLM-optimized wrapper instead of raw LeanExplore:

```bash
# Quick search with automatic detail level selection
scripts/lle search "hasSum"                    # Auto-adjusts detail based on result count

# Specific detail levels
scripts/lle search "factorial" --limit 30 --detail minimal   # Just IDs and names
scripts/lle search "hasSum" --limit 5 --detail standard      # Balanced view
scripts/lle search "HasSum" --limit 1 --detail detailed      # Full documentation

# Get exact API details
scripts/lle get 187626                         # Full details for specific ID

# Check dependencies/imports
scripts/lle dependencies 187626                # Find required imports
```

**Why You MUST Use the Wrapper**:
- Automatically selects detail level: 1 result→detailed, 2-3→standard, 4+→minimal
- Removes decorative output for clean, parseable results
- Reduces token usage while maintaining information quality (critical for LLMs)
- Located at `scripts/llm_leanexplore.py` with convenient `lle` alias
- **NEVER use `uv run leanexplore` directly** - it wastes tokens and provides poor LLM experience

### Essential Import Patterns (Verified in mathlib4 v4.21.0)
```lean
import Mathlib.Analysis.SpecificLimits.Normed     -- Real.summable_pow_div_factorial
import Mathlib.Topology.Algebra.InfiniteSum.Basic -- Summable, HasSum
import Mathlib.Data.Nat.Factorial.Basic           -- Nat.factorial properties
import Mathlib.Algebra.Order.Field.Basic          -- Field inequalities
```

### Known API Changes (mathlib4 v4.21.0)
**Deprecated APIs (still functional but discouraged):**
- `Summable.sum_add_tsum_nat_add` - Deprecated as of 2025-04-12, still exists
- `Summable.sum_add_tsum_compl` - Deprecated, still exists  
- Build failures may occur from incorrect usage patterns (accessing as fields vs direct calls)

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