import PotionProblem.Main
import PotionProblem.KilledPotential
import PotionProblem.JanossyConfiguration
import PotionProblem.IrwinHallTheory

/-!
# Solution Zoo

This module collects six deliberately different presentations of the same
potion-problem value.  The names are intentionally informal; each theorem is a
small verified hook for a different exposition style.

The accompanying prose guide is `SolutionZoo.md`.
-/

namespace PotionProblem

open Real Nat
open scoped BigOperators

/-!
## The six styles
-/

/-- Mass of one Yule lineage with `n` births before time one. -/
noncomputable def yuleLineageMass (n : ℕ) : ℝ :=
  orderedConfigurationMass n

/-- Expected population shadow of a unit-rate Yule process at time one. -/
noncomputable def yuleExpectedPopulation : ℝ :=
  ∑' n : ℕ, yuleLineageMass n

/-- The Yule lineage masses are the same ordered-chamber masses used by the Janossy proof. -/
theorem yuleLineageMass_eq_orderedConfigurationMass (n : ℕ) :
    yuleLineageMass n = orderedConfigurationMass n := by
  rfl

/-- The Yule mean population at time one is `exp 1`. -/
theorem yuleExpectedPopulation_eq_exp :
    yuleExpectedPopulation = exp 1 := by
  unfold yuleExpectedPopulation yuleLineageMass
  exact survivingPrefixPartitionFunction_eq_exp

/-- The "interesting" solution: reinterpret the prefix partition function as Yule growth. -/
theorem mostInterestingYuleBranchingSolution :
    yuleExpectedPopulation = exp 1 :=
  yuleExpectedPopulation_eq_exp

/-- The Janossy normalization remains as the compact Poisson version of the same idea. -/
theorem mostInterestingJanossySolution :
    unitIntervalJanossyFactor * survivingPrefixPartitionFunction = 1 :=
  survivingPrefixPartitionFunction_mul_void_factor

/-- The "boring" solution: do no mathematics here; just re-export the theorem already proved. -/
theorem mostBoringAliasSolution :
    expected_hitting_time = exp 1 :=
  main_theorem

/-- The slightly less boring PMF table calculation reduces the expectation to the factorial series. -/
theorem mostBoringPmfSeriesSolution :
    expected_hitting_time = ∑' n : ℕ, (1 : ℝ) / n.factorial :=
  alternative_expression

/-- The exponential itself satisfies the Volterra value equation. -/
theorem exp_satisfies_volterraValueEquation (r : ℝ) :
    exp r = 1 + killedKernel exp r := by
  rw [killedKernel_exp]
  ring

/-- The "elegant" solution: one Green-kernel mass identity is the whole computation. -/
theorem mostElegantGreenSolution :
    adjointGreen 1 (fun _ => 1) = exp 1 :=
  potion_green_mass

/-- The same elegant core read as the remaining-distance value equation. -/
theorem mostElegantVolterraValueEquation :
    exp 1 = 1 + killedKernel exp 1 :=
  exp_satisfies_volterraValueEquation 1

/-- The "short" solution: the ordered-prefix partition function is exactly the exponential series. -/
theorem shortestPartitionFunctionSolution :
    survivingPrefixPartitionFunction = exp 1 :=
  survivingPrefixPartitionFunction_eq_exp

/-- Short-form bridge from the partition function back to the main expected value. -/
theorem expectedHittingTime_eq_survivingPrefixPartitionFunction :
    expected_hitting_time = survivingPrefixPartitionFunction := by
  rw [main_theorem, survivingPrefixPartitionFunction_eq_exp]

/-- Scalar shadow of the "confusing" first-ascent/first-descent distribution transfer. -/
noncomputable def firstAscentRunTailMass (n : ℕ) : ℝ :=
  orderedConfigurationMass n

/-- The first-ascent tail mass is just the ordered chamber mass. -/
theorem firstAscentRunTailMass_eq_orderedConfigurationMass (n : ℕ) :
    firstAscentRunTailMass n = orderedConfigurationMass n := by
  rfl

