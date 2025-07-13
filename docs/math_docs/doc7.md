<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Specialized AI Research Agent Prompts for Formalizing the Uniform Sum Hitting Time Proof

The following five prompts isolate each “sorry” gap in the Lean 4 development and request rigorous, step-by-step mathematical foundations suitable for mechanized proof. Each prompt is addressed to a specialized AI research agent whose sole task is to produce formalizable proofs (in Lean’s type theory) with full derivations, hypotheses, and citations to authoritative sources.

## 1. Irwin–Hall Distribution Foundation

**Prompt to Agent:**
“Provide a formal mathematical proof in full detail that if $S_n = U_1 + \cdots + U_n$ with each $U_i\sim\mathrm{Uniform}[0,1)$ i.i.d., then

$$
P(S_n < 1) \;=\;\frac1{n!}.
$$

Your deliverable must include:

1. Derivation of the Irwin–Hall probability density function (PDF) for $S_n$.
2. Exact formula for its cumulative distribution function (CDF).
3. Substitution $x=1$ and step-by-step evaluation to yield $1/n!$.
4. Precise conditions (e.g., continuity, support) under which the result holds.
5. References to standard probabilistic texts (e.g., Feller, Billingsley, or equivalent).”

## 2. Hitting Time Probability Mass Function

**Prompt to Agent:**
“Establish rigorously that for the stopping time
$\tau = \min\{n: S_n\ge1\}$,
the probability mass function satisfies

$$
P(\tau = n) \;=\;\frac{n-1}{n!},\quad n\ge2.
$$

Include in your proof:

1. Expression $P(\tau = n) = P(S_{n-1}<1) - P(S_n<1)$.
2. Substitution of $1/(n-1)!$ and $1/n!$ to obtain $(n-1)/n!$.
3. Algebraic justification of the telescoping difference.
4. Verification that $\sum_{n=2}^\infty P(\tau=n)=1$.
5. Connection to renewal theory or first-passage time theorems with citations.”

## 3. Telescoping Series and Expected Value Computation

**Prompt to Agent:**
“Prove that

$$
n\,P(\tau=n)\;=\;\frac1{(n-2)!}
\quad\text{for }n\ge2,
$$

and show that this transforms
$\displaystyle E[\tau]=\sum_{n=2}^\infty n\,P(\tau=n)$
into
$\displaystyle \sum_{k=0}^\infty \frac1{k!}=e.$
Your proof should contain:

1. Algebraic derivation $n\,(n-1)/n! = 1/(n-2)!$.
2. Index substitution $k=n-2$.
3. Formal justification for interchanging summation and expectation.
4. Convergence and rearrangement arguments from real analysis.
5. Citations of series convergence theorems (e.g., ratio test, Fubini’s theorem).”

## 4. Summability and Convergence Theory

**Prompt to Agent:**
“Provide a rigorous analysis of the telescoping sum

$$
\sum_{n=2}^\infty \Bigl[\tfrac1{(n-1)!}-\tfrac1{n!}\Bigr] \;=\;1.
$$

Include:

1. Formal telescoping-series proof.
2. Criteria for convergence of infinite telescoping sums.
3. Rate at which $1/n!\to0$ and error bounds.
4. Conditions permitting limit-summation interchange.
5. References to standard real-analysis sources (e.g., Rudin, Apostol).”

## 5. Reindexing and Series Manipulation

**Prompt to Agent:**
“Demonstrate formally that reindexing an infinite series
$\sum_{n=2}^\infty f(n-2)$
to
$\sum_{k=0}^\infty f(k)$
preserves both convergence and sum, under standard conditions. Specifically:

1. Construct the bijection $k=n-2$.
2. State and prove the theorem ensuring index substitution validity.
3. Apply to $f(k)=1/k!$.
4. Discuss measure-theoretic or analytical conditions (absolute convergence).
5. Cite authoritative real-analysis texts for series reindexing theorems.”

Each prompt targets a discrete “sorry” in the formal proof, requesting a Lean-friendly, citation-backed derivation that can be directly encoded as the axioms:

- `irwin_hall_core`
- `hitting_time_pmf`
- `telescoping_property`
- `prob_sum_one`
- `reindex_series`

This modular approach ensures each gap is addressed by a specialized agent with focused mathematical rigor.

