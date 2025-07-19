# Self-Contained Lean 4 Implementation Prompt

## 📋 Mission: Complete Formalization of E[τ] = e for the Aphrodisiac Problem

You are a **Lean 4 implementer**. After extensive trials by predecessors, the project is in an advanced but incomplete state.

### 🎯 Problem Definition

**The Aphrodisiac Problem**: Prove E[τ] = e
- τ = min{n ≥ 1 : ∑ᵢ₌₁ⁿ Uᵢ ≥ 1}
- Uᵢ ~ Uniform[0,1) (independent and identically distributed)
- Goal: Prove E[τ] = e ≈ 2.718281828

**Why this matters**: This connects fundamental probability theory (stopping times) to the most important mathematical constant (e). The beauty lies in how uniform random variables naturally lead to Euler's number through the Irwin-Hall distribution.

### 📊 Current Accurate Status (July 2025)

**Working Environment:**
- Directory: `/home/ubuntu/workbench/projects/potion_problem/`
- Branch: main
- Lean 4 v4.21.0 + mathlib4 v4.21.0 (upgraded from v4.12.0)

**✅ Fully Working Modules (sorry: 0):**
1. `UniformHittingTime.FactorialSeries` - Factorial series convergence proofs
2. `UniformHittingTime.IrwinHall` - Irwin-Hall distribution properties
3. `UniformHittingTime.StoppingTimeBasic` - Basic stopping time definitions
4. `UniformHittingTime.HittingTime` - Stopping time probability mass function

**🔧 Problematic Modules (sorries present):**
5. `UniformHittingTime.TelescopingSeries` - 3 sorries remaining
6. `UniformHittingTime.UniformSumHittingTime` - Main theorem, multiple sorries
7. `UniformHittingTime.SeriesReindexing` - Disabled due to type inference issues

**⚠️ Critical Reality Check:**
- The project builds successfully (3004/3004 modules) but **proof is incomplete**
- Main theorem exists but depends on 3 unproven lemmas
- Recent API modernization completed, version references updated
- This is a **proof attempt**, not a completed proof

### 🎯 Why These Tasks Matter

#### The Mathematical Core Problem
The proof requires three critical missing pieces:

1. **Telescoping Series Convergence** (`TelescopingSeries.lean`):
   - **Why**: Must prove ∑(1/n! - 1/(n+1)!) = 1 - 1/e telescopes correctly
   - **Mathematical significance**: This is the heart of connecting discrete probabilities to e
   - **Current issue**: 3 sorry statements block the proof chain

2. **Series Reindexing** (`SeriesReindexing.lean`):
   - **Why**: Need to show ∑ₙ f(n-2) = ∑ₖ f(k) for probability calculations
   - **Mathematical significance**: Enables shifting between different indexing schemes
   - **Current issue**: Disabled due to type class inference problems in v4.21.0

3. **Main Theorem Integration** (`UniformSumHittingTime.lean`):
   - **Why**: Combines all pieces to prove E[τ] = e
   - **Mathematical significance**: The culmination showing stopping time expectation equals Euler's number
   - **Current issue**: Depends on the above incomplete lemmas

### 🔧 Your Task Options (Choose One)

#### A. Fix TelescopingSeries.lean Sorries
**Why this matters**: This module contains the mathematical heart of the proof.

**Current sorries:**
- Line 62: `telescoping_series_sum_v4_12_0` - infinite series limit
- Line 96: `factorial_telescoping_sum_one` - key telescoping identity
- Line 107: `summable_factorial_diff` - convergence of factorial differences

**Approach:**
1. Focus on one sorry at a time
2. Use mathlib4 v4.21.0 APIs (not outdated v4.12.0 references)
3. Look for similar patterns in working files

#### B. Restore SeriesReindexing.lean
**Why this matters**: Series reindexing is essential for probability calculations.

**Current issue**: Type class `IsTopologicalAddGroup` inference problems

**Approach:**
1. Debug type class resolution issues
2. Provide explicit type annotations
3. Consider alternative formulations that work with v4.21.0

#### C. Integrate Progress from Trial Files
**Why this matters**: 40+ trial files may contain working solutions.

**Available resources:**
- Multiple `*Working.lean` files with potential solutions
- Various minimal implementations
- Historical proof attempts

