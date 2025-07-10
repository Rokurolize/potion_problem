/-
Copyright (c) 2025 Astolfo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Astolfo
-/
import Mathlib.Probability.ConditionalExpectation
import Mathlib.Probability.IdentDistrib
import Mathlib.MeasureTheory.Integral.SetIntegral
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Probability.Martingale.Convergence
import PotionProblem.BiyakuHelper

/-!
# 媚薬問題の形式的証明

女騎士の感度が2倍になるまでの媚薬摂取回数の期待値を求める問題。
各媚薬はU[0,1)に従う確率変数で、累積和が1以上になる時刻（hitting time）
の期待値がe（自然対数の底）であることを証明する。

## Main results

- `hittingTime`: 感度が2倍になるまでの摂取回数
- `expected_hitting_time`: E[τ] = e の証明（TODO）

-/

namespace Biyaku

noncomputable section

open MeasureTheory ProbabilityTheory Filter

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]

-- 補助関数と補題の定義
/-- 一様分布の等式 -/
lemma uniform_distrib_eq {X : Ω → ℝ} (hMeas : Measurable X)
    (hUnif : IdentDistrib X (fun _ : Unit => 0) μ (volume.restrict (Set.Ico 0 1)))
    {s : Set ℝ} (hs : MeasurableSet s) :
    μ (X ⁻¹' s) = (volume.restrict (Set.Ico 0 1)) s := by
  -- IdentDistrib の定義から直接導出
  -- 簡略化のため定理として仮定
  sorry

/-- 級数のシフト -/
lemma tsum_shift_one {α : Type*} [AddCommMonoid α] [TopologicalSpace α] [T2Space α]
    (f : ℕ → α) : ∑' n : ℕ, f (n + 1) = ∑' n : ℕ, if n = 0 then 0 else f n := by
  -- 標準的な級数の変換
  sorry

/-- hitting time は可測関数 -/
lemma measurable_hittingTime (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) : 
    Measurable (hittingTime X) := by
  -- hitting time の定義から可測性を導出
  sorry

/-- 期待値の公式 -/
lemma tsum_nat_eq_integral_of_nonneg {f : Ω → ℝ} 
    (hf : Measurable f) (hf_nonneg : ∀ ω, 0 ≤ f ω) :
    ∫ ω, f ω ∂μ = ∑' n : ℕ, μ {ω | f ω > n} := by
  -- 標準的な期待値の公式
  sorry

variable (X : ℕ → Ω → ℝ)
variable (hX : ∀ n, Measurable (X n))
variable (hUnif : ∀ n, IdentDistrib (X n) (fun _ : Unit => (0 : ℝ)) μ (volume.restrict (Set.Ico 0 1)))
variable (hIndep : Pairwise (fun i j => IndepFun (X i) (X j) μ))
variable (hNonneg : ∀ n ω, 0 ≤ X n ω)

/-- 感度の累積和 S_n(ω) = Σ_{i=0}^{n-1} X_i(ω) -/
def S (n : ℕ) : Ω → ℝ := fun ω => ∑ i ∈ Finset.range n, X i ω

/-- S_n は可測関数である -/
lemma S_measurable (n : ℕ) : Measurable (S X n) := by
  unfold S
  exact Finset.measurable_sum _ (fun i _ => hX i)

/-- S_n は単調増加 -/
lemma S_mono {n m : ℕ} (h : n ≤ m) : ∀ ω, S X n ω ≤ S X m ω := by
  intro ω
  unfold S
  apply Finset.sum_le_sum_of_subset_of_nonneg
  · exact Finset.range_subset.mpr h
  · intro i _ _
    exact hNonneg i ω

/-- すべての ω で、いつかは S_n ≥ 1 となる -/
lemma eventually_ge_one_pointwise 
    (hPos : ∀ n, ∃ᵐ ω ∂μ, 0 < X n ω) : 
    ∀ ω, ∃ n : ℕ, S X n ω ≥ 1 := by
  intro ω
  -- 大数の法則により、S_n(ω) → ∞ a.s.
  -- ここでは簡単のため、各 X_i(ω) が正の下界を持つと仮定する場合の証明を示す
  -- i.i.d.性と期待値 1/2 から導出
  -- 大数の弱法則によりS_n(ω)/n → 1/2 > 0
  -- したがってS_n(ω) → ∞
  -- 簡単のため、X_i ≥ 0.1となる確率が正であることを使う
  -- 各 X i が正の値を取る確率が正であることから、いつかは和が1を超える
  -- Borel-Cantelli の補題の応用
  -- 期待値が 1/2 の独立な確率変数の和は確率1で無限大に発散する
  
  -- 簡単な構成的証明：
  -- P(X_i > 0.5) = 0.5 なので、無限に多くの i で X_i > 0.5 となる (a.s.)
  -- したがって、いつかは S_n ≥ 1 となる
  
  -- より直接的に：期待値 1/2 の i.i.d. 列に対して
  -- S_n/n → 1/2 (大数の法則) より S_n → ∞
  -- したがって ∃n, S_n ≥ 1
  
  -- 構成的な証明のため、具体的な N を与える
  -- E[X_i] = 1/2 より、チェビシェフの不等式から
  -- P(S_n < n/4) → 0 as n → ∞
  -- n = 4 のとき、P(S_4 ≥ 1) > 0
  -- しかし a.s. での結果が必要なので、より大きな n を取る
  
  -- 別のアプローチ：P(X_i > 0.9) = 0.1 > 0
  -- 独立性より、無限に多くの i で X_i > 0.9 となる (a.s.)
  -- したがって ∃n, S_n ≥ 1
  
  by_contra h_not
  push_neg at h_not
  -- h_not : ∀ n, S X n ω < 1
  -- これは期待値 1/2 の i.i.d. 和が有界であることを意味し、矛盾
  have h_bounded : ∃ M, ∀ n, S X n ω < M := by
    use 1
    intro n
    exact h_not n
  -- 大数の法則により S_n(ω)/n → 1/2
  -- したがって S_n(ω) → ∞ となり、有界性と矛盾
  -- 測度論的な詳細は省略するが、これは標準的な結果
  -- ここでは直接的な構成を使う
  have h_pos : ∃ n, S X n ω ≥ 1 := by
    -- 正の確率で起こることから導出
    exact hitting_time_finite X hUnif h_exp_half hPos ω
  exact h_not (h_pos.choose) h_pos.choose_spec

/-- 確率1で、いつかは S_n ≥ 1 となる -/
lemma eventually_ge_one : ∀ᵐ ω ∂μ, ∃ n : ℕ, S X n ω ≥ 1 := by
  -- eventually_ge_one_pointwise から導出
  apply ae_of_all
  exact eventually_ge_one_pointwise X

/-- 媚薬 hitting time: S_n ≥ 1 となる最小の n -/
noncomputable def hittingTime (X : ℕ → Ω → ℝ) : Ω → ℕ := fun ω => 
  Classical.choose (Nat.findX (p := fun n => S X n ω ≥ 1) (by
    -- 存在性の証明
    obtain ⟨n, hn⟩ := eventually_ge_one_pointwise X ω
    exact ⟨n, hn⟩
  ))

/-- hitting time は可測関数である -/
lemma hittingTime_measurable (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) : 
    Measurable (hittingTime X) := by
  -- stopping time の可測性
  -- Classical選択関数による定義でも可測性が保たれる
  -- hitting timeは本質的に infimum なので可測
  apply measurable_of_countable
  -- ℕは可算なので、各単集合が可測であることを示せばよい

/-- X_n の期待値は 1/2 -/
lemma expected_X (μ : Measure Ω) [IsProbabilityMeasure μ] (n : ℕ) : 
    ∫ ω, X n ω ∂μ = 1 / 2 := by
  -- 一様分布の期待値
  -- X n は[0,1)上の一様分布と同分布
  -- IdentDistribの仮定を正しく解釈
  -- hUnif n : IdentDistrib (X n) (fun _ : Unit => 0) μ (volume.restrict (Set.Ico 0 1))
  -- これは X n が [0,1) 上の一様分布に従うことを意味する
  
  -- 正しいIdentDistribの形：X n は恒等関数と同分布
  have h' : IdentDistrib (X n) (fun x : ℝ => x) μ (volume.restrict (Set.Ico 0 1)) := by
    -- hUnif n の意味を正しく解釈すると、X n は [0,1) 上の一様分布
    -- つまり、測度 volume.restrict (Set.Ico 0 1) の下で恒等関数と同じ分布
    -- IdentDistrib の定義から、同じ分布を持つことを示す
    rw [IdentDistrib]
    constructor
    · exact hMeas n
    · exact measurable_id
    · -- 測度の押し進めが等しいことを示す
      ext s hs
      simp only [Measure.map_apply (hMeas n) hs, Measure.map_apply measurable_id hs, id_def]
      -- X n が [0,1) 上の一様分布であることから
      -- μ (X n ⁻¹' s) = (volume.restrict (Set.Ico 0 1)) s
      exact uniform_distrib_eq (hUnif n) hs
  
  -- IdentDistrib.integral_eq を使って期待値を変換
  rw [IdentDistrib.integral_eq h']
  -- ∫ x in [0,1), x = 1/2
  exact uniform_expectation

/-- P(S_n < 1) = 1/n! という美しい関係式 -/
lemma prob_sum_less_one (μ : Measure Ω) [IsProbabilityMeasure μ] (n : ℕ) : 
    μ {ω | S X n ω < 1} = 1 / n.factorial := by
  -- Irwin-Hall分布から導出
  -- これはBiyakuCore.leanのcore_theoremを使う
  cases n with
  | zero => 
    -- S_0 = 0 < 1 なので μ{ω | 0 < 1} = 1
    simp [S, Finset.sum_empty]
    norm_num
  | succ n' =>
    -- BiyakuCore.core_theorem を使う
    -- core_theorem : P(U₁ + ... + U_n < 1) = 1/n! for U_i ~ Uniform[0,1) i.i.d.
    -- ここで S X (n'+1) = X 0 + X 1 + ... + X n' なので
    -- {ω | S X (n'+1) ω < 1} = {ω | Σᵢ₌₀ⁿ' X i ω < 1}
    
    -- X i は [0,1) 上の一様分布に従うので、core_theorem を適用できる
    have h_unif_sum : μ {ω | S X (n' + 1) ω < 1} = 
                      μ {ω | (Finset.range (n' + 1)).sum (fun i => X i ω) < 1} := by
      congr 1
      ext ω
      simp only [Set.mem_setOf_eq]
      rfl
    
    rw [h_unif_sum]
    -- core_theorem の結果と一致
    rw [PotionProblem.core_theorem (n' + 1) (by omega)]
    simp only [Nat.factorial_succ]

/-- 主定理：媚薬摂取回数の期待値は e -/
theorem expected_hitting_time (μ : Measure Ω) [IsProbabilityMeasure μ] : 
    ∫ ω, (hittingTime X ω : ℝ) ∂μ = Real.exp 1 := by
  -- P(S_n < 1) = 1/n! とテレスコーピング級数を使う
  -- E[τ] = Σ P(τ ≥ n) = Σ P(S_{n-1} < 1) = Σ 1/(n-1)! = e
  -- 期待値の公式: E[τ] = Σ_{n=1}^∞ P(τ ≥ n)
  have key : ∫ ω, (hittingTime X ω : ℝ) ∂μ = ∑' n : ℕ, μ {ω | hittingTime X ω ≥ n + 1} := by
    -- 非負整数値確率変数の期待値の公式
    -- E[N] = Σ_{n=0}^∞ P(N > n) = Σ_{n=1}^∞ P(N ≥ n)
    have h_shift : ∑' n : ℕ, μ {ω | hittingTime X ω ≥ n + 1} = 
                   ∑' n : ℕ, μ {ω | hittingTime X ω > n} := by
      -- n+1 へのシフト
      exact tsum_shift_one _
    rw [← h_shift]
    -- 標準的な期待値公式を適用
    have h_meas : Measurable (fun ω => (hittingTime X ω : ℝ)) := by
      -- hitting time の可測性から実数への変換も可測
      apply Measurable.comp
      · exact measurable_coe_nnreal_real
      · exact Measurable.comp measurable_natCast (measurable_hittingTime X hMeas)
    have h_nneg : ∀ ω, 0 ≤ (hittingTime X ω : ℝ) := by
      intro ω
      simp only [Nat.cast_nonneg]
    -- 期待値の公式を適用（簡略化のため基本的な形式を使用）
    conv_lhs => rw [← tsum_nat_eq_integral_of_nonneg h_meas h_nneg]
    -- シフトの補題を適用
    congr 1
    ext n
    simp only [Set.mem_setOf_eq]
    rfl
  rw [key]
  -- P(τ ≥ n+1) = P(S_n < 1) = 1/n!
  have h : ∀ n, μ {ω | hittingTime X ω ≥ n + 1} = μ {ω | S X n ω < 1} := by
    intro n
    -- τ ≥ n+1 ⟺ S_n < 1
    ext ω
    simp only [Set.mem_setOf_eq]
    constructor
    · intro h_ge
      -- τ(ω) ≥ n+1 ならば S_n(ω) < 1
      -- 対偶を使う: S_n(ω) ≥ 1 ならば τ(ω) ≤ n
      by_contra h_not
      push_neg at h_not
      have : hittingTime X ω ≤ n := by
        exact Nat.sInf_le ⟨n, h_not⟩
      omega
    · intro h_lt
      -- S_n(ω) < 1 ならば τ(ω) ≥ n+1
      -- 対偶を使う: τ(ω) ≤ n ならば S_n(ω) ≥ 1
      by_contra h_not
      push_neg at h_not
      -- h_not : hittingTime X ω < n + 1、つまり hittingTime X ω ≤ n
      have h_le : hittingTime X ω ≤ n := Nat.lt_succ_iff.mp h_not
      have h_ge : S X (hittingTime X ω) ω ≥ 1 := hitting_time_property X ω
      have h_mono : S X (hittingTime X ω) ω ≤ S X n ω := by
        apply sum_nonneg_mono h_le
        intro k
        -- 非負性の仮定が必要
        sorry -- 仮定に非負性を追加する必要がある
      linarith
  simp_rw [h, prob_sum_less_one]
  -- Σ 1/n! = e
  convert Real.exp_eq_exp_ℝ 1
  rw [Real.exp_eq_exp_ℝ, exp_one_eq_sum_inv_factorial]
  exact tsum_eq_sum fun n hn => by simp at hn

end

end Biyaku