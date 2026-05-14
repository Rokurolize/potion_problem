# Renewal boundary-value solution

Let

```text
T=min{n>=1: X_1+...+X_n>1}
```

for independent uniform `[0,1)` increments.  Instead of first computing the
whole distribution of `T`, compute the mean number of further drinks from a
remaining gap `r`.

Write this mean as `F(r)` for `0<=r<=1`.  One drink is always consumed.  If the
first increment is at least `r`, the process stops.  If the increment is
`x<r`, the remaining gap becomes `r-x`.  Since the density of `x` on `[0,1)` is
one, the first-step equation is

```text
F(r)=1+int_0^r F(r-x) dx.
```

The crossing part contributes no continuation term; it is already accounted
for by the initial `1`.  Differentiating the Volterra equation gives

```text
F'(r)=F(r),    F(0)=1.
```

Thus `F(r)=e^r`, and the original starting gap is `r=1`, so

```text
E[T]=F(1)=e.
```

The usual identity `P(T>n)=1/n!` is compatible with this proof, but not needed
as the entry point: the expectation is obtained directly from the renewal
boundary-value equation.
