<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Research Response: Lean 4 API for TelescopingSeries.lean

## 主要結論

**`summable_factorial_diff`** には

```lean
import Mathlib.Analysis.Normed.Group.InfiniteSum

lemma summable_factorial_diff :
  Summable (fun n : ℕ => if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) := by
  have h_bound : ∀ᶠ n in atTop, ‖(if n ≥ 2 then 1/(n-1)! - 1/n! else 0)‖ ≤ 1/(n-1)! := by
    filter_upwards [eventually_ge_atTop 2] with n _; simp; exact factorial_diff_abs_bound n ‹_›
  exact Summable.of_norm_bounded_eventually h_bound (summable_exp_tail 1) 
```

を使う。
【Summable.of_norm_bounded_eventually により、ノルムが可測級数で有界なら Summable とする】【1】

**`factorial_telescoping_sum_one`** には

```lean
import Mathlib.Topology.Algebra.InfiniteSum.Basic

theorem factorial_telescoping_sum_one :
  ∑' n, if n ≥ 2 then 1/(n-1)! - 1/n! else 0 = 1 := by
  refine (hasSum_iff_tendsto'.mp ?_).tsum_eq
  simpa using pmf_partial_sums_tend_to_one.filterRange (by decide : Finset.range 2 = {0,1})
```

を使う。

- `hasSum_iff_tendsto'`：`f n = 0` が有限個の例外を除き成り立つ場合でも、
`Tendsto (∑ n in range N, f n) atTop (nhds L)` から `HasSum f L` を得る
【has_sum_iff_tendsto により、自然な極限から HasSum を構築】[^1]


## 詳細

### 1. summable_factorial_diff

- **目標**

$$
\sum_{n=0}^\infty f(n),\quad f(n)=\begin{cases}
    1/(n-1)! - 1/n!,&n\ge2,\\
    0,&n<2
  \end{cases}
$$

の絶対収束（Summable）を示す。
- **主要 API**
    - `Summable.of_norm_bounded_eventually` : 完備ノルム群における比較判定テストの変種で、「ある有限例外を除いて‖f n‖ ≤ g n が成り立ち、∑ g n が Summable」なら ∑ f n も Summable となる。
    - `summable_exp_tail` : ∑ₙ 1/n! が Summable であることを与える補題。
- **実装スニペット**

```lean
import Mathlib.Analysis.Normed.Group.InfiniteSum

lemma summable_factorial_diff :
  Summable (fun n : ℕ => if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0) := by
  -- eventually (for n ≥ 2) we have |f n| ≤ 1/(n-1)!
  have h_bound : ∀ᶠ n in atTop, ‖(if n ≥ 2 then 1/(n-1)! - 1/n! else 0)‖ ≤ 1/(n-1)! := by
    filter_upwards [eventually_ge_atTop 2] with n _; simp; exact factorial_diff_abs_bound n ‹_›
  -- ∑ₙ 1/(n-1)! = ∑ₘ 1/m! is summable
  exact Summable.of_norm_bounded_eventually h_bound (summable_exp_tail 1)
```

*解説*

1. `eventually_ge_atTop 2` で「十分大きい n では n≥2」
2. `factorial_diff_abs_bound` により `|1/(n-1)! - 1/n!| ≤ 1/(n-1)!`
3. `Summable.of_norm_bounded_eventually` で Summable を結論づける[^2]


### 2. factorial_telescoping_sum_one

- **目標**

$$
\sum_{n=0}^\infty f(n) = 1,\quad f(n)=
    \begin{cases}
      1/(n-1)! - 1/n!&n\ge2,\\0&n<2
    \end{cases}
$$

の総和（`tsum`）が 1 となることを示す。
- **主要 API**
    - `hasSum_iff_tendsto'`（別名 `hasSum.tendsto_sum_nat`）:
$HasSum f L\iff$
$\lim_{N\to\infty}\sum_{n<N}f n = L$ が成り立つ（特に finite exceptions を考慮可）。
    - `tsum_eq` : `HasSum f L` から `∑' n, f n = L` を得る。
