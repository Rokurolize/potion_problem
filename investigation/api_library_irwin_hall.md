# api-library.md に記載されているIrwinHall関連のAPI

## irwin_hall_support (行158) 関連

### 記載されているAPI:
1. **Int.alternating_sum_range_choose** ⭐⭐⭐⭐⭐ (行357-370)
   - Status: ✅ Verified
   - 二項係数の交代和が0になることの証明
   - `import Mathlib.Data.Nat.Choose.Sum`

2. **Int.alternating_sum_range_choose_of_ne** ⭐⭐⭐⭐ (行372-377)
   - Status: ✅ Verified
   - n ≠ 0の場合の直接版

3. **Finset.sum_bij** (行379-384)
   - Status: ✅ Verified
   - 包含排除の再配置用

### コメントで言及されているが未収録のAPI:
- B-スプライン理論（mathlib4に存在しない）
- 分割差分理論（mathlib4に存在しない）

## irwin_hall_sum_at_n (行173) 関連

### 記載されているAPI:
1. **fwdDiff_iter_eq_sum_shift** ⭐⭐⭐⭐⭐ (行435-446)
   - Status: ✅ Verified
   - n階前進差分の一般公式
   - 符号パターン: (-1)^(n-k)
   - `import Mathlib.Algebra.Group.ForwardDiff`

2. **shift_eq_sum_fwdDiff_iter** ⭐⭐⭐⭐ (行448-454)
   - Status: ✅ Verified
   - Gregory-Newton補間公式
   - `import Mathlib.Algebra.Group.ForwardDiff`

### コメントで言及されているが未収録のAPI:
- スカラー作用から乗算への型変換補題
- 多項式とfwdDiffの明示的接続

## irwin_hall_continuous (行208) 関連

### 記載されているAPI:
1. **Continuous.if** (行458-463)
   - Status: ✅ Verified
   - 条件付き連続性
   - `import Mathlib.Topology.Piecewise`

2. **ContinuousOn.piecewise** (行465-470)
   - Status: ✅ Verified
   - 区分的連続性

3. **continuous_piecewise** ⭐⭐⭐⭐ (行472-485)
   - Status: ✅ Verified
   - より柔軟な区分的連続性

4. **continuousOn_floor** ⭐⭐⭐⭐ (行487-493)
   - Status: ✅ Verified
   - 床関数の半開区間での連続性
   - `import Mathlib.Topology.Algebra.Order.Floor`

5. **continuousOn_piecewise_ite** ⭐⭐⭐ (行495-503)
   - Status: ✅ Verified
   - 指示条件による区分的関数

## iter_fwdDiff_pow_eq_factorial 関連

### コメントで言及されているが api-library.md に未収録のAPI:
1. **Polynomial.iterate_derivative_X_sub_pow_self**
   - derivative^[n]((X-c)^n) = n!

2. **Polynomial.iterate_derivative_X_pow_eq_C_mul**
   - 階乗パターンを示す

3. **多項式の次数削減性質**
   - Δ^n[x^k](0) = 0 for k < n