<div style="text-align: center">⁂</div>

[^1]: https://www.semanticscholar.org/paper/e54688a78636b438e5a3b2e7839b398ca5c671ce

[^2]: https://www.semanticscholar.org/paper/e43ea5fe0e4bef35a46cd0d22ebc9f0b5d5a5286

[^3]: https://www.hindawi.com/journals/ijmms/2017/3571419/

[^4]: https://www.semanticscholar.org/paper/ff6119c23f218aacfeac4cb5f193d685df627e22

[^5]: https://linkinghub.elsevier.com/retrieve/pii/S0577907316302088

[^6]: https://www.semanticscholar.org/paper/31c41909a02b771c0f6f4df24467246d5dc04889

[^7]: https://journals.sagepub.com/doi/10.1177/08968608231209850

[^8]: https://link.aps.org/doi/10.1103/PhysRevResearch.6.023044

[^9]: https://ems.press/doi/10.4171/lem/1094

[^10]: https://www.cambridge.org/core/product/identifier/S0305004100052270/type/journal_article

[^11]: http://downloads.hindawi.com/journals/ijmms/2017/3571419.pdf

[^12]: http://arxiv.org/pdf/2403.02670.pdf

[^13]: http://arxiv.org/pdf/2402.00713.pdf

[^14]: https://arxiv.org/pdf/1804.07896.pdf

[^15]: https://arxiv.org/pdf/2308.11685.pdf

[^16]: http://arxiv.org/pdf/2403.10926.pdf

[^17]: https://arxiv.org/pdf/1905.12749.pdf

[^18]: http://arxiv.org/pdf/2003.09955.pdf

[^19]: https://www.mdpi.com/2227-7390/11/21/4513/pdf?version=1698842058

[^20]: https://arxiv.org/pdf/2402.08422.pdf

[^21]: https://www.semanticscholar.org/paper/4f558e2317a3f2c56c9ce0fba73ae33556b348ca

[^22]: https://ieeexplore.ieee.org/document/9944150/

[^23]: https://www.semanticscholar.org/paper/0655187ebffc922c13986bf0ad603e5b53367654

[^24]: https://ieeexplore.ieee.org/document/10821088/

[^25]: https://ieeexplore.ieee.org/document/9665582/

[^26]: https://link.aps.org/doi/10.1103/PhysRevLett.133.201803

[^27]: https://dl.acm.org/doi/10.1145/3183713.3183759

[^28]: https://www.semanticscholar.org/paper/91b158bd9633877fcd867ca4369ac12643067510

[^29]: http://arxiv.org/pdf/2402.14761.pdf

[^30]: https://arxiv.org/pdf/2202.13111.pdf

[^31]: http://arxiv.org/pdf/2312.14581.pdf

[^32]: http://arxiv.org/pdf/2402.09083.pdf

[^33]: http://arxiv.org/pdf/1201.6441.pdf

[^34]: https://escholarship.org/content/qt7p7557d3/qt7p7557d3.pdf?t=re6gr1

[^35]: http://arxiv.org/pdf/2009.14004.pdf

[^36]: http://arxiv.org/pdf/2311.03343.pdf

[^37]: http://arxiv.org/pdf/1407.3829.pdf

[^38]: https://link.aps.org/doi/10.1103/PhysRevB.110.024412

[^39]: https://pubs.aip.org/aip/acp/article/700842

[^40]: https://link.aps.org/doi/10.1103/PhysRevLett.130.126301

[^41]: https://www.nature.com/articles/s41567-024-02517-w

[^42]: https://dl.acm.org/doi/10.1145/3201064.3201080

[^43]: https://link.aps.org/doi/10.1103/PhysRevB.109.035305

[^44]: https://www.mdpi.com/2075-5309/12/9/1418

[^45]: https://www.journals.vu.lt/statisticsjournal/article/download/13873/12791

[^46]: http://arxiv.org/pdf/2111.03765.pdf

[^47]: https://arxiv.org/pdf/2501.05863.pdf

[^48]: https://downloads.hindawi.com/archive/2012/760687.pdf

[^49]: https://onlinelibrary.wiley.com/doi/pdfdirect/10.1002/eng2.12828

[^50]: https://arxiv.org/html/2503.16175v1

[^51]: http://arxiv.org/pdf/2402.07808.pdf

