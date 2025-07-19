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
5. `UniformHittingTime.TelescopingSeries` - 2 sorries remaining
   - `telescoping_series_sum_v4_12_0` (line 62) - ✅ RESOLVED in previous iteration
   - `factorial_telescoping_sum_one` (line 117) - Complex telescoping identity
   - `summable_factorial_diff` (line 136) - Convergence proof needed
6. `UniformHittingTime.UniformSumHittingTime` - Main theorem, multiple sorries
7. `UniformHittingTime.SeriesReindexing` - Disabled due to type inference issues

**⚠️ Critical Reality Check:**
- The project builds successfully (3004/3004 modules) but **proof is incomplete**
- Main theorem exists but depends on 2 unproven lemmas in TelescopingSeries
- Recent improvements: API modernization, one telescoping theorem proven
- This is a **proof attempt**, not a completed proof

### 🎯 Why These Tasks Matter

#### The Mathematical Core Problem
The proof requires two critical missing pieces in TelescopingSeries.lean:

1. **factorial_telescoping_sum_one** (Line 117):
   - **What**: Prove ∑(n≥2) [1/(n-1)! - 1/n!] = 1
   - **Why crucial**: This shows the PMF sums to 1 (total probability)
   - **Mathematical insight**: The series telescopes to 1/1! - 0 = 1
   - **Can use**: The already proven `telescoping_series_sum_v4_12_0`

2. **summable_factorial_diff** (Line 136):
   - **What**: Prove the factorial difference series converges
   - **Why crucial**: Needed for applying telescoping theorem
   - **Mathematical insight**: Use comparison with ∑ 1/n! which converges to e
   - **Approach**: |1/(n-1)! - 1/n!| ≤ 1/(n-1)!

### 🔧 Implementation Strategy

#### Understanding Progress Levels

**Level 1: Documentation & Structure** (Low risk, always valuable)
- Improve mathematical documentation
- Add helper lemmas that break down complex proofs
- Restructure proofs for clarity

**Level 2: Partial Progress** (Medium risk, high value)
- Prove sub-lemmas needed for main sorries
- Add intermediate results with their own sorries
- Make progress that future implementers can build on

**Level 3: Complete Resolution** (High risk, highest value)
- Fully resolve a sorry statement
- Ensure all edge cases handled
- Provide complete, verified proof

#### Recommended Approach for Current Sorries

**For `factorial_telescoping_sum_one`:**
1. Start by proving the finite partial sum formula
2. Show the limit of partial sums equals 1
3. Connect to the proven `telescoping_series_sum_v4_12_0`
4. Handle the index shift (series starts at n=2)

**For `summable_factorial_diff`:**
1. Prove boundedness: |difference| ≤ 1/(n-1)!
2. Use comparison with known convergent series
3. Apply mathlib4's summability theorems

### 🔧 Execution Procedure

#### 1. Exploration Phase (ENCOURAGED!)
```bash
cd /home/ubuntu/workbench/projects/potion_problem
# Explore the problem space
lake build UniformHittingTime.TelescopingSeries 2>&1 | head -30
# Try different approaches - it's okay if they fail!
# Learn from errors before committing
```

#### 2. Implementation Work

**Progressive Implementation Strategy:**
- **Start ambitious**: Try to fully resolve a sorry
- **If that fails**: Break it into helper lemmas
- **If still stuck**: Improve documentation and structure
- **Always**: Make some form of progress

**Key principle**: Experimentation is encouraged! Just don't commit broken code.

#### 3. MANDATORY: Build Verification

**⚠️ CRITICAL: You MUST verify build success before ANY commit**

```bash
# After making changes, ALWAYS verify:
lake build 2>&1 | tail -30

# If build fails:
# - Debug and fix the errors (preferred) OR
# - Simplify your approach OR
# - Revert to last working state
# - But ALWAYS ensure build succeeds before commit
```

**Build Strategy:**
- ✅ **Experiment freely** during development
- ✅ **Debug aggressively** when errors occur
- ✅ **Only commit** when build succeeds
- ❌ **Never commit** broken code

#### 4. Progress Recording and Commit

```bash
# Record your work
echo "## Implementation Record ($(date))" >> docs/state/iteration-history.md
echo "- Agent ID: [your identifier]" >> docs/state/iteration-history.md
echo "- Attempted: [what you tried, even if it didn't fully work]" >> docs/state/iteration-history.md
echo "- Accomplished: [what actually succeeded]" >> docs/state/iteration-history.md
echo "- Resolved sorries: [file:line if any]" >> docs/state/iteration-history.md
echo "- Mathematical insight: [what you learned]" >> docs/state/iteration-history.md
echo "- Build status: [must be successful]" >> docs/state/iteration-history.md
echo "" >> docs/state/iteration-history.md

# Required commit
git add -A
git commit -m "Lean implementation: [specific achievement]

- Attempted: [honest description of attempts]
- Achieved: [what actually worked]
- Mathematical insight: [key learning]
- Build status: Successful (required)

Next steps: [guidance for next implementer]"
```

### 📚 Essential Resources

**Mathematical Background:**
- The proven `telescoping_series_sum_v4_12_0` can be used for other telescoping proofs
- Factorial series ∑ 1/n! = e is available in mathlib4
- Comparison test for series convergence

**Technical Tips:**
- Use `#check` to explore available lemmas
- Look for patterns in FactorialSeries.lean
- Try `simp` and `ring` for algebraic simplifications
- Use explicit type annotations when inference fails

**Available Helpers:**
- `FactorialSeries.inv_factorial_tendsto_zero` - proves 1/n! → 0
- `pmf_telescoping_insight` - factorial difference identity
- `telescoping_series_partial_sum` - finite sum formula

### ⚠️ Success Criteria

**What Success Looks Like:**
1. **Any meaningful progress** that builds successfully
2. **Honest documentation** of what was attempted
3. **Learning captured** for future implementers
4. **Mathematical integrity** maintained

**Remember:**
- Partial progress is valuable
- Failed attempts teach us
- Documentation improvements matter
- Building code is mandatory

### 💡 Encouragement

**You are encouraged to:**
- Try ambitious approaches first
- Experiment with different proof strategies
- Learn from build errors
- Make incremental progress

**The key balance:**
- Be ambitious in attempts
- Be conservative in commits
- Always maintain build success
- Progress over perfection

---

**Begin with optimism, experiment freely, but commit only success.**