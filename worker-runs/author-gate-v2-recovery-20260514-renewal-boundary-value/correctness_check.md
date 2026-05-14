# Correctness check

- Original stopping time: `T=min{n>=1: X_1+...+X_n>1}` is used without changing the threshold.
- Increments: the proof explicitly assumes independent uniform `[0,1)` increments.
- Route to the result: it computes the expected remaining count `F(r)` directly.  Iterating the same Volterra equation gives `P(T>n)=1/n!`, so it is equivalent to the standard valid route.
- Tail-sum: the proof does not need to start from the tail-sum formula, but it is compatible with `E[T]=sum_{n>=0} P(T>n)`.
- There is no hidden change of distribution or stopping rule: increments above `r` stop, increments below `r` continue with gap `r-x`.
- Named theorems: only first-step conditioning and differentiation of a Volterra integral equation are used, both reduced to elementary steps.
