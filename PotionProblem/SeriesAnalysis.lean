/-
Copyright (c) 2025 Potion Problem Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Potion Problem Team
-/
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.Normed.Algebra.Exponential
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import PotionProblem.Basic
import PotionProblem.FactorialSeries
import PotionProblem.ProbabilityFoundations

set_option linter.style.commandStart false

/-!
# Series Analysis for the Potion Problem

This module contains the series convergence and telescoping proofs that form the analytical
foundation for computing the expected hitting time.

## Main Results

- `hitting_time_series_summable`: The expectation series ∑ n · P(τ = n) converges
- `hitting_time_formula`: Formula relating n · P(τ = n) to factorial series  
- `series_reindexing`: Key reindexing lemma connecting to exponential series
- `telescoping_series_identity`: The telescoping property of the PMF
- `exp_series_connection`: Connection to exp(1) = ∑ 1/n!

## Interface

This module provides the analytical machinery needed for the main theorem proof.
The results here bridge between the probability foundations and the final calculation.

-/

namespace PotionProblem

open Real Filter Nat

/-!
## Section 1: Expectation Series Convergence
-/

-- Import the hitting_time_formula and hitting_time_zero from ProbabilityFoundations
-- These are now available from the imported module

/-- The hitting time expectation series is summable -/
theorem hitting_time_series_summable :
  Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := by
  -- Strategy: Use the formula n * hitting_time_pmf n = 1/(n-2)! for n ≥ 2
  -- and show this is essentially the factorial series with index shift
  -- The first two terms are zero, so we can use summable_nat_add_iff
  
  rw [← summable_nat_add_iff 2]
  -- Now we need to show (fun n => (n+2) * hitting_time_pmf (n+2)) is summable
  -- By hitting_time_formula, this equals (fun n => 1/n!)
  convert summable_inv_factorial using 1
  ext n
  exact hitting_time_formula (n + 2) (by omega)

/-!
## Section 2: Series Reindexing and Telescoping
-/

/-- Key reindexing lemma: The expectation series equals the factorial series -/
lemma series_reindexing : 
  ∑' n : ℕ, (n : ℝ) * hitting_time_pmf n = ∑' n : ℕ, (1 : ℝ) / n.factorial := by
  -- This is the heart of the proof: our expectation series is exactly ∑ 1/n!
  -- The proof uses the reindexing established in hitting_time_series_summable
  
  -- Split the sum based on n < 2 vs n ≥ 2
  have h_split : ∑' n : ℕ, (n : ℝ) * hitting_time_pmf n = 
                 ∑' n : ℕ, ((n + 2) : ℝ) * hitting_time_pmf (n + 2) := by
    -- Strategy: Apply summable_sum_add_tsum_nat_add which allows us to reindex
    -- the series by extracting the first k terms and shifting the rest
    have h_eq := Summable.sum_add_tsum_nat_add 2 hitting_time_series_summable
    -- This gives us: ∑' n, f n = ∑ i < 2, f i + ∑' n, f (n + 2)
    
    rw [← h_eq]
    -- Show the finite sum equals zero
    have h_finite_zero : ∑ i ∈ Finset.range 2, (i : ℝ) * hitting_time_pmf i = 0 := by
      simp only [Finset.sum_range_succ, Finset.sum_range_zero]
      rw [hitting_time_zero 0 (by norm_num : 0 < 2)]
      rw [hitting_time_zero 1 (by norm_num : 1 < 2)]
      simp only [add_zero, zero_add]
    
    rw [h_finite_zero, zero_add]
    -- Now we need to show ∑' (i : ℕ), ↑(i + 2) * hitting_time_pmf (i + 2) = ∑' (n : ℕ), (↑n + 2) * hitting_time_pmf (n + 2)
    congr 1
    ext n
    simp only [Nat.cast_add, Nat.cast_two]
  
  rw [h_split]
  -- Now show that the reindexed series equals the factorial series
  -- Each term (n+2) * hitting_time_pmf (n+2) = 1/n! by hitting_time_formula
  congr 1
  ext n
  -- First convert (↑n + 2) to ↑(n + 2)
  have h_cast : (↑n + 2 : ℝ) = ↑(n + 2) := by simp only [Nat.cast_add, Nat.cast_two]
  rw [h_cast]
  -- Now apply hitting_time_formula with argument (n + 2)
  rw [hitting_time_formula (n + 2) (by omega : 2 ≤ n + 2)]
  -- This gives us: (n + 2) * hitting_time_pmf (n + 2) = 1 / (n + 2 - 2).factorial
  -- Since (n + 2 - 2) = n, this equals 1 / n.factorial
  simp only [add_tsub_cancel_right]

