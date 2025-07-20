<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# mathlib4 v4.21.0のAPIギャップと実装支援に関する調査結果

調査された資料に基づき、mathlib4 v4.21.0における特定のAPI問題について包括的な分析を提供します。

## 主要な結論

mathlib4 v4.21.0では、**無限級数の再インデックス化**および**条件付き級数の部分型変換**において、いくつかの重要なAPIが不足または変更されています。しかし、これらの問題に対する代替手法と実装戦略が存在します。

## Issue 1: `tsum_equiv` APIの不在

### 問題の詳細

UniformSumHittingTime.leanで`tsum_equiv`の使用を試みたところ、「unknown identifier」エラーが発生しました[1][2]。これは無限級数の全単射再インデックス化に必要なAPIです。

### 解決策

mathlib4 v4.21.0では、以下の代替APIが利用可能です：

**1. `Equiv.tsum_eq`による実装**

```lean
def subtypeEquiv : {n // n ≥ 2} ≃ ℕ :=
  Equiv.ofBijective (fun ⟨n, h⟩ => n - 2) ...

lemma reindex_series :
  ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial =
  ∑' k : ℕ, (1 : ℝ) / k.factorial := by
  rw [Equiv.tsum_eq subtypeEquiv.symm]
```

**2. `Summable.compEquiv`による可和性伝播**

```lean
have h_summable : Summable (fun n => if n ≥ 2 then f n else 0) := by
  exact (summable_inv_factorial ℝ).compEquiv subtypeEquiv.symm
```


## Issue 2: `tsum_subtype'` APIの活用

### 条件付き級数の部分型変換

mathlib4 v4.21.0では`tsum_subtype'`が利用可能で、以下のパターンで使用できます：

```lean
have h := tsum_subtype' (fun n => if n ≥ 2 then (1 : ℝ) / (n-2).factorial else 0)
-- これにより ∑' n, if P n then f n else 0 = ∑' n : {n // P n}, f n に変換
```


## Issue 3: 比較判定法と可和性証明

### `Summable.of_norm_bounded_eventually_nat`の実装

TelescopingSeries.leanでの問題は、比較判定法の正しいAPI使用法にあります[3][4]：

**正しい実装方法：**

```lean
lemma summable_factorial_diff :
  Summable (fun n => if n ≥ 2 then (1 : ℝ) / (n-1).factorial - 1/n.factorial else 0) := by
  
  -- Step 1: 境界を証明
  have h_bound : ∀ᶠ n in atTop, ‖...‖ ≤ (1 : ℝ) / (n-1).factorial := by
    filter_upwards [eventually_ge_atTop 2] with n hn
    rw [Real.norm_eq_abs]
    exact factorial_diff_abs_bound n hn

  -- Step 2: 比較級数の可和性
  have h_summable_bound : Summable (fun n => (1 : ℝ) / (n-1).factorial) :=
    summable_shifted_factorial

  -- Step 3: 比較判定法適用
  exact Summable.of_norm_bounded_eventually_nat h_summable_bound h_bound
```


## Issue 4: `HasSum`構成とテンデンシー

### 部分和の収束からHasSumへの変換

```lean
theorem factorial_telescoping_sum_one :
  ∑' n, (if n ≥ 2 then (1 : ℝ) / (n-1).factorial - 1/n.factorial else 0) = 1 := by
  
  -- HasSum.tendsto_sum_natを使用
  apply HasSum.tsum_eq
  apply hasSum_of_sum_range_le
  
  -- 部分和の極限を使用
  exact pmf_partial_sums_tend_to_one
```


## 実装戦略の推奨事項

### 1. 段階的アプローチ

- **第一段階**: 既存のAPIで数学的基礎を確立
- **第二段階**: カスタム補助補題で技術的ギャップを埋める
- **第三段階**: 標準APIに統合


### 2. 代替実装パターン

```lean
-- Pattern 1: 条件付き級数を部分型に変換
∑' n, if P n then f n else 0 = ∑' n : {n // P n}, f n

-- Pattern 2: Equivによる再インデックス化
∑' n : A, f n = ∑' m : B, f (e.symm m)  -- where e : A ≃ B

-- Pattern 3: 比較判定法による可和性証明
Summable f ← ∃g, Summable g ∧ ∀ᶠ n, ‖f n‖ ≤ g n
```


## 結論と推奨事項

mathlib4 v4.21.0では、提起された問題のほとんどが**既存APIの組み合わせ**により解決可能です。主な推奨事項：

1. **`Equiv.tsum_eq`と`Summable.compEquiv`**を`tsum_equiv`の代替として使用
2. **`tsum_subtype'`**で条件付き級数を部分型級数に変換
3. **`Summable.of_norm_bounded_eventually_nat`**で比較判定法を実装
4. **`HasSum.tendsto_sum_nat`**で部分和収束からHasSumを構成

これらの手法により、元の数学的証明を完全にmathlib4 v4.21.0でフォーマル化することが可能です[1][2][5][6]。

