# The Potion Problem: An Elegant Mathematical Journey to e

## The Problem

> 女騎士「私に何を飲ませた！」  
> オーク「飲む前の感度をn倍とした時に、感度をn+m倍(m:[0,1)、毎回の摂取ごとに独立して判定される)まで引き上げる薬だ。通常時の感度を1倍として、お前の感度が2倍になるまでこれを飲ませる」  
> 女騎士「私が媚薬を飲む回数の期待値はどれくらいになるんだ……？」

Behind this colorful fantasy narrative lies a profound mathematical question that connects randomness to one of mathematics' most fundamental constants.

## Mathematical Translation

### Formal Setup

Let (Ω, ℱ, P) be a probability space where:
- Ω = [0,1)^ℕ is the space of infinite sequences of real numbers in [0,1)
- ℱ is the product σ-algebra
- P is the product measure of uniform distributions on [0,1)

Define:
- Random variables: mₙ : Ω → [0,1), where mₙ(ω) = ωₙ for ω = (ω₁, ω₂, ...) ∈ Ω
- Each mₙ ~ Uniform[0,1) independently
- Initial sensitivity: S₀ = 1
- Partial sums: Sₙ = 1 + ∑ᵢ₌₁ⁿ mᵢ for n ≥ 1
- Natural filtration: ℱₙ = σ(m₁, ..., mₙ)

**Definition (Stopping Time)**: The hitting time is
```
τ = inf{n ∈ ℕ : n ≥ 1 and Sₙ ≥ 2}
```

**Theorem**: τ is a stopping time with respect to {ℱₙ} and P(τ < ∞) = 1.

**Proof**: 
- For each n, {τ = n} = {S₁ < 2, S₂ < 2, ..., Sₙ₋₁ < 2, Sₙ ≥ 2} ∈ ℱₙ, so τ is a stopping time
- To prove finiteness: P(τ > n) = P(Sₙ < 2) = P(∑ᵢ₌₁ⁿ mᵢ < 1) = 1/n! (by Step 1 below)
- Therefore: P(τ = ∞) = lim_{n→∞} P(τ > n) = lim_{n→∞} 1/n! = 0
- Hence P(τ < ∞) = 1 - P(τ = ∞) = 1

The question asks: **What is E[τ]?**

Equivalently: **How many uniform[0,1) random variables must we sum on average before the total exceeds 1?**

### Why τ ≥ 2: Rigorous Boundary Analysis

**Theorem**: P(τ = 1) = 0, hence P(τ ≥ 2) = 1.

**Proof**: From the definition τ = inf{n ∈ ℕ : n ≥ 1 and Sₙ ≥ 2}, we have:
- {τ = 1} = {S₁ ≥ 2} = {1 + m₁ ≥ 2} = {m₁ ≥ 1}
- Since m₁ ~ Uniform[0,1), we have P(m₁ ≥ 1) = ∫₁^∞ f_{m₁}(x)dx = 0
- Therefore P(τ = 1) = 0

Note that τ ≥ 1 by definition (the infimum is taken over n ≥ 1), so we have P(τ ≥ 2) = 1.

**Remark**: The Lean 4 formalization encodes this through the probability mass function:
```lean
noncomputable def hitting_time_pmf (n : ℕ) : ℝ :=
  if n ≤ 1 then 0 else (n - 1 : ℝ) / n.factorial
```
This function returns 0 for n ≤ 1, confirming P(τ = 0) = P(τ = 1) = 0.

## The Surprising Answer

**E[τ] = e ≈ 2.718281828...**

Yes, Euler's number! This isn't a coincidence but a deep mathematical truth.

## The Beautiful Derivation

### Step 1: Understanding the Probability Distribution

