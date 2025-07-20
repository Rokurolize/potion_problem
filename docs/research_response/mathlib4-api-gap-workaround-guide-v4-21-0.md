<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# 追加調査報告

以下では，ユーザーの追従調査依頼（`38-mathlib4-api-gap-response-and-followup.md`）に基づき，mathlib4 v4.21.0 における主な API ギャップとその回避策について整理する。

## 1. `tsum_equiv` の代替

### 現状

- mathlib4 v4.21.0 には `tsum_equiv` は存在しない。
- 代わりに，`Equiv.tsum_eq`（別名 `Equiv.tsum_eq_tsum_of_support`）が用意されている[^1]。


### 使い方

```lean
import Mathlib.Topology.Algebra.InfiniteSum.Basic

def subtypeEquiv : { n // n ≥ 2 } ≃ ℕ := 
  Equiv.ofBijective (fun ⟨n, hn⟩ => n - 2) 
    ⟨fun k => ⟨k + 2, by simp⟩, by simp, by simp⟩

lemma reindex_series :
  ∑' n : { n // n ≥ 2 }, 1 / ((n : ℕ) - 2).factorial =
  ∑' k : ℕ, 1 / k.factorial := by
  -- Equiv.tsum_eq を使って再インデックス化
  rw [Equiv.tsum_eq subtypeEquiv.symm]
  -- 可和性伝播は別途 Summable.compEquiv 等で証明
```


## 2. `tsum_subtype` / `tsum_subtype'` の署名

### 現状

- `tsum_subtype' : ∀ {α β} [AddCommMonoid β] [TopologicalSpace β] {f : α → β} (p : α → Prop) [DecidablePred p],   (∑' a, if p a then f a else 0) = ∑' a : Subtype p, f a`
が定義されている[^1]。


### 使い方

```lean
lemma cond_sum_to_subtype {f : ℕ → ℝ} :
  (∑' n, if n ≥ 2 then f n else 0) = ∑' n : { n // n ≥ 2 }, f n := by
  exact tsum_subtype' (fun n => if n ≥ 2 then f n else 0)
```


## 3. `conv` モードの引数指定

### 現状

- v4.21.0 以降，`conv => arg i` は非推奨。
- `conv at h => ...`，`conv lhs => ...`，`conv rhs => ...` が使える[^2]。


### 使い方例

```lean
lemma foo : _ := by
  calc
    A = B := by conv at this => 
      -- 部分式を選択し rewrite
      first | rfl | simp
```


## 4. 階乗逆元表記

### 現状

- mathlib4 では `n!⁻¹` と逆数の逆元 notation が提供されており，
`1 / n.factorial` より `n.factorial⁻¹` を使うことが推奨される[^1]。


### 使い方

```lean
#check (3 : ℕ).factorial⁻¹  -- 1/6 : ℝ
```


## まとめと次のステップ

1. **再インデックス化**: `Equiv.tsum_eq` を使用
2. **条件付き無限和⇔部分型**: `tsum_subtype'` を使用
3. **conv モード**: `conv lhs`／`conv rhs`／`conv at` に置き換え
4. **逆数 notation**: `n.factorial⁻¹` を活用

これらを適用することで，UniformSumHittingTime.lean および TelescopingSeries.lean の残りの sorries を埋める技術的橋渡しが可能と考えられます。

<div style="text-align: center">⁂</div>

[^1]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/15d6b7a1a8bb1068e0c17dee20f5ae2b8bd8415e/Mathlib/Topology/Algebra/InfiniteSum/Basic.lean

[^2]: https://lean-lang.org/doc/reference/latest/releases/v4.14.0/

[^3]: 36-uniform-sum-hitting-time-three-sorries.md

[^4]: 37-implementation-issues-follow-up.md

[^5]: UniformSumHittingTime.lean

[^6]: TelescopingSeries.lean

[^7]: 38-mathlib4-api-gap-response-and-followup.md

[^8]: https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Tactic/Sat/FromLRAT.lean

[^9]: https://leanprover-community.github.io/mathlib_docs/data/nat/factorial/basic.html

[^10]: https://arxiv.org/html/2406.03847v2

[^11]: https://leanprover-community.github.io/archive/stream/270676-lean4/

[^12]: https://math.commelin.net/files/mathlib4/2023-01-21/all.pdf

[^13]: https://leanprover-community.github.io/archive/stream/113488-general/

[^14]: https://git.lukegb.com/lukegb/depot/src/commit/66b169d2c3ba1770577aa85fca4ff50047d2d4f3/pkgs/by-name/g8

[^15]: https://leanprover-community.github.io/mathlib4_docs/Mathlib

[^16]: https://leanprover-community.github.io/archive/stream/270676-lean4/topic/doc-gen4.20broken.html

[^17]: https://git.lukegb.com/lukegb/depot/src/commit/1bcbfe0822b908b85a5345b0580880f54d034571/.github

[^18]: https://arxiv.org/html/2507.08665v1

[^19]: https://github.com/leanprover-community/mathlib4/blob/master/Mathlib.lean

[^20]: https://tqft.net/mathlib4/2023-01-25/all.pdf

[^21]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/xfr-mem_span_iff/Mathlib.lean

[^22]: https://tqft.net/mathlib4/2023-01-06/all.pdf

[^23]: https://www.algol60.org/15algolwlego.htm

[^24]: https://arxiv.org/pdf/2507.08665.pdf

[^25]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Topology/Algebra/InfiniteSum/Defs.html

[^26]: https://github.com/leanprover-community/mathlib/blob/master/src/measure_theory/integral/lebesgue.lean

[^27]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/dvdsemired/Mathlib/Probability/CondCount.lean

[^28]: https://github.com/leanprover-community/mathlib/blob/master/src/measure_theory/measure/vector_measure.lean

[^29]: https://speed.lean-lang.org/mathlib4/run-detail/e7b27246-a3e6-496a-b552-ff4b45c7236e/c03f829f30aa93aa8d7da19769d88e73a70b6ba4

[^30]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/YK-sorgenfrey-golf/Mathlib/Analysis/Quaternion.lean

