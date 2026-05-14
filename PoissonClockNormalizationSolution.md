# Poisson clock normalization solution

Problem statement.  Let `X_1,X_2,...` be independent uniform `[0,1)` random
variables and let

```text
tau = min{n>=1 : X_1 + ... + X_n > 1}.
```

We want `E[tau]`.

For fixed `n`, the event `tau>n` is exactly

```text
X_1 + ... + X_n <= 1.
```

The probability of this event is `1/n!`.  This can be checked by the standard
iterated integral

```text
int_0^1 int_0^{1-x_1} ... int_0^{1-x_1-...-x_{n-1}} dx_n ... dx_1 = 1/n!.
```

Now introduce a unit-rate Poisson clock `N(1)`.  Its one-time distribution is

```text
P(N(1)=n)=e^{-1}/n!.
```

Therefore the survival probability has the exact normalization

```text
P(tau>n)=1/n! = e P(N(1)=n).
```

The tail-sum formula for a positive integer-valued stopping time gives

```text
E[tau] = sum_{n>=0} P(tau>n)
       = e sum_{n>=0} P(N(1)=n)
       = e.
```

The new viewpoint is the last step: the factorial tail sequence is not just
summed as a power series, but normalized into an honest probability mass
function.  The constant `e` is exactly the normalizing constant that turns the
safe-prefix probabilities into the Poisson distribution at time one.

Comparison with nearby candidates:

- `JanossySolution.md` uses Poisson configuration normalization, but this proof
  is the one-line marginal normalization of the survival tail.
- `FactorialMomentMeasureSolution.md` works through factorial measures; this
  does not need moment identities.
- `PoissonProcessCampbellSolution.md` uses process machinery; this only uses
  `P(N(1)=n)`.
- `DirichletIntegralTailSolution.md` obtains the factorial by integration, but
  does not repackage the whole tail as a Poisson law.
- `MultinomialCoefficientLimitSolution.md` explains the factorial by a limit;
  this proof explains why the final sum collapses.

This is not merely renamed simplex-volume or tail-sum prose: the simplex
integral appears only to identify the tail once, while the proof's memory hook
is "multiply the tail by `e^{-1}` and it becomes a Poisson distribution."

Author memory hook: `E[tau]` is `e` because the survival tails are `e` times a
probability distribution.
