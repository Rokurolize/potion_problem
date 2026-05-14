# Backward equation with crossing mass solution

Let `F(r)` be the expected number of additional drinks needed when the current
sum is `1-r`, so `r` is the remaining gap.  The original question asks for
`F(1)` for

```text
T=min{n>=1: X_1+...+X_n>1}.
```

On the next drink, the increment lies in `[0,r)` with probability `r` and in
`[r,1)` with probability `1-r`.  The latter part crosses the threshold and
has zero future cost.  Therefore

```text
F(r)=1 + int_0^r F(r-x) dx + int_r^1 0 dx.
```

The explicit crossing-mass term is useful: it shows that no conditioning has
silently changed the law of the first increment.  The equation reduces to

```text
F(r)=1+int_0^r F(y) dy,
```

after the substitution `y=r-x`.  Hence

```text
F'(r)=F(r),    F(0)=1,
```

so `F(r)=e^r`.  Starting from the original gap `r=1` gives

```text
E[T]=e.
```

The tail formula `P(T>n)=1/n!` follows by iterating the same equation, but the
backward proof exposes the absorbing mass at each first step.
