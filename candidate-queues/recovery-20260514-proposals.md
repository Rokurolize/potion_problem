# Recovery 2026-05-14 proposals

This queue restarts the lifetime loop after removing the saturation reward hack.
The goal is a small honest batch, not progress by volume.

## 1. Renewal boundary-value equation

Proof idea: Let `F(r)` be the expected number of further drinks needed to cross
from remaining gap `r`.  Conditioning on the first uniform increment gives
`F(r)=1+int_0^r F(r-u)du`; differentiating gives `F'=F`, `F(0)=1`, hence
`F(1)=e`.

Proof family: renewal equation.  New point: works directly with expected
remaining time instead of first computing all simplex tails.  Overlap: killed
potential and Bellman-style candidates.  Rename risk: medium, but the state
variable is operational rather than a dressed-up volume.  Decision: write.

## 2. Volterra resolvent of the killed averaging operator

Proof idea: Treat one safe drink as the Volterra operator
`(Kg)(r)=int_0^r g(r-u)du`.  The expected number of visits before killing is
`(I+K+K^2+...)1` at `r=1`; the resolvent solves `u=1+Ku`, hence `u=e^r`.

Proof family: operator resolvent.  New point: shows why the proof is a
resolvent identity, not a factorial-volume enumeration.  Overlap: compact
operator and killed potential candidates.  Rename risk: medium.  Decision:
write.

## 3. Backward equation from the first safe increment

Proof idea: Split the first draw into crossing and non-crossing events.  For
remaining gap `r`, a draw above `r` stops and a draw below `r` restarts with
gap `r-x`; this gives the same ODE but from a backward first-step equation.

Proof family: backward equation.  New point: explicitly accounts for the
crossing mass `1-r` instead of hiding it in a tail volume.  Overlap: dynamic
programming candidates.  Rename risk: low to medium.  Decision: write.

## 4. Defect measure at the absorbing boundary

Proof idea: Encode the overshoot event as boundary defect mass and compute the
mean number of interior visits before absorption.

Proof family: boundary defect.  New point: tracks the mass that leaves the
interval.  Overlap: boundary flux candidates.  Rename risk: medium.  Decision:
defer.

## 5. Renewal reward with unit running cost

Proof idea: Give each safe prefix one unit reward and compute total reward of
the killed renewal process.

Proof family: renewal reward.  New point: turns expectation into accumulated
running cost.  Overlap: killed potential.  Rename risk: medium.  Decision:
defer.

## 6. Minimal nonnegative solution comparison

Proof idea: Prove the expected remaining count is the minimal nonnegative
solution of `F=1+KF` and identify `e^r` by comparison.

Proof family: fixed point.  New point: emphasizes uniqueness and minimality.
Overlap: minimal fixed-point candidate.  Rename risk: high.  Decision: reject.

## 7. Truncated horizon monotone convergence

Proof idea: Let `F_N(r)` be the expected number of drinks before either crossing
or reaching horizon `N`; prove `F_N` satisfies a finite recursion and converges
monotonically to `e^r`.

Proof family: truncation.  New point: avoids infinite series until the final
limit.  Overlap: dynamic programming.  Rename risk: medium.  Decision: defer.

## 8. Distribution-free Volterra uniqueness

Proof idea: Characterize the uniform law as the only law that gives the
constant-kernel Volterra equation, then solve the equation.

Proof family: characterization.  New point: clarifies exactly where uniformity
enters.  Overlap: too broad.  Rename risk: low.  Decision: defer.

## 9. Optional stopping with exponential test function

Proof idea: Search for a test function whose one-step drift cancels before the
barrier and derive the expectation from accumulated drift.

Proof family: martingale certificate.  New point: potential stopping argument.
Overlap: killed exponential.  Rename risk: medium.  Decision: defer.

## 10. Hazard of survival under remaining capacity

Proof idea: Model the safe-region mass as a continuous hazard in remaining
capacity and integrate the resulting mean equation.

Proof family: hazard.  New point: interprets the kernel as a capacity hazard.
Overlap: integrated hazard candidates.  Rename risk: high.  Decision: reject.

## 11. Generating function from truncated expectations

Proof idea: Use the recursion for finite-horizon expectations to build an
exponential generating function for the limiting mean.

Proof family: generating function.  New point: expectation-first generating
function.  Overlap: many generating-function candidates.  Rename risk: high.
Decision: reject.

## 12. Coupled interval-shrinking process

Proof idea: Couple the remaining gap to a process that either dies or subtracts
a uniform amount from the current gap, then solve the coupled mean equation.

Proof family: coupling.  New point: probabilistic process description.
Overlap: first-step equation.  Rename risk: medium.  Decision: defer.
