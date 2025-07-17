<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Main Takeaways

For Lean 4 v4.12.0, the core series‐manipulation lemmas you need live in
Mathlib.Topology.Algebra.InfiniteSum.Basic and Mathlib.Analysis.PSeries.

# 1. Splitting an Infinite Series

**Lemma**

```lean
tsum_range_add_tsum {α : Type*} [AddCommMonoid α] [TopologicalSpace α]
  {f : ℕ → α} (h : Summable f) (a : ℕ) :
  (∑' n, f n) = ∑ i in Finset.range a, f i + ∑' k, f (k + a)
```

**Import**

```lean
import Mathlib.Topology.Algebra.InfiniteSum.Basic
```

**Example Usage**

```lean
example {α : Type*} [AddCommMonoid α] [TopologicalSpace α]
  {f : ℕ → α} (h : Summable f) (a : ℕ) :
  (∑' n, f n) = ∑ i in Finset.range a, f i + ∑' k, f (k + a) :=
tsum_range_add_tsum h a
```


# 2. Exponential Series = eˣ

**Lemma**

```lean
Real.tsum_exp : ∑' k : ℕ, (1 : ℝ) / k.factorial = Real.exp 1
```

**Import**

```lean
import Mathlib.Analysis.PSeries
```

**Example Usage**

```lean
example : (∑' k : ℕ, (1 : ℝ) / k.factorial) = Real.exp 1 :=
Real.tsum_exp
```


# 3. Summability under a Natural‐Number Shift

**Lemma**

```lean
summable_comp_add_right {α : Type*} [NormedAddCommGroup α] {f : ℕ → α} {a : ℕ}
  (hf : Summable f) : Summable (fun k => f (k + a))
```

**Import**

```lean
import Mathlib.Topology.Algebra.InfiniteSum.Basic
```

**Example Usage**

```lean
example {α : Type*} [NormedAddCommGroup α] {f : ℕ → α} {a : ℕ}
  (hf : Summable f) : Summable (fun k => f (k + a)) :=
summable_comp_add_right hf
```


# Alternative Approaches

- If you work only in *complete* normed spaces, you can use the absolutely‐summable variants in
`Mathlib.Analysis.NormedSpace.Basic`.
- For reindexing by a general `α ≃ β`, use

```lean
Summable.compEquiv (h : Summable f) (e : α ≃ β) : Summable (f ∘ e)  
tsum_compEquiv (h : Summable f) (e : α ≃ β) : ∑' a, f (e a) = ∑' b, f b  
```

from `Mathlib.Topology.Algebra.InfiniteSum.Basic`.
- Splitting a summation with an `if`‐indicator: see

```lean
tsum_eq_tsum_ite (hf : Summable f) {p} (g) :
  ∑' n, if p n then g n else 0 = ∑' n in {n | p n}, g n  
```

in the same file.

With these three core API lemmas, you can reindex, split, and shift infinite series in v4.12.0.

<div style="text-align: center">⁂</div>

[^1]: https://epubs.siam.org/doi/pdf/10.1137/19M1257780

[^2]: http://arxiv.org/pdf/1712.00993.pdf

[^3]: https://arxiv.org/pdf/2305.10656.pdf

[^4]: https://arxiv.org/ftp/arxiv/papers/2211/2211.04402.pdf

[^5]: https://arxiv.org/pdf/2411.17887.pdf

[^6]: http://arxiv.org/pdf/1502.05204.pdf

[^7]: https://arxiv.org/pdf/2111.14530.pdf

[^8]: http://arxiv.org/pdf/2503.20162.pdf

[^9]: https://joss.theoj.org/papers/10.21105/joss.06049

[^10]: https://link.springer.com/10.1007/978-3-031-66997-2_4

[^11]: https://link.springer.com/10.1007/s10817-023-09668-0

[^12]: https://arxiv.org/abs/2207.12742

[^13]: https://dl.acm.org/doi/10.1145/3573105.3575675

[^14]: https://www.semanticscholar.org/paper/91a965d4b03a1a4d1a4e21d7de11eb10ab1e913c

[^15]: https://www.semanticscholar.org/paper/c5d1f0e3dda813efe19ac59b9513b19df223cbe5

[^16]: https://arxiv.org/abs/2403.14064

[^17]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/List/Range.html

[^18]: https://leanprover-community.github.io/mathlib4_docs/Mathlib

[^19]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/15d6b7a1a8bb1068e0c17dee20f5ae2b8bd8415e/Mathlib/Topology/Algebra/InfiniteSum/Basic.lean

[^20]: https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Data/Complex/Exponential.lean

[^21]: https://florisvandoorn.com/BonnAnalysis/docs/Mathlib/Topology/Algebra/InfiniteSum/Basic.html

[^22]: https://florisvandoorn.com/BonnAnalysis/docs/Mathlib/Data/List/Range.html

[^23]: https://physlean.com/docs/Mathlib/Data/List/Range.html

[^24]: https://plmlab.math.cnrs.fr/nuccio/mathlib4/-/blob/smul-experiment/Mathlib/Analysis/Calculus/Series.lean

[^25]: https://mathlib-changelog.org/theorem/set.mem_range

