import PotionProblem.SolutionZoo

/-!
# Audience Ladder

This module gives verified Lean hooks for sixteen audience-targeted
presentations of the potion problem.

The prose versions are written, in the same order, in `AudienceLadder.md`.
Each hook reuses an already verified scalar core; the point is not to create
sixteen incompatible proofs, but to expose one result through sixteen levels of
abstraction.
-/

namespace PotionProblem

open Real Nat

/-!
## Ordered audience levels
-/

inductive AudienceLevel where
  | preschool
  | elementary
  | juniorHigh
  | highSchool
  | bachelor
  | master
  | doctor
  | postdoc
  | assistantProfessor
  | associateProfessor
  | professor
  | emeritusProfessor
  | fieldsMedalist
  | chiefActuary
  | iasDirector
  | chiefDataOfficer
  deriving DecidableEq, Repr

/-- The requested ladder has sixteen levels. -/
def audienceLadderLength : ℕ := 16

theorem audienceLadderLength_eq :
    audienceLadderLength = 16 := by
  rfl

/-- Rank in the requested top-to-bottom order. -/
def AudienceLevel.rank : AudienceLevel → ℕ
  | preschool => 1
  | elementary => 2
  | juniorHigh => 3
  | highSchool => 4
  | bachelor => 5
  | master => 6
  | doctor => 7
  | postdoc => 8
  | assistantProfessor => 9
  | associateProfessor => 10
  | professor => 11
  | emeritusProfessor => 12
  | fieldsMedalist => 13
  | chiefActuary => 14
  | iasDirector => 15
  | chiefDataOfficer => 16

theorem audienceLevel_first_rank :
    AudienceLevel.rank AudienceLevel.preschool = 1 := by
  rfl

theorem audienceLevel_last_rank :
    AudienceLevel.rank AudienceLevel.chiefDataOfficer = 16 := by
  rfl

/-!
## Sixteen verified hooks
-/

/-- 1. Preschool-child-level hook: the answer is the already verified value. -/
theorem preschoolChildSolution :
    expected_hitting_time = exp 1 :=
  main_theorem

/-- 2. Elementary-level hook: the answer is the total mass of all living prefixes. -/
theorem elementaryGraduateSolution :
    expected_hitting_time = survivingPrefixPartitionFunction := by
  exact expectedHittingTime_eq_survivingPrefixPartitionFunction

/-- 3. Junior-high hook: the `n`-step survival chamber has mass `1 / n!`. -/
theorem juniorHighGraduateSolution (n : ℕ) :
    simplex_volume n = 1 / n.factorial :=
  simplex_volume_formula n

/-- 4. High-school hook: the factorial series sums to the exponential. -/
theorem highSchoolGraduateSolution :
    (∑' n : ℕ, (1 : ℝ) / n.factorial) = exp 1 :=
  exp_series_connection

/-- 5. Bachelor-level hook: the PMF expectation is the factorial series. -/
theorem bachelorGraduateSolution :
    expected_hitting_time = ∑' n : ℕ, (1 : ℝ) / n.factorial :=
  alternative_expression

/-- 6. Master's-level hook: the exponential solves the Volterra value equation. -/
theorem masterGraduateSolution :
    exp 1 = 1 + killedKernel exp 1 :=
  mostElegantVolterraValueEquation

/-- 7. Doctoral-level hook: the Green functional has total mass `exp 1`. -/
theorem doctorGraduateSolution :
    adjointGreen 1 (fun _ => 1) = exp 1 :=
  mostElegantGreenSolution

/-- 8. Postdoc-level hook: the Poisson Janossy normalization is one. -/
theorem postdocGraduateSolution :
    unitIntervalJanossyFactor * survivingPrefixPartitionFunction = 1 :=
  mostInterestingJanossySolution

/-- 9. Assistant-professor hook: the Yule population shadow equals the expectation. -/
theorem assistantProfessorSolution :
    yuleExpectedPopulation = expected_hitting_time :=
  yuleExpectedPopulation_eq_expectedHittingTime

/-- 10. Associate-professor hook: the first-ascent tail sum is the expectation. -/
theorem associateProfessorSolution :
    expected_hitting_time = ∑' n : ℕ, firstAscentRunTailMass n :=
  expectedHittingTime_eq_firstAscentTailSum

/-- 11. Professor hook: raw repeated integration sums to `exp 1`. -/
theorem professorSolution :
    (∑' n : ℕ, bruteForceTailMass n 1) = exp 1 :=
  mostBruteForceIteratedIntegralSolution

/-- 12. Emeritus-professor hook: several mature viewpoints agree. -/
theorem emeritusProfessorSolution :
    expected_hitting_time = exp 1 ∧
      survivingPrefixPartitionFunction = exp 1 ∧
      yuleExpectedPopulation = exp 1 := by
  exact ⟨main_theorem, shortestPartitionFunctionSolution, mostInterestingYuleBranchingSolution⟩

/-- 13. Fields-medalist hook: cancel the Poisson void factor. -/
theorem fieldsMedalistSolution :
    unitIntervalJanossyFactor * expected_hitting_time = 1 := by
  rw [main_theorem]
  unfold unitIntervalJanossyFactor
  rw [← Real.exp_add]
  norm_num

/-- 14. Chief-actuary hook: every survival tail is exactly `1 / n!`. -/
theorem chiefActuarySolution (n : ℕ) :
    (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial :=
  tail_probability_formula n

/-- 15. IAS-director hook: the configuration partition function is the expectation. -/
theorem iasDirectorSolution :
    survivingPrefixPartitionFunction = expected_hitting_time :=
  janossyPartitionFunction_eq_expectedHittingTime

/-- 16. Chief Data Officer hook: the headline metric has a single verified source of truth. -/
theorem chiefDataOfficerSolution :
    expected_hitting_time = yuleExpectedPopulation := by
  exact yuleExpectedPopulation_eq_expectedHittingTime.symm

end PotionProblem
