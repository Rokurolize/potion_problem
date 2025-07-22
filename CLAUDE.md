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

# Check only sorry warnings (ignore style linter warnings)
lake build 2>&1 | grep "declaration uses 'sorry'"

# Check style/linter warnings (many expected due to strict linting)
lake build 2>&1 | grep -E "(linter\.|style\.)" | head -10

# Verify git status and recent changes
git status
git log --oneline -5
git diff HEAD~1
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

### Current Proof Status
- **3 Remaining Sorries** (the only critical warnings):
  1. `telescoping_series_fixed` at TelescopingSeriesFixed.lean:36
  2. `factorial_dominates_exponential_eventually` at UniformSumHittingTime.lean:213
  3. `inv_factorial_geometric_convergence` at UniformSumHittingTime.lean:250
- **Build**: Succeeds successfully - style warnings are expected due to strict linting
- **Main Theorem**: `uniform_sum_hitting_time_expectation : expected_hitting_time = rexp 1`
- **Linting**: Strict mathlib-style guidelines active (docstring format, line length, deprecated tactics)

### Research Documentation System
- **Research Prompts**: `docs/research_prompts/` - Sequential numbered prompts for external AI research
- **Research Responses**: `docs/research_response/` - Results from external research
- **State Management**: `docs/state/` - Current status and iteration history

### Automation System
- **Location**: `.claude/hooks/auto_iteration_continuation.py`
- **Purpose**: Ensures systematic progress toward completing formal verification
- **Control**: Set `HOOK_ENABLED = False` to disable when needed

### Linting Guidelines (Post lakefile.toml Migration)

**IMPORTANT: Why Style Warnings Should NOT Be Fixed**

The lakefile.toml migration enabled strict linting (`weak.linter.mathlibStandardSet = true`), causing many style warnings. **These should NOT be fixed** for these critical reasons:

1. **Mathematical Priority**: This is a formal verification project. Proof completion (`sorry` resolution) takes absolute priority over code style
2. **Consistency Principle**: The codebase has an established style. Partial style changes create inconsistency and pollute git history
3. **Time Management**: Style fixes are time-consuming and distract from the core mathematical work
4. **Review Clarity**: Style changes mixed with proof work make it harder to review actual mathematical progress

**Expected Style Warnings** (ignore these):
- `doc-strings should start with a single space or newline` - Docstring formatting preference
- `line exceeds the 100 character limit` - Line length preference  
- `cases' tactic is discouraged: please strongly consider using cases` - Tactic modernization suggestion
- `starts on column X, but all commands should start at the beginning of the line` - Indentation preference

**Critical Warnings** (fix these immediately):
- `declaration uses 'sorry'` - Incomplete proofs that block mathematical completeness

**When to Consider Style Fixes**: Only after all `sorry` declarations are resolved and the mathematical formalization is complete. Even then, style changes should be done systematically across the entire codebase, not piecemeal.

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
norm_num                -- Numerical computations
linarith                -- Linear arithmetic reasoning

-- Analysis and limits
calc                    -- Step-by-step equational proofs  
gcongr                  -- Monotonicity reasoning
have h : P := by tactic -- Intermediate results
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

**Why This Cheat Sheet Matters**: The 3 remaining `sorry` declarations require sophisticated mathlib4 API usage. These tactics and patterns, extracted from project research, provide the specific tools needed to complete the formal verification.

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