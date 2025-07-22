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

**Expected Warnings** (do NOT fix these - they're style preferences):
- `doc-strings should start with a single space or newline`
- `line exceeds the 100 character limit`
- `cases' tactic is discouraged: please strongly consider using cases`
- `starts on column X, but all commands should start at the beginning of the line`

**Critical Warnings** (these need resolution):
- `declaration uses 'sorry'` - Incomplete proofs that block mathematical completeness

**Linting is now strict** due to `lakefile.toml` enabling `weak.linter.mathlibStandardSet = true`. This is intentional and helps maintain mathlib coding standards.

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