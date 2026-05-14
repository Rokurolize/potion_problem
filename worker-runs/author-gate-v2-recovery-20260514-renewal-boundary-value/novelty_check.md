# Novelty check

Compared with:

- AntiderivativeVolumeSolution.md: uses expected remaining time, not volume recursion.
- FundamentalTheoremTailSolution.md: does not start from tail probabilities.
- LeibnizIntegralRuleSolution.md: differentiates the mean equation, not a tail integral.
- KilledExponentialSolution.md: related potential idea, but this text foregrounds the boundary-value renewal equation.
- MinimalFixedPointSolution.md: avoids minimality machinery.
- BellmanValueIterationSolution.md: uses a continuous boundary equation rather than finite iteration.
- DynamicProgrammingTailSolution.md: no horizon-indexed dynamic program.
- VolterraOperatorSolution.md: this one is expectation-first, not operator-first.
- HittingTimeVolumeSolution.md: no simplex-volume enumeration.
- StoppedProcessPrefixSolution.md: does not count prefixes.

This is not merely a rename because the primitive object is the remaining-gap
mean `F(r)`, and the crossing mass is absorbed into the boundary value rather
than hidden behind `P(T>n)=1/n!`.
