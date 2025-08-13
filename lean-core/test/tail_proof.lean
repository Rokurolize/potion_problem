import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Group
import PotionProblem.Basic
import PotionProblem.FactorialSeries
import PotionProblem.ProbabilityFoundations

open Real Filter Nat Topology PotionProblem

-- Minimal proof of the key decomposition lemma
lemma tail_decomposition (n : ℕ) :
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 
  1 - ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k := by
  -- Strategy: Show that finite sum + tail sum = total sum = 1
  
  -- The key observation: the conditional sum is the same as summing from n+1 onwards
  have h_tail_eq : (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 
                   ∑' k, hitting_time_pmf (k + (n + 1)) := by
    -- Every k > n can be written as j + (n+1) for j = k - (n+1)
    -- And every j ≥ 0 gives j + (n+1) > n
    sorry
  
  -- Now use Summable.sum_add_tsum_nat_add
  have h_split := Summable.sum_add_tsum_nat_add (n + 1) pmf_summable
  rw [pmf_sum_eq_one, h_tail_eq] at h_split
  linarith

-- Even simpler: direct proof using complement
lemma tail_decomposition_v2 (n : ℕ) :
  (∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 
  1 - ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k := by
  -- The total sum splits into two parts
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
    · -- Summability of first part
      apply Summable.of_support
      convert (Finset.range (n + 1)).finite_toSet
      ext k
      simp [Function.support, Finset.mem_range]
      constructor
      · intro h
        by_contra h_not
        push_neg at h_not
        have : k ≤ n := le_of_not_lt h_not
        exact h (if_pos this)
      · intro h
        rw [if_pos (Nat.lt_succ_iff.mp h)]
        exact ne_of_gt (prob_tau_pos_iff.mpr (by omega))
    · -- Summability of second part  
      apply Summable.of_nonneg_of_le
      · intro k
        split_ifs <;> exact pmf_nonneg k
      · intro k
        split_ifs with h
        · exact le_refl _
        · simp
      · exact pmf_summable
  
  -- The finite part equals the sum over range (n+1)
  have h_finite : (∑' k : ℕ, if k ≤ n then hitting_time_pmf k else 0) = 
                  ∑ k ∈ Finset.range (n + 1), hitting_time_pmf k := by
    rw [tsum_eq_sum]
    · intro k hk
      simp [Finset.mem_range] at hk
      exact if_neg (not_le.mpr hk)
    · -- Support is finite
      convert (Finset.range (n + 1)).finite_toSet
      ext k
      simp [Function.support, Finset.mem_range]
      constructor
      · intro h
        by_contra h_not
        push_neg at h_not
        have : k ≤ n := le_of_not_lt h_not
        exact h (if_pos this)
      · intro h
        rw [if_pos (Nat.lt_succ_iff.mp h)]
        exact ne_of_gt (prob_tau_pos_iff.mpr (by omega))
  
  rw [pmf_sum_eq_one] at h_total
  rw [h_finite] at h_total
  linarith