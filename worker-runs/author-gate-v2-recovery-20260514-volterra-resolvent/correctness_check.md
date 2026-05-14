# Correctness check

- Original stopping time: `T=min{n>=1: X_1+...+X_n>1}` is the killed process represented by the operator.
- Increments: the operator integrates over independent uniform `[0,1)` increments that remain safe.
- Route to the result: the resolvent equation `U=1+KU` gives the expected lifetime; expanding the resolvent gives `P(T>n)=1/n!`.
- Tail-sum: the resolvent sum `sum K^n 1(1)` is the tail-sum `sum_{n>=0} P(T>n)`.
- There is no hidden change of distribution or stopping rule: killing occurs exactly when the increment is at least the remaining gap.
- Named theorems: the Neumann resolvent is used only as shorthand for repeated substitution of the positive Volterra operator.
