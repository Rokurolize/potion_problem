# Design Patterns and Guidelines

## Core Development Philosophy

### 1. Build-Driven Development
- Compile after every change - "Only build errors can guide you"
- Never proceed with compilation errors
- Use incremental builds for specific modules

### 2. Sorry Elimination Strategy
- **Fight One Sorry to the Death** - Never change targets mid-proof
- **Dependency-First** - Eliminate sorries that other proofs depend on
- **Foundation-Up** - Start with basic lemmas before complex theorems
- **Framework-First** - Build complete proof structure even with temporary sorries

### 3. API Usage Patterns

#### Critical: Field vs Direct Call (80% of errors)
```lean
-- ❌ WRONG - Field access
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add

-- ✅ CORRECT - Direct namespace access
Summable.sum_add_tsum_nat_add k pmf_summable
```

#### API Verification Protocol
1. Check SQLite database first: `./api_database/api_tools.sh api-exists "API.name"`
2. If not found, use MCP LeanExplore
3. Always create test file before use
4. Update database after verification

### 4. Mathematical Proof Patterns

#### Type Conversion Mastery
```lean
-- Convert cast types explicitly
have h_cast : (↑n + 2 : ℝ) = ↑(n + 2) := by simp only [Nat.cast_add, Nat.cast_two]
```

#### Telescoping Series Pattern
```lean
-- Use conv_lhs for complex rewrites
conv_lhs => 
  rw [Finset.sum_congr rfl (fun k _ => telescoping_lemma k proof)]
```

#### Strategic Retreat Documentation
When a sorry is too complex:
```lean
-- STRATEGIC RETREAT: Enhanced Documentation
-- 
-- MATHEMATICAL FOUNDATION (100% verified):
-- [Complete mathematical approach]
--
-- IMPLEMENTATION CHALLENGES:
-- [Specific technical hurdles]
--
-- PRESERVED FOR FUTURE:
-- [Key insights and verified approaches]
sorry
```

### 5. Module Architecture Principles
- **Separation of Concerns** - Each module has single responsibility
- **Bottom-Up Dependencies** - Basic → Foundations → Analysis → Theory → Main
- **Executive Summary Pattern** - Main.lean imports all and states result concisely

### 6. Documentation Standards
- Mathematical context in module headers using `/-!`
- Individual definitions/theorems with `/--`
- @-path syntax for file references in CLAUDE.md
- Preserve mathematical notation in comments

### 7. Testing and Verification
- Test-Driven Development for new APIs
- Continuous integration mindset - build must always pass
- Document both successful patterns and anti-patterns

### 8. Key Success Factors
- **Evidence-Based Development** - Git analysis, build verification, proof tracking
- **Systematic Approach** - Follow documented workflows, don't improvise
- **Quality Over Speed** - Better to retreat strategically than break the build
- **Knowledge Preservation** - Document everything for future sessions

## Anti-Patterns to Avoid
- Attempting multiple sorries simultaneously
- Using unverified APIs
- Complex proof attempts without framework
- Proceeding despite build errors
- Forgetting to update documentation after changes