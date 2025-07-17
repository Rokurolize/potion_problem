<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Telescoping Property for Hitting Time Expectations in Uniform Sum Processes

## Introduction

The **telescoping property** provides a powerful mathematical framework for analyzing hitting time expectations in uniform sum processes. This property establishes a fundamental connection between discrete probability distributions and the exponential function, culminating in the elegant result that \$ E[\tau] = e \$.

## The Telescoping Identity

### Core Mathematical Identity

For \$ n \geq 2 \$, the fundamental telescoping identity states:

\$ n \cdot P(\tau = n) = \frac{1}{(n-2)!} \$

where \$ P(\tau = n) = \frac{n-1}{n!} \$ represents the probability mass function of the hitting time \$ \tau \$ in uniform sum processes[^1].

### Algebraic Derivation

**Step 1: Starting Expression**

Beginning with the hitting time probability \$ P(\tau = n) = \frac{n-1}{n!} \$, we need to prove:

\$ n \cdot \frac{n-1}{n!} = \frac{1}{(n-2)!} \$

**Step 2: Factorial Decomposition**

Since \$ n! = n \cdot (n-1) \cdot (n-2)! \$, we can substitute:

\$ n \cdot \frac{n-1}{n!} = n \cdot \frac{n-1}{n \cdot (n-1) \cdot (n-2)!} \$

**Step 3: Simplification**

Canceling \$ n \cdot (n-1) \$ from both numerator and denominator:

\$ n \cdot \frac{n-1}{n!} = \frac{n \cdot (n-1)}{n \cdot (n-1) \cdot (n-2)!} = \frac{1}{(n-2)!} \$

This completes the proof of the telescoping identity.

## Expectation Transformation

### Series Transformation Process

The telescoping property enables the transformation of the expectation:

\$ E[\tau] = \sum_{n=2}^{\infty} n \cdot P(\tau = n) = \sum_{n=2}^{\infty} n \cdot \frac{n-1}{n!} \$

Applying the telescoping identity:

\$ E[\tau] = \sum_{n=2}^{\infty} \frac{1}{(n-2)!} \$

### Index Substitution

Let \$ k = n - 2 \$, so \$ n = k + 2 \$. When \$ n \$ ranges from 2 to \$ \infty \$, \$ k \$ ranges from 0 to \$ \infty \$:

\$ E[\tau] = \sum_{k=0}^{\infty} \frac{1}{k!} \$

This transformation reveals the connection to the exponential series.

## Convergence to the Exponential Function

### Recognition of the Exponential Series

The series \$ \sum_{k=0}^{\infty} \frac{1}{k!} \$ is the Taylor series expansion of \$ e^x \$ evaluated at \$ x = 1 \$:

\$ e^x = \sum_{k=0}^{\infty} \frac{x^k}{k!} \$

At \$ x = 1 \$:

\$ e = \sum_{k=0}^{\infty} \frac{1}{k!} \$

Therefore:

\$ E[\tau] = e \$

### Convergence Analysis

The series \$ \sum_{k=0}^{\infty} \frac{1}{k!} \$ converges absolutely due to several key properties:

1. **Ratio Test**: \$ \lim_{k \to \infty} \frac{a_{k+1}}{a_k} = \lim_{k \to \infty} \frac{1}{k+1} = 0 < 1 \$
2. **Rapid Decay**: For large \$ k \$, \$ \frac{1}{k!} \$ decreases faster than any exponential function
3. **Uniform Convergence**: The series converges uniformly on any bounded interval

## Rigorous Justification for Interchange

### Conditions for Valid Interchange

The interchange of summation and expectation \$ E[\tau] = E[\sum_{n=2}^{\infty} n \cdot I(\tau = n)] = \sum_{n=2}^{\infty} n \cdot P(\tau = n) \$ is justified by:

**1. Absolute Convergence**

The series \$ \sum_{n=2}^{\infty} n \cdot P(\tau = n) = \sum_{n=2}^{\infty} n \cdot \frac{n-1}{n!} \$ converges absolutely. This is equivalent to showing convergence of \$ \sum_{n=2}^{\infty} \frac{1}{(n-2)!} = e \$.

