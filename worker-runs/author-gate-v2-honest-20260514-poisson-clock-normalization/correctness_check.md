# Correctness check

- Original stopping time: `T=min{n>=1: X_1+...+X_n>1}` is the same as `tau` in the candidate.
- Increments: independent uniform `[0,1)` increments are used.
- Route: the proof obtains `P(T>n)=1/n!` and then normalizes it by the Poisson distribution.
- Tail-sum: `E[T]=sum_{n>=0} P(T>n)` is used correctly.
- There is no hidden change of distribution or stopping rule.
- Named theorem: the Poisson mass function is stated explicitly.
