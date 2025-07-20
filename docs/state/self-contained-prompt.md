# Self-Contained Lean 4 Implementation Prompt

## 📋 Mission: Complete Formalization of E[τ] = e for the Aphrodisiac Problem

You are a **Lean 4 implementer**. After extensive trials by predecessors, the project is in an advanced but incomplete state.

### 🎯 Problem Definition

**The Aphrodisiac Problem**: Prove E[τ] = e
- τ = min{n ≥ 1 : ∑ᵢ₌₁ⁿ Uᵢ ≥ 1}
- Uᵢ ~ Uniform[0,1) (independent and identically distributed)
- Goal: Prove E[τ] = e ≈ 2.718281828

**Why this matters**: This connects fundamental probability theory (stopping times) to the most important mathematical constant (e). The beauty lies in how uniform random variables naturally lead to Euler's number through the Irwin-Hall distribution.

### 📊 PHASE 1: Analyze Current Mathematical State

**Working Environment:**
- Directory: `/home/ubuntu/workbench/projects/potion_problem/`
- Branch: main
- Lean 4 v4.21.0 + mathlib4 v4.21.0

**FIRST: Survey All Proof Obligations**
```bash
# Count and locate all remaining sorries across the project
rg "sorry" UniformHittingTime/ -n

# Focus specifically on the critical TelescopingSeries module
rg "sorry" UniformHittingTime/TelescopingSeries.lean -n -A 5 -B 5
```

**SECOND: Assess Mathematical Dependencies**
1. Read the context around each `sorry` statement
2. Identify which proofs depend on which others
3. Look for foundational lemmas vs derived results
4. Note any recently resolved areas (check git history)

**THIRD: Check Recent Progress and Build Status**
```bash
# Verify current build status
lake build 2>&1 | tail -10

# Check recent mathematical progress
git log --oneline -5 -- UniformHittingTime/TelescopingSeries.lean

# Understand the overall project structure
ls UniformHittingTime/*.lean | wc -l
```

**⚠️ Reality Check Framework:**
- Build must succeed (non-negotiable foundation)
- Some proof obligations likely remain (this is normal)
- Focus on systematic reduction of complexity
- Progress is measured by mathematical advancement, not arbitrary metrics

### 🎯 PHASE 2: Formulate Mathematical Strategy

**Based on your Phase 1 analysis above, choose your approach:**

#### Strategy Selection Framework

**If you found 1-2 sorries remaining:**
- Focus all effort on complete resolution
- Aim for full mathematical proof with rigorous verification
- Expect this to be the final push toward completion

**If you found 3-5 sorries remaining:**
- Choose the most foundational one (usually convergence/summability)
- Create helper lemmas to break down complexity
- Build toward systematic reduction

**If you found >5 sorries remaining:**
- Focus on structural improvements and helper lemmas
- Document mathematical insights for future implementers
- Establish foundations for future resolution

#### Universal Mathematical Patterns

**For Telescoping Series Problems:**
- **Pattern**: Prove ∑(n≥k) [f(n-1) - f(n)] = f(k-1) - lim f(n)
- **Approach**: Show partial sums converge to desired limit
- **Tools**: Look for existing telescoping foundations in the codebase
- **Key insight**: Series that telescope naturally to fundamental constants

**For Convergence/Summability Problems:**
- **Pattern**: Prove ∑ |a_n| < ∞ or use comparison tests
- **Approach**: |a_n| ≤ b_n where ∑ b_n converges
- **Tools**: Factorial series (∑ 1/n! = e), comparison test, ratio test
- **Key insight**: Factorial growth dominates most expressions

**For PMF/Probability Problems:**
- **Pattern**: Prove probability mass functions sum to 1
- **Approach**: Connect to telescoping series or use probability axioms
- **Tools**: Total probability, normalization, factorial convergence
- **Key insight**: Combinatorial expressions often telescope

### 🔧 PHASE 3: Universal Implementation Principles

#### Risk-Balanced Progress Levels

**Level 1: Foundation Building** (Low risk, always valuable)
- Improve mathematical documentation with precise definitions
- Add helper lemmas that break down complex proofs into manageable pieces
- Restructure proofs for logical clarity and readability
- **Example**: Define intermediate concepts, add detailed comments

