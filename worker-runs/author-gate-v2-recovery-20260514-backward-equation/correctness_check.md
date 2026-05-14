# Correctness check

- Original stopping time: `T=min{n>=1: X_1+...+X_n>1}` is stated and used.
- Increments: the proof keeps independent uniform `[0,1)` increments and splits the first increment at the remaining gap.
- Route to the result: the first-step equation gives the mean directly; iteration recovers `P(T>n)=1/n!`.
- Tail-sum: the result agrees with `E[T]=sum_{n>=0} P(T>n)`, and the proof explains the equivalent route.
- There is no hidden change of distribution or stopping rule: the term `int_r^1 0 dx` explicitly records immediate crossing.
- Named theorems: only first-step conditioning, substitution in an integral, and the elementary ODE `F'=F` are used.
