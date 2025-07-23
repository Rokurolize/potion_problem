# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project: Aphrodisiac Problem Lean 4 Formalization

*Also known as the Potion Problem (媚薬問題)*

## Essential Development Commands

```bash
# Build the Lean 4 project (using lakefile.toml)
lake build

# Build and save output to file for analysis
lake build > build_output.txt 2>&1

# Clean build (useful after major changes)
lake clean && lake build

# Run Python numerical verification
uv sync
uv run python test_all.py

# Check all warnings to track style fixing progress
lake build 2>&1 | grep -E "(warning:|error:)" | grep -v "Build completed" > current_warnings.txt

# Check only sorry warnings
lake build 2>&1 | grep "declaration uses 'sorry'" > current_sorries.txt

# Check style/linter warnings
lake build 2>&1 | grep -E "(warning:|error:)" | wc -l

# Verify git status and recent changes
git status
git log --oneline -5
git diff HEAD~1

# Run specific Lean tests
lake build test_basic
lake build test_minimal
lake build test_summability

# Python analysis tools
uv run python python/simulation/montecarlo_simulation.py
uv run python python/theoretical/exact_expectation_proof.py
```

## 🚀 Quick Iteration Execution

**When requested to "execute next iteration", follow these steps:**

### 1. Immediate Execution Command
Use the Task tool with the following prompt:

### 2. Execution Prompt

**Simple execution method:**
```
Read `/home/ubuntu/workbench/projects/potion_problem/docs/state/self-contained-prompt.md` and follow its instructions.
```

### 3. Technical Execution Method

**Task tool usage:**
1. Call Task tool with description: "Execute Lean 4 implementation task"
2. Use prompt parameter: `Execute the self-contained prompt from /home/ubuntu/workbench/projects/potion_problem/docs/state/self-contained-prompt.md by reading the file and following its instructions.`

**Verified**: Task tool can directly read files and execute instructions.

### 4. MANDATORY: Post-Execution Verification

**After Task agent completes, ALWAYS verify actual results:**

```bash
# Check what actually changed
git status
git log --oneline -3
git diff HEAD~1

# Verify build status
lake build
```

**Critical Rule**: Never trust subagent reports without verification. Check:
- ✅ Actual commits made
- ✅ Files actually changed
- ✅ Build status confirmed
- ✅ Mathematical progress validated

**Documentation**: Update iteration-history.md with verified results only.

---

## High-Level Architecture

### Lean 4 Structure
- **Configuration**: `lakefile.toml` - Modern TOML-based Lake configuration (migrated from lakefile.lean)
- **Main Library**: `UniformHittingTime` - Core formalization of the problem
- **Dependencies**: mathlib4 v4.21.0 - Provides mathematical foundations
- **Key Files**:
  - `UniformHittingTime/UniformSumHittingTime.lean` - Main theorem and supporting lemmas
  - `UniformHittingTime/TelescopingSeriesFixed.lean` - Telescoping series proof components
  - `UniformHittingTime/FactorialSeries.lean` - Factorial series convergence results
- **Python Verification**: `test_all.py` - Numerical validation supporting formal proofs
- **Implementation Variants**: Multiple approaches (Working, Minimal, Complete) for different proof strategies
- **Test Files**: `test_*.lean` files for various verification approaches

### Implementation File Variants
The project contains multiple implementation approaches with different complexity levels:

**Main Implementation Files:**
- `UniformSumHittingTime.lean` - Primary implementation with the main theorem
- `TelescopingSeriesFixed.lean` - Telescoping series components (contains 1 sorry)
- `FactorialSeries.lean` - Factorial series convergence proofs
- `IrwinHall.lean` - Irwin-Hall distribution properties

**Variant Implementations:**
- `*Working*.lean` files - Experimental approaches and work-in-progress proofs
- `*Minimal.lean` files - Simplified versions focusing on core concepts
- `*Complete.lean` files - More comprehensive implementations
- `HittingTime*.lean` files - Different formulations of the hitting time problem