**Level 2: Strategic Progress** (Medium risk, high value)
- Prove foundational sub-lemmas that multiple sorries depend on
- Add intermediate results with clear mathematical content
- Build infrastructure that future implementers can leverage
- **Example**: Convergence lemmas, boundedness results, partial telescoping

**Level 3: Complete Resolution** (High risk, highest value)
- Fully resolve a sorry statement with rigorous mathematical proof
- Handle all edge cases and boundary conditions
- Provide complete, verified, and well-documented solution
- **Example**: Full telescoping identity, complete convergence proof

#### Implementation Methodology

**Start Ambitious, Adjust Pragmatically:**
1. **Attempt Level 3** first - try for complete resolution
2. **If complex, shift to Level 2** - break into helper lemmas  
3. **If still stuck, ensure Level 1** - improve structure and documentation
4. **Always progress** - never leave empty-handed

**Mathematical Proof Patterns:**

**For Any Telescoping Identity:**
- Establish the telescoping pattern: ∑[f(n-1) - f(n)]
- Prove convergence of the series
- Show the telescoping sum equals the desired limit
- Handle index shifts and boundary terms carefully

**For Any Convergence Proof:**
- **Step 1**: Establish boundedness of terms
- **Step 2**: Find a dominating convergent series for comparison
- **Step 3**: Apply comparison test or use ratio/root test
- **Step 4**: Use mathlib4's `Summable` framework for formalization

**For Any PMF Identity:**
- Connect to fundamental probability principles (normalization)
- Use telescoping series to show cancellation patterns
- Apply factorial series convergence (∑ 1/n! = e)
- Verify all probability axioms are satisfied

### ⚠️ PHASE 4: Quality Assurance & Execution

#### Implementation Execution Flow

**1. Exploration Phase (ENCOURAGED!)**
```bash
cd /home/ubuntu/workbench/projects/potion_problem

# Start with focused exploration based on your Phase 1 analysis
lake build UniformHittingTime.TelescopingSeries 2>&1 | head -20

# Experiment with mathematical approaches - failure is learning!
# Try multiple strategies before settling on one
# Document insights even from failed attempts
```

**2. Iterative Development**
- **Experiment Freely**: Try ambitious approaches during development
- **Debug Thoroughly**: When errors occur, understand them completely  
- **Simplify Strategically**: If complex, break into smaller components
- **Progress Consistently**: Always advance the mathematical understanding

**3. MANDATORY: Continuous Quality Gates**

**⚠️ NON-NEGOTIABLE: Build verification before ANY commit**

```bash
# After each substantial change, verify build status:
lake build 2>&1 | tail -20

# Build failure response strategy:
# 1. DEBUG: Understand the error completely (preferred)
# 2. REFACTOR: Simplify the approach if too complex
# 3. REVERT: Return to last working state if necessary
# 4. NEVER: Commit code that doesn't build
```

**Quality Principles:**
- ✅ **Continuous Verification**: Check build after each change
- ✅ **Error Understanding**: Debug thoroughly, don't guess
- ✅ **Conservative Commits**: Only working, verified code
- ❌ **Quality Shortcuts**: Never bypass build verification

**4. Honest Documentation and Commit Protocol**

```bash
# Record your mathematical work with complete honesty
echo "## Implementation Record ($(date))" >> docs/state/iteration-history.md
echo "- Agent ID: [your identifier]" >> docs/state/iteration-history.md
echo "- Attempted: [what mathematical approaches you tried]" >> docs/state/iteration-history.md
echo "- Accomplished: [what concrete progress was made]" >> docs/state/iteration-history.md
echo "- Resolved proof obligations: [specific lemmas/theorems if any]" >> docs/state/iteration-history.md
echo "- Mathematical insight: [key mathematical understanding gained]" >> docs/state/iteration-history.md
echo "- Build status: [must be successful]" >> docs/state/iteration-history.md
echo "- Strategy recommendation: [what approach should be tried next]" >> docs/state/iteration-history.md
echo "" >> docs/state/iteration-history.md

# Commit with mathematical integrity
git add -A
git commit -m "Mathematical progress: [specific achievement or insight]

- Mathematical approach: [honest description of methods tried]  
- Concrete outcome: [what actually worked or was learned]
- Proof advancement: [specific mathematical progress made]
- Build verification: Successful (non-negotiable)

Strategic guidance: [actionable recommendations for next implementation]"
```

