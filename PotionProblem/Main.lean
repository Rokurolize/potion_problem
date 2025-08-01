import PotionProblem.Basic
import PotionProblem.FactorialSeries
import PotionProblem.ProbabilityFoundations
import PotionProblem.SeriesAnalysis
import PotionProblem.IrwinHallTheory


/-!
# Main Theorem: E[τ] = e

This module contains the main theorem proving that the expected hitting time
for independent uniform [0,1) random variables to sum to at least 1 is exactly e.

## Main Result

- `main_theorem`: E[τ] = e

## Architecture

This file serves as the "executive summary" that imports all the modular components
and states the main result concisely. The detailed proofs are distributed across:

- `ProbabilityFoundations`: Basic PMF properties and distributional results
- `SeriesAnalysis`: Series convergence, reindexing, and telescoping proofs  
- `IrwinHallTheory`: Geometric interpretation via Irwin-Hall distribution
- `FactorialSeries`: Factorial series convergence and limits

-/

namespace PotionProblem

open Real Filter Nat

/-!
## Main Definition and Theorem
-/

/-- The expected hitting time E[τ] = ∑_{n=1}^∞ n · P(τ = n) -/
noncomputable def expected_hitting_time : ℝ :=
  ∑' n : ℕ, n * hitting_time_pmf n

/-- **Main Theorem**: The expected hitting time equals e 
    
This is the central result of the entire formalization. The proof combines:
- Probability theory: PMF properties and summability (ProbabilityFoundations)
- Series analysis: Reindexing and telescoping techniques (SeriesAnalysis)  
- Geometric probability: Connection to simplex volumes (IrwinHallTheory)
-/
theorem main_theorem : expected_hitting_time = exp 1 := by
  -- The proof follows from the fundamental series identity in SeriesAnalysis
  -- which shows that our expectation series equals the exponential series
  unfold expected_hitting_time
  exact main_series_identity

/-!
## Verification and Connections
-/

/-- Verification: The PMF is valid (sums to 1) -/
theorem pmf_verification : ∑' n : ℕ, hitting_time_pmf n = 1 := 
  telescoping_pmf_sum

/-- Verification: The expectation series converges -/
theorem expectation_convergence : Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := 
  hitting_time_series_summable

/-- Connection to geometric probability via Irwin-Hall distribution -/
theorem geometric_connection (n : ℕ) :
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = simplex_volume n :=
  geometric_interpretation n

/-- Alternative expression: E[τ] = ∑ 1/n! -/
theorem alternative_expression : 
  expected_hitting_time = ∑' n : ℕ, (1 : ℝ) / n.factorial := by
  rw [main_theorem]
  exact exp_series_connection.symm

/-!
## Numerical Value
-/

/-- The numerical value: E[τ] ≈ 2.71828... -/
theorem numerical_value : expected_hitting_time = exp 1 := main_theorem

end PotionProblem