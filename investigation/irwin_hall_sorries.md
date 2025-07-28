# IrwinHallTheory.lean Sorry Analysis

## 3つのsorryの詳細

### 1. irwin_hall_support (行179)
**証明内容**: Irwin-Hall CDFが0となる条件 `irwin_hall_cdf n x = 0 ↔ x < 0 ∨ (x = 0 ∧ n > 0)`

**必要なAPI（コメントより）**:
- B-スプライン理論（mathlib4には存在しない）
- 分割差分理論（mathlib4には存在しない）
- 包含排除の複雑な論証
- 交代和の正値性の証明

**関連する既存API**:
- `Int.alternating_sum_range_choose` - 二項係数の交代和が0になることの証明

### 2. iter_fwdDiff_pow_eq_factorial (行233)
**証明内容**: `(fwdDiff 1)^[n] (fun x : ℝ => x ^ n) 0 = n.factorial`

**必要なAPI（コメントより）**:
- `add_pow` - 二項展開（利用可能）
- fwdDiffの線形性（線形写像として利用可能）
- 多項式の次数削減性質：Δ^n[x^k](0) = 0 for k < n（欠落）
- fwdDiffと多項式操作の明示的な接続（欠落）

**発見されたAPI（コメントより）**:
- `Polynomial.iterate_derivative_X_sub_pow_self`
- `Polynomial.iterate_derivative_X_pow_eq_C_mul`
- `fwdDiff_iter_eq_sum_shift`

### 3. irwin_hall_sum_at_n (行274)
**証明内容**: 包含排除公式 `∑ k ∈ Finset.range (n + 1), ((-1 : ℝ) ^ k * (Nat.choose n k) * (n - k : ℝ) ^ n) = n.factorial`

**必要なAPI（コメントより）**:
- `fwdDiff_iter_eq_sum_shift` - 一般的な前進差分公式（利用可能だが型の問題）
- スカラー作用（•）から乗算（*）への型変換
- `Finset.sum_bij` - 全単射による和の変換（利用可能）
- `shift_eq_sum_fwdDiff_iter` - Gregory-Newton公式

**技術的課題**:
- fwdDiff_iter_eq_sum_shiftはℤ値スカラー乗算を使用
- 実際の和はℝの乗算を使用
- 必要な補題：(n : ℤ) • r = (n : ℝ) * r