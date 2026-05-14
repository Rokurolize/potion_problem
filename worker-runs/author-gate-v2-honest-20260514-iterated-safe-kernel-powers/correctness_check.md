# Correctness check

- Original stopping time: `T=min{n>=1: X_1+...+X_n>1}` is the same stopped sum.
- Increments: independent uniform `[0,1)` increments are used.
- Route: the proof obtains `P(T>n)=Q^n1(1)=1/n!` by induction.
- Tail-sum: `E[T]=sum_{n>=0} P(T>n)` is used correctly.
- There is no hidden change of distribution or stopping rule.
- Named theorem: only first-step conditioning and induction are used.
