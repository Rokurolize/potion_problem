import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Factorial.Basic


/-!
# Basic Definitions for the Potion Problem

This module provides the core definitions for formalizing the expected hitting time problem
where we sum independent uniform [0,1) random variables until the sum exceeds 1.

## Main Definitions

- `hitting_time_pmf`: The probability mass function P(τ = n) = (n-1)/n! for n ≥ 2

-/

namespace PotionProblem

open Real Nat

/-- The probability mass function for the hitting time τ.
    P(τ = n) = (n-1)/n! for n ≥ 2, and 0 otherwise. -/
noncomputable def hitting_time_pmf (n : ℕ) : ℝ :=
  if n ≤ 1 then 0 else (n - 1 : ℝ) / n.factorial

end PotionProblem