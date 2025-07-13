# Research Prompt: Complete Calc Proof Chain for Main Result

## Objective
Complete the final calculation chain that proves E[τ] = e by connecting all the established lemmas through a rigorous calc block in Lean 4.

## Mathematical Statement
```lean
theorem main_result : expected_hitting_time = exp 1 := by
  calc expected_hitting_time 
      = ∑' n : ℕ, n * hitting_time_pmf n := by sorry  -- Definition
    _ = ∑' n : ℕ, if n ≤ 1 then 0 else n * ((n - 1 : ℝ) / n.factorial) := by sorry
    _ = ∑' n : {n : ℕ // n ≥ 2}, n * ((n - 1 : ℝ) / n.factorial) := by sorry
    _ = ∑' n : {n : ℕ // n ≥ 2}, ((n : ℝ) - 1) := by sorry
    _ = ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial := by sorry
    _ = ∑' k : ℕ, (1 : ℝ) / k.factorial := by sorry
    _ = exp 1 := by sorry
```

## Required Deliverables

### 1. Step 1: Definition Unfolding
```lean
-- Prove: E[τ] = ∑' n, n * P(τ = n)
lemma expected_value_as_series : 
  expected_hitting_time = ∑' n : ℕ, n * hitting_time_pmf n := by
  -- This should be true by definition
  -- May need to unfold expected_hitting_time
  unfold expected_hitting_time
  -- If defined differently, show equivalence
  rfl
```

### 2. Step 2: PMF Formula Substitution
```lean
-- Expand hitting_time_pmf definition
lemma expand_pmf_in_sum :
  ∑' n : ℕ, n * hitting_time_pmf n = 
  ∑' n : ℕ, if n ≤ 1 then 0 else n * ((n - 1 : ℝ) / n.factorial) := by
  congr 1
  ext n
  simp only [hitting_time_pmf]
  split_ifs with h
  · -- Case n ≤ 1: Both sides are 0
    simp only [mul_zero]
  · -- Case n ≥ 2: Use the formula
    rfl
```

### 3. Step 3: Zero Terms Elimination
```lean
-- Remove zero terms from the sum
lemma eliminate_zero_terms :
  ∑' n : ℕ, if n ≤ 1 then 0 else n * ((n - 1 : ℝ) / n.factorial) =
  ∑' n : {n : ℕ // n ≥ 2}, n * ((n - 1 : ℝ) / n.factorial) := by
  -- Use tsum_subtype or similar
  symm
  apply tsum_subtype
  intro n hn
  -- When n < 2, the term is 0
  simp only [Nat.not_le] at hn
  have : n ≤ 1 := Nat.lt_two.mp hn
  simp [if_pos this]
```

### 4. Step 4: Algebraic Simplification
```lean
-- Key algebraic step: n * (n-1)/n! = 1/(n-2)!
lemma simplify_factorial_expression (n : ℕ) (hn : n ≥ 2) :
  (n : ℝ) * ((n - 1 : ℝ) / n.factorial) = 1 / (n - 2).factorial := by
  -- n * (n-1)/n! = (n-1)/((n-1)!) = 1/(n-2)!
  have h_pos : (n : ℝ) ≠ 0 := by
    norm_cast
    omega
  
  -- Compute step by step
  calc (n : ℝ) * ((n - 1 : ℝ) / n.factorial)
      = (n : ℝ) * (n - 1 : ℝ) / n.factorial := by ring
    _ = (n * (n - 1) : ℕ) / n.factorial := by norm_cast
    _ = (n * (n - 1) : ℕ) / (n * (n - 1).factorial) := by
        rw [← Nat.factorial_succ, Nat.succ_eq_add_one]
        congr 1
        omega
    _ = ((n * (n - 1) : ℕ) : ℝ) / ((n : ℝ) * (n - 1).factorial) := by norm_cast
    _ = (n - 1 : ℝ) / (n - 1).factorial := by
        field_simp
        ring
    _ = 1 / (n - 2).factorial := by
        have : n - 1 ≥ 1 := by omega
        rw [div_eq_iff (factorial_pos _)]
        rw [one_mul]
        have : (n - 1 : ℕ) = (n - 2).succ := by omega
        rw [this, Nat.factorial_succ]
        norm_cast
        ring
```

