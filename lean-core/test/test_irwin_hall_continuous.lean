import Mathlib.Topology.Piecewise
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Data.Real.Basic

-- Create a simplified version of irwin_hall_cdf to test continuity approach
noncomputable def test_irwin_hall_cdf (n : ℕ) (x : ℝ) : ℝ :=
  if x < 0 then 0
  else if x ≥ n then 1  
  else (1 / n.factorial) * ∑ k ∈ Finset.range (Int.natAbs ⌊x⌋ + 1), 
    (-1)^k * (Nat.choose n k) * (x - k)^n

-- Test the continuity approach
example (n : ℕ) (hn : n > 0) : Continuous (test_irwin_hall_cdf n) := by
  unfold test_irwin_hall_cdf
  -- Apply Continuous.if for the outer if x < 0
  apply Continuous.if
  · -- Boundary agreement at x = 0
    intro x hx
    -- hx says x is in the frontier of {y | y < 0}, which is {0}
    simp at hx
    rw [hx]
    simp only [ite_false, not_lt.mpr (le_refl 0)]
    by_cases h_n_eq_1 : n = 1
    · -- Special case n = 1
      simp [h_n_eq_1]
      norm_num
    · -- Case n ≥ 2
      have h_n_ge_2 : n ≥ 2 := by
        cases' n with n'
        · exact absurd rfl hn
        · cases' n' with n''
          · exact absurd rfl h_n_eq_1
          · omega
      -- For x = 0 and n ≥ 2, we have 0 < n, so we're in the else branch
      have : ¬(0 : ℝ) ≥ n := by
        rw [not_le]
        exact Nat.cast_pos.mpr hn
      simp [this]
      -- The sum at x = 0
      simp only [Int.floor_zero, Int.natAbs_zero]
      rw [Finset.sum_range_one]
      simp [pow_zero, Nat.choose_zero_right]
      -- We get (1/n!) * 1 * 0^n
      have : (0 : ℝ)^n = 0 := zero_pow (ne_of_gt hn)
      simp [this]
  · -- First branch: constant 0
    exact continuous_const
  · -- Second branch: if x ≥ n then 1 else polynomial
    apply Continuous.if
    · -- Boundary agreement at x = n
      intro x hx
      -- hx says x is in the frontier of {y | y ≥ n}, which is {n}
      simp at hx
      rw [hx]
      simp
      -- Need to show the polynomial formula equals 1 at x = n
      -- This requires the mathematical property of the CDF
      sorry
    · -- constant 1 is continuous
      exact continuous_const
    · -- The polynomial part is continuous
      -- This is continuous as a composition of continuous functions:
      -- - Multiplication by constant 1/n!
      -- - Finite sum of continuous functions
      -- - Each term is product of constants and (x - k)^n which is continuous
      sorry