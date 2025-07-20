<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# 追加調査結果

以下では、Mathlib4 (v4.21.0) における主要な API レンガを紹介し、`factorial_telescoping_sum_one` の証明に必要な HasSum 構成と、インデックスシフト・フィルタ付き部分和への対処法を示します。

## 1. 部分和の極限から HasSum を得る（`∑' f = L` の証明）

Mathlib4 では、以下の補題で「部分和の極限」から `HasSum f L` を構築できます。

```lean
open Filter Topology

-- Mathlib4: Mathlib.Topology.Algebra.InfiniteSum.Basic
theorem hasSum_iff_tendsto (f : ℕ → α) (L : α) [AddCommMonoid α] [TopologicalSpace α] :
  HasSum f L ↔ Tendsto (fun N => ∑ n in Finset.range N, f n) atTop (𝓝 L)
```

これを使うと、

```lean
have h_lim : Tendsto (fun N => ∑ n in Finset.range N, f n) atTop (𝓝 1) := -- 既証
have h_sum : HasSum f 1 := (hasSum_iff_tendsto f 1).2 h_lim
```

さらに、`HasSum.tsum_eq` で `∑' n, f n = 1` を得られます。

-- `hasSum_iff_tendsto` は `Tendsto` ↔ `HasSum` の双方向定理です[^1][^2]。

## 2. インデックスシフトを扱う補題

関数 `g : ℕ → α` について、`g (n+1)` の級数が可測級数（summable）であることと、元の `g` の級数が可測級数であることは同値です。Mathlib4 には次のような補題があります：

```lean
theorem Summable.nat_add_iff {α : Type*} [AddCommMonoid α] [TopologicalSpace α] (f : ℕ → α) (k : ℕ) :
  Summable (fun n => f (n + k)) ↔ Summable f
```

特に `k=1` のとき、

```lean
Summable (fun n => f (n+1)) ↔ Summable f
```

を用いて、`(1/(n-1)!)` へのシフトを処理できます。

## 3. フィルタ付き部分和（`Finset.range N \ Finset.range k`）の扱い

`f n = 0` for `n < k` かつ

```lean
Tendsto (fun N => ∑ n in Finset.range N \ Finset.range k, f n) atTop (𝓝 L)
```

が成り立つ場合、`Tendsto (fun N => ∑ n in Finset.range N, f n) atTop (𝓝 L)` を自明に導出できます。なぜなら、`Finset.range k` 上の項は零なので、

```
∑ n in Finset.range N, f n = ∑ n in Finset.range N \ Finset.range k, f n
```

が `N ≥ k` 以降常に成り立ち、`filter_upwards` と `eventually` を使って極限を引き継げます。

```lean
have h_zero : ∀ n < k, f n = 0 := …  
have h_eventually : ∀ᶠ N in atTop, 
  ∑ n in Finset.range N, f n = ∑ n in Finset.range N \ Finset.range k, f n := by
  filter_upwards [eventually_ge_atTop k] with N hN; simp [*, Finset.sum_diff_subset]
```

これを先の `hasSum_iff_tendsto` に結びつけます。

## 4. 推奨 API と証明スケッチ

```lean
import Mathlib.Topology.Algebra.InfiniteSum.Basic

theorem factorial_telescoping_sum_one :
  ∑' n, if n ≥ 2 then 1/(n-1)! - 1/n! else 0 = 1 := by
  set f := fun n => if n ≥ 2 then 1/(n-1)! - 1/n! else 0
  -- (1) 部分和の極限を示す（既に証明済みと仮定）
  have h_lim : Tendsto (fun N => ∑ n in Finset.range N \ Finset.range 2, f n) atTop (𝓝 1) := …
  -- (2) n<2 のとき f n = 0 を示す
  have h_zero : ∀ n < 2, f n = 0 := by simp [f]
  -- (3) フィルタ付き部分和を全範囲の部分和に置き換える
  have h_eventually :
    ∀ᶠ N in atTop, (∑ n in Finset.range N, f n) = ∑ n in Finset.range N \ Finset.range 2, f n := by
    filter_upwards [eventually_ge_atTop 2] with N hN; simp [h_zero]
  have h_lim_full : Tendsto (fun N => ∑ n in Finset.range N, f n) atTop (𝓝 1) := by
    refine tendsto_nhds_of_eventuallyEq h_eventually h_lim
  -- (4) 部分和の極限から HasSum を得て tsum に移行
  have h_sum : HasSum f 1 := (hasSum_iff_tendsto f 1).2 h_lim_full
  exact h_sum.tsum_eq
```