**Test Files:**
- `test_basic.lean` - Basic functionality tests
- `test_minimal.lean` - Tests for minimal implementations
- `test_summability.lean` - Series summability verification
- `test_working.lean` - Tests for experimental approaches

### Current Proof Status
- **Style Warnings**: @current_warnings.txt
- **Remaining Sorries**: @current_sorries.txt
- **Build**: Succeeds with warnings
- **Main Theorem**: `uniform_sum_hitting_time_expectation : expected_hitting_time = rexp 1`
- **Linting**: Maximum strictness enabled (`weak.linter.mathlibStandardSet = true`, `linter.all = true`)
- **Current Priority**: Achieve zero style warnings before proceeding with mathematical proofs

### Research Documentation System
- **Research Prompts**: `docs/research_prompts/` - Sequential numbered prompts for external AI research
- **Research Responses**: `docs/research_response/` - Results from external research
- **State Management**: `docs/state/` - Current status and iteration history

### Automation System
- **Location**: `.claude/hooks/auto_iteration_continuation.py`
- **Status**: Currently **DISABLED** (`HOOK_ENABLED = False`)
- **Purpose**: Automatically continues iterations while proof obligations remain
- **Features**: Build verification, infinite loop prevention, strategic guidance
- **Control**: Set `HOOK_ENABLED = True` to enable automatic continuation

### Python Verification Ecosystem
The project includes comprehensive Python tools for numerical validation:

**Directory Structure:**
- `python/simulation/` - Monte Carlo simulations and analytical solutions
- `python/theoretical/` - Exact mathematical proofs and Irwin-Hall distribution analysis
- `python/proof_assistants/` - Z3 theorem prover demonstration

**Key Python Files:**
- `test_all.py` - Main test runner that validates E[τ] = e
- `montecarlo_simulation.py` - Numerical simulation of the hitting time problem
- `exact_expectation_proof.py` - Direct mathematical calculation
- `irwin_hall_analysis.py` - Analysis of the underlying distribution

**Running Python Tools:**
```bash
# Install dependencies and run all tests
uv sync
uv run python test_all.py

# Run individual analysis tools
uv run python python/simulation/montecarlo_simulation.py
uv run python python/theoretical/exact_expectation_proof.py
```

### Linting Configuration

**Current Settings (Maximum Strictness):**
```toml
[leanOptions]
weak.linter.mathlibStandardSet = true
linter.all = true
```

**Development Priority: Fix All Style Warnings First**

This project prioritizes clean code and mathlib4 compliance:
1. **First**: Fix all style warnings to achieve mathlib4 standards
2. **Then**: Focus on resolving the 3 sorry declarations
3. **Goal**: Clean build with only sorry warnings before mathematical work

## 🛠️ Lean 4 Proof Completion Tactics Cheat Sheet

### Interactive Proof Discovery
```lean
-- Essential tactic suggestions
exact?        -- Find exact proof from context
apply?        -- Find applicable lemmas  
rw?          -- Suggest rewrite rules
simp?        -- Show applicable simp lemmas

-- Context exploration
#check name   -- Show type of definition/theorem
#find pattern -- Search for lemmas by pattern
```

### Core Proof Tactics for This Project
```lean
-- Algebraic simplification
simp [lemma1, lemma2]    -- Simplify with specific lemmas
ring                     -- Ring arithmetic
field_simp              -- Field operations and fractions
norm_num                 -- Numerical computations
linarith                -- Linear arithmetic reasoning

-- Analysis and limits
calc                    -- Step-by-step equational proofs  
gcongr                  -- Monotonicity reasoning
have h : P := by tactic -- Intermediate results

-- Advanced tactics (from external research)
aesop                   -- Best-first automated search
rw_search               -- Breadth-first rewrite search (CLI equivalent of VS Code widget)
conv                    -- Local rewrites deep inside terms (use with lhs, rhs, congr)
```