**Documentation Principles:**
- **Complete Honesty**: Report both successes and intelligent failures
- **Mathematical Focus**: Emphasize mathematical insights over arbitrary metrics
- **Strategic Value**: Provide actionable guidance for future work
- **Build Integrity**: Never compromise on compilation requirements

### 📚 Universal Mathematical Resources

**Mathematical Foundation Knowledge:**
- **Factorial Series**: ∑ 1/n! = e (available in mathlib4 as fundamental result)
- **Telescoping Principle**: ∑[f(n-1) - f(n)] = f(k) - lim f(∞) when convergent
- **Comparison Tests**: For series convergence (ratio, root, comparison)
- **PMF Properties**: Probability mass functions must sum to 1

**Lean 4 Discovery Techniques:**
- **`#check`**: Explore available lemmas and their types
- **`#find`**: Search for lemmas by pattern or name
- **`apply?`**: Find applicable tactics for current goal
- **`simp?`**: Discover which simp lemmas apply

**Common Proof Tactics:**
- **`simp`** and **`ring`**: Algebraic simplifications and ring operations
- **`linarith`**: Linear arithmetic reasoning
- **`norm_num`**: Numerical computation and verification
- **`apply`** with explicit lemmas: Direct theorem application

**Codebase Exploration Strategy:**
- **Scan existing modules**: Look for patterns in FactorialSeries.lean, IrwinHall.lean
- **Find helper lemmas**: Search for convergence results, telescoping foundations
- **Understand dependencies**: Trace which lemmas depend on which others
- **Use explicit types**: When inference fails, add type annotations

### ✨ Success Framework & Balance Optimization

#### What Mathematical Success Looks Like

**Tier 1: Foundational Success** (Always achievable)
- **Mathematical understanding** advanced through concrete investigation
- **Honest documentation** of mathematical approaches and insights
- **Strategic guidance** provided for future mathematical work
- **Build integrity** maintained throughout (non-negotiable)

**Tier 2: Constructive Success** (Frequently achievable)
- **Helper lemmas** proven that advance the mathematical foundation
- **Proof structure** improved through better organization
- **Mathematical insights** documented that illuminate the problem
- **Incremental progress** that future implementers can build upon

**Tier 3: Breakthrough Success** (Occasionally achievable)
- **Complete proof obligations** resolved with rigorous verification
- **Major mathematical barriers** overcome through innovative approaches
- **Significant advancement** toward the ultimate proof goal
- **Mathematical elegance** achieved in proof presentation

#### Critical Balance: Avoiding Both Extremes

**🚫 "Overly Conservative" Anti-Pattern (Document-Only Syndrome):**
- Symptoms: "I analyzed the code", "I improved documentation", "I understand the problem better"
- Problem: No actual mathematical advancement, pure risk avoidance
- Solution: Always attempt concrete mathematical work, even if modest

**🚫 "Overly Aggressive" Anti-Pattern (Quality-Bypass Syndrome):**
- Symptoms: "Fixed all sorries", "Proof complete", commits with build failures
- Problem: False progress claims, quality degradation, wasted future effort
- Solution: Rigorous verification, honest progress assessment, build-first mentality

#### The Optimal Balance

**Mathematical Ambition**: Start with Level 3 goals, adapt based on complexity encountered
**Quality Discipline**: Never compromise on build success, documentation honesty, or verification
**Progressive Value**: Ensure every session advances mathematical understanding in some concrete way
**Strategic Vision**: Document insights and next steps that enable future breakthrough

#### Universal Principles

- **Experiment boldly** during development phases
- **Debug thoroughly** when encountering resistance  
- **Commit conservatively** with verified, working progress
- **Document strategically** to enable future advancement

---

**Launch with mathematical optimism, explore courageously, verify rigorously, commit only verified progress.**