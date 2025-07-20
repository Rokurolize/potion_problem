<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Research Response: UniformSumHittingTime.lean – Three Remaining Sorries

## 結論（Main Takeaway）

Lean 4（mathlib4 v4.21.0）では、無限級数の**再インデックス化**・**部分型への変換**・**条件付き級数の扱い**に対して、以下の標準的APIが用意されています。

1. `tsum_equiv`：全ての無限級数をEquivを用いて再インデックス化
2. `Summable.compEquiv`：級数の可和性をEquiv経由で伝播
3. `tsum_subtype'`：条件付き和を部分型（`{n // P n}`）上の和に変換

これらを組み合わせることで、以下のsorriesをすべて解消できます。

## Sorry \#1: Series Reindexing

```lean
lemma reindex_series :
  ∑' n : {n : ℕ // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial =
  ∑' k : ℕ, (1 : ℝ) / k.factorial
```


### 解決方法

- **Equiv定義**

```lean
def subtypeEquiv : {n // n ≥ 2} ≃ ℕ :=
  Equiv.ofBijective (fun ⟨n, h⟩ => n - 2)
    (by
      refine ⟨fun k => ⟨k+2, Nat.succ_le_iff.2 (Nat.zero_le _)⟩, _, _⟩
      · rintro ⟨n, h⟩; simp [Nat.sub_add_cancel (Nat.le_of_lt_succ h)]
      · intro k; simp)
```

- **tsum_equiv適用**

```lean
lemma reindex_series :
  (∑' n : {n // n ≥ 2}, (1 : ℝ) / ((n : ℕ) - 2).factorial) =
  ∑' k : ℕ, (1 : ℝ) / k.factorial := by
rw [tsum_equiv (subtypeEquiv : {n // n ≥ 2} ≃ ℕ)]
· rfl
· exact (summable_inv_factorial ℝ).compEquiv subtypeEquiv.symm
```

- **ポイント**
    - `tsum_equiv`の第一引数に `A ≃ B` を渡すと、`∑' b : B, f (e.symm b) = ∑' a : A, f a` が自動化される。
    - `Summable.compEquiv` で可和性を移す。


## Sorry \#2: Summability Inheritance

```lean
lemma summable_hitting_time : Summable (fun n => n * prob_hitting_time n)
```


### 解決方法

- 知見：`n * prob_hitting_time n = if n ≥ 2 then 1/(n-2)! else 0`
- **部分型での和に変換**

```lean
have h_sum_eq : (fun n => n * prob_hitting_time n) =
  fun n => if n ≥ 2 then (1 : ℝ) / ((n - 2).factorial) else 0 := by
  ext n; cases n; decide
```

- **可和性移行**

```lean
lemma summable_hitting_time : Summable (fun n => n * prob_hitting_time n) := by
  rw [h_sum_eq]
  -- ∑' n, if P n then f n else 0 なら部分型に移せる
  refine (FactorialSeries.summable_inv_factorial ℝ).ofEquiv
    (Equiv.subtypeEquiv₂ fun n => n ≥ 2).symm
```

- **API**
    - `Summable.ofEquiv` または `Summable.compEquiv` で，Equiv経由で可和性を伝播。
    - 条件付き級数を部分型に変換可能な `tsum_subtype'` に対応する `Summable.subtype` も利用できる。


## Sorry \#3: Main Theorem Assembly

```lean
theorem main_result : expected_hitting_time = exp 1
```


### 解決方法

1. **条件分岐付き級数を部分型の和へ**

```lean
have h := by
  simp [expected_hitting_time] -- ∑' n, if n ≥ 2 then ((n - 2).factorial : ℝ)⁻¹ else 0
  exact tsum_subtype' fun n => (1 : ℝ) / ((n - 2).factorial)
```

2. **部分型の和をℕ上の級数へ再インデックス化**

```lean
have h' : (∑' k : {n // n ≥ 2}, (1 : ℝ) / ((k : ℕ) - 2).factorial) =
          ∑' k : ℕ, (1 : ℝ) / k.factorial := reindex_series
```

3. **指数関数級数への同値変換**

```lean
calc
  expected_hitting_time = ∑' n, if n ≥ 2 then ((n - 2).factorial : ℝ)⁻¹ else 0 := by simp
  _ = ∑' k : {n // n ≥ 2}, (1 : ℝ) / ((k : ℕ) - 2).factorial := by simp [tsum_subtype']
  _ = ∑' k : ℕ, (1 : ℝ) / k.factorial := by rw [reindex_series]
  _ = exp 1 := exp_one_eq_tsum_inv_factorial ℝ
```


- **ポイント**
    - `tsum_subtype'`：`∑' n, if P n then f n else 0 = ∑' n : {n // P n}, f n`
    - 以上と `reindex_series` ，および既存の `exp_one_eq_tsum_inv_factorial` を連結。


## まとめ

- **再インデックス化**には `tsum_equiv`＋`Equiv`
- **可和性伝播**には `Summable.compEquiv`（旧 `Summable.ofEquiv`）
- **条件付き級数⇔部分型の級数**には `tsum_subtype'`
- これら標準APIを組み合わせることで、最終的に

$$
\sum_{n\ge2}\frac1{(n-2)!}
  =\sum_{k\ge0}\frac1{k!}
  =e
$$

をLean上でスッキリと機械的に証明できます。

<div style="text-align: center">⁂</div>

[^1]: 36-uniform-sum-hitting-time-three-sorries.md