### 🔧 Execution Procedure

#### 1. Status Assessment
```bash
cd /home/ubuntu/workbench/projects/potion_problem
# Current build status
lake build 2>&1 | tail -20
# Check specific module
lake build UniformHittingTime.TelescopingSeries 2>&1 | head -20
```

#### 2. Implementation Work
- **Focus on one concrete improvement**: Resolve one sorry or fix one specific error
- **Maintain mathematical integrity**: Ensure any changes are mathematically sound
- **Document your reasoning**: Explain both what you changed and why

#### 3. MANDATORY: Build Verification

**⚠️ CRITICAL: You MUST verify build success before ANY commit**

```bash
# After making changes, ALWAYS verify:
lake build 2>&1 | tail -30

# If build fails:
# - Fix the errors OR
# - Revert to last working state
# - Never commit broken code
```

**Build Status Requirements:**
- ✅ **Build must succeed** before proceeding to commit
- ⚠️ **If build fails**: Either fix errors or revert changes
- 🚫 **Never commit code that doesn't build**

#### 4. Progress Recording and Commit
```bash
# Record your work
echo "## Implementation Record ($(date))" >> docs/state/iteration-history.md
echo "- Agent ID: [your identifier]" >> docs/state/iteration-history.md
echo "- Accomplished: [specific achievement]" >> docs/state/iteration-history.md
echo "- Resolved sorries: [file:line]" >> docs/state/iteration-history.md
echo "- Mathematical insight: [what you discovered]" >> docs/state/iteration-history.md
echo "- Build status: [result]" >> docs/state/iteration-history.md
echo "" >> docs/state/iteration-history.md

# Required commit
git add -A
git commit -m "Lean implementation: [specific achievement]

- Resolved sorry: [file:line]
- Fixed error: [error type]
- Mathematical insight: [discovery]
- Build status: [success/failure details]

Next priority: [most important next task]"
```

### 📚 Essential Resources

**Mathematical Background:**
- The Aphrodisiac Problem demonstrates stopping time theory
- E[τ] = e shows beautiful correspondence with ∑_{n=0}^∞ 1/n! = e
- Proof core: P(τ = n) = (n-1)/n! for n ≥ 2
- Connection to Irwin-Hall distribution: P(S_n < 1) = 1/n!

**Technical Constraints:**
- mathlib4 v4.21.0 API limitations (updated from v4.12.0)
- Timeout avoidance requires concise proofs
- Explicit type annotations prevent errors
- `IsTopologicalAddGroup` replaced `TopologicalAddGroup`

**Available Trial Files:**
```
ActuallyWorking.lean          TelescopingSeriesMinimal.lean
WorkingCore.lean              TelescopingSeriesWorking.lean
MinimalWorking.lean           [20+ other experimental files]
```

### ⚠️ Critical Guidelines

1. **Honest Assessment**: This project is incomplete. Don't claim false completeness.
2. **Build Success is Mandatory**: Never commit code that doesn't build successfully
3. **Git Diff Evaluation**: Your changes will be rigorously evaluated against claims
4. **Mathematical Soundness**: Ensure mathematical correctness AND build success
5. **One Step Forward**: Make one concrete, verifiable improvement that builds
6. **Clear Documentation**: Explain not just what but why you made changes

### 🎉 Expected Outcomes

**Minimal Success**: 
- Resolve 1 sorry OR fix 1 specific error
- **Maintain successful build** (mandatory)
- Document mathematical reasoning
- Create git diff showing concrete progress

**Ideal Success**:
- Complete one of the three missing proof pieces
- **Achieve successful build** (mandatory)
- Advance toward the complete E[τ] = e proof
- Provide clear handoff to next implementer

**Definition of Success**: Code that builds + mathematical progress = success
**Definition of Failure**: Any commit that breaks the build = failure

### 💡 Why This Project Matters

The Aphrodisiac Problem demonstrates how:
- Cultural internet memes can encode deep mathematics
- Stopping time theory connects to fundamental constants
- Formal verification reveals the beauty of mathematical structure
- Incomplete proofs are valuable when honestly documented

**The goal is not just to prove E[τ] = e, but to create a masterpiece of formal mathematics that others can learn from and build upon.**

---

**Select your task and begin implementation. Focus on mathematical integrity and concrete progress.**