### CLI-Specific Advanced Commands
```bash
# Lake optimization commands
lake build --verbose       -- Watch compilation order
lake exe cache get        -- Grab mathlib cache for faster builds
lake env lean --profile    -- Profile compilation performance
lake build -K              -- Keep going after errors
lake rebuild -R myPkg      -- Rebuild only specific package

# Performance debugging
lean --run --heartbeat-attribution MyFile.lean  -- Find performance bottlenecks
set_option maxHeartbeats 400000                 -- Increase timeout budget
set_option trace.profiler true                  -- Show compilation times
```

### Project-Specific Patterns

**For Telescoping Series (`telescoping_series_fixed`)**:
- Key concepts: `HasSum`, `Summable`, partial sums, limit behavior
- Pattern: `HasSum (fun k => a k - a (k+1)) (a 0 - lim atTop a)`
- Use `calc` mode for step-by-step series manipulation

**For Factorial Growth (`factorial_dominates_exponential_eventually`)**:
- Key concepts: `eventually`, `atTop`, `Filter.Eventually`  
- Pattern: `∀ᶠ n in atTop, condition n` (eventually true for large n)
- Use Stirling's approximation and induction from suitable base case

**For Geometric Convergence (`inv_factorial_geometric_convergence`)**:
- Key concepts: ratio test, geometric bounds, `∃ c r, conditions ∧ ∀ᶠ n, bound`
- Pattern: Find constants where `1/n! ≤ c * r^n` eventually  
- Use factorial growth estimates and ratio test convergence

### Debugging When Stuck
```lean
-- Show current goal and hypotheses
sorry  -- Temporarily complete to check other parts

-- Add intermediate steps  
have step1 : P := by sorry
have step2 : Q := by sorry
-- then: exact final_step step1 step2
```

### Important API Patterns from Research
```lean
-- Series convergence
Summable.hasSum          -- Convert summable to HasSum
hasSum_iff_tendsto_nat   -- HasSum via limit of partial sums

-- Factorial properties  
Nat.factorial_pos        -- n! > 0
factorial_le_pow         -- Growth bounds

-- Eventually patterns
Filter.Eventually        -- ∀ᶠ notation
eventually_of_forall     -- Convert universal to eventual
```

### Essential mathlib4 v4.21.0 Modules
```lean
import Mathlib.Analysis.SpecificLimits.Normed     -- Real.summable_pow_div_factorial
import Mathlib.Topology.Algebra.InfiniteSum.Basic -- Summable.tendsto_zero, HasSum
import Mathlib.Data.Nat.Factorial.Basic           -- Nat.factorial properties
import Mathlib.Algebra.Order.Field.Basic          -- Field inequalities
import Mathlib.Algebra.BigOperators.Basic         -- Finite sum operations
```