/-- The confusing transfer has the same `1 / n!` tail chamber as the original survival event. -/
theorem mostConfusingFirstAscentShadow (n : ℕ) :
    firstAscentRunTailMass n = simplex_volume n := by
  rfl

/-- The whole first-ascent tail sum matches the expected hitting time. -/
theorem expectedHittingTime_eq_firstAscentTailSum :
    expected_hitting_time = ∑' n : ℕ, firstAscentRunTailMass n := by
  rw [expectedHittingTime_eq_survivingPrefixPartitionFunction]
  unfold survivingPrefixPartitionFunction firstAscentRunTailMass
  rfl

/-- The "brute force" approximation: compute the finite killed recursion for `N` steps. -/
noncomputable def bruteForceFiniteHorizonValue (N : ℕ) : ℝ :=
  finiteHorizonValue N 1

/-- The brute-force finite recursion is just the first `N` terms of the exponential series. -/
theorem bruteForceFiniteHorizonValue_eq_partialExp (N : ℕ) :
    bruteForceFiniteHorizonValue N =
      ∑ k ∈ Finset.range N, (1 : ℝ) / k.factorial := by
  unfold bruteForceFiniteHorizonValue
  exact finiteHorizonValue_one_eq_partial_exp N

/-- Tail mass computed by raw repeated integration, with no named distribution. -/
noncomputable def bruteForceTailMass : ℕ → ℝ → ℝ
  | 0, _ => 1
  | n + 1, x => killedKernel (bruteForceTailMass n) x

/-- Repeated integration forces the `x^n / n!` term. -/
theorem bruteForceTailMass_eq_pow_div_factorial (n : ℕ) (x : ℝ) :
    bruteForceTailMass n x = x ^ n / n.factorial := by
  induction n generalizing x with
  | zero =>
      simp [bruteForceTailMass]
  | succ n ih =>
      unfold bruteForceTailMass
      have hK : killedKernel (bruteForceTailMass n) x =
          killedKernel (fun t : ℝ => t ^ n / n.factorial) x := by
        unfold killedKernel
        congr 1
        ext t
        exact ih t
      rw [hK]
      exact integral_monomial_div_factorial n x

/-- At threshold one, the raw repeated integral gives the factorial tail mass. -/
theorem bruteForceTailMass_one_eq_inv_factorial (n : ℕ) :
    bruteForceTailMass n 1 = (1 : ℝ) / n.factorial := by
  rw [bruteForceTailMass_eq_pow_div_factorial]
  simp

/-- Summing every raw repeated integral gives the exponential. -/
theorem bruteForceTailSum_eq_exp :
    (∑' n : ℕ, bruteForceTailMass n 1) = exp 1 := by
  have hterms :
      (fun n : ℕ => bruteForceTailMass n 1) =
        (fun n : ℕ => (1 : ℝ) / n.factorial) := by
    funext n
    exact bruteForceTailMass_one_eq_inv_factorial n
  rw [hterms]
  exact exp_series_connection

/-- The "brute force" solution: raw repeated integration all the way to the infinite sum. -/
theorem mostBruteForceIteratedIntegralSolution :
    (∑' n : ℕ, bruteForceTailMass n 1) = exp 1 :=
  bruteForceTailSum_eq_exp

/-!
## Cross-checks
-/

/-- All six presentations point at the same constant in their verified scalar cores. -/
theorem solutionZoo_mainValue :
    expected_hitting_time = exp 1 :=
  main_theorem

/-- The Janossy partition function equals the main expected value. -/
theorem janossyPartitionFunction_eq_expectedHittingTime :
    survivingPrefixPartitionFunction = expected_hitting_time := by
  rw [survivingPrefixPartitionFunction_eq_exp, main_theorem]

/-- The Yule version also equals the expected hitting time. -/
theorem yuleExpectedPopulation_eq_expectedHittingTime :
    yuleExpectedPopulation = expected_hitting_time := by
  rw [yuleExpectedPopulation_eq_exp, main_theorem]

end PotionProblem