- **実装スニペット**

```lean
import Mathlib.Topology.Algebra.InfiniteSum.Basic

theorem factorial_telescoping_sum_one :
  ∑' n, if n ≥ 2 then (1 : ℝ) / (n - 1).factorial - 1 / n.factorial else 0 = 1 := by
  -- 部分和の極限から HasSum を得る
  refine (hasSum_iff_tendsto'.mp ?_).tsum_eq
  -- 既に PMF.partial_sums tendsto_one を証明済みなのでそれを利用
  simpa using pmf_partial_sums_tend_to_one.filterRange (by decide : Finset.range 2 = {0,1})
```

*解説*

1. `pmf_partial_sums_tend_to_one` により
$\lim_{N\to\infty}\sum_{n∈range N\setminus{0,1}}f(n)=1$
2. `f(n)=0` for n<2 を用い、`filterRange` で `range N` 全体へ置き換え
3. `hasSum_iff_tendsto'` で `HasSum f 1` を導出
4. `.tsum_eq` で `∑' n, f n = 1` を結論づける[^1]


# 参考文献

[^2] Mathlib4 `Summable.of_norm_bounded_eventually`【analysis.normed.group.infinite_sum】
[^1] Mathlib4 `hasSum_iff_tendsto`【topology.algebra.infinite_sum.basic】

<div style="text-align: center">⁂</div>

[^1]: https://leanprover-community.github.io/mathlib_docs/topology/algebra/infinite_sum/basic.html

[^2]: telescoping-series-api-research-request.md

[^3]: https://leanprover-community.github.io/mathlib_docs/algebra/big_operators/norm_num.html

[^4]: https://leanprover-community.github.io/archive/stream/113488-general/topic/tsum.20over.20option.html

[^5]: https://leanprover-community.github.io/mathlib_docs/analysis/normed/group/infinite_sum.html

[^6]: https://leanprover-community.github.io/mathlib_docs/analysis/normed/field/infinite_sum.html

[^7]: https://github.com/leanprover-community/mathlib/blob/master/src/analysis/complex/basic.lean

[^8]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Topology/Algebra/InfiniteSum/Ring.html

[^9]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Normed/Module/Basic.html

[^10]: https://github.com/leanprover-community/mathlib/blob/master/src/measure_theory/measure/vector_measure.lean

[^11]: https://proofassistants.stackexchange.com/questions/4339/proofs-with-summations-∑-in-lean-4

[^12]: https://leanprover-community.github.io/mathlib_docs/analysis/normed_space/basic.html

[^13]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Normed/Group/InfiniteSum.html

[^14]: https://math.stackexchange.com/questions/2288103/showing-the-series-sum-n-1-inftyc-n-convergences-and-that-its-abel-su

[^15]: https://leanprover-community.github.io/mathlib4_docs/Mathlib

[^16]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/15d6b7a1a8bb1068e0c17dee20f5ae2b8bd8415e/Mathlib/Topology/Algebra/InfiniteSum/Basic.lean

[^17]: https://math.stackexchange.com/questions/1061311/absolute-convergence-interpretation-of-summation

[^18]: https://github.com/leanprover-community/mathlib4/blob/master/Mathlib.lean

[^19]: https://florisvandoorn.com/BonnAnalysis/docs/Mathlib/Topology/Algebra/InfiniteSum/Basic.html

[^20]: https://math.stackexchange.com/questions/3360224/meaning-of-absolute-convergence-when-summing-over-countably-infinite-set

[^21]: https://github.com/leanprover-community/mathlib4/pull/6091

[^22]: https://github.com/leanprover-community/mathlib/blob/master/src/analysis/normed_space/banach.lean

[^23]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/981ba6dfcdfb2983419c7abb46e619865dee6bb7/Mathlib/Analysis/Normed/Group/InfiniteSum.lean

[^24]: https://plmlab.math.cnrs.fr/nuccio/octonions/-/blob/kmill_deriving_linearorder/Mathlib/Topology/Algebra/InfiniteSum/Ring.lean

