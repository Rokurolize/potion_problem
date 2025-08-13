import Mathlib.Topology.Piecewise
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.BigOperators.Basic
import Mathlib.Data.Nat.Choose.Basic

-- Test the Continuous.if approach for irwin_hall_continuous

example : Continuous (fun (x : ℝ) => if x < 0 then (0 : ℝ) else if x ≥ 1 then (1 : ℝ) else x) := by
  -- Apply Continuous.if for the outer if
  apply Continuous.if
  · -- Boundary agreement: at x = 0, both branches should be equal
    intro x hx
    -- hx : x ∈ frontier {y | y < 0}
    -- frontier {y | y < 0} = {0}
    simp at hx
    rw [hx]
    simp
  · -- First branch: constant function 0 is continuous
    exact continuous_const
  · -- Second branch: if x ≥ 1 then 1 else x
    apply Continuous.if
    · -- Boundary agreement: at x = 1
      intro x hx
      -- hx : x ∈ frontier {y | y ≥ 1}
      -- frontier {y | y ≥ 1} = {1}
      simp at hx
      rw [hx]
      simp
    · -- constant function 1 is continuous
      exact continuous_const
    · -- identity function x is continuous
      exact continuous_id

-- More complex test with polynomial
example (n : ℕ) : Continuous (fun (x : ℝ) => 
  if x < 0 then (0 : ℝ) 
  else if x ≥ n then (1 : ℝ) 
  else x^n) := by
  apply Continuous.if
  · -- Boundary at x = 0
    intro x hx
    simp at hx
    rw [hx]
    by_cases hn : n = 0
    · simp [hn]
    · have : (0 : ℝ)^n = 0 := zero_pow hn
      simp [this]
  · exact continuous_const
  · apply Continuous.if
    · -- Boundary at x = n
      intro x hx
      simp at hx
      rw [hx]
      -- Need to show n^n = 1, which is not true in general
      -- This shows the challenge with boundary conditions
      sorry
    · exact continuous_const
    · exact continuous_pow n