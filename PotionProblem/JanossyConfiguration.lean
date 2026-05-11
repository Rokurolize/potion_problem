import PotionProblem.SeriesAnalysis

/-!
# Janossy Configuration Certificate

This module records the deterministic scalar identity behind the
Poisson point-process presentation of the potion problem.

The surviving length-`n` prefixes are sent by cumulative sums to the ordered
configuration chamber

`0 < t_1 < ... < t_n < 1`.

That chamber has mass `1 / n!`.  In a unit-rate Poisson process on `[0, 1]`,
the ordered Janossy density is `exp (-1)` times this chamber mass.  Since the
Poisson process is normalized, multiplying the whole surviving-prefix
partition function by `exp (-1)` gives `1`, so the partition function is
`exp 1`.

The file intentionally does not formalize Poisson point processes.  It
formalizes the algebraic normalization identity that the Janossy proof uses.
-/

namespace PotionProblem

open Real Nat

/-- Mass of the ordered configuration chamber `0 < t_1 < ... < t_n < 1`. -/
noncomputable def orderedConfigurationMass (n : ℕ) : ℝ :=
  (1 : ℝ) / n.factorial

/-- The grand-canonical mass of all surviving ordered prefixes. -/
noncomputable def survivingPrefixPartitionFunction : ℝ :=
  ∑' n : ℕ, orderedConfigurationMass n

/-- The ordered Janossy density factor for a unit-rate Poisson process on `[0, 1]`. -/
noncomputable def unitIntervalJanossyFactor : ℝ :=
  exp (-1)

/-- The chamber-mass formulation is the exponential series at one. -/
theorem survivingPrefixPartitionFunction_eq_exp :
    survivingPrefixPartitionFunction = exp 1 := by
  unfold survivingPrefixPartitionFunction orderedConfigurationMass
  exact exp_series_connection

/-- The unit-rate Poisson Janossy masses over all ordered chambers normalize to one. -/
theorem unitIntervalJanossy_normalization :
    ∑' n : ℕ, unitIntervalJanossyFactor * orderedConfigurationMass n = 1 := by
  unfold unitIntervalJanossyFactor orderedConfigurationMass
  rw [tsum_mul_left]
  rw [exp_series_connection]
  rw [← Real.exp_add]
  norm_num

/-- Equivalently, the surviving-prefix partition function is the inverse of the Poisson void factor. -/
theorem survivingPrefixPartitionFunction_mul_void_factor :
    unitIntervalJanossyFactor * survivingPrefixPartitionFunction = 1 := by
  unfold unitIntervalJanossyFactor
  rw [survivingPrefixPartitionFunction_eq_exp]
  rw [← Real.exp_add]
  norm_num

end PotionProblem
