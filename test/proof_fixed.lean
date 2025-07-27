-- test/proof_fixed.lean

import PotionProblem.ProbabilityFoundations
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Algebra.Group.Indicator

open Real Filter Nat Topology PotionProblem Set

-- The telescoping sum lemma (already proven earlier)
lemma telescoping_sum_lemma (N : ℕ) :
    ∑ n ∈ Finset.range N, hitting_time_pmf (n + 2) = 1 - 1 / (N + 1).factorial := by
  induction N with
  | zero => simp
  | succ N ih =>
    rw [Finset.sum_range_succ, ih, pmf_telescoping (N + 2) (by omega)]
    have h_eq : N + 2 - 1 = N + 1 := by omega
    rw [h_eq]
    ring

-- Fixed version of tail_probability_formula
theorem tail_probability_formula_fixed (n : ℕ) :
    (∑' k, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := by
  
  -- Step 1: Use indicator function notation
  have h_indicator : (∑' k, if k > n then hitting_time_pmf k else 0) = 
                     ∑' k, indicator {k | k > n} hitting_time_pmf k := by
    congr 1
    ext k
    simp [indicator_apply]
    
  rw [h_indicator]
  
  -- Step 2: Show that this equals 1 - finite sum using complement decomposition
  have h_complement : ∑' k, indicator {k | k > n} hitting_time_pmf k = 
                      1 - ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k := by
    -- We use the fact that ∑' k, hitting_time_pmf k = 1
    -- and split it into finite + infinite parts
    have h_split : 1 = ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k + 
                       ∑' k, indicator {k | k > n} hitting_time_pmf k := by
      rw [← pmf_sum_eq_one]
      -- Use Summable.sum_add_tsum_nat_add but need to relate indicator to shifted sum
      sorry -- This is the key step
    
    linarith [h_split]
  
  rw [h_complement]
  
  -- Step 3: Compute the finite sum
  by_cases h0 : n = 0
  · simp [h0, Finset.sum_range_one, prob_tau_eq_zero_one.1]
    
  by_cases h1 : n = 1
  · simp [h1]
    rw [Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_zero]
    simp [prob_tau_eq_zero_one.1, prob_tau_eq_zero_one.2, Finset.sum_empty]
    
  -- For n ≥ 2
  push_neg at h0 h1
  have h_ge : 2 ≤ n := by omega
  
  have h_finite_sum : ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k = 1 - 1 / n.factorial := by
    -- Split off k=0,1 terms (which are 0)
    have h_split : ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k = 
                   ∑ k ∈ Finset.Ico 2 (n + 1), hitting_time_pmf k := by
      rw [← Finset.sum_sdiff (Finset.range_subset.mpr (by omega : 2 ≤ n + 1))]
      have h_zero : ∑ k ∈ Finset.range 2, hitting_time_pmf k = 0 := by
        simp [Finset.sum_range_succ, prob_tau_eq_zero_one.1, prob_tau_eq_zero_one.2]
      rw [h_zero, add_zero]
    
    rw [h_split]
    
    -- Index shift: k ∈ [2,n] ↦ j ∈ [0,n-2] via k = j+2
    have h_shift : ∑ k ∈ Finset.Ico 2 (n + 1), hitting_time_pmf k = 
                   ∑ j ∈ Finset.range (n - 1), hitting_time_pmf (j + 2) := by
      apply Finset.sum_bij (fun k hk => k - 2)
      · intro k hk
        simp [Finset.mem_Ico] at hk ⊢
        simp [Finset.mem_range]
        omega
      · intro k hk
        simp [Finset.mem_Ico] at hk
        congr
        omega
      · intro a ha b hb h_eq
        simp [Finset.mem_Ico] at ha hb
        omega
      · intro j hj
        simp [Finset.mem_range] at hj
        use j + 2
        constructor
        · simp [Finset.mem_Ico]
          omega
        · omega
    
    rw [h_shift, telescoping_sum_lemma]
    congr
    omega
  
  rw [h_finite_sum]
  ring