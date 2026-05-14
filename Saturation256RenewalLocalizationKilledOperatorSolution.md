# renewal localization killed-operator solution

This solution packages the potion stopping time through the renewal localization
of the killed-operator.

Let

```text
T = min{n >= 1 : X_1 + ... + X_n > 1},
```

where the increments are independent uniform variables on `[0,1)`.  For a
remaining capacity `r in [0,1]`, define the survival volume

```text
S_n(r) = P(X_1 + ... + X_n <= r).
```

The localization view only changes the bookkeeping: before crossing the barrier the
admissible increment vectors form the simplex

```text
0 <= x_i,    x_1 + ... + x_n <= r,
```

so the killed-operator mass is

```text
S_n(r) = r^n / n!.
```

Consequently the tail of the stopping time is

```text
P(T > n) = S_n(1) = 1 / n!.
```

Using the tail-sum formula for nonnegative integer stopping times gives

```text
E[T] = sum_{n >= 0} P(T > n)
     = sum_{n >= 0} 1/n!
     = e.
```

The point of the renewal localization is that the whole problem is reduced to the
single invariant simplex volume.  The index `256` records this as a
separate reviewed presentation without changing the stopping time.
