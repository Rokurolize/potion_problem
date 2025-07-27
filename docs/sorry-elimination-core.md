# Sorry Elimination Core Guide

*Essential principles and workflow for systematic sorry elimination*

**Mission**: Eliminate all `sorry` statements through systematic, build-driven development.

## 🎯 Core Principles

### 1. **Fight One Sorry to the Death**
- **Never change targets mid-proof** - Stick with your chosen sorry until completion
- **Design approach thoroughly first** - Plan the entire proof strategy before coding  
- **Only build errors can guide you** - Trust compilation feedback over intuition

### 2. **Systematic Target Selection**  
- **Dependency-First**: Eliminate sorries that other proofs depend on
- **Foundation-Up**: Start with basic lemmas before complex theorems
- **File-Focused**: Complete all sorries in one file before moving to another

### 3. **Framework-First Development**
- **Build Complete Infrastructure**: Establish full proof structure even with temporary sorries
- **Commit on Solid Progress**: If build succeeds with meaningful framework, commit and proceed
- **Mathematical Rigor**: Document the complete mathematical approach in comments
- **Cross-Module Patterns**: Recognize and reuse proof patterns across different modules

## 🔧 Pre-Attack Checklist

Before targeting any sorry:

### 1. **API Verification**

**Check Pre-Verified APIs**:
Check [`docs/api-library.md`](api-library.md) for proven patterns

**LeanExplore Research** (MUST use wrapper):
```bash
scripts/lle search "lemma_name" --package Mathlib --limit 5
scripts/lle get [GROUP_ID]  # Get exact signature
scripts/lle dependencies [GROUP_ID]  # Get import requirements
```

### 2. **MANDATORY API Usage Verification**
Create `test_api.lean` in project root:
```lean
import Required.Module.From.Dependencies

-- Test the exact usage pattern from LeanExplore
variable {α : Type} {f : ℕ → α} (hf : Summable f) (k : ℕ)
#check Summable.sum_add_tsum_nat_add k hf  -- Must compile without errors
```

**Run verification**:
```bash
echo "test_api.lean" >> .gitignore  # Exclude from version control
lake env lean test_api.lean        # Must succeed before proceeding
```

### 3. **Check Current Build Status**
```bash
lake build PotionProblem.ModuleName
```

### 4. **Understand the Goal**
- Read the theorem statement carefully
- Identify the mathematical strategy needed  
- Check what lemmas are already available

### 5. **Update Todo List**
```bash
# Mark current sorry as "in_progress"
# This provides accountability and progress tracking
```

## ⚠️ CRITICAL: Common API Misuse Patterns (MUST AVOID)

### Field vs Direct Call Confusion
**❌ WRONG** - Causes "invalid field" errors:
```lean
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add
```

**✅ CORRECT** - Direct namespace access:
```lean
Summable.sum_add_tsum_nat_add k pmf_summable
```

### Argument Order Mistakes
**❌ WRONG**:
```lean
Summable.sum_add_tsum_nat_add summability_proof k  -- Wrong order
```

**✅ CORRECT**:  
```lean
Summable.sum_add_tsum_nat_add k summability_proof  -- k first, proof second
```

**See [`docs/api-library.md`](api-library.md) for comprehensive API patterns**

## 🔄 Build-Driven Development Workflow

### Progressive Refinement
```lean
-- Start with structure
sorry  

-- Add key steps
have h1 : P := by sorry
have h2 : Q := by sorry  
exact final_step h1 h2

-- Fill in details
have h1 : P := by
  rw [some_lemma]
  simp
have h2 : Q := by sorry
-- Continue...
```

### TDD-Style Verification
```bash
# After each change
lake build 2>&1 | grep -E "(error:|Build completed)"
# Only commit if build succeeds
git add [file] && git commit -m "[specific change]"
```

## 📊 Progress Tracking

### Todo List Management
**Mandatory**: Update TodoWrite after each sorry elimination
```bash
# Mark completed sorries as "completed"
# Update sorry count in main tracking todo
# Mark next target as "in_progress"
```

### Verification Commands
```bash
# Check sorry count
grep -c "sorry" ./PotionProblem/*.lean

# Find specific sorries  
grep -n "sorry" ./PotionProblem/FileName.lean

# Verify build success
lake build
echo "Exit code: $?"
```

## 🏆 Success Patterns

### High-Success Techniques (Based on Actual Experience)
1. **Build Error-Driven Resolution**: Fix compilation errors systematically
2. **Framework Documentation**: Complete proof structure with clear mathematical reasoning
3. **Field vs Direct Call Awareness**: Always use `Summable.api_name k proof` not `(some_object).api_name`
4. **Strategic Sorry Placement**: Working sorry with clear next steps > broken complex proof

### Proven Workflow
1. ✅ Choose sorry based on dependency analysis
2. ✅ Check pre-verified APIs in api-library.md
3. ✅ Fix build errors and type mismatches
4. ✅ Document mathematical framework clearly in comments
5. ✅ Use LeanExplore wrapper (scripts/lle) for API discovery when needed
