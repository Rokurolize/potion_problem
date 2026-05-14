# Math validity check

- Exact problem: `tau=min{n>=1: X_1+...+X_n>1}`.
- Variables: the `X_i` are independent uniform `[0,1)` increments.
- Tail event: `tau>n` is equivalent to `X_1+...+X_n<=1`.
- Tail probability: the iterated integral over the safe region gives
  `P(tau>n)=1/n!`.
- Poisson normalization: for a unit-rate Poisson variable, `P(N(1)=n)=e^{-1}/n!`.
- Tail-sum: `E[tau]=sum_{n>=0}P(tau>n)=e sum_n P(N(1)=n)=e`.
- No hidden change: the Poisson clock is used only to normalize the sequence;
  the stopping rule and the uniform increments are unchanged.
