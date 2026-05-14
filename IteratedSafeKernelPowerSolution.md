# Iterated safe-kernel power solution

Problem statement.  Let `X_1,X_2,...` be independent uniform `[0,1)` random
variables and define the stopping time

```text
tau = min{n>=1 : X_1 + ... + X_n > 1}.
```

For a remaining capacity `r`, define the killed safe-increment kernel

```text
(Qf)(r)=int_0^r f(r-x) dx.
```

The upper limit `r` is the whole stopping rule: increments `x>=r` cross the
barrier and contribute no continuation.  Thus `Q` is not an abstract decoration;
it is the transition kernel of one safe drink.

Let `q_n(r)=Q^n 1(r)`.  By induction, `q_n(r)` is the probability that `n`
further drinks are all safe when the current gap is `r`.  The induction step is
first-step conditioning:

```text
q_{n+1}(r)=int_0^r q_n(r-x) dx.
```

Starting with `q_0(r)=1`, the same recursion gives

```text
q_n(r)=r^n/n!.
```

At the original gap `r=1`,

```text
P(tau>n)=q_n(1)=1/n!.
```

Now apply the tail-sum formula:

```text
E[tau]=sum_{n>=0} P(tau>n)
      =sum_{n>=0} Q^n 1(1)
      =sum_{n>=0} 1/n!
      =e.
```

The new viewpoint is that every tail probability is a power of the same killed
kernel.  The proof is not a renamed simplex-volume argument because it tracks
survival by iterating the actual one-step transition operator.

Comparison with nearby candidates:

- `VolterraResolventLifetimeSolution.md` sums the resolvent directly; this
  proof inspects each kernel power as a survival event.
- `RenewalBoundaryValueSolution.md` solves for the mean first; this derives the
  tail sequence first from Markov-kernel powers.
- `CompactOperatorSimplexSolution.md` emphasizes operator structure; this keeps
  the probabilistic interpretation of `Q^n`.
- `DynamicProgrammingTailSolution.md` uses dynamic recursion; this makes the
  recursion an explicit kernel power.
- `HittingTimeVolumeSolution.md` computes volumes; this uses the one-step
  killed transition as the organizing object.

Author memory hook: the whole expectation is the geometric series of a killed
safe-drink kernel, evaluated at the constant function `1`.
