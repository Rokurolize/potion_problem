# Research Prompt: Summable Hitting Time Norm Bound

## Objective
Prove that the hitting time PMF satisfies the norm bound required for summability in the expected value calculation, establishing ∀n, ‖n * hitting_time_pmf n‖ ≤ f(n) for some summable f.

## Mathematical Statement
```lean
lemma summable_hitting_time : 
  Summable (fun n => n * hitting_time_pmf n) := by
  apply Summable.of_norm_bounded _ _
  · sorry  -- Find appropriate bound function
  · sorry  -- Prove the bound holds
```

## Required Deliverables

### 1. PMF Formula Analysis
**Recall the hitting time PMF:**
```lean
hitting_time_pmf n = 
  if n ≤ 1 then 0 
  else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial
```

**Simplified form for n ≥ 2:**
```lean
hitting_time_pmf n = (n - 1 : ℝ) / n.factorial
```

**Thus we need to bound:**
```lean
n * hitting_time_pmf n = n * (n - 1) / n.factorial = (n² - n) / n.factorial
```

### 2. Factorial Growth Analysis
```lean
-- Key insight: n²/n! → 0 very fast
lemma quadratic_div_factorial_bound (n : ℕ) (hn : n ≥ 3) :
  (n² : ℝ) / n.factorial ≤ 2 / (n - 2).factorial := by
  -- For n ≥ 3:
  -- n²/n! = n²/[n*(n-1)*(n-2)!]
  --       = n/[(n-1)*(n-2)!]
  --       ≤ n/[2*(n-2)!]     (since n-1 ≥ 2)
  --       ≤ 2/(n-2)!         (for n ≥ 4)
  -- Handle n = 3 separately
```

### 3. Explicit Bound Construction
```lean
-- Define the bounding function
def hitting_time_bound : ℕ → ℝ
| 0 => 0
| 1 => 0  
| 2 => 2  -- Since 2 * hitting_time_pmf 2 = 2 * 1/2 = 1
| n + 3 => 2 / n.factorial

-- Prove it's summable
lemma summable_hitting_time_bound : Summable hitting_time_bound := by
  -- Split into finite part [0,2] and tail [3,∞)
  have : hitting_time_bound = fun n =>
    if n ≤ 2 then hitting_time_bound n else 2 / (n - 3).factorial := by
    ext n
    cases n with
    | zero => rfl
    | succ n =>
      cases n with
      | zero => rfl
      | succ n =>
        cases n with
        | zero => rfl
        | succ n => simp [hitting_time_bound]
        
  -- Finite part is summable
  -- Tail is 2 * (shifted factorial series) which is summable
  sorry
```

### 4. Norm Bound Verification
```lean
lemma hitting_time_norm_le_bound : 
  ∀ n, ‖(n : ℝ) * hitting_time_pmf n‖ ≤ hitting_time_bound n := by
  intro n
  -- Case split on n
  match n with
  | 0 => simp [hitting_time_pmf, hitting_time_bound]
  | 1 => simp [hitting_time_pmf, hitting_time_bound]
  | 2 => 
    -- Direct calculation: |2 * 1/2| = 1 ≤ 2
    simp [hitting_time_pmf, hitting_time_bound]
    norm_num
  | n + 3 =>
    -- Use quadratic_div_factorial_bound
    simp [hitting_time_pmf, hitting_time_bound]
    rw [norm_mul, norm_coe_nat]
    -- Show (n+3) * (n+2) / (n+3)! ≤ 2 / n!
    sorry
```

### 5. Alternative Approach: Direct Ratio Test
```lean
-- Show series converges by ratio test
lemma hitting_time_ratio_test :
  ∃ (r : ℝ) (hr : r < 1) (N : ℕ), ∀ n ≥ N,
    |((n + 1) : ℝ) * hitting_time_pmf (n + 1)| / |n * hitting_time_pmf n| ≤ r := by
  use 1/2, by norm_num, 4
  intro n hn
  -- Calculate ratio:
  -- [(n+1) * n / (n+1)!] / [n * (n-1) / n!]
  -- = [(n+1) * n * n!] / [n * (n-1) * (n+1)!]
  -- = [(n+1) * n * n!] / [n * (n-1) * (n+1) * n!]
  -- = n / [(n-1) * (n+1)]
  -- = n / (n² - 1)
  -- ≤ n / n² = 1/n ≤ 1/4 < 1/2  (for n ≥ 4)
  sorry
```

