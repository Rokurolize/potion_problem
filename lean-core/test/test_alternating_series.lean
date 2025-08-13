import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

-- Test the alternating series approach for irwin_hall_support

-- The sum we need to analyze:
-- ∑ k ∈ Finset.range (⌊x⌋ + 1), (-1)^k * (n choose k) * (x - k)^n

-- Let's test if we can apply the alternating series theorem
example (n : ℕ) (x : ℝ) (hx : 0 < x ∧ x < n) : 
  ∃ (f : ℕ → ℝ), Antitone f ∧ Tendsto f atTop (𝓝 0) := by
  -- Define f(k) = (n choose k) * (x - k)^n for the alternating series
  use fun k => if k ≤ n then (Nat.choose n k : ℝ) * |x - k|^n else 0
  constructor
  · -- Show f is antitone (decreasing)
    intro a b hab
    -- This is not trivial - need to show (n choose a) * |x - a|^n ≥ (n choose b) * |x - b|^n
    -- when a ≤ b. This depends on the value of x and is not always true.
    sorry
  · -- Show f tends to 0
    -- For large k > n, we have (n choose k) = 0, so f(k) = 0
    sorry

-- The actual expression we need to prove positive
example (n : ℕ) (x : ℝ) (hx : 0 < x ∧ x < n) (hn : n > 0) :
  (1 / n.factorial : ℝ) * ∑ k ∈ Finset.range (Int.natAbs ⌊x⌋ + 1), 
    (-1)^k * (Nat.choose n k) * (x - k)^n > 0 := by
  -- This is the core challenge - proving positivity of alternating binomial sums
  -- The alternating series theorem gives convergence but not positivity
  sorry

-- Test a simpler case: n = 2, x = 0.5
example : 
  let n := 2
  let x := (0.5 : ℝ)
  (1 / n.factorial : ℝ) * ∑ k ∈ Finset.range (Int.natAbs ⌊x⌋ + 1), 
    (-1)^k * (Nat.choose n k) * (x - k)^n > 0 := by
  -- For x = 0.5, ⌊x⌋ = 0, so range is {0}
  simp only [Int.floor_eq_zero_iff, Int.natAbs_zero]
  rw [Finset.sum_range_one]
  simp [pow_zero, Nat.choose_zero_right]
  -- We get (1/2!) * 1 * 1 * 0.5^2 = (1/2) * 0.25 = 0.125 > 0
  norm_num