**2. Dominated Convergence**

Each term \$ \frac{1}{k!} \$ in the telescoping series is dominated by terms in a convergent geometric series, satisfying the conditions of the Dominated Convergence Theorem[^2][^3].

**3. Monotone Convergence**

The partial sums \$ S_N = \sum_{k=0}^{N} \frac{1}{k!} \$ form a monotone increasing sequence bounded above by \$ e \$, ensuring convergence by the Monotone Convergence Theorem[^2].

### Verification of Convergence Properties

The convergence can be verified numerically:

- Terms decay rapidly: \$ \frac{1}{10!} \approx 2.76 \times 10^{-7} \$
- Partial sums approach \$ e \$: \$ \sum_{k=0}^{20} \frac{1}{k!} \approx 2.7182818285 \$
- The difference from \$ e \$ becomes negligible with increasing terms


## Mathematical Significance

The telescoping property establishes a profound connection between:

1. **Discrete Probability Theory**: Hitting time distributions in stochastic processes
2. **Classical Analysis**: The exponential function and its series representation
3. **Combinatorial Mathematics**: Factorial sequences and their asymptotic behavior

This result demonstrates how the fundamental constant \$ e \$ emerges naturally from the analysis of uniform sum processes, providing both theoretical insight and practical applications in probability theory and stochastic modeling.

## Conclusion

The telescoping property for hitting time expectations represents a elegant mathematical result that transforms a complex discrete probability calculation into a classical series evaluation. The identity \$ n \cdot P(\tau = n) = \frac{1}{(n-2)!} \$ serves as the key bridge connecting the discrete hitting time distribution to the continuous exponential function, ultimately establishing that \$ E[\tau] = e \$ through rigorous series convergence analysis.

<div style="text-align: center">⁂</div>

[^1]: https://projecteuclid.org/journals/electronic-communications-in-probability/volume-6/issue-none/Kendalls-identity-for-the-first-crossing-time-revisited/10.1214/ECP.v6-1038.full

[^2]: https://www.semanticscholar.org/paper/5d889ec7189416871c5622b9016991fee81aaadd

[^3]: https://arxiv.org/pdf/1108.4400.pdf

[^4]: https://www.semanticscholar.org/paper/796eced4ff6e7ee95c59ba5cba8e5058da573224

[^5]: https://iopscience.iop.org/article/10.3847/1538-4365/ad957f

[^6]: https://iopscience.iop.org/article/10.1088/1751-8121/ab7138

[^7]: https://ojs.ukscip.com/index.php/ptnd/article/view/270

[^8]: https://iopscience.iop.org/article/10.3847/2041-8213/ad0a95

[^9]: https://academic.oup.com/mnras/article/520/1/1311/6993088

[^10]: http://kigiran.com/pubs/index.php/bul/article/view/1954

[^11]: https://scholar.kyobobook.co.kr/article/detail/4010036882653

[^12]: https://www.semanticscholar.org/paper/7efae0ddd8b77824f3c0794c0311a6c04c7f064c

[^13]: https://www.semanticscholar.org/paper/d0fc6e19b291ffbe18609e8e8a6c466f8864abf5

[^14]: http://arxiv.org/pdf/2309.15871.pdf

[^15]: https://www.frontiersin.org/articles/10.3389/fnhum.2021.642025/pdf

[^16]: https://pmc.ncbi.nlm.nih.gov/articles/PMC3983934/

[^17]: https://pmc.ncbi.nlm.nih.gov/articles/PMC3338450/

[^18]: http://arxiv.org/pdf/2102.11787.pdf

[^19]: https://www.frontiersin.org/articles/10.3389/fnhum.2014.00342/pdf

[^20]: https://pmc.ncbi.nlm.nih.gov/articles/PMC3655327/

[^21]: http://arxiv.org/pdf/2406.19895.pdf

[^22]: https://pmc.ncbi.nlm.nih.gov/articles/PMC6672223/

[^23]: https://jov.arvojournals.org/article.aspx?articleid=2772513

[^24]: https://www.parapsychologypress.org/jparticle/jp-84-1-38-65

