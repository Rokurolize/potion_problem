<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Lemma (reindex_series)

For any sequence $f\colon \mathbb{N}\to\mathbb{R}$,

$$
\sum_{n=2}^\infty f(n-2)\;=\;\sum_{k=0}^\infty f(k).
$$

## 1. Proof by Index Substitution

Define the bijection

$$
\phi\colon \{n\in\mathbb{N}:n\ge2\}\;\longrightarrow\;\mathbb{N},
\qquad 
\phi(n)=n-2.
$$

Then for each $n\ge2$, $f(n-2)=f\bigl(\phi(n)\bigr)$.  By the **definition of an infinite series over a countable set** (or by writing out partial sums),

$$
\sum_{n=2}^N f(n-2)
=\sum_{n=2}^N f\bigl(\phi(n)\bigr)
=\sum_{k=0}^{N-2} f(k).
$$

Taking $N\to\infty$ yields

$$
\sum_{n=2}^\infty f(n-2)
=\lim_{N\to\infty}\sum_{k=0}^{N-2} f(k)
=\sum_{k=0}^\infty f(k),
$$

establishing the desired identity.

## 2. Conditions Preserving Convergence and Sum

Reindexing by any bijection $\phi$ on the index set preserves both convergence and the sum value under either of the following standard hypotheses:

1. **Absolute Convergence**:
If $\sum_{n=0}^\infty |f(n)|<\infty$, then for any bijection $\phi$,
$\sum_n f(\phi(n))$ converges absolutely and
$\sum_n f(\phi(n))=\sum_n f(n)$.
*Theorem:* Rearrangement theorem for absolutely convergent series.
2. **Non-Negative Terms**:
If $f(n)\ge0$ for all $n$, then
$\sum f(n)$ converges (possibly to $+\infty$), and for any bijection $\phi$,
$\sum f(\phi(n))=\sum f(n)$.
*Theorem:* Monotone Convergence Theorem (for series of nonnegative terms).

## 3. Application: $f(k)=1/k!$ in Hitting Time Expectations

In many discrete-time hitting-time arguments (e.g., Poisson process interarrival sums), one encounters

$$
\sum_{n=2}^\infty \frac1{(n-2)!}
\;=\;\sum_{k=0}^\infty \frac1{k!}
\;=\;e.
$$

Since $1/k!\ge0$, monotone convergence justifies the index shift without altering the sum.

## 4. Bijection Between $\{n\ge2\}$ and $\mathbb{N}$

Explicitly,

$$
\phi(n)=n-2,\quad \phi^{-1}(k)=k+2.
$$

This is a one-to-one and onto mapping between the two countable sets.  In measure-theoretic language, if $\mu$ is the counting measure on $\mathbb{N}$, then the **pushforward** measure $\phi_* \mu$ is again the counting measure on $\mathbb{N}$.  Hence

$$
\sum_{n=2}^\infty f(n-2)
=\int_{\{n\ge2\}} f(\phi(n))\,d\mu(n)
=\int_{\mathbb{N}} f(k)\,d\mu(k).
$$

## 5. Governing Theorems from Real Analysis

| Theorem | Statement |
| :-- | :-- |
| Rearrangement Theorem (Absolute Convergence) | Any rearrangement (and hence reindexing) of an absolutely convergent series converges to the same sum. |
| Monotone Convergence for Series | If $a_n\ge0$, then the partial sums $S_N=\sum_{n=0}^N a_n$ form a nondecreasing sequence; its limit (finite or infinite) is independent of index order. |
| Fubini’s Theorem (Countable Sums) | For a double series of nonnegative terms, $\sum_i \sum_j a_{ij}=\sum_j\sum_i a_{ij}$; index reordering is a special case. |
| Dominated Convergence Theorem | If $f_n\to f$ pointwise and \$ |

### Conclusion

By constructing the explicit bijection $\phi(n)=n-2$ and invoking either absolute convergence or nonnegativity, one rigorously shows

$$
\sum_{n=2}^\infty f(n-2)=\sum_{k=0}^\infty f(k),
$$

and applies this directly when $f(k)=1/k!$ to derive the exponential series in hitting-time analyses.