### 6. Comparison with Known Series
```lean
-- Compare with factorial series
lemma compare_with_factorial : 
  ∃ C : ℝ, ∀ n ≥ 2, n * hitting_time_pmf n ≤ C / (n - 2).factorial := by
  use 2
  intro n hn
  -- n * (n-1)/n! = (n²-n)/n!
  -- For n ≥ 2: (n²-n)/n! < n²/n! 
  -- We need: n²/n! ≤ 2/(n-2)!
  -- i.e., n²/(n*(n-1)*(n-2)!) ≤ 2/(n-2)!
  -- i.e., n/(n-1) ≤ 2
  -- This holds for n ≥ 2
  sorry
```

### 7. Complete Summability Proof
```lean
theorem summable_hitting_time_complete : 
  Summable (fun n => (n : ℝ) * hitting_time_pmf n) := by
  -- Method 1: Bounded by summable function
  apply Summable.of_norm_bounded hitting_time_bound
  · exact summable_hitting_time_bound
  · exact hitting_time_norm_le_bound
  
  -- Alternative Method 2: Direct ratio test
  -- apply summable_of_ratio_test
  -- exact hitting_time_ratio_test
  
  -- Alternative Method 3: Comparison  
  -- apply Summable.of_nonneg_of_le
  -- · intro n; exact mul_nonneg (Nat.cast_nonneg _) (hitting_time_pmf_nonneg _)
  -- · exact compare_with_factorial
  -- · apply Summable.mul_left
  --   exact summable_shifted_inv_factorial
```

### 8. Expected Value Computation
```lean
-- With summability established, compute E[τ]
theorem expected_hitting_time_converges :
  HasSum (fun n => (n : ℝ) * hitting_time_pmf n) (exp 1) := by
  -- Use summability to guarantee convergence
  have h_sum := summable_hitting_time_complete.hasSum
  
  -- Now show the sum equals e
  -- This connects to the main theorem
  sorry
```

## Lean 4 Technical Aspects

### Norm Properties
```lean
-- Key lemmas for norm manipulation
#check norm_mul  -- ‖x * y‖ = ‖x‖ * ‖y‖
#check norm_coe_nat  -- ‖(n : ℝ)‖ = n
#check abs_of_nonneg  -- For non-negative reals
```

### Summability API
```lean
-- Different ways to prove summability
#check Summable.of_norm_bounded
#check Summable.of_nonneg_of_le  
#check summable_of_ratio_test
#check Summable.of_abs_convergent
```

### Factorial Inequalities
```lean
-- Useful bounds
lemma factorial_growth (n : ℕ) (hn : n ≥ 1) :
  n.factorial ≥ n := by
  -- n! = n * (n-1)! ≥ n * 1 = n

lemma factorial_quadratic_bound (n : ℕ) (hn : n ≥ 3) :
  n.factorial ≥ n * (n - 1) := by
  -- n! = n * (n-1) * (n-2)! ≥ n * (n-1) * 1
```

## Expected Output Format

1. **Complete norm bound proof** (1500-2000 words)
   - Explicit bound function construction
   - Detailed verification of all inequalities
   - Multiple proof methods

2. **Computational verification** (500 words)
   - Numeric checks for small n
   - Ratio test calculations
   - Convergence rate analysis

3. **Connection to main theorem** (500 words)
   - How summability enables E[τ] calculation
   - Link to the final e result

4. **Alternative approaches** (500 words)
   - Abel's test
   - Cauchy condensation
   - Integral test comparison

5. **References**:
   - Real analysis texts on series convergence tests
   - Probability theory on expected values
   - Concrete Mathematics factorial bounds

## Connection to Main Theorem
This lemma appears at line 127 of UniformSumHittingTime.lean and is crucial for justifying the interchange of summation and expectation in the calculation E[τ] = ∑ n * P(τ = n).