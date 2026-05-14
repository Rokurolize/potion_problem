# Skeptical review

Objection 1: The argument may be just the same simplex tail proof in another
language.

Response: It does not compute simplex volumes; it solves the expectation
equation directly.  The tail probabilities are mentioned only as compatibility.

Objection 2: The equation might forget the probability of immediate crossing.

Response: The initial `1` counts the current drink, and the continuation
integral only ranges over safe increments.  Crossing increments contribute zero
future cost.

Objection 3: Differentiating the integral equation might hide regularity.

Response: The kernel is continuous once `F` is locally bounded; the integral
form itself also verifies `F(r)=e^r` by substitution, so the derivative step is
not a fragile assumption.
