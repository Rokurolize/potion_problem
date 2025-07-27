-- test/api_test.lean

import PotionProblem.ProbabilityFoundations
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Topology.Algebra.InfiniteSum.Basic

open Real Filter Nat Topology PotionProblem

-- AIが自力で導出したこの補題は素晴らしい。証明を完成させてグローバルに利用する。
lemma telescoping_sum_lemma (N : ℕ) :
    ∑ n in Finset.range N, hitting_time_pmf (n + 2) = 1 - 1 / (N + 1).factorial := by
  induction N with
  | zero => simp
  | succ N ih =>
    rw [Finset.sum_range_succ, ih, pmf_telescoping (N + 2) (by omega)]
    have h_eq : N + 2 - 1 = N + 1 := by omega
    rw [h_eq]
    ring

-- Simplified proof of tail_probability_formula
theorem tail_probability_formula_proof (n : ℕ) :
    (∑' k, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := by
  
  -- Key insight: Show that tail = 1 - finite_sum
  -- We use the approach from tail_decomposition_v2
  
  -- Step 1: The total sum splits into two parts
  have h_total : ∑' k, hitting_time_pmf k = 
                 (∑' k : ℕ, if k ≤ n then hitting_time_pmf k else 0) +
                 (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) := by
    -- This is true because every k is either ≤ n or > n
    rw [← Summable.tsum_add]
    · congr 1
      ext k
      by_cases h : k ≤ n
      · simp [h, le_iff_lt_or_eq]
      · simp [h, not_le.mp h]
    · -- Summability of first part (finite support)
      -- The support is {0, 1, ..., n}, which is finite
      have h_support : (Function.support (fun k => if k ≤ n then hitting_time_pmf k else 0)).Finite := by
        apply Set.Finite.subset (s := (Finset.range (n + 1) : Set ℕ))
        · exact Finset.finite_toSet _
        · intro k hk
          simp [Function.support] at hk
          simp [Finset.mem_coe, Finset.mem_range]
          contrapose! hk
          exact if_neg (not_le_of_gt hk)
      exact Summable.of_finite_support h_support
    · -- Summability of second part  
      apply Summable.of_nonneg_of_le
      · intro k
        split_ifs
        · exact pmf_nonneg k
        · exact le_refl 0
      · intro k
        split_ifs with h
        · exact le_refl _
        · exact zero_le (hitting_time_pmf k)
      · exact pmf_summable
  
  -- Step 2: The finite part equals the sum over range (n+1)
  have h_finite : (∑' k : ℕ, if k ≤ n then hitting_time_pmf k else 0) = 
                  ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k := by
    rw [tsum_eq_sum (s := Finset.range (n + 1))]
    · simp only [Finset.sum_congr rfl]
      congr 1
      ext k
      simp only [Finset.mem_range]
      split_ifs with h
      · rfl
      · rfl
    · intro k hk
      simp [Finset.mem_range] at hk
      exact if_neg (not_le_of_gt hk)
  
  -- Step 3: Use pmf_sum_eq_one to get tail = 1 - finite
  rw [pmf_sum_eq_one] at h_total
  rw [h_finite] at h_total
  have h_result : (∑' k, if k > n then hitting_time_pmf k else 0) = 
                  1 - ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k := by
    linarith
  rw [h_result]
  
  -- Step 4: Compute the finite sum
  by_cases h0 : n = 0
  · -- Case n = 0
    simp [h0, Finset.sum_range_one, prob_tau_eq_zero_one.1]
    
  by_cases h1 : n = 1
  · -- Case n = 1
    simp [h1]
    rw [Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_zero]
    simp [prob_tau_eq_zero_one.1, prob_tau_eq_zero_one.2, Finset.sum_empty]
    
  -- Case n ≥ 2
  push_neg at h0 h1
  have h_ge : 2 ≤ n := by omega
  
  -- The finite sum equals 1 - 1/n!
  suffices ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k = 1 - 1 / n.factorial by
    linarith
  
  -- Split off k=0,1 terms (which are 0)
  have h_sum_eq : ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k = 
                  ∑ k ∈ Finset.Ico 2 (n + 1), hitting_time_pmf k := by
    have h_eq : Finset.range (n + 1) = Finset.range 2 ∪ Finset.Ico 2 (n + 1) := by
      ext k
      simp [Finset.mem_range, Finset.mem_Ico, Finset.mem_union]
      omega
    rw [h_eq, Finset.sum_union]
    · simp [Finset.sum_range_succ, prob_tau_eq_zero_one.1, prob_tau_eq_zero_one.2]
    · apply Finset.disjoint_left.mpr
      intro k hk_range hk_ico
      simp [Finset.mem_range, Finset.mem_Ico] at hk_range hk_ico
      omega
  
  rw [h_sum_eq]
  
  -- Reindex: k ∈ [2,n] ↦ j ∈ [0,n-2] via k = j+2
  have h_reindex : ∑ k ∈ Finset.Ico 2 (n + 1), hitting_time_pmf k = 
                   ∑ j ∈ Finset.range (n - 1), hitting_time_pmf (j + 2) := by
    -- Direct reindexing using sum_bij'
    apply Finset.sum_bij'
    · -- Forward map: k ↦ k - 2
      intro k hk
      exact k - 2
    · -- Forward map is valid
      intro k hk
      simp [Finset.mem_Ico, Finset.mem_range] at hk ⊢
      omega
    · -- Values match forward
      intro k hk
      simp [Finset.mem_Ico] at hk
      have : k = (k - 2) + 2 := by omega
      rw [this]
    · -- Reverse map: j ↦ j + 2
      intro j hj
      exact j + 2
    · -- Reverse map is valid
      intro j hj
      simp [Finset.mem_range, Finset.mem_Ico] at hj ⊢
      omega
    · -- Left inverse
      intro k hk
      simp [Finset.mem_Ico] at hk
      omega
    · -- Right inverse
      intro j hj
      simp
  
  rw [h_reindex, telescoping_sum_lemma]
  congr
  omega

-- This completes the proof!