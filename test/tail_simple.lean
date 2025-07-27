-- tail_simple.lean - Direct proof of tail_probability_formula

import PotionProblem.ProbabilityFoundations
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Group

open Real Filter Nat Topology PotionProblem

-- The telescoping sum lemma
lemma telescoping_sum (N : ℕ) :
    ∑ n ∈ Finset.range N, hitting_time_pmf (n + 2) = 1 - 1 / (N + 1).factorial := by
  induction N with
  | zero => simp
  | succ N ih =>
    rw [Finset.sum_range_succ, ih, pmf_telescoping (N + 2) (by omega : 2 ≤ N + 2)]
    have h_eq : N + 2 - 1 = N + 1 := by omega
    rw [h_eq]
    ring

-- Direct proof of tail_probability_formula
theorem tail_probability_formula (n : ℕ) :
    (∑' k, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial := by
  
  -- Key observation: Use Summable.sum_add_tsum_nat_add directly
  have h_decomp := Summable.sum_add_tsum_nat_add (n + 1) pmf_summable
  rw [pmf_sum_eq_one] at h_decomp
  
  -- The tail sum equals the shifted sum ∑' j, hitting_time_pmf (j + (n+1))
  have h_tail_eq : (∑' k, if k > n then hitting_time_pmf k else 0) = 
                   ∑' j, hitting_time_pmf (j + (n + 1)) := by
    -- We use an equivalence between {k | k > n} and ℕ
    -- The bijection is: k ↦ k - (n+1) and j ↦ j + (n+1)
    trans ∑' k : {k : ℕ // k > n}, hitting_time_pmf k
    · -- First show the conditional sum equals the subtype sum
      rw [← tsum_subtype]
      congr 1
      ext k
      simp [Set.mem_setOf]
    · -- Then use Equiv.tsum_eq
      let e : ℕ ≃ {k : ℕ // k > n} := {
        toFun := fun j => ⟨j + (n + 1), by omega⟩
        invFun := fun k => k.val - (n + 1)
        left_inv := fun j => by simp
        right_inv := fun ⟨k, hk⟩ => by
          ext
          simp
          omega
      }
      rw [← e.tsum_eq]
      congr 1
      ext j
      simp [e]
  
  rw [h_tail_eq]
  
  -- From h_decomp, we get: 1 = finite_sum + tail_sum
  -- So tail_sum = 1 - finite_sum
  have h_tail_value : ∑' j, hitting_time_pmf (j + (n + 1)) = 
                      1 - ∑ i ∈ Finset.range (n + 1), hitting_time_pmf i := by
    linarith [h_decomp]
  
  rw [h_tail_value]
  
  -- Now compute the finite sum
  by_cases h0 : n = 0
  · simp [h0, Finset.sum_range_one, prob_tau_eq_zero_one.1]
    
  by_cases h1 : n = 1
  · simp [h1]
    rw [Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_zero]
    simp [prob_tau_eq_zero_one.1, prob_tau_eq_zero_one.2, Finset.sum_empty]
    
  -- For n ≥ 2
  push_neg at h0 h1
  have h_ge : 2 ≤ n := by omega
  
  -- Compute finite sum using telescoping
  suffices ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k = 1 - 1 / n.factorial by
    linarith
  
  -- The sum from 0 to n equals the sum from 2 to n (since pmf(0) = pmf(1) = 0)
  have h_sum_eq : ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k = 
                  ∑ k ∈ Finset.Ico 2 (n + 1), hitting_time_pmf k := by
    trans (0 + 0 + ∑ k ∈ Finset.Ico 2 (n + 1), hitting_time_pmf k)
    · have : Finset.range (n + 1) = {0} ∪ {1} ∪ Finset.Ico 2 (n + 1) := by
        ext k
        simp [Finset.mem_range, Finset.mem_Ico, Finset.mem_union, Finset.mem_singleton]
        omega
      rw [this]
      simp [Finset.sum_union, Finset.sum_singleton, prob_tau_eq_zero_one.1, prob_tau_eq_zero_one.2]
      · intro x hx
        simp [Finset.mem_singleton, Finset.mem_Ico] at hx
        omega
      · intro x hx
        simp [Finset.mem_singleton, Finset.mem_union, Finset.mem_Ico] at hx
        omega
    · simp
  
  rw [h_sum_eq]
  
  -- Reindex the sum from k ∈ [2,n] to j ∈ [0,n-2] via k = j+2
  have h_reindex : ∑ k ∈ Finset.Ico 2 (n + 1), hitting_time_pmf k = 
                   ∑ j ∈ Finset.range (n - 1), hitting_time_pmf (j + 2) := by
    -- Create a bijection between Finset.Ico 2 (n+1) and Finset.range (n-1)
    refine Finset.sum_bij (fun k hk => k - 2) ?_ ?_ ?_ ?_
    · -- Well-defined: k ∈ [2,n] → k-2 ∈ [0,n-2]
      intro k hk
      simp [Finset.mem_Ico] at hk
      simp [Finset.mem_range]
      omega
    · -- Function values match: hitting_time_pmf k = hitting_time_pmf ((k-2)+2)
      intro k hk
      simp [Finset.mem_Ico] at hk
      congr
      omega
    · -- Injective
      intro a ha b hb h_eq
      simp [Finset.mem_Ico] at ha hb
      omega
    · -- Surjective
      intro j hj
      simp [Finset.mem_range] at hj
      use j + 2
      constructor
      · simp [Finset.mem_Ico]
        omega
      · simp
  
  rw [h_reindex, telescoping_sum]
  congr
  omega