# Killed exponential solution

This note gives a non-PMF proof of the potion problem.  It does not first find
`P(tau = n)`, and it does not use simplex volume.  The whole computation is a
one-line potential drop.

For the broader comparison that led to this proof being selected, see
[DeepSolutionSurvey.md](DeepSolutionSurvey.md).  The conceptual upgrade is that
`exp(r)` is not a lucky guess: it is a certificate solving the killed-chain
Poisson equation `(I - K)h = 1`.

Let `U_1, U_2, ...` be independent uniform random variables on `[0, 1]`, let

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 },
```

and write `A_n = { tau > n }`, so that the process is still alive after `n`
drinks exactly when `S_n <= 1`.

## The potential

Let `r` denote the remaining distance to the boundary.  The killed transition
operator is

```text
(K f)(r) = E[f(r - U) 1_{U <= r}]
         = int_0^r f(r - u) du.
```

The expected lifetime `m(r)` is the Green potential `(I + K + K^2 + ...)1`, so
it solves

```text
(I - K)m = 1.
```

Solving this equation gives

```text
m(r) - int_0^r m(t) dt = 1,
m(0) = 1,
m'(r) = m(r),
```

hence `m(r)=exp(r)` and `m(1)=e`.  The martingale below is the dynamic form of
the same certificate.

Define the killed exponential potential

```text
V_n = exp(1 - S_n) * 1_{A_n}.
```

If the process is already dead, both sides below are zero.  If it is alive at
time `n`, put `r = 1 - S_n`, where `0 <= r <= 1`.  Conditioning on the next
drink `U`, the next potential is present only when `U <= r`, and therefore

```text
E[V_{n+1} | F_n]
  = int_0^r exp(r - u) du
  = exp(r) - 1
  = V_n - 1.
```

Thus, in all cases,

```text
E[V_{n+1} | F_n] = V_n - 1_{A_n}.
```

Equivalently,

```text
M_n = V_n + sum_{k=0}^{n-1} 1_{A_k}
```

is a martingale.

## Taking expectations

Since `V_0 = exp(1)`, the martingale identity at deterministic time `n` gives

```text
E[V_n] + sum_{k=0}^{n-1} P(tau > k) = exp(1).        (1)
```

The partial sums are bounded by `exp(1)`, so `P(tau > n) -> 0`.  Also
`0 <= V_n <= exp(1) * 1_{A_n}`, hence `E[V_n] -> 0`.  Letting `n -> infinity`
in (1) yields

```text
E[tau]
  = sum_{k=0}^infty P(tau > k)
  = exp(1).
```

This proves the result without ever computing the distribution of `tau`.

## Why this is the unusual move

The usual solution counts simplex volumes:

```text
P(tau > n) = P(S_n <= 1) = 1 / n!.
```

Here the factorials never appear.  The number `e` is instead the initial value
of a harmonic potential for the killed random walk.  Each surviving drink burns
exactly one unit of conditional expected potential:

```text
exp(r) - E[exp(r - U) * 1_{U <= r}] = 1.
```

The expected lifetime is therefore the initial capital `exp(1)`.

## Volterra-resolvent shadow

The same idea can be written without martingales.  For `0 <= x <= 1`, let
`tau_x = min { n >= 1 : U_1 + ... + U_n > x }` and

```text
f_N(x) = E[min(tau_x, N)].
```

Conditioning on the first drink gives

```text
f_0(x) = 0,
f_{N+1}(x) = 1 + int_0^x f_N(x - u) du
           = 1 + int_0^x f_N(t) dt.
```

Induction gives

```text
f_N(x) = sum_{k=0}^{N-1} x^k / k!.
```

By monotone convergence,

```text
E[tau_x] = sum_{k=0}^infty x^k / k! = exp(x),
```

and `x = 1` again gives `E[tau] = e`.  This is the deterministic Volterra
resolvent `(I - J)^{-1} 1`, where `Jf(x) = int_0^x f(t) dt`.
