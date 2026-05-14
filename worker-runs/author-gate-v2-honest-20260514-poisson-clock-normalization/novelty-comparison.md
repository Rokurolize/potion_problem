# Novelty comparison

Nearby accepted candidates:

- JanossySolution.md: both are Poisson-flavored, but this candidate uses only
  the one-time Poisson mass function as a normalization of the survival tail.
- FactorialMomentMeasureSolution.md: avoids factorial moment machinery.
- PoissonProcessCampbellSolution.md: avoids Campbell/Mecke formulas.
- DirichletIntegralTailSolution.md: uses the integral only to identify
  `1/n!`, then changes viewpoint to a normalized probability law.
- MultinomialCoefficientLimitSolution.md: no limiting multinomial argument.
- BetaFunctionSliceSolution.md: no beta slicing.
- RenewalBoundaryValueSolution.md: no renewal ODE for the mean.
- VolterraResolventLifetimeSolution.md: no resolvent equation.
- IteratedSafeKernelPowerSolution.md: does not organize the proof by kernel
  powers.
- HittingTimeVolumeSolution.md: the final summation is not "sum the volumes";
  it is "sum a Poisson distribution."

This is not merely a rename of simplex volume or tail sum.  The memory hook is
that `e^{-1} P(tau>n)` is exactly the Poisson probability `P(N(1)=n)`, so the
normalizing constant must be `e`.
