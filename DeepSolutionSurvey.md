# Deep solution survey

This note records the stronger conclusion after a broad parallel search over
martingales, killed Markov chains, Volterra resolvents, Poisson embeddings,
order-statistics bijections, finite-horizon transforms, and adversarial
critiques.

The short verdict is:

```text
The most impressive proof is not "compute the distribution".
It is a one-function certificate for the killed Markov chain.
Find h with (I - K) h = 1; then E[tau] = h(1).
For this problem, h(r) = exp(r).
```

This is the same mathematical core as the killed exponential martingale, but
stated as a Green-kernel/Poisson-equation certificate.  That presentation is
substantially stronger: it explains why the proof works, why the exponential is
forced, and why no PMF calculation is being smuggled in.

## Final chosen proof

Let

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 },
R_n = 1 - S_n.
```

While the process is alive, `R_n` is the remaining distance to the absorbing
boundary.  On bounded functions over `[0, 1]`, define the killed transition
operator

```text
(K f)(r) = E[f(r - U) 1_{U <= r}]
         = int_0^r f(r - u) du
         = int_0^r f(t) dt.
```

If `G = I + K + K^2 + ...` is the Green operator, then the expected number of
visits before death, starting from remaining distance `r`, is

```text
m(r) = (G 1)(r).
```

So `m` solves the Poisson equation

```text
(I - K) m = 1.                                      (1)
```

Instead of finding the law of `tau`, find a certificate `h` satisfying (1).
For `0 <= r <= 1`, equation (1) says

```text
h(r) - int_0^r h(t) dt = 1.
```

This immediately implies

```text
h(0) = 1,
h'(r) = h(r),
```

and therefore

```text
h(r) = exp(r).
```

Hence

```text
E[tau] = m(1) = h(1) = e.
```

This proof never computes `P(tau = n)` or `P(tau > n)`.

## Why this is a certificate, not a hidden series proof

For a finite time horizon, define

```text
m_N(r) = E[min(tau_r, N)].
```

Then

```text
m_0 = 0,
m_{N+1} = 1 + K m_N.
```

Thus `m_N` increases pointwise to the minimal nonnegative solution of (1).  If
we exhibit any nonnegative `h` with `(I - K)h = 1`, induction gives

```text
m_N <= h
```

for all `N`; monotone convergence then identifies the limit.  The certificate
`h(r)=exp(r)` proves both finiteness and the value at the same time.

The martingale form is the same certificate written dynamically.  Put

```text
V_n = exp(R_n) 1_{tau > n}.
```

Conditioning on the next drink and writing `r = R_n`,

```text
E[V_{n+1} | F_n]
  = int_0^r exp(r - u) du
  = exp(r) - 1
  = V_n - 1
```

on `{tau > n}`, while both sides vanish after death.  Therefore

```text
V_n + sum_{k=0}^{n-1} 1_{tau > k}
```

is a martingale.  Taking expectations and letting `n -> infinity` again yields
`E[tau]=e`.

## Stronger finite-horizon shadow

The same operator proof also explains the truncated expectation:

```text
E[min(tau_r, N)] = sum_{k=0}^{N-1} r^k / k!.
```

At `r=1`, this is the partial exponential series.  The point is not that the
answer is a series; the point is that the series is the iterated Green kernel
of the killed walk.

One can also record the censored probability-generating function

```text
E[z^(min(tau, N))] = 1 + (z - 1) sum_{k=0}^{N-1} z^k / k!,
```

which is stronger than merely knowing `E[min(tau, N)]`.

## Follow-up Janossy configuration proof

A later brainstorming pass produced a sharper presentation of the
configuration-space version.  It is implemented in
[`PotionProblem/JanossyConfiguration.lean`](PotionProblem/JanossyConfiguration.lean)
and explained in [`JanossySolution.md`](JanossySolution.md).

The idea is to count surviving prefixes:

```text
tau = sum_{n>=0} 1_{S_n <= 1}.
```

After the cumulative-sum change of variables `t_i = S_i`, the event
`S_n <= 1` is the ordered chamber

```text
0 < t_1 < ... < t_n <= 1.
```

For a unit-rate Poisson point process on `[0,1]`, the ordered Janossy density
on that chamber is `exp(-1) dt_1 ... dt_n`.  Summing over every `n` and every
ordered configuration gives total probability `1`, hence

```text
1 = exp(-1) E[tau],
```

so `E[tau]=e`.  This does not supersede the killed-potential certificate as a
general method, but it is arguably the most compact surprise presentation: `e`
appears as the inverse Poisson void factor.

## Search comparison

The broad search separated the candidates as follows.

| Rank | Family | Verdict |
| --- | --- | --- |
| 1 | Killed Markov chain / Poisson equation / martingale certificate | Best final proof.  It is short, rigorous, and genuinely avoids distribution-first reasoning. |
| 2 | Volterra resolvent / spectral view | Same proof in analytic clothing.  Excellent explanatory backup, but less startling than the potential certificate. |
| 3 | Finite-horizon PGF identity | Strong strengthening and useful as a second punchline. |
| 4 | Poisson/order-statistics/spacings | Elegant, but too close to the classical simplex-volume proof. |
| 5 | Inclusion-exclusion/species/umbral calculus | Good for explaining factorials, weaker as a surprise solution. |
| 6 | Fredholm/RKHS/fractional/entropy framings | Can be made true, but mostly decorative overkill for this problem. |

The adversarial pass found no fatal flaw in the certificate proof under the
iid continuous uniform model.  The only points that must be stated cleanly are:

- The boundary event has probability zero for continuous uniforms, but using
  `U <= r` in the killed kernel handles it harmlessly.
- Optional stopping is used only at deterministic finite times; the limit uses
  monotone convergence and the bound supplied by the certificate.
- The proof is for the threshold `1` with uniform increments on `[0,1]`; the
  all-threshold renewal function becomes piecewise on later intervals.

## Presentation to use

The shortest high-impact version is:

```text
Do not ask for the distribution of tau.  Ask for a potential h(r) whose
expected loss in one surviving drink is exactly 1.

For remaining distance r, the next surviving potential is
int_0^r h(r-u) du.  We need

    h(r) - int_0^r h(r-u) du = 1.

This forces h(0)=1 and h'=h, hence h(r)=e^r.  Starting from r=1, the initial
potential is e; each surviving drink burns exactly one unit; therefore the
expected number of drinks is e.
```
