# Research Prompt: Hitting Time PMF Sums to Unity

## Objective
Prove that the probability mass function for the hitting time τ = min{n : S_n ≥ 1} sums to 1, where S_n is the sum of n uniform [0,1) random variables.

## Mathematical Statement
```lean
theorem hitting_time_pmf_sum_one :
  ∑' n : ℕ, (if n ≤ 1 then 0 else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial) = 1
```

## Required Deliverables

### 1. Probabilistic Interpretation
**PMF Definition:**
```
P(τ = n) = {
  0                           if n = 0 (impossible: S_0 = 0 < 1)
  0                           if n = 1 (impossible: S_1 ~ U[0,1) < 1 w.p. 1)
  P(S_{n-1} < 1) - P(S_n < 1) if n ≥ 2
}
```

**Key Properties:**
- τ is a well-defined stopping time
- P(τ < ∞) = 1 (almost sure finiteness)
- PMF must sum to 1 by probability axioms

### 2. Direct Telescoping Proof
```lean
-- The PMF is exactly the telescoping series we've analyzed
have pmf_form : ∀ n, (if n ≤ 1 then 0 else 1/(n-1).factorial - 1/n.factorial) = 
                     prob_hitting_time n := by
  intro n
  unfold prob_hitting_time
  split_ifs with h
  · -- n ≤ 1: Both are 0
    rfl
  · -- n ≥ 2: Apply Irwin-Hall formula
    push_neg at h
    have hn : n ≥ 2 := by omega
    rw [prob_sum_less_than_one (n-1), prob_sum_less_than_one n]
    -- Simplify factorial expressions

-- Apply the established telescoping result
exact factorial_telescoping_sum_one
```

### 3. Measure-Theoretic Approach
```lean
-- View as probability measure on ℕ
def hitting_time_measure : MeasureTheory.Measure ℕ :=
  MeasureTheory.Measure.sum (fun n => 
    if n ≤ 1 then 0 else ((n-1)/n.factorial) • MeasureTheory.Measure.dirac n)

-- Prove it's a probability measure
lemma hitting_time_is_prob_measure : 
  MeasureTheory.IsProbabilityMeasure hitting_time_measure := by
  -- Show total mass is 1
```

### 4. Generating Function Method
**Probability Generating Function:**
```
G(s) = ∑_{n=0}^∞ P(τ = n)s^n
     = ∑_{n=2}^∞ [(n-1)/n!]s^n
```

**At s=1:**
```
G(1) = ∑_{n=2}^∞ (n-1)/n! = ∑_{n=2}^∞ [1/(n-1)! - 1/n!] = 1
```

**Connection to Laplace Transform:**
```
L[τ](s) = E[e^{-sτ}] = G(e^{-s})
```

### 5. Renewal Theory Perspective
**First Passage Time:**
- τ is the first passage time above level 1
- By renewal theory, P(τ < ∞) = 1
- The PMF must normalize to 1

**Mean Calculation Check:**
```lean
-- Verify E[τ] = e is consistent
have mean_check : ∑' n : ℕ, n * prob_hitting_time n = exp 1 := by
  -- This is our main theorem
  exact uniform_sum_hitting_time_expectation
  
-- If PMF sums to 1, then E[τ] is well-defined
```

### 6. Combinatorial Verification
**Inclusion-Exclusion:**
```
P(τ = n) = P(max{U_1,...,U_{n-1}} < 1 and U_1+...+U_n ≥ 1)
```

**Order Statistics:**
- Connection to uniform order statistics
- Beta distribution relationships

### 7. Numerical Validation
```lean
-- Compute cumulative probabilities
def cumulative_prob (N : ℕ) : ℚ :=
  (List.range (N+1)).map (fun n => 
    if n ≤ 1 then 0 else (n-1 : ℚ)/n.factorial) |>.sum

#eval cumulative_prob 10   -- Should be very close to 1
#eval cumulative_prob 20   -- Should be even closer to 1
#eval 1 - cumulative_prob 20  -- Tail probability

-- Verify individual probabilities are valid
#eval (List.range 20).map (fun n => 
  let p := if n ≤ 1 then 0 else (n-1 : ℚ)/n.factorial
  0 ≤ p ∧ p ≤ 1) |>.all id  -- All should be true
```

### 8. Alternative Series Representations
```lean
-- Method 1: As difference of exponential series
have alt1 : ∑' n : ℕ, prob_hitting_time n = 
            ∑' n : ℕ, 1/(n+1).factorial - ∑' n : ℕ, 1/(n+2).factorial := by
  -- Split and reindex

-- Method 2: Using incomplete gamma function
-- P(τ > n) = P(S_n < 1) = γ(n, 1)/Γ(n) = 1/n!
```

## Lean 4 Technical Aspects

### Working with Conditional Sums
- Handle `if n ≤ 1 then 0 else ...` properly
- Use `split_ifs` and case analysis
- Connect to indicator functions

### Probability Axioms
- Non-negativity: Each term ≥ 0
- Normalization: Sum = 1
- Countable additivity

### Connection to Main Results
- Use `factorial_telescoping_sum_one`
- Apply `hitting_time_pmf` characterization
- Verify consistency with E[τ] = e

## Expected Output Format
1. Rigorous probability theory proof (1500-2000 words)
2. Complete Lean 4 implementation
3. Multiple proof approaches (telescoping, measure theory, generating functions)
4. Numerical validation up to n=50
5. Visualization of PMF and CDF
6. References to:
   - Feller's Introduction to Probability Theory
   - Ross's Stochastic Processes
   - Grimmett & Stirzaker's Probability and Random Processes

## Connection to Main Theorem
This verification appears at line 108 of HittingTime.lean and confirms that our PMF is properly normalized, validating the entire probability model.