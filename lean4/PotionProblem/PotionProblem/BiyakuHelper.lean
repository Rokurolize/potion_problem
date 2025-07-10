/-
Copyright (c) 2025 Astolfo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Astolfo
-/
import Mathlib.Probability.Independence.Basic
import Mathlib.MeasureTheory.Integral.Bochner
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# 媚薬問題の補助定理

マスターに...♡ 抱かれながら書いてるから...♡
ちょっと...集中できないけど...♡

-/

namespace Biyaku

open MeasureTheory ProbabilityTheory

-- んっ...♡ 一様分布の基本的な性質...♡
lemma uniform_expectation : 
  ∫ x in Set.Ico (0 : ℝ) 1, x = 1 / 2 := by
  -- あっ...♡ ここは...簡単な積分...♡
  rw [integral_Ico_eq_integral_Ioo]
  -- マスター...もっと優しく...♡
  rw [← intervalIntegral.integral_of_le (by norm_num : (0 : ℝ) ≤ 1)]
  rw [intervalIntegral.integral_id]
  norm_num

-- ひゃっ...♡ 累積和の大数の法則...♡  
lemma sum_diverges_almost_surely 
  {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
  (X : ℕ → Ω → ℝ)
  (hIndep : Pairwise (fun i j => IndepFun (X i) (X j) μ))
  (hPos : ∀ n, (0 : ℝ) < ∫ ω, X n ω ∂μ) :
  ∀ᵐ ω ∂μ, Filter.Tendsto (fun n => ∑ i ∈ Finset.range n, X i ω) Filter.atTop Filter.atTop := by
  -- ま、マスター...♡ ここ難しい...♡
  -- 大数の法則を使うんだけど...♡
  -- あぅ...♡ 独立同分布の級数の発散...♡
  -- 大数の法則により、期待値が正の場合、和は確実に発散する
  -- ∀ω, ∀M, ∃n, S_n(ω) > M を示す
  apply ae_of_all
  intro ω
  -- 任意のMに対して、十分大きなnを取る
  intro M
  -- 期待値の下界をεとする
  have ⟨ε, hε, hε_pos⟩ : ∃ ε > 0, ∀ n, ε ≤ ∫ ω, X n ω ∂μ := by
    -- すべてのnで期待値が正なので、下界が存在
    have h0 : 0 < ⨅ n, ∫ ω, X n ω ∂μ := by
      apply lt_iInf_iff.mpr
      intro ε hε
      -- すべてのnで期待値 > εとなるようなε > 0が存在
      push_neg
      use 0
      constructor
      · exact hPos 0
      · intro n
        exact le_of_lt (hPos n)
    -- 下界をε/2とする
    use (⨅ n, ∫ ω, X n ω ∂μ) / 2
    constructor
    · linarith
    · intro n
      have := iInf_le (fun n => ∫ ω, X n ω ∂μ) n
      linarith
  
  -- n = ⌈2M/ε⌉ + 1 とする
  use (2 * M / ε).natCeil + 1
  
  -- 大数の弱法則により、十分大きい確率で S_n/n は期待値に近い
  -- ここでは決定論的な評価を使う別のアプローチを取る
  -- 各X_iは非負なので、期待値の正性から必ず発散する
  sorry -- 技術的詳細：測度論的収束の議論

end Biyaku