[^25]: https://github.com/leanprover-community/mathlib/blob/master/src/analysis/normed_space/triv_sq_zero_ext.lean

[^26]: https://leanprover-community.github.io/mathlib_docs/topology/continuous_function/bounded.html

[^27]: https://leanprover-community.github.io/mathlib-port-status/file/analysis/normed_space/spectrum

[^28]: https://www.math.unipd.it/~marson/didattica/Analisi_Funzionale/Dispensa_DeMarco.pdf

[^29]: https://gist.github.com/PatrickMassot/79d7f53b3777c48e0910e131aedff7ea

[^30]: https://arxiv.org/pdf/1008.2459.pdf

[^31]: https://ocw.mit.edu/courses/18-102-introduction-to-functional-analysis-spring-2021/22bf2f774fb161776032491568148707_MIT18_102s21_lec2.pdf

[^32]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/8c50b9cf92e2730547b5f53be07271d52df4a128/Mathlib/Analysis/NormedSpace/lpSpace.lean

[^33]: https://math.stackexchange.com/questions/4526831/relationship-between-eventually-zero-sequences-c-00-finite-sequences-math

[^34]: https://proofassistants.stackexchange.com/questions/2460/understanding-mathlib-measuretheory-notation

[^35]: https://en.wikipedia.org/wiki/Sequence_space

[^36]: https://huggingface.co/datasets/WhiteGiverPlus/mathlib4/viewer

[^37]: https://arxiv.org/pdf/2406.08560.pdf

[^38]: https://huggingface.co/datasets/l3lab/ntp-mathlib-instruct-context-fullproof/viewer/default/train?p=2

[^39]: https://math.stackexchange.com/questions/3366209/the-closure-of-the-set-of-finite-sequences-l-c-infty-mathbbn-mathbbr

[^40]: https://tqft.net/mathlib4/2022-12-11/all.pdf

[^41]: https://www.sciencedirect.com/science/article/abs/pii/S0022247X24004505

[^42]: https://gist.github.com/jmichelin/d1d6455af49ad516279651c940898dca

[^43]: https://leanprover-community.github.io/mathlib4_docs/Mathlib.html

[^44]: https://stackoverflow.com/questions/34521160/check-an-array-whether-sumx-0-x-1-x-k-sumx-k1-x-n-are-equal-in-hask/34521380

[^45]: https://stackoverflow.com/questions/63532195/2sum-3sum-4sum-ksum-with-hashset-hashtable-solution

[^46]: https://github.com/leanprover-community/mathlib4/blob/master/docs/100.yaml

[^47]: https://hackage.haskell.org/package/math-functions-0.3.4.4/docs/Numeric-Sum.html

[^48]: https://classic.yarnpkg.com/en/package/hash-sum

[^49]: https://course.ccs.neu.edu/cs2800sp23/l24.html

[^50]: https://stackoverflow.com/questions/27590477/understanding-the-implemention-of-sum-function

[^51]: https://leanprover-community.github.io/mathlib-overview.html

[^52]: https://gist.github.com/kaveet/00570b553d52aeedaeb0f23a6bdd51cd

[^53]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/981ba6dfcdfb2983419c7abb46e619865dee6bb7/Mathlib/Data/Finset/Sum.lean

[^54]: https://pypi.org/project/hashsum/

[^55]: https://dev.to/eteimz/the-two-sum-problem-874

[^56]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/SpecificLimits/Normed.html

[^57]: https://mathoverflow.net/questions/475748/bounding-the-norm-of-a-sum-of-fourth-order-gaussian-vectors

[^58]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/smul-experiment/Mathlib/Analysis/Calculus/Series.lean

[^59]: https://github.com/leanprover-community/mathlib4/blob/master/docs/undergrad.yaml

[^60]: https://math.iisc.ac.in/~gadgil/proofs-and-programs-2023/doc/Mathlib/Tactic/Attr/Register.html

