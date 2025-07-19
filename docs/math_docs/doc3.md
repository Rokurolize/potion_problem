<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Mathematical Derivation of Hitting Time Probability Mass Function for Uniform Sum Processes

## Problem Statement and Main Result

The stopping time $\tau = \min\{n : S_n \geq 1\}$ where $S_n$ is the sum of $n$ independent uniform random variables on $[0,1)$ has the probability mass function[1][2]:

$P(\tau = n) = \frac{n-1}{n!} \quad \text{for } n \geq 2$

This result establishes a fundamental connection between uniform sum processes and first passage time problems in renewal theory.

## The Irwin-Hall Distribution Foundation

The cumulative distribution function of $S_n$ (the sum of $n$ independent uniform $[0,1)$ random variables) is given by the Irwin-Hall distribution[1][2]. For $0 \leq x \leq n$, the probability density function is:

$f_{S_n}(x) = \frac{1}{2^{n-1}(n-1)!} \sum_{k=0}^{\lfloor x \rfloor} (-1)^k \binom{n}{k} (x-k)^{n-1}$

The cumulative distribution function is:

$F_{S_n}(x) = P(S_n < x) = \frac{1}{n!} \sum_{k=0}^{\lfloor x \rfloor} (-1)^k \binom{n}{k} (x-k)^n$

## Derivation of the Hitting Time Formula

### Step 1: Telescoping Difference Representation

The key insight is that the hitting time probability can be expressed as a telescoping difference:

$P(\tau = n) = P(S_{n-1} < 1) - P(S_n < 1)$

This follows from the definition of the stopping time: $\tau = n$ if and only if $S_{n-1} < 1$ and $S_n \geq 1$.

### Step 2: Applying the Irwin-Hall Distribution

For $x = 1$ and the range of interest, we have:

$P(S_n < 1) = \frac{1}{n!} \sum_{k=0}^{0} (-1)^k \binom{n}{k} (1-k)^n = \frac{1}{n!}$

Similarly:

$P(S_{n-1} < 1) = \frac{1}{(n-1)!}$

### Step 3: Computing the Telescoping Difference

$$
\begin{align}
P(\tau = n) &= P(S_{n-1} < 1) - P(S_n < 1) \\
&= \frac{1}{(n-1)!} - \frac{1}{n!} \\
&= \frac{1}{(n-1)!} - \frac{1}{n \cdot (n-1)!} \\
&= \frac{n - 1}{n \cdot (n-1)!} \\
&= \frac{n-1}{n!}
\end{align}
$$

## Verification of the Probability Mass Function

### Step 4: Proving the Sum Equals Unity

To verify this is a proper probability mass function, we need to show:

$\sum_{n=2}^{\infty} P(\tau = n) = \sum_{n=2}^{\infty} \frac{n-1}{n!} = 1$

This can be proven using the telescoping property:

$$
\begin{align}
\sum_{n=2}^{\infty} \frac{n-1}{n!} &= \sum_{n=2}^{\infty} \left(\frac{1}{(n-1)!} - \frac{1}{n!}\right) \\
&= \left(\frac{1}{1!} - \frac{1}{2!}\right) + \left(\frac{1}{2!} - \frac{1}{3!}\right) + \left(\frac{1}{3!} - \frac{1}{4!}\right) + \cdots \\
&= \frac{1}{1!} = 1
\end{align}
$$

Alternatively, we can use the series expansion of the exponential function:

$\sum_{n=2}^{\infty} \frac{n-1}{n!} = \sum_{n=1}^{\infty} \frac{n}{n!} - \sum_{n=1}^{\infty} \frac{1}{n!} = e - (e - 1) = 1$

## Connection to Renewal Theory

### Renewal Process Interpretation

The hitting time $\tau$ can be interpreted as the first renewal time in a renewal process where the inter-arrival times are the differences between consecutive uniform random variables crossing integer boundaries[3][4]. This connects our result to classical renewal theory.

### Martingale Approach

The process $M_n = S_n - n/2$ is a martingale (since $E[X_i] = 1/2$ for uniform $[0,1)$ variables), and the stopping time $\tau$ is a stopping time with respect to the natural filtration. The optional stopping theorem provides an alternative derivation path[5][6].

### First Passage Time Properties

The expected hitting time is:

$E[\tau] = \sum_{n=2}^{\infty} n \cdot \frac{n-1}{n!} = \sum_{n=2}^{\infty} \frac{n(n-1)}{n!} = \sum_{n=2}^{\infty} \frac{1}{(n-2)!} = e$

This result aligns with renewal theory predictions, where the expected first passage time is the reciprocal of the drift rate[3][4].

## Mathematical Rigor and Intermediate Steps

### Complete Proof Structure

1. **Foundation**: The Irwin-Hall distribution provides the exact cumulative distribution function for sums of uniform random variables[1][2].
2. **Telescoping Identity**: The hitting time probability decomposes as $P(\tau = n) = P(S_{n-1} < 1) - P(S_n < 1)$.
3. **Exact Computation**: Using the Irwin-Hall formula with $x = 1$ gives the precise values needed for the telescoping difference.
4. **Verification**: The telescoping sum structure ensures the probabilities sum to unity.

### Connection to Formal Probability Theory

This establishes the axiom `hitting_time_pmf` in formal probability theory, connecting:

- **Uniform random variables** on the unit interval
- **First passage times** across integer boundaries
- **Renewal theory** for regenerative processes
- **Martingale theory** through optional stopping theorems

The formula $P(\tau = n) = \frac{n-1}{n!}$ thus represents a fundamental result bridging discrete probability, continuous distributions, and stochastic process theory[3][5][6].

