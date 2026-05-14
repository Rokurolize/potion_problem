# Volterra resolvent lifetime solution

Consider the killed one-step operator on functions of the remaining gap:

```text
(K g)(r)=int_0^r g(r-x) dx.
```

The integral is only over safe first increments `x<r`; increments `x>=r` leave
the state space and stop the process.  Starting with a unit running cost for
each drink, the expected number of drinks before killing is the resolvent

```text
U(r)=(I+K+K^2+...)1(r).
```

Equivalently, `U` is the solution of

```text
U=1+K U.
```

This is the same equation as

```text
U(r)=1+int_0^r U(r-x) dx.
```

It has derivative `U'(r)=U(r)` and boundary value `U(0)=1`, hence `U(r)=e^r`.
At the original gap `1`,

```text
E[T]=U(1)=e.
```

If the resolvent is expanded, `K^n 1(1)=P(T>n)=1/n!`, so the operator proof
also recovers the standard tail-sum expansion.  Its main point is that the
answer is the resolvent of the killed uniform-increment operator at unit cost.
