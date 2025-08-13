import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.Group.ForwardDiff
import Mathlib.Data.Real.Basic

-- Test the relationship between fwdDiff and polynomial derivatives

variable {R : Type*} [CommRing R]

-- Check if we can connect fwdDiff to polynomial derivatives
#check Polynomial.iterate_derivative_X_pow_eq_C_mul
#check Polynomial.iterate_derivative_X_sub_pow_self
#check fwdDiff

-- For real numbers
variable (n : ℕ)

-- The polynomial X^n
def poly_x_pow_n : Polynomial ℝ := Polynomial.X ^ n

-- Check evaluation
#check Polynomial.eval
#check Polynomial.aeval

-- Can we express x^n as a polynomial evaluation?
example (x : ℝ) : x ^ n = (Polynomial.X ^ n).eval x := by
  simp [Polynomial.eval_pow, Polynomial.eval_X]

-- Check the n-th derivative
#check Polynomial.iterate_derivative_X_pow_eq_C_mul n n

-- The key insight: when k = n, we get n.factorial
example : Polynomial.derivative^[n] (Polynomial.X ^ n : Polynomial ℝ) = 
          Polynomial.C (Nat.descFactorial n n : ℝ) * Polynomial.X ^ (n - n) := by
  exact Polynomial.iterate_derivative_X_pow_eq_C_mul n n

-- And descFactorial n n = n!
#check Nat.descFactorial_self

example : Nat.descFactorial n n = n.factorial := Nat.descFactorial_self n