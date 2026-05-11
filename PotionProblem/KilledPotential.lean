import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.IntegrationByParts
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

/-!
# Killed Potential Certificate

This module isolates the deterministic Volterra calculation behind the
non-PMF proof of the potion problem.

The killed transition for the remaining distance is represented by

`killedKernel f r = ∫ t in 0..r, f t`.

The exponential is a certificate for the Poisson equation

`exp r - killedKernel exp r = 1`,

and the adjoint Green kernel has total mass `exp a`.

This file deliberately stays on the analytic side.  The bridge from this
Volterra recursion to iid uniform stopping times can be added separately.
-/

namespace PotionProblem

open Real Nat
open scoped Interval BigOperators

/-- The killed transition operator on rewards over the remaining distance. -/
noncomputable def killedKernel (f : ℝ → ℝ) (r : ℝ) : ℝ :=
  ∫ t in (0 : ℝ)..r, f t

/-- The finite Green polynomial `∑_{k<N} r^k/k!`. -/
noncomputable def factorialGreenPolynomial (N : ℕ) (r : ℝ) : ℝ :=
  ∑ k ∈ Finset.range N, r ^ k / k.factorial

/-- Finite-horizon values for the Volterra reward recursion. -/
noncomputable def finiteHorizonValue : ℕ → ℝ → ℝ
  | 0, _ => 0
  | n + 1, r => 1 + killedKernel (finiteHorizonValue n) r

/-- The adjoint Green functional represented by the proposed kernel. -/
noncomputable def adjointGreen (a : ℝ) (f : ℝ → ℝ) : ℝ :=
  f a + ∫ x in (0 : ℝ)..a, exp (a - x) * f x

/-- Integral of an exponential over the killed remaining interval. -/
lemma integral_exp_remaining (a : ℝ) :
    (∫ x in (0 : ℝ)..a, exp (a - x)) = exp a - 1 := by
  rw [intervalIntegral.integral_comp_sub_left (f := exp) (a := (0 : ℝ)) (b := a) a]
  rw [integral_exp]
  simp [exp_zero]

/-- The exponential solves the killed Poisson equation up to the constant reward. -/
theorem killedKernel_exp (r : ℝ) :
    killedKernel exp r = exp r - 1 := by
  unfold killedKernel
  rw [integral_exp]
  simp [exp_zero]

/-- One unit of expected potential is burned by one killed transition. -/
theorem poisson_certificate (r : ℝ) :
    exp r - killedKernel exp r = 1 := by
  rw [killedKernel_exp]
  ring

/-- The adjoint Green kernel has total mass `exp a`. -/
theorem adjointGreen_const_one (a : ℝ) :
    adjointGreen a (fun _ => 1) = exp a := by
  unfold adjointGreen
  simp only [mul_one]
  rw [integral_exp_remaining]
  ring

/-- The original threshold-one value recovered from the adjoint Green mass. -/
theorem potion_green_mass :
    adjointGreen 1 (fun _ => 1) = exp 1 :=
  adjointGreen_const_one 1

/-- The killed kernel has no mass at remaining distance zero. -/
lemma killedKernel_zero (f : ℝ → ℝ) :
    killedKernel f 0 = 0 := by
  simp [killedKernel]