### 5. Step 5: Apply Simplification
```lean
lemma apply_simplification :
  ∑' n : {n : ℕ // n ≥ 2}, n * ((n - 1 : ℝ) / n.factorial) =
  ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial := by
  congr 1
  ext ⟨n, hn⟩
  exact simplify_factorial_expression n hn
```

### 6. Step 6: Series Reindexing
```lean
-- Apply the n-2 reindexing theorem
lemma reindex_to_standard_form :
  ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial =
  ∑' k : ℕ, (1 : ℝ) / k.factorial := by
  -- This is exactly reindex_factorial_series from SeriesReindexing.lean
  exact reindex_factorial_series
```

### 7. Step 7: Exponential Series Recognition
```lean
-- Standard result: ∑ 1/k! = e
lemma factorial_series_is_exp :
  ∑' k : ℕ, (1 : ℝ) / k.factorial = exp 1 := by
  -- This should be in Mathlib
  exact exp_series_div_factorial 1
```

### 8. Complete Calc Chain
```lean
theorem main_result_complete : expected_hitting_time = exp 1 := by
  calc expected_hitting_time 
      = ∑' n : ℕ, n * hitting_time_pmf n := 
        expected_value_as_series
    _ = ∑' n : ℕ, if n ≤ 1 then 0 else n * ((n - 1 : ℝ) / n.factorial) := 
        expand_pmf_in_sum
    _ = ∑' n : {n : ℕ // n ≥ 2}, n * ((n - 1 : ℝ) / n.factorial) := 
        eliminate_zero_terms
    _ = ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial := 
        apply_simplification
    _ = ∑' k : ℕ, (1 : ℝ) / k.factorial := 
        reindex_to_standard_form
    _ = exp 1 := 
        factorial_series_is_exp
```

### 9. Alternative Direct Approach
```lean
-- More direct calculation
theorem main_result_direct : expected_hitting_time = exp 1 := by
  unfold expected_hitting_time
  -- E[τ] = ∑_{n=2}^∞ n * P(τ = n)
  --      = ∑_{n=2}^∞ n * (n-1)/n!
  --      = ∑_{n=2}^∞ 1/(n-2)!
  --      = ∑_{k=0}^∞ 1/k!
  --      = e
  
  conv => 
    lhs
    -- Transform the sum step by step
    
  simp only [hitting_time_pmf]
  -- Continue transformation...
```

### 10. Verification Steps
```lean
-- Verify each equality numerically
def verify_calc_step (N : ℕ) : List (ℚ × ℚ × Bool) :=
  List.range N |>.map fun n =>
    let term1 := n * hitting_time_pmf_rat n
    let term2 := if n ≤ 1 then 0 else (n * (n - 1) : ℚ) / n.factorial
    let term3 := if n < 2 then 0 else (1 : ℚ) / (n - 2).factorial
    (term1, term3, term1 = term3)

#eval verify_calc_step 10
-- Should show agreement for all terms
```

## Lean 4 Technical Aspects

### Calc Mode Best Practices
- Each step must type-check independently
- Use explicit lemma names for clarity
- Break complex steps into smaller ones

### Type Coercion Handling
```lean
-- Be careful with Nat to Real coercions
example (n : ℕ) : ((n : ℝ) - 1 : ℝ) = ((n - 1 : ℕ) : ℝ) := by
  -- Only true when n ≥ 1!
  sorry
```

### Subtype Manipulations
```lean
-- Working with {n : ℕ // n ≥ 2}
example (f : ℕ → ℝ) : 
  (fun n : {n : ℕ // n ≥ 2} => f n.val) = 
  (fun n : {n : ℕ // n ≥ 2} => f n) := by
  -- Coercion is implicit
  rfl
```

## Expected Output Format

1. **Complete calc proof** (1200-1500 words)
   - Every step fully justified
   - No remaining sorries
   - Clear mathematical narrative

2. **Alternative proof strategies** (500 words)
   - Direct computation approach
   - Using generating functions
   - Probabilistic interpretation

3. **Edge case analysis** (300 words)
   - Why n = 0, 1 terms vanish
   - Convergence justification
   - Domain considerations

4. **Pedagogical explanation** (500 words)
   - Intuition for why E[τ] = e
   - Connection to Poisson process
   - Geometric interpretation

5. **References**:
   - Feller's probability theory
   - Concrete Mathematics summation techniques  
   - Lean 4 calc mode documentation

## Connection to Main Theorem
This is the culmination at line 152 of UniformSumHittingTime.lean, bringing together all the lemmas to prove the main result that the expected hitting time equals e.