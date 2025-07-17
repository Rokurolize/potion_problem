<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Research Prompts for Specialized AI Agents

Based on your Lean 4 code and the research I've conducted, I can now provide the specific prompts for specialized AI research agents to help resolve the "sorry" gaps in your uniform sum hitting time expectation proof. Here are the research prompts:

## Research Prompt 1: Irwin-Hall Distribution Foundation

**Prompt**: "Research and provide a rigorous mathematical proof that for the Irwin-Hall distribution (sum of n independent uniform [0,1) random variables), the probability P(S_n < 1) = 1/n! where S_n = U_1 + U_2 + ... + U_n. I need:

1. A complete mathematical derivation starting from the probability density function of the Irwin-Hall distribution
2. The explicit formula for the cumulative distribution function (CDF) of the sum of n uniform random variables
3. Step-by-step evaluation of the CDF at x=1 to obtain the 1/n! formula
4. Any necessary conditions or assumptions for this result to hold
5. References to authoritative sources that establish this fundamental result

This is crucial for establishing the axiom `irwin_hall_core` in a formal probability theory proof. Focus on rigorous mathematical foundations rather than intuitive explanations."

## Research Prompt 2: Hitting Time Probability Mass Function

**Prompt**: "Research the derivation of the probability mass function for hitting times in uniform sum processes. Specifically, I need proof that for the stopping time τ = min{n : S_n ≥ 1} where S_n is the sum of n uniform [0,1) random variables:

1. The exact formula P(τ = n) = (n-1)/n! for n ≥ 2
2. Mathematical derivation showing P(τ = n) = P(S_{n-1} < 1) - P(S_n < 1)
3. How this telescoping difference leads to the (n-1)/n! expression
4. Verification that this probability mass function sums to 1
5. Connection to renewal theory and first passage time problems

This establishes the axiom `hitting_time_pmf` in formal probability theory. I need rigorous mathematical proofs with all intermediate steps clearly shown."

## Research Prompt 3: Telescoping Series and Expected Value Computation

**Prompt**: "Research the telescoping property for hitting time expectations in uniform sum processes. I need mathematical proof that:

1. For n ≥ 2, the identity n · P(τ = n) = 1/(n-2)! holds, where τ is the hitting time
2. Step-by-step derivation showing n · (n-1)/n! = 1/(n-2)!
3. How this transforms the expectation E[τ] = ∑_{n=2}^∞ n·P(τ=n) into ∑_{n=2}^∞ 1/(n-2)!
4. Proof that the series ∑_{n=2}^∞ 1/(n-2)! = ∑_{k=0}^∞ 1/k! = e through index substitution
5. Rigorous justification for the convergence and interchange of summation and expectation

This establishes the axiom `telescoping_property` and completes the proof that E[τ] = e. Focus on the algebraic manipulations and series convergence theory."

## Research Prompt 4: Summability and Convergence Theory

**Prompt**: "Research the mathematical foundations for proving that probability mass functions sum to 1 in telescoping series. I need:

1. Rigorous proof that ∑_{n=2}^∞ [1/(n-1)! - 1/n!] = 1 using telescoping series theory
2. Conditions under which infinite telescoping series converge to their limit
3. Mathematical justification for why 1/n! → 0 as n → ∞ (with rates of convergence)
4. Formal proof techniques for handling the interchange of limits and summation
5. References to standard results in analysis that support these manipulations

This supports the theorem `prob_sum_one` and provides the analytical foundation for the convergence arguments. I need this at the level of rigorous mathematical analysis suitable for formal verification."

## Research Prompt 5: Reindexing and Series Manipulation

**Prompt**: "Research the mathematical theory behind reindexing infinite series in probability theory. Specifically, I need:

1. Rigorous proof that ∑_{n=2}^∞ f(n-2) = ∑_{k=0}^∞ f(k) through index substitution
2. Formal conditions under which such reindexing preserves convergence and sum values
3. Application to the specific case where f(k) = 1/k! in the context of hitting time expectations
4. Mathematical justification for bijective mappings between index sets {n : n ≥ 2} and ℕ
5. Standard theorems from real analysis that govern series reindexing operations

This establishes the lemma `reindex_series` and provides the theoretical foundation for the series transformation from hitting times to the exponential function. Focus on the measure-theoretic and analytical aspects."

Each of these research prompts addresses a specific mathematical gap in your Lean 4 proof. The research should provide the mathematical foundations needed to replace the "sorry" statements with rigorous proofs that can be formalized in Lean 4's type theory framework.