[^26]: https://arxiv.org/abs/2403.13310

[^27]: https://arxiv.org/abs/2410.10878

[^28]: https://arxiv.org/abs/2502.17925

[^29]: https://arxiv.org/abs/2505.14929

[^30]: https://arxiv.org/abs/2504.19110

[^31]: https://arxiv.org/abs/2503.04772

[^32]: https://arxiv.org/abs/2408.15180

[^33]: https://arxiv.org/abs/2403.12733

[^34]: https://leanprover-community.github.io/mathlib_docs/topology/algebra/infinite_sum/basic.html

[^35]: https://leanprover-community.github.io/archive/stream/113488-general/topic/tsum.20over.20option.html

[^36]: https://search.r-project.org/CRAN/refmans/sumR/html/infiniteSum.html

[^37]: https://leanprover-community.github.io/mathlib_docs/data/nat/basic.html

[^38]: https://www.rdocumentation.org/packages/hett/versions/0.3-3/topics/tsum

[^39]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Topology/Algebra/InfiniteSum/Ring.html

[^40]: https://course.ccs.neu.edu/cs2800sp23/l24.html

[^41]: https://www.tensorflow.org/probability/api_docs/python/tfp/substrates/numpy/sts/Sum

[^42]: https://leanprover-community.github.io/mathlib4_docs/Mathlib.html

[^43]: https://stackoverflow.com/questions/23506070/how-to-implement-a-summation-from-1-to-infinite-in-python/23506166

[^44]: https://leanprover-community.github.io/mathlib-overview.html

[^45]: https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/unsorted-segment-sum

[^46]: https://docs.rs/sum_range/latest/sum_range/

[^47]: https://isabelle.in.tum.de/library/Doc/Tutorial/natsum.html

[^48]: https://www.tensorflow.org/probability/api_docs/python/tfp/substrates/jax/sts/Sum

[^49]: https://gist.github.com/mizunashi-mana/8a1257f81a7d783fb8e18535b738b304

[^50]: https://arxiv.org/pdf/2311.01515.pdf

[^51]: https://dl.acm.org/doi/pdf/10.1145/3632874

[^52]: https://arxiv.org/pdf/2403.13310.pdf

[^53]: https://arxiv.org/pdf/2207.12742.pdf

[^54]: https://arxiv.org/pdf/2202.01629.pdf

[^55]: https://arxiv.org/pdf/1910.09336.pdf

[^56]: https://arxiv.org/pdf/1306.1295.pdf

[^57]: http://arxiv.org/pdf/2111.06718.pdf

[^58]: https://huggingface.co/datasets/WhiteGiverPlus/mathlib4/viewer

[^59]: https://tqft.net/mathlib4/2022-11-20/all.pdf

[^60]: https://github.com/leanprover-community/mathlib4/pkgs/container/mathlib4

[^61]: https://tqft.net/mathlib4/2022-11-28/data.fintype.basic.pdf

[^62]: https://math.iisc.ac.in/~gadgil/proofs-and-programs-2023/doc/Mathlib/Data/Nat/Basic.html

[^63]: https://cocalc.com/share/public_paths/embed/f014cd1885a22e8665a728be825e563fc79b7e1f/_target/deps/mathlib/docs/mathlib-overview.md

[^64]: https://joss.theoj.org/papers/10.21105/joss.05153.pdf

[^65]: http://arxiv.org/pdf/2501.11125.pdf

[^66]: http://arxiv.org/pdf/2410.21953.pdf

[^67]: https://arxiv.org/pdf/2301.02057.pdf

[^68]: http://arxiv.org/pdf/2410.18661.pdf

[^69]: https://arxiv.org/pdf/2410.20764.pdf

[^70]: https://arxiv.org/pdf/2209.04936.pdf

[^71]: https://joss.theoj.org/papers/10.21105/joss.00753.pdf

[^72]: http://arxiv.org/pdf/2410.09567.pdf

[^73]: http://arxiv.org/pdf/2207.11758.pdf

[^74]: http://arxiv.org/pdf/2503.22054.pdf

[^75]: http://arxiv.org/pdf/2310.13174.pdf

[^76]: https://arxiv.org/abs/2501.13959

[^77]: https://dl.acm.org/doi/10.1145/3658644.3670322

[^78]: https://arxiv.org/pdf/2501.15639.pdf

[^79]: https://arxiv.org/pdf/2101.00086.pdf

[^80]: https://arxiv.org/pdf/0709.0948.pdf

[^81]: https://arxiv.org/pdf/2103.05581.pdf

[^82]: https://gist.github.com/shunghsiyu/a63e08e6231553d1abdece4aef29f70e

[^83]: https://read.learnyard.com/dsa/range-sum-query-immutable/

[^84]: https://huggingface.co/datasets/DaniilOr/cat3_local_gens/viewer/default/train?p=2218

[^85]: https://stackoverflow.com/questions/68314118/program-to-find-sum-in-an-infinite-array-within-given-ranges

[^86]: https://www.statsmodels.org/0.8.0/_modules/statsmodels/tsa/tsatools.html

[^87]: https://arxiv.org/pdf/2109.04193.pdf

[^88]: http://arxiv.org/pdf/2108.12981.pdf