/-- Connection to exponential series -/
lemma exp_series_connection : 
  ∑' n : ℕ, (1 : ℝ) / n.factorial = exp 1 := by
  -- This is the fundamental series representation of e
  -- exp(x) = ∑ x^n/n!, so exp(1) = ∑ 1/n!
  rw [Real.exp_eq_exp_ℝ]
  rw [NormedSpace.exp_eq_tsum]
  simp only [one_pow, smul_eq_mul, inv_eq_one_div, mul_one]

/-!
## Section 3: Telescoping Series Properties
-/

/-- The telescoping identity for partial sums -/
lemma telescoping_partial_sum (N : ℕ) :
  ∑ n ∈ Finset.range N, hitting_time_pmf (n + 2) = 
  1 - 1 / (N + 1).factorial := by
  -- The telescoping property: each PMF term can be written as a difference
  -- P(τ = n) = 1/(n-1)! - 1/n! for n ≥ 2
  -- So the partial sum telescopes to 1 - 1/(N+1)!
  
  -- Use the telescoping identity from ProbabilityFoundations
  have h_telescope : ∀ n ≥ 2, hitting_time_pmf n = 1/(n-1).factorial - 1/n.factorial :=
    pmf_telescoping
  
  -- Apply the telescoping identity to each term in the sum
  -- The sum becomes: ∑ n ∈ range N, (1/(n+1)! - 1/(n+2)!)
  -- which telescopes to 1/1! - 1/(N+1)! = 1 - 1/(N+1)!
  
  -- First, apply the telescoping identity to transform each PMF term
  have h_rewrite : ∑ n ∈ Finset.range N, hitting_time_pmf (n + 2) = 
                   ∑ n ∈ Finset.range N, ((1 : ℝ) / (n + 1).factorial - (1 : ℝ) / (n + 2).factorial) := by
    apply Finset.sum_congr rfl
    intro n hn
    exact h_telescope (n + 2) (by omega : 2 ≤ n + 2)
  
  rw [h_rewrite]
  
  -- Now we have: ∑ n ∈ range N, (1/(n+1).factorial - 1/(n+2).factorial)
  rw [Finset.sum_sub_distrib]
  -- Split into: ∑ n ∈ range N, 1/(n+1).factorial - ∑ n ∈ range N, 1/(n+2).factorial
  
  -- Now we need to show this equals 1 - 1/(N+1)!
  -- We'll use the telescoping property of the sums
  
  -- For N = 0, the sums are empty
  by_cases hN : N = 0
  · simp [hN]
  
  -- For N ≥ 1, establish the relationship between the sums
  -- The key insight: The second sum is the first sum shifted by 1
  have h_relation : ∑ k ∈ Finset.range N, (1 : ℝ) / (k + 2).factorial = 
                    ∑ k ∈ Finset.range N, (1 : ℝ) / (k + 1).factorial - 
                    (1 : ℝ) / Nat.factorial 1 + (1 : ℝ) / (N + 1).factorial := by
    -- First, handle the special case N = 1
    by_cases h1 : N = 1
    · subst h1
      simp [Finset.sum_range_one]
      norm_num
    
    -- For N ≥ 2, use index manipulation
    -- The key observation: ∑_{k=0}^{N-1} 1/(k+2)! = ∑_{j=2}^{N+1} 1/j!
    -- And: ∑_{k=0}^{N-1} 1/(k+1)! = ∑_{j=1}^N 1/j!
    -- So: ∑ 1/(k+2)! = (∑_{j=1}^N 1/j!) - 1/1! + 1/(N+1)!
    
    -- First establish the index shift for the second sum
    have h_shift : ∑ k ∈ Finset.range N, (1 : ℝ) / (k + 2).factorial = 
                   ∑ j ∈ (Finset.range (N + 2) \ Finset.range 2), (1 : ℝ) / j.factorial := by
      apply Finset.sum_bij (fun k _ => k + 2)
      · intro k hk
        simp [Finset.mem_range] at hk ⊢
        omega
      · intro k hk; rfl
      · intro a₁ a₂ ha₁ ha₂ h_eq
        -- k + 2 = a₂ + 2 → k = a₂
        omega
      · intro b hb
        simp [Finset.mem_range] at hb
        use b - 2
        simp [Finset.mem_range]
        constructor <;> omega
    
    -- Similarly for the first sum
    have h_shift' : ∑ k ∈ Finset.range N, (1 : ℝ) / (k + 1).factorial = 
                    ∑ j ∈ (Finset.range (N + 1) \ Finset.range 1), (1 : ℝ) / j.factorial := by
      apply Finset.sum_bij (fun k _ => k + 1)
      · intro k hk
        simp [Finset.mem_range] at hk ⊢
        omega
      · intro k hk; rfl
      · intro a₁ a₂ ha₁ ha₂ h_eq
        -- k + 1 = a₂ + 1 → k = a₂
        omega
      · intro b hb
        simp [Finset.mem_range] at hb
        use b - 1
        simp [Finset.mem_range]
        constructor <;> omega
    
    -- Now express these in terms of each other
    rw [h_shift, h_shift']
    
    -- The key insight: range(N+2) \ range(2) = {2,...,N+1}
    --                  range(N+1) \ range(1) = {1,...,N}
    -- So the difference is {1} removed and {N+1} added
    
    -- Split the sets appropriately
    have h_split : Finset.range (N + 2) \ Finset.range 2 = 
                   ({N + 1} : Finset ℕ) ∪ ((Finset.range (N + 1) \ Finset.range 1) \ {1}) := by
      ext x
      simp [Finset.mem_range]
      omega
    
    rw [h_split]
    
    -- Use disjointness and union properties
    have h_disj : Disjoint {N + 1} ((Finset.range (N + 1) \ Finset.range 1) \ {1}) := by
      simp [Finset.disjoint_iff_ne]
      intro a ha b hb
      omega
    
    rw [Finset.sum_union h_disj]
    simp only [Finset.sum_singleton]
    
    -- Show that (range(N+1) \ range(1)) \ {1} = range(N+1) \ range(1) - {1}
    have h_diff : ((Finset.range (N + 1) \ Finset.range 1) \ {1}) = 
                  Finset.range (N + 1) \ Finset.range 2 := by
      ext x
      simp [Finset.mem_range]
      omega
    
    rw [h_diff]
    
    -- Now we need to show: sum over {1,...,N} = 1/1! + sum over {2,...,N}
    have h_split_sum : ∑ j ∈ (Finset.range (N + 1) \ Finset.range 1), (1 : ℝ) / j.factorial = 
                       (1 : ℝ) / Nat.factorial 1 + 
                       ∑ j ∈ (Finset.range (N + 1) \ Finset.range 2), (1 : ℝ) / j.factorial := by
      -- Split off the j=1 term
      have h_split' : Finset.range (N + 1) \ Finset.range 1 = 
                      {1} ∪ (Finset.range (N + 1) \ Finset.range 2) := by
        ext x
        simp [Finset.mem_range]
        omega
      
      rw [h_split']
      
      have h_disj' : Disjoint {1} (Finset.range (N + 1) \ Finset.range 2) := by
        simp [Finset.disjoint_iff_ne]
        intro a ha b hb
        omega
      
      rw [Finset.sum_union h_disj']
      simp only [Finset.sum_singleton]
    
    rw [h_split_sum]
    ring
  
  -- Apply the relation
  rw [h_relation]
  -- Now we have: sum1 - (sum1 - 1/1! + 1/(N+1)!) = 1/1! - 1/(N+1)! = 1 - 1/(N+1)!
  -- Simplify 1/1! = 1/1 = 1
  norm_num
  ring

/-- The telescoping property implies PMF sums to 1 -/
theorem telescoping_pmf_sum : 
  ∑' n : ℕ, hitting_time_pmf n = 1 := by
  -- This follows from the telescoping partial sum taking limit N → ∞
  -- As N → ∞, 1/(N+1)! → 0, so the sum approaches 1
  
  -- Use the decomposition: sum = first two terms + tail sum
  have h_split : ∑' n : ℕ, hitting_time_pmf n = 
                 hitting_time_pmf 0 + hitting_time_pmf 1 + 
                 ∑' n : ℕ, hitting_time_pmf (n + 2) := by
    -- Use the same reindexing technique as in series_reindexing
    have h_eq := Summable.sum_add_tsum_nat_add 2 pmf_summable
    rw [← h_eq]
    -- Expand the finite sum: ∑ i ∈ range 2, hitting_time_pmf i = hitting_time_pmf 0 + hitting_time_pmf 1
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add]
  
  rw [h_split]
  -- First two terms are zero
  have h_zeros := prob_tau_eq_zero_one
  rw [h_zeros.1, h_zeros.2, zero_add, zero_add]
  
  -- Now use telescoping limit
  -- Use the telescoping limit property to show sum equals 1
  sorry

/-!
## Section 4: Main Series Identity
-/

/-- The fundamental series identity underlying the main theorem -/
theorem main_series_identity :
  ∑' n : ℕ, (n : ℝ) * hitting_time_pmf n = exp 1 := by
  -- Combine all the pieces: reindexing + exponential series connection
  calc ∑' n : ℕ, (n : ℝ) * hitting_time_pmf n
      = ∑' n : ℕ, (1 : ℝ) / n.factorial := series_reindexing
    _ = exp 1 := exp_series_connection

end PotionProblem