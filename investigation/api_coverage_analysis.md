# API Coverage Analysis for IrwinHallTheory.lean

## Executive Summary

IrwinHallTheory.leanには3つのsorryがありますが、**必要なAPIの一部がapi-library.mdに記載されていません**。

## 収録されているAPI

### 1. irwin_hall_support (行158) 関連
✅ **収録済み**:
- `Int.alternating_sum_range_choose` - 二項係数の交代和の証明
- `Int.alternating_sum_range_choose_of_ne` - n ≠ 0版
- `Finset.sum_bij` - 包含排除用

❌ **未収録** (コメントで言及):
- B-スプライン理論（mathlib4に存在しない）
- 分割差分理論（mathlib4に存在しない）

### 2. iter_fwdDiff_pow_eq_factorial (行233) 関連
✅ **収録済み**:
- なし（関連APIが一切収録されていない）

❌ **未収録** (コメントで言及):
- `Polynomial.iterate_derivative_X_sub_pow_self` - derivative^[n]((X-c)^n) = n!
- `Polynomial.iterate_derivative_X_pow_eq_C_mul` - 階乗パターン
- `fwdDiff_iter_eq_sum_shift` - 一般的な前進差分公式（irwin_hall_sum_at_n用には収録済みだが、このsorry用ではない）
- 多項式の次数削減性質（Δ^n[x^k](0) = 0 for k < n）

### 3. irwin_hall_sum_at_n (行274) 関連
✅ **収録済み**:
- `fwdDiff_iter_eq_sum_shift` - n階前進差分の一般公式
- `shift_eq_sum_fwdDiff_iter` - Gregory-Newton補間公式
- `Finset.sum_bij` - 全単射による和の変換

❌ **未収録** (コメントで必要と言及):
- スカラー作用（•）から乗算（*）への型変換補題
- 抽象的なfwdDiffと具体的な評価の接続

### 4. irwin_hall_continuous (行318) 関連
✅ **収録済み**（全て収録済み）:
- `Continuous.if` - 条件付き連続性
- `ContinuousOn.piecewise` - 区分的連続性
- `continuous_piecewise` - 柔軟な区分的連続性
- `continuousOn_floor` - 床関数の半開区間での連続性
- `continuousOn_piecewise_ite` - 指示条件による区分的関数

## 調査結果サマリー

1. **iter_fwdDiff_pow_eq_factorial** のsorryに必要なAPIは**全く収録されていない**
   - 特に`Polynomial.iterate_derivative_*`系のAPIが欠落

2. **irwin_hall_sum_at_n** のsorryには一部APIは収録されているが、型変換関連の重要なAPIが欠落

3. **irwin_hall_support** のsorryは、そもそもmathlib4に存在しないAPI（B-スプライン理論等）が必要なため、戦略的撤退が妥当

4. **irwin_hall_continuous** のsorryは全て必要なAPIが収録済み

## 推奨アクション

1. `iter_fwdDiff_pow_eq_factorial`に必要な多項式関連APIを調査し、api-library.mdに追加
2. スカラー作用から乗算への型変換補題の存在を確認
3. 多項式の次数削減性質に関するAPIの調査