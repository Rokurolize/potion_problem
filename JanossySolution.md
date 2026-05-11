# Janossy configuration solution

This note records the Poisson point-process presentation of the potion problem.
It is meant as a high-impact companion to the killed-potential certificate in
[KilledExponentialSolution.md](KilledExponentialSolution.md).  The Lean module
[PotionProblem/JanossyConfiguration.lean](PotionProblem/JanossyConfiguration.lean)
formalizes the scalar normalization identity used below.

Let `U_1, U_2, ...` be independent uniform random variables on `[0, 1]`, let

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }.
```

The stopping time counts the living prefixes:

```text
tau = sum_{n >= 0} 1_{S_n <= 1}.
```

By Tonelli,

```text
E[tau] = sum_{n >= 0} P(S_n <= 1).
```

For fixed `n`, change variables from increments to arrival times,

```text
t_i = S_i = U_1 + ... + U_i.
```

The Jacobian is `1`, and the survival event becomes the ordered chamber

```text
0 < t_1 < ... < t_n <= 1.
```

So

```text
E[tau] = sum_{n >= 0} int_{0<t_1<...<t_n<=1} dt_1 ... dt_n.
```

Now place a unit-rate Poisson point process on `[0, 1]`.  Its ordered Janossy
density for exactly `n` points at `0 < t_1 < ... < t_n <= 1` is

```text
exp(-1) dt_1 ... dt_n.
```

Summing this density over all ordered configurations and all `n` gives total
probability `1`.  Therefore

```text
1
  = exp(-1) * sum_{n >= 0} int_{0<t_1<...<t_n<=1} dt_1 ... dt_n
  = exp(-1) * E[tau].
```

Thus

```text
E[tau] = exp(1) = e.
```

The proof does not solve a value equation and does not first compute
`P(tau = n)`.  The number `e` appears as the inverse of the Poisson void factor
`exp(-1)`: the stopped paths are exactly the ordered configurations after the
Poisson normalization has been stripped off.
