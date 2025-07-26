# FOCUSED TARGET: tail_probability_formula - Complete Elimination Strategy

**MISSION**: Eliminate the single most critical sorry in PotionProblem formalization

## 🎯 TARGET SPECIFICATION

**File**: `PotionProblem/ProbabilityFoundations.lean:217`  
**Function**: `tail_probability_formula`  
**Goal**: `(∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial`  
**Strategic Importance**: ⭐⭐⭐ CRITICAL - Linchpin connecting main theorem to geometric interpretation

## 📊 DEPENDENCY ANALYSIS (PROVEN CRITICAL IMPORTANCE)

### Direct Dependencies (BLOCKING)
- **Line 112**: `hitting_time_connection` CANNOT BE PROVEN without this
- **Line 126**: `geometric_interpretation` depends on `hitting_time_connection`  
- **Main.lean:76**: `geometric_connection` depends on `geometric_interpretation`

### Available Tools (ALREADY PROVEN)
✅ `pmf_telescoping` (ProbabilityFoundations.lean:121) - Core telescoping identity  
✅ `telescoping_partial_sum` (SeriesAnalysis.lean:129) - Finite sum formula  
✅ `pmf_summable` (ProbabilityFoundations.lean:80) - Summability of PMF  
✅ `pmf_sum_eq_one` (ProbabilityFoundations.lean:190) - Total probability  
✅ `pmf_eq_zero_of_le_one` (ProbabilityFoundations.lean:274) - PMF vanishes for n ≤ 1

## 🧮 MATHEMATICAL STRATEGY (VALIDATED)

### Core Insight
P(τ > n) = 1 - P(τ ≤ n) = 1 - ∑_{k=2}^n hitting_time_pmf k = 1 - (1 - 1/n!) = 1/n!

### Step-by-Step Approach
1. **Complement Decomposition**: Split into tail + head = total = 1
2. **Eliminate k < 2 terms**: Use `pmf_eq_zero_of_le_one` 
3. **Apply Telescoping**: Use `telescoping_partial_sum` for finite sum
4. **Algebraic Simplification**: 1 - (1 - 1/n!) = 1/n!

### Key Mathematical Components
```lean
-- The telescoping identity (ALREADY PROVEN):
lemma telescoping_partial_sum (N : ℕ) :
  ∑ n ∈ Finset.range N, hitting_time_pmf (n + 2) = 1 - 1 / (N + 1).factorial

-- The core telescoping property (ALREADY PROVEN):
lemma pmf_telescoping (n : ℕ) (hn : 2 ≤ n) :
  hitting_time_pmf n = 1 / (n - 1).factorial - 1 / n.factorial
```

## ⚠️ TECHNICAL CHALLENGES & SOLUTIONS

### Challenge 1: Conditional Sum Manipulation
**Problem**: `∑' k : ℕ, if k > n then hitting_time_pmf k else 0` 
**Solution**: Use complement approach: `1 - ∑' k : ℕ, if k ≤ n then hitting_time_pmf k else 0`

### Challenge 2: API Deprecation Issues  
**Known Problems**: 
- `tsum_add` deprecated → use `Summable.tsum_add`
- `Summable.subtype` type complexity
**Solution**: Avoid problematic APIs, use direct finite sum approach

### Challenge 3: Index Range Handling
**Problem**: PMF only nonzero for k ≥ 2
**Solution**: Use `pmf_eq_zero_of_le_one` to eliminate k = 0, 1 terms

## 🔧 IMPLEMENTATION APPROACH (NEVER CHANGE)

### Phase 1: Finite Sum Decomposition
```lean
-- Case analysis on n
by_cases h_n : n < 2
· -- Case n < 2: All terms are 0, direct computation
  -- Use pmf_eq_zero_of_le_one to show all relevant terms vanish
  -- Direct factorial computation for small cases
· -- Case n ≥ 2: Use telescoping structure
```

### Phase 2: Telescoping Application (n ≥ 2)
```lean
-- Convert tail sum to finite sum using complement
have h_complement : tail_sum + head_sum = 1 := by
  -- Use total probability pmf_sum_eq_one
  
-- Show head_sum = 1 - 1/n! using telescoping_partial_sum
have h_head : head_sum = 1 - 1/n.factorial := by
  -- Eliminate k < 2 terms, apply telescoping_partial_sum
  
-- Solve: tail_sum = 1 - head_sum = 1 - (1 - 1/n!) = 1/n!
linarith [h_complement, h_head]
```

### Phase 3: Index Transformation Technique
**Key Pattern**: Transform `∑' k, if k ≤ n then ...` to finite sum using:
1. PMF vanishing for k < 2
2. Finite range [2, n] for k ≤ n  
3. Direct application of `telescoping_partial_sum`

## 🚨 CRITICAL SUCCESS FACTORS

### API Safety Protocol
1. **MANDATORY**: Test any new API in separate file first
2. **VERIFIED SAFE**: `pmf_summable`, `telescoping_partial_sum`, `pmf_telescoping`
3. **AVOID**: `tsum_add`, `Summable.subtype`, complex `conv_lhs` patterns

### Proof Structure Protocol  
1. **Start Simple**: Handle n < 2 case with direct computation
2. **Use Proven Tools**: Only leverage already-established telescoping machinery
3. **Finite Focus**: Convert infinite sums to finite ones via complement
4. **Incremental Build**: Verify each step compiles before proceeding

### Build Verification Protocol
```bash
# After each significant change
lake build PotionProblem.ProbabilityFoundations
# Must succeed before committing any changes
```

## 📋 SESSION EXECUTION CHECKLIST

### Pre-Attack (MANDATORY)
- [ ] Read `tail_probability_formula` context
- [ ] Verify `telescoping_partial_sum` availability 
- [ ] Check `pmf_telescoping` usage pattern
- [ ] Confirm `pmf_eq_zero_of_le_one` signature

### Attack Phase
- [ ] Implement n < 2 case with direct computation
- [ ] Implement n ≥ 2 case with complement decomposition
- [ ] Apply telescoping_partial_sum to finite range [2, n]
- [ ] Verify algebraic simplification: 1 - (1 - 1/n!) = 1/n!

### Verification Phase  
- [ ] Build succeeds: `lake build PotionProblem.ProbabilityFoundations`
- [ ] No new warnings introduced
- [ ] Sorry eliminated: `grep -c "sorry" PotionProblem/ProbabilityFoundations.lean`

### Success Metrics
- [ ] **Primary**: sorry eliminated, build succeeds
- [ ] **Secondary**: `hitting_time_connection` can now be proven
- [ ] **Strategic**: `geometric_interpretation` dependency satisfied

## 🎯 WHY THIS TARGET (NEVER CHANGE)

### Strategic Centrality
- **Blocks 3 downstream theorems** in dependency chain
- **Enables geometric interpretation** connecting discrete → continuous  
- **Mathematical foundation** is completely understood and documented

### Technical Feasibility
- **All dependencies proven** and available
- **Clear mathematical path** via telescoping
- **Manageable complexity** compared to inclusion-exclusion or continuity

### Success Probability: HIGH
- Mathematical approach validated
- Dependencies confirmed available  
- Technical challenges have known solutions
- API issues documented with workarounds

---

**NEXT SESSION INSTRUCTIONS**: 
1. Read this file completely
2. Focus ALL cognitive resources on `tail_probability_formula` ONLY
3. Never deviate from the telescoping approach
4. Use the exact phase structure outlined above
5. Verify build success after each phase
6. Document any new API issues encountered

**REMEMBER**: This is the single most important sorry for project completion. Success here unlocks the entire geometric interpretation connection.