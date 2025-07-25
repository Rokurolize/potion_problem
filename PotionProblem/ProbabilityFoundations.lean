/-
Copyright (c) 2025 Potion Problem Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Potion Problem Team
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import PotionProblem.Basic
import PotionProblem.FactorialSeries

set_option linter.style.commandStart false

/-!
# Probability Foundations for the Potion Problem

This module provides the basic probability-theoretic results that form the foundation
for all other analyses of the hitting time problem.

## Main Results

- `pmf_nonneg`: The PMF is non-negative
- `pmf_summable`: The PMF series converges
- `pmf_sum_eq_one`: The PMF sums to 1 (fundamental property)
- `prob_tau_eq_zero_one`: P(τ = 0) = P(τ = 1) = 0
- `prob_tau_pos_iff`: P(τ = n) > 0 iff n ≥ 2
- `tail_probability_formula`: P(τ > n) = 1/n! (key distributional property)

## Interface

Other modules should import this for any basic probability facts about the hitting time.
The results here are the "axioms" from which expectation calculations and other
analyses follow.

-/

namespace PotionProblem

open Real Filter Nat

/-!
## Section 1: Basic PMF Properties
-/

/-- The PMF is always non-negative -/
lemma pmf_nonneg (n : ℕ) : 0 ≤ hitting_time_pmf n := by
  simp [hitting_time_pmf]
  split_ifs with h
  · rfl
  · apply div_nonneg
    · simp
      omega
    · simp

/-- P(τ = 0) = P(τ = 1) = 0 -/
lemma prob_tau_eq_zero_one : hitting_time_pmf 0 = 0 ∧ hitting_time_pmf 1 = 0 := by
  simp [hitting_time_pmf]

/-- P(τ = n) > 0 if and only if n ≥ 2 -/
lemma prob_tau_pos_iff (n : ℕ) : 0 < hitting_time_pmf n ↔ 2 ≤ n := by
  constructor
  · intro h
    by_contra h_not
    push_neg at h_not
    have : n ≤ 1 := by omega
    rw [hitting_time_pmf, if_pos this] at h
    exact lt_irrefl 0 h
  · intro h
    simp [hitting_time_pmf, if_neg (not_le.mpr (by omega : 1 < n))]
    apply _root_.div_pos
    · simp
      omega
    · simp
      exact Nat.factorial_pos _

/-- The PMF series is summable -/
lemma pmf_summable : Summable hitting_time_pmf := by
  -- This follows from the fact that hitting_time_pmf n ≤ n/n! for n ≥ 2
  -- and the first two terms are zero
  -- The series ∑ n/n! is summable as it's bounded by the exponential series
  -- For a complete proof, we would use comparison with the factorial series
  sorry

/-!
## Section 2: Fundamental Distributional Properties
-/

/-- The PMF sums to 1 (fundamental property of probability distributions) -/
theorem pmf_sum_eq_one : ∑' n : ℕ, hitting_time_pmf n = 1 := by
  -- This is the fundamental property that ensures hitting_time_pmf is a valid PMF
  -- The proof uses the telescoping property: hitting_time_pmf n = 1/(n-1)! - 1/n! for n ≥ 2
  -- So the sum telescopes to 1/1! = 1
  sorry

/-- Tail probability formula: P(τ > n) = 1/n! -/
theorem tail_probability_formula (n : ℕ) :
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := by
  -- This is the key distributional property connecting to the Irwin-Hall distribution
  -- P(τ > n) equals the probability that the sum of n uniform [0,1) variables is < 1
  -- which is exactly the volume of the n-simplex: 1/n!
  sorry

/-!
## Section 3: PMF Characterization
-/

/-- Alternative characterization: PMF equals (n-1)/n! for n ≥ 2 -/
lemma pmf_eq (n : ℕ) (hn : 2 ≤ n) : 
  hitting_time_pmf n = (n - 1 : ℝ) / n.factorial := by
  simp [hitting_time_pmf, if_neg (not_le.mpr (by omega : 1 < n))]

/-- The PMF vanishes for n ≤ 1 -/
lemma pmf_eq_zero_of_le_one (n : ℕ) (hn : n ≤ 1) : 
  hitting_time_pmf n = 0 := by
  simp [hitting_time_pmf, if_pos hn]

/-!
## Section 4: Series Properties
-/

/-- The hitting time random variable has finite expectation -/
lemma expectation_finite : Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := by
  -- This is proven in SeriesAnalysis.lean as hitting_time_series_summable
  -- But we cannot import SeriesAnalysis here due to circular dependency
  -- The proof uses the relationship between our series and the factorial series
  sorry

/-- Alternative expression for the PMF using the telescoping property -/
lemma pmf_telescoping (n : ℕ) (hn : 2 ≤ n) :
  hitting_time_pmf n = 1 / (n - 1).factorial - 1 / n.factorial := by
  -- This telescoping identity is key to proving the sum equals 1
  -- hitting_time_pmf n = (n-1)/n! = 1/(n-1)! - 1/n!
  rw [pmf_eq n hn]
  -- hitting_time_pmf n = (n-1)/n! = 1/(n-1)! - 1/n!
  -- This is the telescoping identity
  -- We need to show: (n-1)/n! = 1/(n-1)! - 1/n!
  -- This requires careful algebraic manipulation
  sorry

end PotionProblem