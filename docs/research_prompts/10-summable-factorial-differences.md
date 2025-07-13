# Research Prompt: Summability of Factorial Difference Series

## Objective
Prove that the series of factorial differences with indicator function is summable in Lean 4, establishing absolute convergence.

## Mathematical Statement
```lean
lemma summable_factorial_diff :
  Summable (fun n : ℕ => if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0)
```

## Required Deliverables

### 1. Absolute Convergence Proof
**Key Observation:**
```
|1/(n-1)! - 1/n!| = |n - 1|/n! = (n-1)/n! ≤ 1/(n-1)!
```

**Domination Argument:**
```lean
-- The series is dominated by ∑ 1/(n-1)! which converges
apply Summable.of_norm_bounded (fun n => if n ≥ 2 then 1/(n-1).factorial else 0) _
· -- Show the bound holds
  intro n
  split_ifs with h
  · -- Case n ≥ 2
    rw [norm_sub, norm_div, norm_div, norm_one, norm_natCast]
    have : |1/(n-1).factorial - 1/n.factorial| = (n-1)/n.factorial := by
      -- Simplify using factorial recurrence
      field_simp
      rw [abs_div, abs_sub]
      -- Show |n.factorial - (n-1).factorial| = (n-1)·(n-1).factorial
    rw [this]
    -- Show (n-1)/n! ≤ 1/(n-1)!
  · -- Case n < 2
    simp
```

### 2. Direct Summability via Comparison Test
```lean
-- Alternative: Use comparison with exponential series
have h1 : Summable (fun n : ℕ => 1/n.factorial) := summable_inv_factorial

-- Our series has only positive terms for n ≥ 2
have h2 : ∀ n ≥ 2, 0 < 1/(n-1).factorial - 1/n.factorial := by
  intro n hn
  rw [sub_pos, div_lt_div_iff]
  -- Show n! < (n-1)! is false, so inequality holds other way
  
-- Split into positive and zero parts
have h3 : (fun n => if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0) =
          (fun n => max 0 (1/(n-1).factorial - 1/n.factorial)) := by
  ext n; split_ifs; simp [max_eq_right]
```

### 3. Telescoping Structure Recognition
```lean
-- The absolute series ∑|aₙ - aₙ₊₁| converges when aₙ → 0 monotonically
have mono : Antitone (fun n => 1/n.factorial) := by
  intro n m hnm
  exact div_le_div_of_nonneg_left zero_le_one (Nat.cast_pos.mpr (Nat.factorial_pos _))
    (Nat.cast_le.mpr (Nat.factorial_le hnm))

-- For monotone sequences, |aₙ - aₙ₊₁| = aₙ - aₙ₊₁
have pos_diff : ∀ n, 0 ≤ 1/n.factorial - 1/(n+1).factorial := by
  intro n
  exact sub_nonneg_of_le (mono (Nat.le_succ n))
```

### 4. Series Decomposition Method
```lean
-- Write as difference of two summable series
have decomp : (fun n => if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0) =
              (fun n => if n ≥ 1 then 1/n.factorial else 0) -
              (fun n => if n ≥ 2 then 1/n.factorial else 0) := by
  ext n
  -- Case analysis on n = 0, 1, or ≥ 2
  
-- Both component series are summable
have sum1 : Summable (fun n => if n ≥ 1 then 1/n.factorial else 0) := by
  -- This is ∑_{n≥1} 1/n! = e - 1
  
have sum2 : Summable (fun n => if n ≥ 2 then 1/n.factorial else 0) := by  
  -- This is ∑_{n≥2} 1/n! = e - 2
  
-- Difference of summable series is summable
exact Summable.sub sum1 sum2
```

### 5. Explicit Bound Computation
```lean
-- Show the sum is bounded by 2
have bound : ∑' n, |if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0| ≤ 2 := by
  calc ∑' n, |if n ≥ 2 then 1/(n-1).factorial - 1/n.factorial else 0|
      ≤ ∑' n, (if n ≥ 2 then 1/(n-1).factorial else 0) := by
          -- Apply the bound |aₙ - aₙ₊₁| ≤ aₙ
      = ∑' n : {n // n ≥ 2}, 1/((n:ℕ)-1).factorial := by
          -- Convert to subtype sum
      = ∑' k : {k // k ≥ 1}, 1/k.factorial := by
          -- Reindex n-1 = k
      = (∑' k : ℕ, 1/k.factorial) - 1 := by
          -- Subtract k=0 term
      = exp 1 - 1 := by
          -- Apply exponential series
      < 2 := by norm_num
```

### 6. Computational Verification
```lean
-- Compute partial sums of absolute values
def abs_partial_sum (N : ℕ) : ℚ :=
  (List.range N).map (fun n => 
    if n ≥ 2 then |(1/(n-1).factorial - 1/n.factorial : ℚ)| else 0) |>.sum

#eval abs_partial_sum 10   -- Should be < 2
#eval abs_partial_sum 20   -- Should converge to finite value

-- Verify the bound holds
#eval (List.range 20).map (fun n => 
  if n ≥ 2 then (n-1 : ℚ)/n.factorial ≤ 1/(n-1).factorial else true) |>.all id
```

## Lean 4 Technical Requirements

### Norm and Absolute Value
- Work with `norm_div`, `norm_sub`
- Use `abs_of_pos` for positive terms
- Apply `norm_natCast` appropriately

### Summability API
- `Summable.of_norm_bounded`
- `Summable.of_abs_convergent`  
- `summable_of_nonneg_of_le`

### Factorial Properties
- `Nat.factorial_succ`
- `Nat.factorial_pos`
- `Nat.factorial_le` for monotonicity

## Expected Output Format
1. Complete summability proof (1200-1500 words)
2. Multiple proof strategies in Lean 4
3. Explicit bounds and convergence rates
4. Numerical verification up to N=50
5. References to:
   - Apostol's Mathematical Analysis
   - Mathlib4 summability documentation
   - Series convergence tests

## Connection to Main Theorem
This lemma appears at line 113 of TelescopingSeries.lean and is essential for justifying the interchange of limits in the telescoping series proof.