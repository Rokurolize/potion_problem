<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Mathematical Foundations for Proving Probability Mass Functions Sum to 1 in Telescoping Series

## Rigorous Proof of the Main Telescoping Identity

### Core Telescoping Series Proof

The fundamental telescoping series we need to prove is:

$$
\sum_{n=2}^{\infty} \left[\frac{1}{(n-1)!} - \frac{1}{n!}\right] = 1
$$

This is a classic example of a telescoping series where consecutive terms cancel[1][2][3]. The partial sum is:

$$
S_N = \sum_{n=2}^{N} \left[\frac{1}{(n-1)!} - \frac{1}{n!}\right]
$$

When we expand this sum explicitly:

$$
S_N = \left(\frac{1}{1!} - \frac{1}{2!}\right) + \left(\frac{1}{2!} - \frac{1}{3!}\right) + \left(\frac{1}{3!} - \frac{1}{4!}\right) + \cdots + \left(\frac{1}{(N-1)!} - \frac{1}{N!}\right)
$$

The telescoping property becomes evident as all intermediate terms cancel:

$$
S_N = \frac{1}{1!} - \frac{1}{N!} = 1 - \frac{1}{N!}
$$

Therefore:

$$
\lim_{N \to \infty} S_N = \lim_{N \to \infty} \left(1 - \frac{1}{N!}\right) = 1
$$

This completes the proof that the infinite telescoping series converges to 1[4][5].

## Convergence Conditions for Infinite Telescoping Series

### General Convergence Theory

A telescoping series of the form $\sum_{n=1}^{\infty} (a_n - a_{n+1})$ converges if and only if the sequence $(a_n)$ converges[3][4]. For our specific case, we have $a_n = \frac{1}{n!}$, and the series converges because:

1. **Necessary Condition**: $\lim_{n \to \infty} a_n = 0$
2. **Sufficient Condition**: The sequence $(a_n)$ is monotonic and bounded

### Specific Conditions for Factorial Series

For factorial-based telescoping series, convergence is guaranteed by the super-exponential decay of factorials[6][7]. The key conditions are:

1. **Monotonicity**: $\frac{1}{n!}$ is strictly decreasing for $n \geq 1$
2. **Boundedness**: $0 < \frac{1}{n!} < 1$ for all $n \geq 1$
3. **Limit Condition**: $\lim_{n \to \infty} \frac{1}{n!} = 0$

These conditions ensure that the telescoping series converges absolutely and uniformly on any compact subset of its domain[8][9].

## Mathematical Justification for $1/n! \to 0$

### Stirling's Approximation and Rate of Convergence

The asymptotic behavior of $1/n!$ is governed by **Stirling's approximation**[6][7]:

$$
n! \sim \sqrt{2\pi n} \left(\frac{n}{e}\right)^n
$$

This gives us:

$$
\frac{1}{n!} \sim \frac{1}{\sqrt{2\pi n}} \left(\frac{e}{n}\right)^n
$$

### Rate of Convergence Analysis

The convergence rate is **super-exponential**, meaning it decays faster than any exponential function[7][10]. Specifically:

1. **Comparison with exponential decay**: For any $c > 0$, we have $\lim_{n \to \infty} \frac{1/n!}{1/c^n} = 0$
2. **Ratio test**: $\lim_{n \to \infty} \frac{1/(n+1)!}{1/n!} = \lim_{n \to \infty} \frac{1}{n+1} = 0$
3. **Logarithmic analysis**: $\log(1/n!) = -\sum_{k=1}^{n} \log k \sim -n\log n + n\log e$

This super-exponential decay ensures that the tail of the series contributes negligibly to the sum, making numerical computation highly accurate even with finite partial sums[11][12].

## Formal Proof Techniques for Interchange of Limits and Summation

### Dominated Convergence Theorem

The **Dominated Convergence Theorem** provides the theoretical foundation for interchanging limits and summation[13][14][15]. For our telescoping series:

**Theorem**: If $f_n(x) = \frac{1}{n!} \mathbf{1}_{[n,\infty)}(x)$ and there exists an integrable function $g$ such that $|f_n(x)| \leq g(x)$ for all $n$, then:

$$
\lim_{n \to \infty} \sum_{k=1}^{n} f_k(x) = \sum_{k=1}^{\infty} \lim_{n \to \infty} f_k(x)
$$

### Monotone Convergence Theorem

Since $\frac{1}{n!}$ forms a decreasing sequence of positive terms, the **Monotone Convergence Theorem** applies directly:

**Theorem**: For a monotone decreasing sequence $(a_n)$ of non-negative terms with $\lim_{n \to \infty} a_n = 0$, the series $\sum_{n=1}^{\infty} (a_n - a_{n+1})$ converges to $a_1$.

### Uniform Convergence

The telescoping series converges uniformly on any compact subset of its domain[8][16]. This uniform convergence allows us to interchange limits and summation operations without loss of validity.

## Standard Results in Analysis Supporting These Manipulations

### Weierstrass M-Test

The **Weierstrass M-test** confirms absolute convergence[8][17]:

$$
\sum_{n=2}^{\infty} \left|\frac{1}{(n-1)!} - \frac{1}{n!}\right| = \sum_{n=2}^{\infty} \frac{1}{n!} < \infty
$$

### Fubini's Theorem

**Fubini's Theorem** in its discrete form justifies the rearrangement of double summations that may arise in probability calculations[18][19][20]:

$$
\sum_{i=1}^{\infty} \sum_{j=1}^{\infty} a_{i,j} = \sum_{j=1}^{\infty} \sum_{i=1}^{\infty} a_{i,j}
$$

provided the double series converges absolutely.

### Cauchy Criterion for Series Convergence

The **Cauchy Criterion** provides the foundational test for series convergence[21]. For our telescoping series:

$$
\left|\sum_{n=m}^{N} \left[\frac{1}{(n-1)!} - \frac{1}{n!}\right]\right| = \left|\frac{1}{(m-1)!} - \frac{1}{N!}\right| < \frac{1}{(m-1)!}
$$

This can be made arbitrarily small by choosing $m$ sufficiently large.

### Abel's Summation Formula

**Abel's summation formula** provides an alternative approach to telescoping series analysis[22][23]:

$$
\sum_{n=a}^{b} f(n) \cdot g(n) = f(b) \sum_{n=a}^{b} g(n) - \sum_{n=a}^{b-1} \left(\sum_{k=a}^{n} g(k)\right) (f(n+1) - f(n))
$$

## Applications to Probability Theory

### Probability Mass Function Normalization

The telescoping series proof provides a rigorous foundation for proving that discrete probability mass functions sum to 1. For a PMF $p(x)$ defined on a countable space, the normalization condition becomes:

$$
\sum_{x} p(x) = 1
$$

The telescoping approach is particularly useful when the PMF can be expressed as differences of cumulative distribution functions or when dealing with geometric or exponential-type distributions[24][25].

### Formal Verification Framework

These mathematical foundations support formal verification systems by providing:

1. **Constructive proofs** that can be mechanically verified
2. **Explicit error bounds** for numerical approximations
3. **Modular proof components** that can be reused across different probability distributions
4. **Rigorous convergence guarantees** that ensure computational stability

The combination of telescoping series theory, dominated convergence, and uniform convergence provides a complete analytical framework for proving the fundamental theorem that probability mass functions sum to 1, with all necessary mathematical rigor for formal verification systems.

