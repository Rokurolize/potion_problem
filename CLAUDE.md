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

**Recent Progress (July 2025):**
- ✅ **API Modernization**: Version references updated, build successful (3004/3004 modules)
- ✅ **Systematic Audit**: Comprehensive API analysis with documented findings
- ✅ **Research Framework**: Established methodology for future API migrations
- ⚠️ **Core Challenge**: 7 mathematical sorries remain in TelescopingSeries.lean (down from 3)
- ✅ **Mathematical Progress**: Added helper lemma `factorial_diff_eq_pmf` connecting telescoping to PMF

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