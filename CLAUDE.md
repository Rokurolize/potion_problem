# CLAUDE.md - Aphrodisiac Problem Lean 4 Formalization Project

*Also known as the Potion Problem (媚薬問題)*

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

---

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
- **API Constraints**: Infinite series operations in mathlib4 v4.12.0
- **Type System**: Rigorous typing for probability theory
- **Performance**: Avoiding timeouts in complex proofs

### Key Principles

**Development Philosophy:**
- **Small and Certain**: One concrete improvement per implementation
- **Mathematical Correctness First**: Mathematical validity over build success
- **Sustainability**: Design for long-term development

**Quality Assurance:**
- **Git Recording Required**: Track all changes with commits
- **Build Verification**: Always verify build status after changes
- **Accuracy of Records**: Ensure reports match actual changes

### Continuous Improvement System

- **Timeline Jump Support**: Handle non-linear timelines for status understanding
- **Git Diff Evaluation**: Complete avoidance of "talk is cheap" problem
- **Cumulative Learning**: Accumulation and utilization of success/failure patterns

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

---

## 📝 System Design Lessons and Improvement Records

### Fixed Issue: Complete Removal of Duplicate Descriptions

**Discovered Root Design Flaw:**
- **Problem**: Same prompt duplicated in CLAUDE.md and docs/state/self-contained-prompt.md
- **Cause**: Designed based on speculation without testing actual Task tool behavior
- **Discovery**: Confirmed Task tool can directly read files and execute instructions

**Evidence-Based Improvements:**
1. **Actual Behavior Test Completed** - Task tool file reading test completed
2. **Execution Test Completed** - Direct execution from self-contained-prompt.md confirmed
3. **Duplicate Code Removed** - Long prompt completely removed from CLAUDE.md

**Future Prevention Measures:**
- Always test actual tool API behavior before designing
- Prohibit system design based on speculation
- Avoid duplicate work justified by "redundancy"

---

**Note**: This project pursues true mathematical value by combining mathematical absoluteness with formal verification rigor. When the master instructs "execute next iteration", immediately follow the procedure in the first section of this file.