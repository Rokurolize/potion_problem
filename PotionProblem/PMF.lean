import Mathlib.Data.Real.Basic
import PotionProblem.Basic

set_option linter.style.commandStart false

/-!
# PMF Properties for the Potion Problem

This module provides the basic properties of the hitting time probability mass function.

## Main Results

- `pmf_nonneg`: The PMF is non-negative
- `prob_tau_eq_zero_one`: P(τ = 0) = P(τ = 1) = 0
- `prob_tau_pos_iff`: P(τ = n) > 0 iff n ≥ 2
- `pmf_eq`: Alternative characterization for n ≥ 2
- `pmf_telescoping`: Telescoping identity

## Interface

Import this for basic PMF properties without heavier analysis.
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

/-- Alternative characterization: PMF equals (n-1)/n! for n ≥ 2 -/
lemma pmf_eq (n : ℕ) (hn : 2 ≤ n) :
  hitting_time_pmf n = (n - 1 : ℝ) / n.factorial := by
  simp [hitting_time_pmf, if_neg (not_le.mpr (by omega : 1 < n))]

/-- Alternative expression for the PMF using the telescoping property -/
lemma pmf_telescoping (n : ℕ) (hn : 2 ≤ n) :
  hitting_time_pmf n = 1 / (n - 1).factorial - 1 / n.factorial := by
  -- This telescoping identity is key to proving the sum equals 1
  -- hitting_time_pmf n = (n-1)/n! = 1/(n-1)! - 1/n!
  rw [pmf_eq n hn]
  -- We need to show: (n-1)/n! = 1/(n-1)! - 1/n!
  -- Rewrite the RHS using common denominator
  have h1 : ((n - 1).factorial : ℝ) ≠ 0 := by
    simp [Nat.factorial_ne_zero]
  have h2 : (n.factorial : ℝ) ≠ 0 := by
    simp [Nat.factorial_ne_zero]
  rw [div_sub_div 1 1 h1 h2]
  -- Now show: (n-1)/n! = (n! - (n-1)!) / ((n-1)! * n!)
  -- Since n! = n * (n-1)!, we have n! - (n-1)! = n*(n-1)! - (n-1)! = (n-1)*(n-1)!
  -- So the RHS becomes: ((n-1)*(n-1)!) / ((n-1)! * n!) = (n-1)/n!
  have fact_eq : (n.factorial : ℝ) = n * (n - 1).factorial := by
    cases n with
    | zero => omega  -- impossible since n ≥ 2
    | succ n => 
      rw [Nat.factorial_succ]
      simp only [Nat.cast_mul]
      congr 1
  rw [fact_eq]
  -- Now we need to show: (n-1)/n! = (n*(n-1)! - (n-1)!) / ((n-1)! * n*(n-1)!)
  field_simp
  ring

/-- The PMF vanishes for n ≤ 1 -/
lemma pmf_eq_zero_of_le_one (n : ℕ) (hn : n ≤ 1) :
  hitting_time_pmf n = 0 := by
  simp [hitting_time_pmf, if_pos hn]

end PotionProblem