以上の方法で、Mathlib4 v4.21.0 の標準的 API を用いて `∑' f = 1` を証明できます。

<div style="text-align: center">⁂</div>

[^1]: https://leanprover-community.github.io/mathlib_docs/topology/algebra/infinite_sum/basic.html

[^2]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/981ba6dfcdfb2983419c7abb46e619865dee6bb7/Mathlib/Data/Finset/Sum.lean

[^3]: telescoping-series-api-research-request.md

[^4]: 39-telescoping-series-api-response-and-followup.md

[^5]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Topology/Algebra/InfiniteSum/Defs.html

[^6]: https://isabelle.systems/zulip-archive/stream/202961-General/topic/summation.20swaps.html

[^7]: https://leanprover-community.github.io/mathlib4_docs/Mathlib.html

[^8]: https://leanprover-community.github.io/mathlib_docs/topology/continuous_function/bounded.html

[^9]: https://stackoverflow.com/questions/62290277/cant-prove-trivial-lemma-about-function-with-non-standard-recursion

[^10]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/15d6b7a1a8bb1068e0c17dee20f5ae2b8bd8415e/Mathlib/Topology/Algebra/InfiniteSum/Basic.lean

[^11]: https://tqft.net/mathlib4/2023-01-01/topology.metric_space.basic.pdf

[^12]: https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Scope.20of.20mathlib.html

[^13]: https://gist.github.com/Aaron1011/981f24fb87d805cc209b87b52d49e99d

[^14]: https://gist.github.com/PatrickMassot/79d7f53b3777c48e0910e131aedff7ea

[^15]: https://proofassistants.stackexchange.com/questions/4393/manipulating-summations-∑-and-telescopic-sums-in-lean-4

[^16]: https://huggingface.co/datasets/tasksource/leandojo/viewer/default/train?p=0

[^17]: https://leanprover-community.github.io/archive/stream/116395-maths/topic/Help.20.7Bgeneralize.2C.20rename.7D.20these.20.20lemmas.20for.20mathlib.html

[^18]: https://huggingface.co/datasets/l3lab/ntp-mathlib-instruct-context-fullproof/viewer/default/train?p=2

[^19]: http://www.cs.umd.edu/~gasarch/BLOGPAPERS/sum.pdf

[^20]: https://proofassistants.stackexchange.com/questions/2460/understanding-mathlib-measuretheory-notation

[^21]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/hrmacbeth-aesop-experiment/Mathlib/Deprecated/Subgroup.lean

[^22]: https://plmlab.math.cnrs.fr/nuccio/octonions/-/blob/mono/Mathlib/Topology/Algebra/InfiniteSum/Order.lean

[^23]: https://stackoverflow.com/questions/74337244/turning-a-valuesimp-example-into-a-lemma-with-functions-in-them

[^24]: https://leanprover-community.github.io/mathlib_docs/data/nat/basic.html

[^25]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Sum/Basic.html

[^26]: https://proofassistants.stackexchange.com/questions/4339/proofs-with-summations-∑-in-lean-4

[^27]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/981ba6dfcdfb2983419c7abb46e619865dee6bb7/Mathlib/Analysis/Normed/Group/InfiniteSum.lean

[^28]: https://isabelle.in.tum.de/library/Doc/Tutorial/natsum.html

[^29]: https://tqft.net/mathlib4/2022-12-11/all.pdf

[^30]: https://isabelle.in.tum.de/exercises/lists/sum/sol.pdf

[^31]: https://course.ccs.neu.edu/cs2800sp23/l24.html

[^32]: https://leanprover-community.github.io/mathlib4_docs/Init/Data/Nat/Basic.html

