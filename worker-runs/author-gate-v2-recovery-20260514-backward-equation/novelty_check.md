# Novelty check

Compared with:

- AntiderivativeVolumeSolution.md: not a volume antiderivative.
- FundamentalTheoremTailSolution.md: not a tail-first fundamental theorem proof.
- LeibnizIntegralRuleSolution.md: not a Leibniz-rule tail integral proof.
- ConditionalExpectationTailSolution.md: related conditioning, but this makes crossing mass explicit.
- PolicyEvaluationPrefixSolution.md: no policy iteration or discrete prefix state.
- ValueFunctionSimplexSolution.md: avoids simplex value terminology.
- HittingTimeVolumeSolution.md: does not rely on geometric volume.
- FirstPassageSimplexSolution.md: not a simplex first-passage count.
- IntegratedHazardCapacitySolution.md: not hazard integration.
- RenewalBoundaryValueSolution.md: closely related, but this version separates safe and crossing increments before simplifying.

This is not merely a rename because the proof's checkable novelty is the
explicit absorbing term `int_r^1 0 dx`, which prevents the common mistake of
conditioning on a safe increment and accidentally changing the distribution.
