# Honest loop proposals 2026-05-14

The strict count before this batch is 3.  This queue proposes 8 ideas and
accepts 2, staying below the limit of 3 accepted candidates.

## 1. Poisson clock normalization

- Proposed filename: `PoissonClockNormalizationSolution.md`
- Mathematical lens: Poisson counting normalization.
- Core route: observe `P(tau>n)=P(X_1+...+X_n<=1)=1/n!`, then rewrite this as
  `e * P(N(1)=n)` for a unit Poisson clock and sum over `n`.
- Not a mere rename: the final normalization uses a probability distribution
  summing to 1, not a renamed simplex-volume computation.
- Closest existing candidates: `JanossySolution.md`,
  `FactorialMomentMeasureSolution.md`, `PoissonProcessCampbellSolution.md`.
- Novelty risk: medium, because Poisson language already appears nearby.
- Expected author-persona reaction: pass if the normalization is kept exact.
- Triage: accept.

## 2. Iterated safe-kernel powers

- Proposed filename: `IteratedSafeKernelPowerSolution.md`
- Mathematical lens: powers of the killed safe-increment kernel.
- Core route: define `Qf(r)=int_0^r f(r-x)dx`, show `Q^n 1(1)=P(tau>n)`,
  compute the powers recursively, and sum.
- Not a mere rename: focuses on the Markov kernel powers that encode survival,
  not on geometric naming of the same simplex.
- Closest existing candidates: `VolterraResolventLifetimeSolution.md`,
  `CompactOperatorSimplexSolution.md`, `DynamicProgrammingTailSolution.md`.
- Novelty risk: medium-high because of overlap with the Volterra resolvent.
- Expected author-persona reaction: pass only if the kernel-power meaning is
  explicit and the overlap is acknowledged.
- Triage: accept.

## 3. Beta integral endpoint peeling

- Proposed filename: `BetaEndpointPeelingSolution.md`
- Mathematical lens: repeated endpoint peeling of a beta integral.
- Core route: represent the safe sum integral as a beta integral and peel one
  endpoint at a time.
- Not a mere rename: would need endpoint analysis beyond naming.
- Closest existing candidates: `BetaFunctionSliceSolution.md`,
  `BetaPeelingSlackSolution.md`.
- Novelty risk: high; likely duplicates existing beta candidates.
- Expected author-persona reaction: reject.
- Triage: reject.

## 4. Hazard martingale certificate

- Proposed filename: `HazardMartingaleCertificateSolution.md`
- Mathematical lens: drift cancellation for an exponential test function.
- Core route: build a martingale-like compensation before the threshold.
- Not a mere rename: could be certificate-based if made precise.
- Closest existing candidates: `KilledExponentialSolution.md`,
  `IntegratedHazardCapacitySolution.md`.
- Novelty risk: high; likely too close.
- Expected author-persona reaction: defer.
- Triage: defer.

## 5. Renewal reward occupation measure

- Proposed filename: `RenewalRewardOccupationSolution.md`
- Mathematical lens: occupation measure with unit reward.
- Core route: integrate unit running cost over visits to remaining-gap states.
- Not a mere rename: occupation measure could be distinct.
- Closest existing candidates: `RenewalBoundaryValueSolution.md`,
  `KilledPotentialSolution.md`.
- Novelty risk: high after the previous recovery batch.
- Expected author-persona reaction: defer.
- Triage: defer.

## 6. Order-statistic probability proof

- Proposed filename: `OrderStatisticProbabilitySolution.md`
- Mathematical lens: order statistics of uniforms.
- Core route: identify `1/n!` as the probability that `n` uniforms fall in
  one increasing order region.
- Not a mere rename: doubtful; likely just simplex volume with order labels.
- Closest existing candidates: `OrderSimplexBijectionSolution.md`,
  `SymmetrizationProjectionSolution.md`.
- Novelty risk: very high.
- Expected author-persona reaction: reject.
- Triage: reject.

## 7. Truncated expectation monotone limit

- Proposed filename: `TruncatedExpectationLimitSolution.md`
- Mathematical lens: finite-horizon monotone convergence.
- Core route: solve finite horizon equations and pass to the limit.
- Not a mere rename: finite approximants are a genuine route if developed.
- Closest existing candidates: `BellmanValueIterationSolution.md`,
  `DynamicProgrammingTailSolution.md`.
- Novelty risk: medium.
- Expected author-persona reaction: defer.
- Triage: defer.

## 8. Laplace transform of survival sequence

- Proposed filename: `LaplaceSurvivalSequenceSolution.md`
- Mathematical lens: transform of the survival sequence.
- Core route: encode `P(tau>n)` into a transform and evaluate at one.
- Not a mere rename: weak unless the transform does real work.
- Closest existing candidates: `LaplaceTransformTailSolution.md`,
  `BorelTransformSurvivalSolution.md`.
- Novelty risk: very high.
- Expected author-persona reaction: reject.
- Triage: reject.
