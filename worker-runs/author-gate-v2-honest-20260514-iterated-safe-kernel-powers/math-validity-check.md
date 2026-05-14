# Math validity check

- Exact problem: `tau=min{n>=1: X_1+...+X_n>1}`.
- Variables: independent uniform `[0,1)` increments.
- Kernel meaning: `Qf(r)=int_0^r f(r-x)dx` integrates exactly over safe first
  increments and kills crossing increments.
- Tail event: by induction, `Q^n1(r)` is the probability that `n` further
  increments remain safe from gap `r`; hence `P(tau>n)=Q^n1(1)`.
- Computation: the recursion gives `Q^n1(r)=r^n/n!`.
- Tail-sum: `E[tau]=sum_{n>=0}P(tau>n)=sum 1/n!=e`.
- No hidden change: the kernel encodes the original stopping rule.