[^25]: https://www.semanticscholar.org/paper/b7447763adda99c59cf1bb7324e0b6ca852d7857

[^26]: https://www.cambridge.org/core/product/identifier/S0021900200100701/type/journal_article

[^27]: https://www.science.org/doi/10.1126/science.362.6418.1078

[^28]: https://www.semanticscholar.org/paper/2ab4184a18057a509d56753cfd579e542b5be49f

[^29]: https://www.semanticscholar.org/paper/4b91fd281a5e3c358b382aec0a1996f4ffdc71cb

[^30]: https://www.semanticscholar.org/paper/5c2692029b367156867e2789f5ea77df298203ae

[^31]: https://www.jstor.org/stable/1270251?origin=crossref

[^32]: https://journal.media-culture.org.au/index.php/mcjournal/article/view/1437

[^33]: https://pmc.ncbi.nlm.nih.gov/articles/PMC9542167/

[^34]: http://arxiv.org/pdf/2402.04392.pdf

[^35]: https://arxiv.org/pdf/2101.10748.pdf

[^36]: https://pmc.ncbi.nlm.nih.gov/articles/PMC9363376/

[^37]: https://arxiv.org/pdf/2310.04660.pdf

[^38]: https://arxiv.org/pdf/2302.01963.pdf

[^39]: https://arxiv.org/pdf/2211.00671.pdf

[^40]: http://arxiv.org/pdf/1001.3619.pdf

[^41]: http://arxiv.org/pdf/2310.07003.pdf

[^42]: https://www.cambridge.org/core/product/identifier/S0025557200502241/type/journal_article

[^43]: https://www.cambridge.org/core/product/identifier/S0025557200150442/type/journal_article

[^44]: https://www.tandfonline.com/doi/full/10.4169/amer.math.monthly.122.5.444

[^45]: https://www.ams.org/proc/2020-148-06/S0002-9939-2020-14664-3/

[^46]: https://www.semanticscholar.org/paper/53448cefd761c833c74525ee4c76ca88b3c0e2d7

[^47]: https://www.mdpi.com/2227-7390/11/13/2949

[^48]: https://iopscience.iop.org/article/10.1149/1945-7111/ad14ca

[^49]: https://link.springer.com/10.1007/978-3-031-69646-6_3

[^50]: https://iopscience.iop.org/article/10.1088/1742-6596/1752/1/012081

[^51]: https://link.springer.com/10.1007/s11802-021-4826-9

[^52]: http://arxiv.org/pdf/2208.10079.pdf

[^53]: http://arxiv.org/pdf/1910.10761.pdf

[^54]: http://arxiv.org/pdf/2404.16199.pdf

[^55]: http://arxiv.org/pdf/1102.0659.pdf

[^56]: https://arxiv.org/pdf/0802.2189.pdf

[^57]: http://arxiv.org/pdf/2310.06963.pdf

[^58]: https://arxiv.org/pdf/2210.02233.pdf

[^59]: http://arxiv.org/pdf/1601.03952.pdf

[^60]: http://meraa.uniag.sk/docs/2020-01/potucek.pdf

[^61]: https://arxiv.org/pdf/1403.7665.pdf

[^62]: http://issuesofanalysis.petrsu.ru/article/genpdf.php?id=5310

[^63]: https://www.semanticscholar.org/paper/d2aad966f8d32a52fbd371ad41a0dc61d65ca171

[^64]: https://www.tandfonline.com/doi/full/10.1080/00029890.2003.11919971

[^65]: https://www.semanticscholar.org/paper/03d1299fa6df31bb7d1ceaa56ab2dcdc52f02572

[^66]: http://epubs.siam.org/doi/10.1137/090760337

[^67]: http://link.springer.com/10.1007/BF01060516

[^68]: https://www.semanticscholar.org/paper/1142d753ccb91a1a5f766555defb689c62b72435

[^69]: https://link.springer.com/10.1007/s13171-024-00339-9

[^70]: https://link.springer.com/10.1007/s40687-021-00309-9

[^71]: https://www.semanticscholar.org/paper/bd233048947004292d326eb4d65867fe306e3e95

[^72]: https://arxiv.org/pdf/2312.15543.pdf

