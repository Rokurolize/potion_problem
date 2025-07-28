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

1. Check [`verified-apis.md`](api-reference/verified-apis.md) for pre-verified APIs
2. If not found, search using [`mcp-leanexplore-workflow.md`](mcp-leanexplore-workflow.md)
3. Always create test file before using any new API

### 2. **Check Current Build Status**
```bash
lake build PotionProblem.ModuleName
```

### 3. **Understand the Goal**
- Read the theorem statement carefully
- Identify the mathematical strategy needed  
- Check what lemmas are already available

### 4. **Update Todo List**
- Mark current sorry as "in_progress"
- This provides accountability and progress tracking

## ⚠️ CRITICAL: Common API Misuse Patterns

**Most Common Error**: Field vs Direct Call pattern causes 80% of API failures.

See [`common-errors.md`](common-errors.md) for detailed patterns including:
- Field access vs direct namespace calls
- Argument order mistakes
- Type mismatch patterns

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
- Build after each change
- Only commit if build succeeds
- See [`workflow-commands.md`](workflow-commands.md#development-workflow) for detailed commands

## 📊 Progress Tracking

### Todo List Management
**Mandatory**: Update TodoWrite after each sorry elimination
- Mark completed sorries as "completed"  
- Update sorry count in main tracking todo
- Mark next target as "in_progress"

### Verification Commands
See [`workflow-commands.md`](workflow-commands.md#progress-monitoring) for:
- Sorry counting commands
- Build verification
- Deprecation checks

## 🏆 Success Patterns

### High-Success Techniques (Based on Actual Experience)
1. **Build Error-Driven Resolution**: Fix compilation errors systematically
2. **Framework Documentation**: Complete proof structure with clear mathematical reasoning
3. **Field vs Direct Call Awareness**: Always use `Summable.api_name k proof` not `(some_object).api_name`
4. **Strategic Sorry Placement**: Working sorry with clear next steps > broken complex proof

### Proven Workflow
1. ✅ Choose sorry based on dependency analysis
2. ✅ Check pre-verified APIs in verified-apis.md
3. ✅ Fix build errors and type mismatches
4. ✅ Document mathematical framework clearly in comments
5. ✅ Use MCP LeanExplore for API discovery when needed
