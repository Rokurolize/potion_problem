# IrwinHallTheory.lean Sorry解決のためのAPI収録推奨

## 概要

調査の結果、IrwinHallTheory.leanの3つのsorryのうち、2つのsorry解決に必要なAPIが発見されました。これらをapi-library.mdに追加することを推奨します。

## 推奨追加API

### 1. iter_fwdDiff_pow_eq_factorial (行233) 用

#### `Polynomial.iterate_derivative_X_sub_pow_self` ⭐⭐⭐⭐⭐ **CRITICAL**
**Status**: ✅ Verified (2025-01-28)  
**Signature**: `theorem iterate_derivative_X_sub_pow_self (n : ℕ) (c : R) : derivative^[n] ((X - C c) ^ n) = n.factorial`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28743  
**Mathematical Significance**: (X-c)^nのn階導関数がn!に等しいことの直接証明
**Critical for**: iter_fwdDiff_pow_eq_factorial - c=0の場合でX^nのn階導関数 = n!

#### `Polynomial.iterate_derivative_X_pow_eq_C_mul` ⭐⭐⭐⭐
**Status**: ✅ Verified (2025-01-28)  
**Signature**: `theorem iterate_derivative_X_pow_eq_C_mul (n k : ℕ) : derivative^[k] (X ^ n : R[X]) = C (Nat.descFactorial n k : R) * X ^ (n - k)`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28721  
**Usage Pattern**: k=nの場合：derivative^[n] (X^n) = n.factorial * 1

#### `Polynomial.iterate_derivative_eq_zero` ⭐⭐⭐⭐
**Status**: ✅ Verified (2025-01-28)  
**Signature**: `theorem iterate_derivative_eq_zero {p : R[X]} {x : ℕ} (hx : p.natDegree < x) : Polynomial.derivative^[x] p = 0`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28688  
**Mathematical Significance**: 多項式の次数削減性質 - Δ^n[x^k](0) = 0 for k < n

### 2. irwin_hall_sum_at_n (行274) 用

#### `zsmul_eq_mul` ⭐⭐⭐⭐⭐ **CRITICAL**
**Status**: ✅ Verified (2025-01-28)  
**Signature**: `@[simp] lemma _root_.zsmul_eq_mul (a : α) : ∀ n : ℤ, n • a = n * a`  
**Import**: `import Mathlib.Data.Int.Cast.Lemmas`  
**ID**: 91820  
**Mathematical Significance**: スカラー作用から乗算への型変換
**Critical for**: irwin_hall_sum_at_n - fwdDiff_iter_eq_sum_shiftのℤ値スカラー作用をℝ乗算に変換

## 非収録の判断

### irwin_hall_support (行179) 用
- B-スプライン理論、分割差分理論は**mathlib4に存在しない**ため、収録不要
- 既に収録済みの`Int.alternating_sum_range_choose`で部分的に対応可能

### irwin_hall_continuous (行318) 用
- 必要なAPIは**全て既に収録済み**

## 結論

上記4つのAPIをapi-library.mdに追加することで、iter_fwdDiff_pow_eq_factorialとirwin_hall_sum_at_nの2つのsorry解決の可能性が大幅に向上します。