For the sum of n independent Uniform[0,1) variables to first exceed 1 at step n, we need:
- S_{n-1} < 1 (haven't exceeded yet)
- S_n ≥ 1 (just exceeded)

#### The Irwin-Hall Distribution Connection

**Definition**: Let U₁, U₂, ..., Uₙ be independent random variables with Uᵢ ~ Uniform[0,1). The Irwin-Hall distribution of order n is the distribution of their sum Tₙ = ∑ᵢ₌₁ⁿ Uᵢ.

**Theorem (Irwin, 1927)**: For x ∈ [0, n], the cumulative distribution function of Tₙ is:

```
P(Tₙ ≤ x) = (1/n!) ∑ₖ₌₀^⌊x⌋ (-1)ᵏ (n choose k)(x-k)ⁿ
```

where ⌊x⌋ denotes the floor function (greatest integer ≤ x).

**Lemma**: For the special case x = 1 and n ≥ 1:

```
P(Tₙ < 1) = 1/n!
```

**Proof**: Since Tₙ has a continuous distribution (as the sum of continuous random variables):
- P(Tₙ < 1) = P(Tₙ ≤ 1) = (1/n!) ∑ₖ₌₀^⌊1⌋ (-1)ᵏ (n choose k)(1-k)ⁿ
- Since ⌊1⌋ = 1, the sum includes terms for k = 0 and k = 1
- For k = 0: (-1)⁰(n choose 0)(1-0)ⁿ = 1 · 1 · 1 = 1
- For k = 1: (-1)¹(n choose 1)(1-1)ⁿ = -1 · n · 0 = 0
- Therefore: P(Tₙ < 1) = (1/n!) · 1 = 1/n!

**Connection to our problem**: In our notation, Sₙ - 1 = Tₙ, so:
- P(τ > n) = P(Sₙ < 2) = P(Tₙ < 1) = 1/n!

**Reference**: Irwin, J.O. (1927). "On the frequency distribution of the means of samples from a population having any law of frequency with finite moments, with special reference to Pearson's Type II." *Biometrika*, 19(3/4), pp. 225-239.

For this distribution: **P(Sₙ < 1) = 1/n!**

#### Alternative Derivation via Geometric Probability

For completeness, we provide an alternative derivation using geometric probability:

**Proposition**: P(Tₙ < 1) = 1/n! where Tₙ = ∑ᵢ₌₁ⁿ Uᵢ.

**Proof**: The joint density of (U₁, ..., Uₙ) is f(u₁,...,uₙ) = 1 on [0,1)ⁿ. Thus:

```
P(Tₙ < 1) = ∫∫...∫_{u₁+...+uₙ<1, uᵢ≥0} 1 du₁...duₙ
```

This integral equals the volume of the n-dimensional simplex:
```
Δₙ = {(u₁,...,uₙ) : uᵢ ≥ 0, ∑uᵢ < 1}
```

**Theorem**: Vol(Δₙ) = 1/n!

**Proof by induction**:
- Base case (n=1): Δ₁ = {u₁ : 0 ≤ u₁ < 1}, so Vol(Δ₁) = 1 = 1/1! ✓
- Inductive step: Assume Vol(Δₙ₋₁) = 1/(n-1)!. Then:
  ```
  Vol(Δₙ) = ∫₀¹ Vol({(u₂,...,uₙ) : uᵢ ≥ 0, u₂+...+uₙ < 1-u₁}) du₁
          = ∫₀¹ (1-u₁)ⁿ⁻¹ · Vol(Δₙ₋₁) du₁
          = (1/(n-1)!) ∫₀¹ (1-u₁)ⁿ⁻¹ du₁
          = (1/(n-1)!) · [-(1-u₁)ⁿ/n]₀¹
          = (1/(n-1)!) · (1/n) = 1/n! ✓
  ```

### Step 2: Finding P(τ = n)

Using the survival function approach:
- P(τ > n) = P(Sₙ < 2) = P(Tₙ < 1) = 1/n!
- P(τ > n-1) = P(Sₙ₋₁ < 2) = P(Tₙ₋₁ < 1) = 1/(n-1)!

Therefore, for n ≥ 2:
```
P(τ = n) = P(τ > n-1) - P(τ > n)
         = 1/(n-1)! - 1/n!
         = n/(n!) - 1/n!
         = (n-1)/n!
```

**Verification**: The PMF sums to 1:
```
∑_{n=1}^∞ P(τ = n) = P(τ = 1) + ∑_{n=2}^∞ (n-1)/n!
                   = 0 + ∑_{n=2}^∞ [(1/(n-1)!) - (1/n!)]
                   = lim_{N→∞} [1/1! - 1/N!]
                   = 1 - 0 = 1 ✓
```

### Step 3: The Telescoping Series Magic

**Lemma**: E[τ] exists and is finite.

**Proof**: Since P(τ = n) = (n-1)/n! for n ≥ 2, we have:
```
E[τ] = ∑_{n=1}^∞ n · P(τ = n) = ∑_{n=2}^∞ n · (n-1)/n!
```

To verify convergence:
```
∑_{n=2}^∞ n · (n-1)/n! = ∑_{n=2}^∞ (n-1)/(n-1)! = ∑_{n=2}^∞ 1/(n-2)! = ∑_{k=0}^∞ 1/k! = e < ∞
```

Therefore E[τ] exists. Now we calculate its value:

```
E[τ] = ∑_{n=2}^∞ n · (n-1)/n!
     = ∑_{n=2}^∞ (n-1) · n!/(n! · (n-1)!)
     = ∑_{n=2}^∞ (n-1)/(n-1)!
     = ∑_{n=2}^∞ 1/(n-2)!
```

Let k = n-2:
```
E[τ] = Σ(k=0 to ∞) 1/k!
     = 1/0! + 1/1! + 1/2! + 1/3! + ...
     = e
```

### Rigorous Proof of Convergence and Equality

#### Summability of the Series

Before manipulating the series, we must establish that E[τ] = Σ n·P(τ = n) converges. 

**Theorem (Summability)**: The series Σ(n=1 to ∞) n·(n-1)/n! is absolutely convergent.

**Proof**: We show that the series can be rewritten as a shifted factorial series:
- For n < 2: n·P(τ = n) = 0
- For n ≥ 2: n·P(τ = n) = n·(n-1)/n! = 1/(n-2)!

Using the index shifting theorem for summable series:
```
Σ(n=0 to ∞) f(n) is summable ⟺ Σ(n=0 to ∞) f(n+k) is summable
```

Since Σ(n=0 to ∞) 1/n! = e converges, our series converges.

#### The Telescoping Identity

**Key Lemma**: The sum can be decomposed using index shifting.

For a summable function f : ℕ → ℝ and k ∈ ℕ:
```
∑_{n=0}^∞ f(n) = ∑_{i=0}^{k-1} f(i) + ∑_{n=0}^∞ f(n+k)
```

Applying this with f(n) = n·P(τ = n) and k = 2:
```
∑_{n=0}^∞ n·P(τ = n) = ∑_{i=0}^1 i·P(τ = i) + ∑_{n=0}^∞ (n+2)·P(τ = n+2)
                      = 0·P(τ = 0) + 1·P(τ = 1) + ∑_{n=0}^∞ (n+2)·P(τ = n+2)
                      = 0 + 0 + ∑_{n=0}^∞ 1/n!
```

The last equality uses (n+2)·P(τ = n+2) = (n+2)·(n+1)/(n+2)! = 1/n! for all n ≥ 0.

## Why e Appears

The emergence of e is not accidental. It reflects a deep connection between:

1. **Exponential growth**: e is the base of natural growth
2. **Poisson processes**: Uniform arrivals in continuous time
3. **Factorial series**: The Taylor series of e^x at x=1

The Potion Problem essentially asks: "When does a Poisson-like process first cross a threshold?" The answer connects discrete combinatorics (factorials) with continuous analysis (e).

## Visual Intuition

Imagine dropping uniform random points in [0,1):
```
Trial 1: •----•--•----| (Sum = 0.7, continue)
Trial 2: •--•----•--•-| (Sum = 1.2, stop!)
```

The probability that exactly n points sum to less than 1 is precisely 1/n!, leading us inexorably to e.

## Mathematical Beauty

This problem showcases several beautiful aspects of mathematics:

1. **Unexpected Connections**: A seemingly arbitrary threshold problem connects to the fundamental constant e
2. **Telescoping Series**: The clever cancellation that transforms a complex sum into the simple factorial series
3. **Probability meets Analysis**: Discrete probability distributions converging to a transcendental constant
4. **Universal Patterns**: The same e that appears in compound interest, population growth, and complex analysis

## The Formal Proof

The Lean 4 formalization proves this rigorously:

```lean
theorem main_theorem : expected_hitting_time = exp 1
```

The proof establishes:
1. The PMF formula: `P(τ = n) = (n-1)/n!`
2. Series convergence: `Σ n·P(τ = n)` converges
3. Telescoping identity: The sum equals `Σ 1/n! = e`

### Key Technical Insights from Formal Verification

1. **Definitional Equality**: The final step `rfl` (reflexivity) shows that after index shifting, the equality is definitional—no further computation needed.

2. **Constructive Proof**: The proof constructively shows how to transform the expectation series into the exponential series, not just that they're equal.

3. **Type-Safe Probability**: The formalization ensures all probabilities are in [0,1] and sum to 1, catching potential errors in informal proofs.

4. **Connection to mathlib**: The proof leverages:
   - `NormedSpace.exp_eq_tsum`: The analytic definition of e
   - `Summable.sum_add_tsum_nat_add`: Advanced series manipulation
   - `Real.summable_pow_div_factorial`: Convergence of exponential series

## Reflections

The Potion Problem is a perfect example of how playful problems can lead to profound mathematics. What starts as a fantasy scenario reveals fundamental truths about randomness, growth, and the nature of mathematical constants.

The fact that the expected number of doses is exactly e—not approximately e, but *exactly* e—hints at deep structures in mathematics where discrete and continuous worlds meet. It's a reminder that mathematical beauty often hides in unexpected places, waiting to be discovered through curiosity and rigorous analysis.

**Final thought**: Next time you encounter e in a formula, remember it might be counting something as whimsical as magical potions, yet as fundamental as the crossing times of random walks. That's the magic of mathematics.