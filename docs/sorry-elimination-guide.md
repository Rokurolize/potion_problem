# Sorry Elimination Guide for PotionProblem

*Created from practical experience eliminating 6+ sorries in the Lean 4 formalization*

## 🎯 Core Principles

### 1. **Fight One Sorry to the Death**
- **Never change targets mid-proof** - Stick with your chosen sorry until completion
- **Design approach thoroughly first** - Plan the entire proof strategy before coding
- **Only build errors can guide you** - Trust compilation feedback over intuition

### 2. **Systematic Target Selection**
- **Dependency-First**: Eliminate sorries that other proofs depend on
- **Foundation-Up**: Start with basic lemmas before complex theorems  
- **File-Focused**: Complete all sorries in one file before moving to another

## 🔧 Pre-Attack Checklist

Before targeting any sorry:

1. **Verify API Existence with LeanExplore**
   ```bash
   uv run leanexplore search "lemma_name" --package Mathlib --limit 5
   uv run leanexplore get [GROUP_ID]  # Get exact signature
   uv run leanexplore dependencies [GROUP_ID]  # Get import requirements
   ```

2. **Check Current Build Status**
   ```bash
   lake build PotionProblem.ModuleName
   ```

3. **Understand the Goal**
   - Read the theorem statement carefully
   - Identify the mathematical strategy needed
   - Check what lemmas are already available

4. **Update Todo List**
   ```bash
   # Mark current sorry as "in_progress"
   # This provides accountability and progress tracking
   ```

## 📚 Technique Library

### Type Conversion Mastery

**Problem**: Mismatched types like `(↑n + 2)` vs `↑(n + 2)`

**Solution Pattern**:
```lean
have h_cast : (↑n + 2 : ℝ) = ↑(n + 2) := by simp only [Nat.cast_add, Nat.cast_two]
rw [h_cast]
```

**Why This Works**: Lean's type system is strict about cast placement. Always convert to the expected form.

### Series Reindexing with `sum_add_tsum_nat_add`

**Problem**: Need to extract first k terms from infinite series

**Correct Pattern**:
```lean
have h_eq := Summable.sum_add_tsum_nat_add k summability_proof
rw [← h_eq]  -- Note the reverse direction!
-- Show finite sum equals desired value
have h_finite : ∑ i ∈ Finset.range k, f i = target_value := by
  -- Proof here
```

**Critical Details**:
- **Argument Order**: `k` first, then summability proof
- **Direction**: Use `← h_eq` (reverse) to get the form you want
- **Finite Sum Simplification**: Use `Finset.sum_range_succ` and `Finset.sum_range_zero`

### Telescoping Series Technique

**Problem**: Prove finite telescoping sum

**Strategy**:
1. **Apply telescoping identity to each term**:
   ```lean
   rw [Finset.sum_congr rfl (fun n hn => telescoping_lemma n proof_of_condition)]
   ```

2. **Split the sum**:
   ```lean
   rw [Finset.sum_sub_distrib]
   ```

3. **Use standard telescoping identity** (may need to prove separately)

### Using `hitting_time_zero` and `hitting_time_formula`

**Pattern for n < 2**:
```lean
rw [hitting_time_zero n (by norm_num : n < 2)]
```

**Pattern for n ≥ 2**:
```lean
rw [hitting_time_formula n (by omega : 2 ≤ n)]
```

**Critical**: Always provide the proof obligation explicitly with `by norm_num` or `by omega`

## ⚠️ Common Pitfalls and Solutions

### 1. API Hallucination Prevention

**Problem**: Using non-existent Mathlib functions
**Solution**: **ALWAYS** verify with LeanExplore before using any API

**Real Example**:
- ❌ `Real.exp_eq_tsum_inv_factorial` (doesn't exist)
- ✅ `NormedSpace.exp_eq_tsum` (verified with LeanExplore)

### 2. Import Path Errors

**Problem**: "Unknown identifier" errors
**Solution**: Use `uv run leanexplore dependencies [GROUP_ID]` to get exact imports

### 3. Argument Order Confusion

**Problem**: Function arguments in wrong order
**Solution**: Check examples from LeanExplore, especially NNReal versions

**Example**: `Summable.sum_add_tsum_nat_add k summability_proof` (not the reverse)

### 4. Rewrite Direction Mistakes

**Problem**: `tactic 'rewrite' failed` errors
**Solution**: 
- Check if you need `rw [lemma]` vs `rw [← lemma]`
- Use `simp only` for normalization before rewriting
- Apply type conversions first when needed

### 5. Proof Obligation Omissions

**Problem**: "unsolved goals" with missing conditions
**Solution**: Always provide explicit proofs for conditions

```lean
-- ❌ hitting_time_formula n
-- ✅ hitting_time_formula n (by omega : 2 ≤ n)
```

## 🚀 Efficient Workflow

### Build-Driven Development

1. **Make minimal change**
2. **Run `lake build` immediately**
3. **Read ALL error messages carefully**
4. **Fix one error at a time**
5. **Never batch changes without testing**

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

## 🎯 File-Specific Strategies

### ProbabilityFoundations.lean
- **Focus**: Basic PMF properties and distributional results
- **Key Lemmas**: `pmf_telescoping`, `hitting_time_formula`
- **Dependencies**: Usually depends only on Basic.lean and mathlib

### SeriesAnalysis.lean  
- **Focus**: Series convergence and reindexing proofs
- **Key Techniques**: `sum_add_tsum_nat_add`, telescoping identities
- **Dependencies**: Uses ProbabilityFoundations heavily

### IrwinHallTheory.lean
- **Focus**: Continuous distribution theory
- **Key Techniques**: Case analysis, inclusion-exclusion
- **Dependencies**: Independent of other project modules

## 🏆 Success Patterns

### High-Success Techniques Used in This Project:

1. **LeanExplore Verification**: 100% prevention of API hallucinations
2. **Systematic Type Handling**: Explicit cast conversions  
3. **`sum_add_tsum_nat_add`**: Perfect for series reindexing
4. **Build-First Development**: Immediate error feedback
5. **Todo Tracking**: Clear progress visibility

### Proven Elimination Sequence:

1. ✅ **`series_reindexing`** (SeriesAnalysis.lean:78) - Key lemma
2. ✅ **`telescoping_pmf_sum` first sorry** (SeriesAnalysis.lean:148) - Foundation
3. 🎯 **`telescoping_partial_sum`** (SeriesAnalysis.lean:135) - Current target

## 🔄 Recovery from Errors

### When Stuck:
1. **Check LeanExplore** for correct API signature
2. **Use `#check`** to verify lemma types
3. **Add intermediate `sorry`** to isolate the issue
4. **Apply type conversions** before complex tactics
5. **Simplify with `simp only`** before rewriting

### When Build Fails:
1. **Read every error message** (don't skip any)
2. **Fix errors in order** they appear
3. **Use `convert` tactic** for goal refinement
4. **Check argument order** for API calls

---

## 💡 Key Insights

**Mathematical**: The Potion Problem requires mastery of series reindexing, telescoping identities, and the connection between discrete PMFs and continuous distributions.

**Technical**: Lean 4 success depends on precise type handling, correct API usage, and systematic build-driven development.

**Strategic**: Focus on dependency chains and complete one file before moving to another.

---

*This guide represents battle-tested knowledge from successfully eliminating multiple sorries in a complex mathematical formalization. Follow these patterns for efficient sorry elimination.*