/-- Applying the adjoint Green functional after one killed transition removes the atom. -/
theorem adjointGreen_killedKernel_eq_integral
    (a : ℝ) (f : ℝ → ℝ) (hf : Continuous f) :
    adjointGreen a (killedKernel f) =
      ∫ x in (0 : ℝ)..a, exp (a - x) * f x := by
  unfold adjointGreen
  have hu : ∀ x ∈ [[(0 : ℝ), a]],
      HasDerivAt (fun x : ℝ => exp (a - x)) (-exp (a - x)) x := by
    intro x _hx
    have h : HasDerivAt (fun x : ℝ => a - x) (-1) x := by
      simpa using (hasDerivAt_const (x := x) (c := a)).sub (hasDerivAt_id x)
    simpa using h.exp
  have hv : ∀ x ∈ [[(0 : ℝ), a]],
      HasDerivAt (fun y : ℝ => killedKernel f y) (f x) x := by
    intro x _hx
    unfold killedKernel
    exact (hf.integral_hasStrictDerivAt 0 x).hasDerivAt
  have hu' : IntervalIntegrable
      (fun x : ℝ => -exp (a - x)) MeasureTheory.volume 0 a := by
    exact (Real.continuous_exp.comp (continuous_const.sub continuous_id)).neg.intervalIntegrable _ _
  have hv' : IntervalIntegrable f MeasureTheory.volume 0 a := hf.intervalIntegrable _ _
  have h := intervalIntegral.integral_mul_deriv_eq_deriv_mul (a := (0 : ℝ)) (b := a)
    (u := fun x : ℝ => exp (a - x))
    (u' := fun x : ℝ => -exp (a - x))
    (v := fun y : ℝ => killedKernel f y) (v' := f) hu hv hu' hv'
  rw [h]
  simp [killedKernel_zero]

/-- The explicit adjoint Green kernel solves the adjoint resolvent equation. -/
theorem adjointGreen_resolvent
    (a : ℝ) (f : ℝ → ℝ) (hf : Continuous f) :
    adjointGreen a f = f a + adjointGreen a (killedKernel f) := by
  rw [adjointGreen_killedKernel_eq_integral a f hf]
  rfl

/-- The integral of the factorial-normalized monomial. -/
lemma integral_monomial_div_factorial (n : ℕ) (r : ℝ) :
    (∫ t in (0 : ℝ)..r, t ^ n / n.factorial) =
      r ^ (n + 1) / (n + 1).factorial := by
  rw [intervalIntegral.integral_div]
  rw [integral_pow]
  rw [Nat.factorial_succ]
  norm_num
  field_simp [
    show (↑n + 1 : ℝ) ≠ 0 by positivity,
    show (↑n.factorial : ℝ) ≠ 0 by positivity]

/-- The Volterra kernel shifts the Green polynomial by one term. -/
theorem killedKernel_factorialGreenPolynomial (N : ℕ) (r : ℝ) :
    killedKernel (factorialGreenPolynomial N) r =
      factorialGreenPolynomial (N + 1) r - 1 := by
  unfold killedKernel factorialGreenPolynomial
  rw [intervalIntegral.integral_finset_sum]
  · simp_rw [integral_monomial_div_factorial]
    induction N with
    | zero =>
        simp
    | succ N ih =>
        rw [Finset.sum_range_succ, Finset.sum_range_succ]
        rw [ih]
        ring
  · intro i _hi
    exact ((continuous_id.pow i).div_const (i.factorial : ℝ)).intervalIntegrable _ _

/-- The finite-horizon recursion is exactly the finite Green polynomial. -/
theorem finiteHorizonValue_eq_factorialGreenPolynomial (N : ℕ) :
    ∀ r : ℝ, finiteHorizonValue N r = factorialGreenPolynomial N r := by
  induction N with
  | zero =>
      intro r
      simp [finiteHorizonValue, factorialGreenPolynomial]
  | succ N ih =>
      intro r
      have hK : killedKernel (finiteHorizonValue N) r =
          killedKernel (factorialGreenPolynomial N) r := by
        unfold killedKernel
        congr 1
        ext t
        exact ih t
      calc
        finiteHorizonValue (N + 1) r = 1 + killedKernel (finiteHorizonValue N) r := by
          rfl
        _ = 1 + killedKernel (factorialGreenPolynomial N) r := by
          rw [hK]
        _ = 1 + (factorialGreenPolynomial (N + 1) r - 1) := by
          rw [killedKernel_factorialGreenPolynomial]
        _ = factorialGreenPolynomial (N + 1) r := by
          ring

/-- At threshold one, finite horizons are partial sums of the exponential series. -/
theorem finiteHorizonValue_one_eq_partial_exp (N : ℕ) :
    finiteHorizonValue N 1 =
      ∑ k ∈ Finset.range N, (1 : ℝ) / k.factorial := by
  rw [finiteHorizonValue_eq_factorialGreenPolynomial]
  unfold factorialGreenPolynomial
  simp [one_pow]

end PotionProblem
