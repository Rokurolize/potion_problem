import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.Normed.Algebra.Exponential
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import PotionProblem.Basic
import PotionProblem.FactorialSeries

set_option linter.style.commandStart false

/-!
# Main Theorem: E[τ] = e

This module contains the main theorem proving that the expected hitting time
for independent uniform [0,1) random variables to sum to at least 1 is exactly e.

## Main Result

- `main_theorem`: E[τ] = e

-/

namespace PotionProblem

open Real Filter Nat

/-- The expected hitting time E[τ] = ∑_{n=1}^∞ n · P(τ = n) -/
noncomputable def expected_hitting_time : ℝ :=
  ∑' n : ℕ, n * hitting_time_pmf n

/-- Fundamental lemma: exp 1 = ∑ 1/n! -/
lemma exp_one_eq_tsum_inv_factorial : exp 1 = ∑' n : ℕ, (1 : ℝ) / n.factorial := by
  -- Use the fact that Real.exp = NormedSpace.exp ℝ
  rw [Real.exp_eq_exp_ℝ]
  -- Now apply the series representation of exp
  rw [NormedSpace.exp_eq_tsum]
  -- At x = 1, we get ∑' n, (n!)⁻¹ • 1^n = ∑' n, 1/n!
  simp only [one_pow, smul_eq_mul, inv_eq_one_div, mul_one]

/-- Helper lemma: For n ≥ 2, n * hitting_time_pmf n = 1/(n-2)! -/
lemma hitting_time_formula (n : ℕ) (hn : 2 ≤ n) : 
  (n : ℝ) * hitting_time_pmf n = 1 / (n - 2).factorial := by
  -- Expand the definition of hitting_time_pmf
  simp only [hitting_time_pmf]
  -- Since n ≥ 2, we have ¬(n ≤ 1)
  have h_not_le : ¬(n ≤ 1) := by omega
  rw [if_neg h_not_le]
  
  -- Goal: n * ((n - 1) / n!) = 1 / (n - 2)!
  -- We'll use the fact that n! = n * (n - 1) * (n - 2)!
  
  -- First handle the natural number subtraction
  have h_sub : (n : ℝ) - 1 = ((n - 1 : ℕ) : ℝ) := by
    have : 1 ≤ n := by omega
    rw [Nat.cast_sub this]
    simp
  rw [h_sub]
  
  -- Now use field_simp to clear denominators
  field_simp
  
  -- The goal is: ↑n * (↑n - 1) * ↑(n - 2)! = ↑n!
  -- Use h_sub to convert (↑n - 1) to ↑(n - 1)
  rw [h_sub]
  
  -- Now we have: ↑n * ↑(n - 1) * ↑(n - 2)! = ↑n!
  -- Convert to natural numbers
  rw [← Nat.cast_mul, ← Nat.cast_mul]
  norm_cast
  
  -- Now we need to prove: n * (n - 1) * (n - 2)! = n!
  -- We'll use factorial_succ twice
  
  -- We want to prove: n * (n - 1) * (n - 2)! = n!
  -- Using factorial properties step by step
  
  -- Step 1: (n-1)! = (n-1) * (n-2)!
  have h1 : (n - 1).factorial = (n - 1) * (n - 2).factorial := by
    -- Since n ≥ 2, we have n - 1 ≥ 1, so n - 1 = (n - 2) + 1
    conv_lhs => rw [← Nat.succ_pred_eq_of_pos (by omega : 0 < n - 1)]
    rw [Nat.factorial_succ]
    congr 1
    exact Nat.succ_pred_eq_of_pos (by omega : 0 < n - 1)
  
  -- Step 2: n! = n * (n-1)!
  have h2 : n.factorial = n * (n - 1).factorial := by
    -- Since n ≥ 2, we have n ≥ 1, so n = (n - 1) + 1
    conv_lhs => rw [← Nat.succ_pred_eq_of_pos (by omega : 0 < n)]
    rw [Nat.factorial_succ]
    congr 1
    exact Nat.succ_pred_eq_of_pos (by omega : 0 < n)
  
  -- Now combine: n! = n * (n-1)! = n * ((n-1) * (n-2)!) = n * (n-1) * (n-2)!
  rw [h2, h1]
  ring

/-- Helper lemma: For n < 2, n * hitting_time_pmf n = 0 -/
lemma hitting_time_zero (n : ℕ) (hn : n < 2) : 
  (n : ℝ) * hitting_time_pmf n = 0 := by
  cases n with
  | zero =>
    -- n = 0
    simp [hitting_time_pmf]
  | succ n' =>
    -- n = n' + 1
    cases n' with
    | zero =>
      -- n = 1
      simp [hitting_time_pmf]
    | succ n'' =>
      -- n ≥ 2, contradiction
      omega