[^2]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Group/Equiv/Basic.html

[^3]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Matrix/Defs.html

[^4]: https://github.com/leanprover-community/mathlib/blob/master/src/measure_theory/integral/lebesgue.lean

[^5]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Algebra/Equiv.html

[^6]: https://leanprover-community.github.io/mathlib_docs/topology/algebra/infinite_sum/basic.html

[^7]: https://mathlib-changelog.org/v3/theorem/tsum_sub

[^8]: https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/CategoryTheory/Types.lean

[^9]: https://aclanthology.org/2024.findings-emnlp.470.pdf

[^10]: https://cs.brown.edu/courses/cs1951x/docs/data/set_like.html

[^11]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/smul-experiment/Mathlib/FieldTheory/PolynomialGaloisGroup.lean

[^12]: https://huggingface.co/datasets/tasksource/leandojo/viewer/default/train?p=0

[^13]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/15d6b7a1a8bb1068e0c17dee20f5ae2b8bd8415e/Mathlib/Topology/Algebra/InfiniteSum/Basic.lean

[^14]: https://stackoverflow.com/questions/16885210/typeerror-when-multiplying-matrices

[^15]: https://github.com/leanprover-community/mathlib4/blob/master/Mathlib.lean

[^16]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/dvdsemired/Mathlib/Probability/CondCount.lean

[^17]: https://leanprover-community.github.io/mathlib4_docs/Mathlib

[^18]: https://github.com/leanprover-community/mathlib4/blob/master/Archive/Imo/Imo2019Q2.lean

[^19]: https://speed.lean-lang.org/mathlib4/run-detail/e7b27246-a3e6-496a-b552-ff4b45c7236e/c03f829f30aa93aa8d7da19769d88e73a70b6ba4

[^20]: https://proofassistants.stackexchange.com/questions/2460/understanding-mathlib-measuretheory-notation

[^21]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/YK-ord-hom-funlike/Mathlib/LinearAlgebra/Matrix/Reindex.lean

[^22]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Topology/Algebra/InfiniteSum/Ring.html

[^23]: https://www.rdocumentation.org/packages/hett/versions/0.3-3/topics/tsum

[^24]: https://www.tensorflow.org/probability/api_docs/python/tfp/bijectors/Cumsum

[^25]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Topology/Algebra/InfiniteSum/Order.html

[^26]: https://www.tensorflow.org/federated/api_docs/python/tff/federated_secure_sum_bitwidth

[^27]: https://support.google.com/docs/answer/3093583

[^28]: https://florisvandoorn.com/BonnAnalysis/docs/Mathlib/Topology/Algebra/InfiniteSum/Real.html

[^29]: https://docs.w3cub.com/tensorflow~2.9/einsum.html

[^30]: https://datascience.stackexchange.com/questions/41834/how-to-calculate-cumulative-sum-with-groupby-in-python

[^31]: https://leanprover-community.github.io/archive/stream/113488-general/topic/tsum.20over.20option.html

[^32]: https://mathlib-changelog.org/v3/commit/8fa8f175

[^33]: https://apps.apple.com/sg/app/line-disney-tsum-tsum/id867964741

[^34]: https://www.rdocumentation.org/packages/PASWR2/versions/1.0.5/topics/tsum.test

[^35]: https://apps.apple.com/it/app/tsum-collect/id6443570090

[^36]: https://florisvandoorn.com/carleson/docs/Mathlib/Topology/Algebra/InfiniteSum/Module.html

[^37]: https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/unsorted-segment-sum

[^38]: https://superuser.com/questions/1603768/problems-with-sumproduct

[^39]: https://plmlab.math.cnrs.fr/nuccio/octonions/-/blob/mono/Mathlib/Topology/Algebra/InfiniteSum/Order.lean

[^40]: https://stackoverflow.com/questions/23612467/r-bonferroni-correction-on-tsum-test

[^41]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/GroupTheory/SpecificGroups/Dihedral.html

[^42]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/mono/Mathlib/GroupTheory/OrderOfElement.lean

[^43]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Topology/Algebra/InfiniteSum/Defs.html

[^44]: https://leanprover-community.github.io/mathlib4_docs/Mathlib.html

[^45]: https://proofassistants.stackexchange.com/questions/4339/proofs-with-summations-∑-in-lean-4

[^46]: https://florisvandoorn.com/BonnAnalysis/docs/Mathlib/Topology/Algebra/InfiniteSum/Basic.html

[^47]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Sum/Basic.html

[^48]: https://leanprover-community.github.io/mathlib_docs/analysis/normed/group/infinite_sum.html

[^49]: https://tqft.net/mathlib4/2022-11-28/data.fintype.basic.pdf

[^50]: https://math.stackexchange.com/questions/1949310/summation-over-a-countably-infinite-set

[^51]: https://mathematica.stackexchange.com/questions/197117/efficiently-define-a-function-as-the-numerical-result-of-infinite-sums

[^52]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/981ba6dfcdfb2983419c7abb46e619865dee6bb7/Mathlib/Data/Finset/Sum.lean

[^53]: https://tqft.net/mathlib4/2022-11-20/all.pdf

[^54]: https://sites.math.rutgers.edu/~sussmann/infinite-sums.pdf

[^55]: https://tqft.net/mathlib4/2022-11-17/data.fintype.basic.pdf

[^56]: https://lean-forward.github.io/lean-together/2019/slides/hoelzl.pdf

