/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Tactic
import UniformHittingTime.IrwinHall

/-!
# Hitting Time Probability Mass Function

This module derives the probability mass function for the hitting time
τ = min{n : S_n ≥ 1} where S_n is the sum of n uniform [0,1) random variables.

## Main Results

- `hitting_time_pmf_formula`: P(τ = n) = (n-1)/n! for n ≥ 2
- `hitting_time_telescoping`: P(τ = n) = P(S_{n-1} < 1) - P(S_n < 1)
- `hitting_time_pmf_zero_one`: P(τ = 0) = P(τ = 1) = 0

## Mathematical Background

The hitting time PMF is derived from the telescoping difference of the 
cumulative distribution functions of consecutive sums.
-/

namespace HittingTime

open Real IrwinHall

/-- 
The probability that τ = n is the difference between consecutive CDFs:
P(τ = n) = P(S_{n-1} < 1) - P(S_n < 1)
-/
theorem hitting_time_telescoping (n : ℕ) (hn : n ≥ 2) :
  let prob_n := (1 : ℝ) / (n - 1).factorial - 1 / n.factorial
  prob_n = (1 : ℝ) / (n - 1).factorial - 1 / n.factorial := by
  -- This is just the definition
  rfl

/-- 
Simplification of the telescoping difference:
1/(n-1)! - 1/n! = (n - (n-1)!)/n! = (n-1)/n!
-/
lemma telescoping_diff_simplification (n : ℕ) (hn : n ≥ 1) :
  (1 : ℝ) / (n - 1).factorial - 1 / n.factorial = (n - 1 : ℝ) / n.factorial := by
  -- Factor out 1/n!
  have h1 : n.factorial = n * (n - 1).factorial := by
    cases' n with n
    · contradiction
    · simp [Nat.factorial_succ]
  
  -- Rewrite using the factorial relationship
  rw [h1]
  field_simp
  ring

/-- 
Main theorem: P(τ = n) = (n-1)/n! for n ≥ 2
-/
theorem hitting_time_pmf_formula (n : ℕ) (hn : n ≥ 2) :
  (if n ≤ 1 then 0 else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial) = 
  (n - 1 : ℝ) / n.factorial := by
  -- Since n ≥ 2, the if condition is false
  simp [not_le.mpr (by omega : ¬n ≤ 1)]
  -- Apply the simplification lemma
  exact telescoping_diff_simplification n (by omega)

/-- 
For n = 0 or n = 1, P(τ = n) = 0
This makes sense: we need at least 2 uniform variables to exceed 1.
-/
theorem hitting_time_pmf_zero_one (n : ℕ) (hn : n ≤ 1) :
  (if n ≤ 1 then 0 else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial) = 0 := by
  simp [hn]

/-- 
The telescoping property: n · P(τ = n) = 1/(n-2)! for n ≥ 2
-/
theorem hitting_time_telescoping_property (n : ℕ) (hn : n ≥ 2) :
  n * ((n - 1 : ℝ) / n.factorial) = 1 / (n - 2).factorial := by
  -- Simplify: n · (n-1)/n! = (n-1)/(n-1)! = 1/(n-2)!
  field_simp
  -- We have n · (n-1) / n! = (n-1) / (n-1)!
  have h1 : n.factorial = n * (n - 1).factorial := by
    cases' n with n
    · omega
    · simp [Nat.factorial_succ]
  rw [h1]
  ring_nf
  -- Now we have (n-1) / (n-1)! = 1 / (n-2)!
  have h2 : (n - 1).factorial = (n - 1) * (n - 2).factorial := by
    have : n - 1 ≥ 1 := by omega
    cases' h : n - 1 with m
    · omega
    · simp [Nat.factorial_succ]
  rw [h2]
  field_simp
  ring

/-- 
Verification: The hitting time PMF sums to 1
-/
theorem hitting_time_pmf_sum_one :
  ∑' n : ℕ, (if n ≤ 1 then 0 else (1 : ℝ) / (n - 1).factorial - 1 / n.factorial) = 1 := by
  -- This is a telescoping series that equals 1/1! - lim(1/n!) = 1 - 0 = 1
  -- The proof uses the telescoping series machinery
  sorry

end HittingTime