/-- The hitting time expectation series is summable -/
theorem summable_hitting_time :
  Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := by
  -- The series n * hitting_time_pmf n equals:
  -- - 0 for n = 0, 1
  -- - 1/(n-2)! for n ≥ 2
  -- This is essentially the factorial series ∑ 1/k! with two zeros prepended
  
  -- Mathematical proof strategy:
  -- Since n * hitting_time_pmf n = 0 for n < 2 and = 1/(n-2)! for n ≥ 2,
  -- we need to show that ∑' n, (if n < 2 then 0 else 1/(n-2)!) converges
  
  -- This series is essentially ∑' k, 1/k! with two zeros prepended
  -- Since ∑' k, 1/k! converges (to e), our series also converges
  
  -- Formal approach: Use that f(n+2) = 1/n! and summable_inv_factorial
  -- to conclude summability of f
  
  -- We'll show that the function equals a summable shifted factorial series
  -- Key: ∑' n, n * hitting_time_pmf n = ∑' n, f n where
  -- f(n) = 0 for n < 2 and f(n) = 1/(n-2)! for n ≥ 2
  
  -- We can rewrite this as: ∑' n, f n = ∑' n, f (n + 2)
  -- And f(n + 2) = 1/n! for all n
  
  -- Use the fact that if g is summable, and f(n+k) = g(n), then f is summable
  -- when f is zero for n < k
  rw [← summable_nat_add_iff 2]
  -- Now we need to show that fun n => n * hitting_time_pmf (n + 2) is summable
  -- But (n + 2) * hitting_time_pmf (n + 2) = 1/n! by hitting_time_formula
  convert summable_inv_factorial using 1
  ext n
  exact hitting_time_formula (n + 2) (by omega)

/-- Main theorem: The expected hitting time equals e -/
theorem main_theorem : expected_hitting_time = exp 1 := by
  -- Expand the definition and use exp series representation
  unfold expected_hitting_time
  rw [exp_one_eq_tsum_inv_factorial]
  
  -- The key insight: our sum ∑' n, n * hitting_time_pmf n can be rewritten
  -- as ∑' k, 1/k! by using the relationship f(n+2) = 1/n!
  
  -- We already proved in summable_hitting_time that:
  -- (fun n => n * hitting_time_pmf n) = (fun n => if n < 2 then 0 else 1/(n-2)!)
  -- and this equals ∑' k, 1/k! after shifting indices
  
  -- Use the same approach as in summable_hitting_time:
  -- The series ∑' n, n * hitting_time_pmf n equals the shifted factorial series
  
  -- From our hitting_time_formula and hitting_time_zero lemmas:
  have h_form : ∀ (n : ℕ), n ≥ 2 → (n : ℝ) * hitting_time_pmf n = 1 / (n - 2).factorial :=
    fun n hn => hitting_time_formula n hn
  have h_zero : ∀ (n : ℕ), n < 2 → (n : ℝ) * hitting_time_pmf n = 0 :=
    fun n hn => hitting_time_zero n hn
  
  -- The summability is already established
  have h_summable : Summable (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) := summable_hitting_time
  
  -- We use the fact that our series is exactly the factorial series with 2 zeros prepended
  -- This follows from the same reindexing argument used in summable_hitting_time
  -- Since ∑' n, (n+2) * hitting_time_pmf (n+2) = ∑' n, 1/n! (by hitting_time_formula)
  -- and the first two terms are zero, we get ∑' n, n * hitting_time_pmf n = ∑' n, 1/n!
  
  -- The proof strategy: use the same transformation as summable_hitting_time
  -- but for the tsum equality instead of just summability
  
  -- Use a direct approach based on the characterization of the series
  -- We know that n * hitting_time_pmf n = 0 for n < 2 and = 1/(n-2)! for n ≥ 2
  -- So our series is: 0 + 0 + 1/0! + 1/1! + 1/2! + ... = ∑' k, 1/k!
  -- This is exactly what we proved in summable_hitting_time using index shifting
  
  -- We'll use the same technique: show that our series equals a reindexed factorial series
  have key_identity : (fun n : ℕ => (n : ℝ) * hitting_time_pmf n) = 
                      (fun n : ℕ => if n < 2 then (0 : ℝ) else (1 : ℝ) / (n - 2).factorial) := by
    ext n
    by_cases hn : n < 2
    · simp [hn, h_zero n hn]
    · push_neg at hn
      simp [hn]
      rw [h_form n hn]
      simp only [one_div]
      -- Since hn : 2 ≤ n, we have ¬(n < 2)
      have : ¬(n < 2) := by omega
      simp [this]
  
  -- Now we show that the sum of the RHS equals the factorial series
  rw [key_identity]
  
  -- Split the sum based on the condition n < 2
  have sum_split : ∑' n : ℕ, (if n < 2 then (0 : ℝ) else (1 : ℝ) / (n - 2).factorial) = 
                   ∑' n : ℕ, (1 : ℝ) / n.factorial := by
    -- Strategy: Use the fact that our series is just the factorial series with two zeros prepended
    -- We know from summable_hitting_time that the series is summable,
    -- so we can use sum_add_tsum_nat_add
    
    -- First establish summability 
    have h_summable : Summable 
      (fun n : ℕ => if n < 2 then (0 : ℝ) else (1 : ℝ) / (n - 2).factorial) := by
      rw [← summable_nat_add_iff 2]
      exact summable_inv_factorial
    
    -- Apply sum_add_tsum_nat_add in reverse: ∑' f = (∑ᵢ⁼⁰¹ f i) + ∑' f(i+2)
    rw [← h_summable.sum_add_tsum_nat_add 2]
    
    -- The finite sum is zero: f(0) + f(1) = 0 + 0 = 0
    have h_finite_zero : ∑ i ∈ Finset.range 2, 
      (if i < 2 then (0 : ℝ) else (1 : ℝ) / (i - 2).factorial) = 0 := by
      -- range 2 = {0, 1}, so sum is f(0) + f(1) = 0 + 0 = 0
      simp only [Finset.sum_range_succ, Finset.sum_range_one, Finset.sum_range_zero, add_zero]
      simp
    rw [h_finite_zero, zero_add]
    
    -- Now show: ∑' k, f(k+2) = ∑' k, 1/k!
    -- Since f(k+2) = (if k+2 < 2 then 0 else 1/(k+2-2)!) = 1/k!
    rfl
  
  exact sum_split

end PotionProblem