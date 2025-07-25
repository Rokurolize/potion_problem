# Immediate Action Plan for PotionProblem

*Generated: 2025-07-25*  
*Status: SeriesAnalysis.lean now builds! IrwinHallTheory.lean has new build errors*

## 🚨 Priority 1: Fix IrwinHallTheory.lean Build Errors

### Error 1: Line 130 - `introN` tactic failure
**Problem**: `intro h` expects to introduce a hypothesis from `0 ≤ x ∧ (x = 0 → n = 0)` but the tactic name is wrong.

**Fix**:
```lean
-- Line 130: Replace
intro h
-- With:
constructor
```

### Error 2: Line 164 - Function expected at `h2`
**Problem**: `h2` is being used as a function but it's a proposition `x < 0`.

**Fix**:
```lean
-- Line 164: The logic is confused. In the neg branch, h2 is `¬(x ≥ n)`, so x < n
-- Replace lines 163-164 with:
have : n = 0 := Nat.eq_zero_of_not_pos h2
```

### Error 3: Line 167 - Type mismatch in `absurd`
**Problem**: `h1` has type `0 ≤ x` but `absurd` expects `¬x < 0`.

**Fix**:
```lean
-- Line 167: Replace
exact absurd h h1
-- With:
exact absurd h (not_lt.mpr h1)
```

## 🔧 Priority 2: Fix Circular Dependencies

### Step 1: Move `hitting_time_formula` to ProbabilityFoundations.lean

**Add to ProbabilityFoundations.lean** (after `pmf_telescoping`):
```lean
/-- Key formula: For n ≥ 2, n * hitting_time_pmf n = 1/(n-2)! -/
theorem hitting_time_formula (n : ℕ) (hn : 2 ≤ n) : 
  (n : ℝ) * hitting_time_pmf n = 1 / (n - 2).factorial := by
  rw [pmf_eq n hn]
  simp only [mul_div_assoc']
  -- Goal: n * (n - 1) / n! = 1 / (n - 2)!
  rw [div_eq_iff (Nat.factorial_ne_zero n)]
  rw [one_div_mul_eq_div_self]
  -- Goal: n * (n - 1) = n! / (n - 2)!
  have h1 : n! = n * (n - 1)! := by
    cases' n with n
    · omega
    rw [Nat.factorial_succ]
    congr 1
    omega
  have h2 : (n - 1)! = (n - 1) * (n - 2)! := by
    have : n - 1 ≥ 1 := by omega
    cases' (n - 1) with m
    · omega
    rw [Nat.factorial_succ]
    congr 1
    omega
  rw [← h1, h2]
  ring

/-- For n < 2, n * hitting_time_pmf n = 0 -/
theorem hitting_time_zero (n : ℕ) (hn : n < 2) : 
  (n : ℝ) * hitting_time_pmf n = 0 := by
  cases n with
  | zero => simp [hitting_time_pmf]
  | succ n' =>
    cases n' with
    | zero => simp [hitting_time_pmf]
    | succ n'' => omega
```

### Step 2: Update SeriesAnalysis.lean

**Replace the duplicate definitions** (lines 46-71) with:
```lean
-- Import the formulas from ProbabilityFoundations
open ProbabilityFoundations
```

**Update line 85**:
```lean
exact hitting_time_formula (n + 2) (by omega)
```

**Update lines 132-133**:
```lean
have h_telescope := pmf_telescoping
```

## 📋 Priority 3: Sorry Resolution Order

### Phase 1: ProbabilityFoundations.lean (3 sorries) - FOUNDATION

1. **`pmf_telescoping` (line 97)** - EASIEST
   - Use: `pmf_eq` and algebraic manipulation
   - Key: `(n-1)/n! = 1/(n-1)! - 1/n!`

2. **`tail_probability_induction` (line 165)** - MEDIUM
   - Use: Strong induction on n
   - Key: Relationship between consecutive tail probabilities

3. **`pmf_sum_eq_one` (line 130)** - HARDEST
   - Depends on: `pmf_telescoping` 
   - Use: Telescoping series limit

### Phase 2: SeriesAnalysis.lean (6 sorries) - ANALYSIS

4. **`hitting_time_formula` (line 54)** - DELETE
   - Action: Remove after moving to ProbabilityFoundations

5. **`series_reindexing` first sorry (line 102)** - EASY
   - Use: `hitting_time_zero` lemma
   - Key: First two terms are zero

6. **`series_reindexing` second sorry (line 108)** - MEDIUM
   - Use: Index shifting with `tsum_eq_zero_add`
   - Key: Careful tracking of indices

7. **`telescoping_partial_sum` (line 136)** - MEDIUM
   - Use: Finite telescoping sum formula
   - Key: Induction on N

8. **`telescoping_pmf_sum` first sorry (line 188)** - EASY
   - Use: `tsum_eq_zero_add` twice
   - Key: Split first two terms

9. **`telescoping_pmf_sum` second sorry (line 197)** - HARD
   - Use: Limit of telescoping partial sums
   - Key: `tendsto_inv_factorial_zero`

### Phase 3: IrwinHallTheory.lean (4 sorries) - THEORY

10. **`irwin_hall_pdf_formula` (line 72)** - COMPLEX
    - Mathematical content: Derivative of inclusion-exclusion
    - Requires: Careful case analysis

11. **`irwin_hall_special_case` (line 84)** - EASY
    - Just plug in the formula for x = 1
    - Should evaluate to 1/n!

12. **`irwin_hall_support` first sorry (line 157)** - MEDIUM
    - Show formula is positive for x > 0
    - Use: Properties of binomial coefficients

13. **`irwin_hall_support` second sorry (line 174)** - EASY
    - Show 0^n = 0 for n > 0
    - Direct calculation

## 🎯 Execution Strategy

### Day 1: Emergency Build Fix (30 minutes)
1. Fix the 3 build errors in IrwinHallTheory.lean
2. Verify `lake build` succeeds
3. Commit: "Fix build errors in IrwinHallTheory"

### Day 2: Dependency Cleanup (1 hour)
1. Move `hitting_time_formula` to ProbabilityFoundations.lean
2. Update SeriesAnalysis.lean to use imported version
3. Delete duplicate definitions
4. Verify no circular dependencies
5. Commit: "Resolve circular dependencies"

### Day 3-5: Sorry Resolution (2-3 hours per day)
- Follow the numbered order above
- Each sorry gets its own commit
- Run tests after each resolution

## 💡 Quick Wins

These sorries can be fixed in under 10 minutes each:
- `hitting_time_formula` in SeriesAnalysis (just delete it)
- `irwin_hall_support` second sorry (line 174)
- `series_reindexing` first sorry (line 102)
- `telescoping_pmf_sum` first sorry (line 188)

## 🔍 Verification Commands

After each change:
```bash
# Quick build check
lake build PotionProblem.[ModuleName]

# Full build
lake build

# Check sorry count
grep -n "sorry" ./PotionProblem/*.lean | wc -l

# Run tests
lake build PotionProblem.ComprehensiveTests
```

## 📝 Commit Message Templates

```
Fix: [IrwinHallTheory] Correct tactic usage in irwin_hall_support

Fix: [Dependencies] Move hitting_time_formula to ProbabilityFoundations

Proof: [ProbabilityFoundations] Complete pmf_telescoping using algebra

Refactor: [SeriesAnalysis] Remove duplicate hitting_time_formula
```

---

**Remember**: The main theorem is already proven! We're just cleaning up the supporting infrastructure. Take it one step at a time, and the codebase will be sorry-free soon.