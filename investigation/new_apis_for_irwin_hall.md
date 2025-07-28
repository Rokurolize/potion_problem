# 新規発見API - IrwinHallTheory.lean用

## iter_fwdDiff_pow_eq_factorial (行233) のsorry解決に寄与するAPI

### 1. `Polynomial.iterate_derivative_X_sub_pow_self` ⭐⭐⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `theorem iterate_derivative_X_sub_pow_self (n : ℕ) (c : R) : derivative^[n] ((X - C c) ^ n) = n.factorial`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28743  
**Mathematical Significance**: (X-c)^nのn階導関数がn!に等しいことを証明
**Usage Pattern**:
```lean
-- n階導関数がn!になることの直接的な証明
have h := Polynomial.iterate_derivative_X_sub_pow_self n c
-- c=0の場合：derivative^[n] (X^n) = n.factorial
```

### 2. `Polynomial.iterate_derivative_X_pow_eq_C_mul` ⭐⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `theorem iterate_derivative_X_pow_eq_C_mul (n k : ℕ) : derivative^[k] (X ^ n : R[X]) = C (Nat.descFactorial n k : R) * X ^ (n - k)`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28721  
**Mathematical Foundation**: X^nのk階導関数 = n^(k) * X^(n-k) where n^(k)は下降階乗
**Usage Pattern**:
```lean
-- k=nの場合：derivative^[n] (X^n) = n! * X^0 = n!
have h := Polynomial.iterate_derivative_X_pow_eq_C_mul n n
-- Note: descFactorial n n = n!
```

### 3. `Polynomial.iterate_derivative_eq_zero` ⭐⭐⭐⭐
**Status**: ✅ Verified  
**Signature**: `theorem iterate_derivative_eq_zero {p : R[X]} {x : ℕ} (hx : p.natDegree < x) : Polynomial.derivative^[x] p = 0`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28688  
**Mathematical Significance**: 多項式の次数より多く微分するとゼロになる
**Usage Pattern**:
```lean
-- n次多項式のn+1階以上の導関数は0
have h : derivative^[n+1] p = 0 := iterate_derivative_eq_zero (by omega)
```

## 追加で発見された関連API

### 4. `Polynomial.iterate_derivative_X_add_pow`
**Status**: ✅ Verified  
**Signature**: `theorem iterate_derivative_X_add_pow (n k : ℕ) (c : R) : derivative^[k] ((X + C c) ^ n) = Nat.descFactorial n k • (X + C c) ^ (n - k)`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28725  
**Note**: (X+c)^nのパターン（fwdDiffとの関連性）

### 5. `Polynomial.iterate_derivative_X_sub_pow`
**Status**: ✅ Verified  
**Signature**: `theorem iterate_derivative_X_sub_pow (n k : ℕ) (c : R) : derivative^[k] ((X - C c) ^ n) = n.descFactorial k • (X - C c) ^ (n - k)`  
**Import**: `import Mathlib.Algebra.Polynomial.Derivative`  
**ID**: 28742  
**Note**: iterate_derivative_X_sub_pow_selfの一般化版

## 提案

これらのAPIをapi-library.mdの新しいセクション「Polynomial Derivative APIs」として追加することを推奨します。特に最初の3つは、iter_fwdDiff_pow_eq_factorialのsorry解決に直接的に寄与する可能性があります。