[^73]: http://arxiv.org/pdf/2412.20101.pdf

[^74]: http://arxiv.org/pdf/2303.03768.pdf

[^75]: http://www.scirp.org/journal/PaperDownload.aspx?paperID=64069

[^76]: https://arxiv.org/pdf/2409.02949.pdf

[^77]: https://arxiv.org/pdf/1501.03297.pdf

[^78]: https://arxiv.org/pdf/2203.13676.pdf

[^79]: https://www.iejme.com/download/from-powers-to-exponential-function-5774.pdf

[^80]: https://arxiv.org/pdf/2501.08762.pdf

[^81]: http://arxiv.org/pdf/2502.05298.pdf

[^82]: http://link.springer.com/10.1007/BF01199981

[^83]: https://www.ams.org/proc/1972-034-02/S0002-9939-1972-0296223-8/

[^84]: https://www.semanticscholar.org/paper/6026af21b8ceec8ea5dcc9ac0b1864c2d8d53c15

[^85]: http://www.jstor.org/stable/10.14321/realanalexch.30.2.0783

[^86]: https://www.research-publication.com/jcsam/all-issues/vol-06/iss-01/

[^87]: https://www.semanticscholar.org/paper/f4a0cbaebcf89f377806f403ed8c99abe82d5e7e

[^88]: https://www.tandfonline.com/doi/full/10.1080/03610926.2017.1422760

[^89]: http://link.springer.com/10.1007/s10587-008-0080-1

[^90]: https://projecteuclid.org/journals/electronic-journal-of-probability/volume-29/issue-none/Power-variations-and-limit-theorems-for-stochastic-processes-controlled-by/10.1214/24-EJP1179.full

[^91]: http://arxiv.org/pdf/2305.04872.pdf

[^92]: https://arxiv.org/pdf/2209.00354.pdf

[^93]: https://downloads.hindawi.com/journals/jfs/2013/682823.pdf

[^94]: http://arxiv.org/pdf/2411.04560.pdf

[^95]: http://downloads.hindawi.com/journals/tswj/2014/535419.pdf

[^96]: http://www.logicandanalysis.com/index.php/jla/article/viewFile/138/50

[^97]: https://arxiv.org/pdf/1503.00817.pdf

[^98]: https://www.degruyter.com/document/doi/10.1515/dema-2020-0010/pdf

[^99]: http://arxiv.org/pdf/2104.10430.pdf

[^100]: https://link.springer.com/10.1007/s40687-023-00401-2

[^101]: https://linkinghub.elsevier.com/retrieve/pii/S0378375805002454

[^102]: https://www.jstor.org/stable/2322220?origin=crossref

[^103]: https://pubs.aip.org/jmp/article/37/2/965/229878/A-proof-of-polynomial-identities-of-type-sl-n-1-sl

[^104]: http://www.m-hikari.com/imf/imf-2022/1-4-2022/912300.html

[^105]: https://linkinghub.elsevier.com/retrieve/pii/S0304397518302652

[^106]: https://www.semanticscholar.org/paper/39f5757f89d913ee349d859520163c5af94518ca

[^107]: https://www.semanticscholar.org/paper/2105809b5fda3af21e7da7725bb1ded7a3915779

[^108]: https://iopscience.iop.org/article/10.1088/1751-8121/ab3715

[^109]: https://www.cambridge.org/core/product/identifier/S0305004100033454/type/journal_article

[^110]: https://arxiv.org/pdf/1809.07360.pdf

[^111]: https://www.combinatorics.org/ojs/index.php/eljc/article/download/v30i2p1/pdf

[^112]: https://downloads.hindawi.com/journals/ijmms/1995/318564.pdf

[^113]: https://arxiv.org/pdf/1807.08416.pdf

[^114]: https://arxiv.org/pdf/2412.00040.pdf

[^115]: https://arxiv.org/pdf/2308.09761.pdf

[^116]: http://arxiv.org/pdf/1409.8118.pdf

[^117]: http://arxiv.org/pdf/2310.19098.pdf

[^118]: https://arxiv.org/pdf/2310.05301.pdf

[^119]: https://www.preprints.org/manuscript/202106.0243/v1/download

