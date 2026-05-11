import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.Normed.Algebra.Exponential
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.Order.Floor
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Order.Filter.AtTopBot.Basic
import PotionProblem.Basic
import PotionProblem.FactorialSeries
import PotionProblem.ProbabilityFoundations


open Filter Topology

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
      simp only [add_zero]
    
    rw [h_finite_zero, zero_add]
    -- Now we need to show ∑' (i : ℕ), ↑(i + 2) * hitting_time_pmf (i + 2) = 
    -- ∑' (n : ℕ), (↑n + 2) * hitting_time_pmf (n + 2)
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
  rw [NormedSpace.exp_eq_tsum ℝ]
  simp only [one_pow, smul_eq_mul, inv_eq_one_div, mul_one]

/-!
## Section 3: Telescoping Series Properties
-/

/-- The telescoping identity for partial sums -/
lemma telescoping_partial_sum (N : ℕ) :
  ∑ n ∈ Finset.range N, hitting_time_pmf (n + 2) = 
  1 - 1 / (N + 1).factorial := by
  -- Use induction on N
  induction N with
  | zero =>
    -- Base case: N = 0, sum is empty
    simp only [Finset.range_zero, Finset.sum_empty]
    -- Need to show: 0 = 1 - 1/1!
    norm_num
  | succ N ih =>
    -- Inductive step: assume true for N, prove for N+1
    rw [Finset.sum_range_succ, ih]
    -- Now we have: (1 - 1/(N+1)!) + hitting_time_pmf (N+2) = 1 - 1/(N+2)!
    -- Note: when n = N in the sum, we get hitting_time_pmf (N + 2)
    
    -- Use pmf_telescoping to expand hitting_time_pmf (N+2)
    rw [pmf_telescoping (N + 2) (by omega : 2 ≤ N + 2)]
    -- This gives us: (1 - 1/(N+1)!) + (1/(N+1)! - 1/(N+2)!) = 1 - 1/(N+2)!
    -- First, simplify N + 2 - 1 = N + 1
    have h_eq : N + 2 - 1 = N + 1 := by omega
    simp only [h_eq]
    -- Now we have: 1 - 1/(N+1)! + (1/(N+1)! - 1/(N+2)!) = 1 - 1/(N+2)!
    -- Rearrange: 1 - 1/(N+1)! + 1/(N+1)! - 1/(N+2)! = 1 - 1/(N+2)!
    -- The middle terms cancel
    ring

/-- The telescoping property implies PMF sums to 1 -/
theorem telescoping_pmf_sum : 
  ∑' n : ℕ, hitting_time_pmf n = 1 := by
  -- Use the decomposition: sum = first two terms + tail sum
  have h_split : ∑' n : ℕ, hitting_time_pmf n = 
                 hitting_time_pmf 0 + hitting_time_pmf 1 + 
                 ∑' n : ℕ, hitting_time_pmf (n + 2) := by
    -- Use reindexing to split the sum
    have h_eq := Summable.sum_add_tsum_nat_add 2 pmf_summable
    rw [← h_eq]
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add]
  
  rw [h_split]
  -- First two terms are zero
  have h_zeros := prob_tau_eq_zero_one
  rw [h_zeros.1, h_zeros.2, zero_add, zero_add]
  
  -- Now show that ∑' n : ℕ, hitting_time_pmf (n + 2) = 1
  -- We use the fact that this follows from the telescoping partial sum
  
  -- The partial sums converge to 1
  have h_partial : ∀ N : ℕ, ∑ n ∈ Finset.range N, hitting_time_pmf (n + 2) = 
    1 - 1 / (N + 1).factorial := telescoping_partial_sum
  
  -- As N → ∞, 1/(N+1)! → 0 
  have h_limit : Tendsto (fun N => (1 : ℝ) / (N + 1).factorial) atTop (𝓝 0) := by
    -- Direct application: 1/(N+1)! → 0
    -- Show that this is just inv_factorial_tendsto_zero composed with successor
    have h : (fun N => (1 : ℝ) / (N + 1).factorial) = 
             (fun n => (1 : ℝ) / n.factorial) ∘ (fun N => N + 1) := by
      ext N
      simp only [Function.comp_apply]
    rw [h]
    exact inv_factorial_tendsto_zero.comp (tendsto_add_atTop_nat 1)
  
  -- Apply the lemma connecting HasSum and partial sum convergence
  have h_hasSum : HasSum (fun n => hitting_time_pmf (n + 2)) 1 := by
    rw [hasSum_iff_tendsto_nat_of_nonneg]
    · -- Show the partial sums converge to 1
      simp_rw [h_partial]
      -- As N → ∞, 1 - 1/(N+1)! → 1
      -- Since h_limit shows 1/(N+1)! → 0, we have 1 - 1/(N+1)! → 1 - 0 = 1
      convert Tendsto.sub tendsto_const_nhds h_limit
      ring
    · -- Show non-negativity
      intro n
      exact pmf_nonneg (n + 2)
  
  exact h_hasSum.tsum_eq

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