**Critical API Notes**:
- Use `Mathlib.Algebra.BigOperators.Basic`, NOT `.Group.Finset.Basic` (doesn't exist)
- factorial/exponential growth lemmas are in `SpecificLimits.Normed`
- `HasSum` and infinite series API is in `InfiniteSum.Basic`

### Hidden mathlib4 Features (from External Research)
```lean
-- Advanced factorial bounds
Nat.factorial_le_pow           -- n! ≤ k^n for n ≥ k
Nat.choose_le_pow_two n        -- Binomial bounds
tendsto_one_div_factorial_atTop_nhds_0  -- 1/n! → 0

-- Series convergence (SpecificLimits.Basic/Normed)
hasSum_geometric_of_lt_1       -- Geometric series
tendsto_pow_const_mul_const_pow_of_abs_lt_one  -- Power decay
Real.tendsto_exp_atTop_nhdsInf -- Exponential limits

-- Filter theory shortcuts
eventually_of_forall           -- Convert ∀ to ∀ᶠ
tendsto_add_atTop_iff_nat     -- Limit arithmetic
```

### Worked Solutions from External Research

**For telescoping_series_fixed**: Use `hasSum_iff.2` with partial sum identity:
```lean
-- Key insight: ∑(1/(k+1)! - 1/(k+2)!) telescopes to 1 - 1/(n+1)!
-- Then apply tendsto_one_div_factorial_atTop_nhds_0
```

**For factorial_dominates_exponential_eventually**: Apply Stirling's asymptotic formula:
```lean
-- Use stirling_tendsto to show factorial/exponential → ∞
-- Convert via filter_upwards and eventually patterns
```

**For inv_factorial_geometric_convergence**: Choose constants c=2, r=1/2:
```lean
-- Since n! ≥ 2^n eventually, we get 1/n! ≤ (1/2)^n
-- Multiply by constant 2 to get the required form
```

**Why This Cheat Sheet Matters**: The 3 remaining `sorry` declarations require sophisticated mathlib4 API usage. These tactics and patterns, extracted from comprehensive project research including external expert consultation, provide the specific tools and complete solution strategies needed to finish the formal verification.

## 📋 Project Overview

### Problem Source

**Author**: suamax (@suamax_scp)  
**Date**: July 9, 2025  
**URL**: https://x.com/suamax_scp/status/1942902598203322849

**Original (Japanese)**:
```
女騎士「私に何を飲ませた！」
オーク「飲む前の感度をn倍とした時に、感度をn+m倍(m:[0,1)、毎回の摂取ごとに独立して判定される)まで引き上げる薬だ。通常時の感度を1倍として、お前の感度が2倍になるまでこれを飲ませる」
女騎士「私が媚薬を飲む回数の期待値はどれくらいになるんだ……？」
```

### Mathematical Background

**Core Proof Structure:**
1. **Basic Identity**: ∑_{n=0}^∞ 1/n! = e
2. **Probability Mass Function**: P(τ = n) = (n-1)/n! for n ≥ 2
3. **Expected Value Calculation**: E[τ] = ∑_{n=1}^∞ n · P(τ = n) = e

**Formalization Challenges:**
- **API Evolution**: Successfully migrated from mathlib4 v4.12.0 to v4.21.0
- **Type System**: Rigorous typing for probability theory
- **Performance**: Avoiding timeouts in complex proofs

**Development Framework:**
- ✅ **API Evolution Management**: Systematic approach to mathlib4 version migrations
- ✅ **Comprehensive Analysis**: Methodical audit and documentation of API changes
- ✅ **Research Integration**: Evidence-based methodology for future mathematical developments
- 🎯 **Core Focus**: Telescoping series formalization with automated proof obligation tracking
- ✅ **Mathematical Architecture**: Helper lemma strategy connecting discrete and continuous perspectives

### Key Principles

**Development Philosophy:**
- **Small and Certain**: One concrete improvement per implementation
- **Mathematical Correctness AND Build Success**: Both are mandatory requirements
- **Sustainability**: Design for long-term development
- **Progressive Implementation**: Encourage ambition in attempts, conservative in commits

**Quality Assurance:**
- **Git Recording Required**: Track all changes with commits
- **Build Verification**: Always verify build status after changes
- **Accuracy of Records**: Ensure reports match actual changes

### Continuous Improvement Philosophy

- **Evidence-Based Progress**: Systematic evaluation through concrete mathematical milestones
- **Formal Verification Priority**: Mathematical completeness over arbitrary metrics  
- **Cumulative Knowledge**: Building on proven foundations for sustained advancement

### Important Documents

**State Management System:**
- `docs/state/current-state.md` - Current accurate status
- `docs/state/iteration-history.md` - Cumulative trial records
- `docs/state/self-contained-prompt.md` - Self-contained implementation prompt
- `docs/state/session-restoration.md` - Session restoration procedures

**Papers and Documentation:**
- `2025-07-15-02-00-00-aphrodisiac-problem-MIT-thesis.md` - MIT-level mathematical paper
- `docs/problem-statement-japanese.md` - Original Japanese text
- `docs/problem-statement-context.md` - English interpretation

**API Modernization Framework:**
- `docs/research_prompts/35-lean4-v4.21.0-api-migration-validation.md` - Systematic API research framework
- `docs/api-analysis/2025-07-19-15-40-11-obvious-improvements-audit.md` - Completed API audit findings
- `docs/research_response/P36-*.md` - Community best practices research

---

## 🔀 Delegation Workflow: Internal vs External Research

### **Two-Pathway Delegation System**

**Understanding when and how to delegate is critical for project success.** The project uses two distinct delegation pathways:

#### **Pathway 1: Internal Task Tool (Subagents)**

**When to Use:**
- Implementation tasks with existing project context
- File reading, editing, building within the environment
- Lean 4 implementation work where files can be directly accessed
- API fixes, code modifications, testing

**How to Use:**
```bash
# Task tool can read files directly and execute instructions
Task tool → "Read /path/file.md and follow its instructions"
```

**Capabilities:**
- ✅ Direct file system access
- ✅ Can execute commands (lake build, git, etc.)
- ✅ Access to project environment and context
- ✅ Can make commits and track changes

#### **Pathway 2: External Research AIs** 

**When to Use:**
- Advanced troubleshooting beyond internal expertise
- Complex research requiring specialized knowledge
- Investigation of problems that need external perspective
- When internal agents lack necessary domain expertise

**How to Use:**
1. **Create research prompt** in `docs/research_prompts/` with sequential number
2. **Include complete context** (external AI cannot scan directories)
3. **Use ask_human tool** to initiate external research

**Critical Requirements for External Research:**

### **Research Prompt Creation Protocol**

**File Naming:**
- Place in `docs/research_prompts/`
- Use sequential numbers: `[next-number]-description.md`
- Check existing files to determine next available number
- **Do NOT reference numbers within prompt content**

**Content Requirements (Essential for Success):**
```markdown
# Research Prompt [Number]: [Descriptive Title]

## Problem Context
[Complete background - external AI has no file access]

## Specific Issue
[Exact error messages, code snippets, version information]

## Development Environment
- Lean 4 version: v4.21.0
- mathlib4 version: v4.21.0  
- Operating system: [specify]
- Tool versions: [lake, etc.]

## Exact Code Causing Issues
```lean
[Complete problematic code snippets - not just references]
```

## What Has Been Tried
[Previous attempts, what worked, what didn't]

## Specific Questions
[Precise questions for the research AI to answer]
```

**Think Advanced AI Troubleshooting:** Structure prompts like sophisticated Stack Overflow questions with complete context, minimal reproducible examples, and specific environment details.

### **External Research Initiation**

**Using ask_human Tool:**
```bash
# After creating research prompt file
ask_human("I've created research prompt at /full/path/to/docs/research_prompts/[number]-[description].md requesting investigation of [brief description]. Please initiate external research assistance.")
```

**Expected Response:**
- ask_human tool returns full path where research findings will be placed
- Research results integrated back into project workflow

### **Decision Matrix: Internal vs External**

| Task Type | Use Internal Task Tool | Use External Research |
|-----------|----------------------|---------------------|
| File reading/editing | ✅ | ❌ |
| Lean 4 implementation | ✅ | ❌ |
| Build troubleshooting | ✅ | ❌ |
| API research (known patterns) | ✅ | ❌ |
| Complex domain research | ❌ | ✅ |
| Unknown error investigation | ❌ | ✅ |
| Community best practices | ❌ | ✅ |
| Advanced optimization | ❌ | ✅ |

### **Integration Workflow**

**Complete Research Cycle:**
1. **Identify need** for external research
2. **Create comprehensive prompt** with full context  
3. **Use ask_human tool** to initiate research
4. **Receive research findings** at specified path
5. **Integrate findings** into project using internal tools
6. **Document integration** in project files

---

**Note**: This project pursues true mathematical value by combining mathematical absoluteness with formal verification rigor. When instructed to "execute next iteration", immediately follow the procedure in the Quick Iteration Execution section above.
