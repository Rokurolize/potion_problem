# Research Prompt: Stirling's Approximation and Factorial Lower Bounds in Lean 4

## Objective
Prove that n! ≥ (n/e)^n for all n ≥ 1 using Stirling's approximation or related techniques, with a complete Lean 4 formalization.

## Mathematical Background
Stirling's approximation states:
```
n! ~ √(2πn) * (n/e)^n
```
More precisely: lim_{n→∞} n! / (√(2πn) * (n/e)^n) = 1

## Required Deliverables

### 1. Proof Strategies
Provide THREE different approaches:

**Method A: Elementary Proof via Induction**
- Base case: 1! = 1 ≥ (1/e)¹ ≈ 0.368
- Inductive step using the inequality (1 + 1/n)^n < e
- Show how to formalize in Lean using `Nat.rec_on`

**Method B: Integral Representation**
- Use log-convexity: log(n!) = ∑_{k=1}^n log(k)
- Compare with integral: ∫₁ⁿ log(x) dx = n log(n) - n + 1
- Apply Jensen's inequality or direct comparison

**Method C: Probabilistic Proof**
- Use the fact that n! = n^n * P(all elements distinct in uniform sampling)
- Show P(all distinct) ≥ e^(-n)
- Connect to birthday paradox analysis

### 2. Lean 4 Implementation Requirements
```lean
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Data.Nat.Factorial.Basic

lemma factorial_ge_n_div_e_pow_n {n : ℕ} (hn : n ≥ 1) : 
  (n.factorial : ℝ) ≥ (n / Real.exp 1) ^ n := by
  -- Implementation here
```

### 3. Supporting Lemmas Needed
- `exp_sum_div_pow_le_exp_one`: ∑_{k=0}^n 1/k! ≤ e
- `log_factorial_bounds`: Bounds on log(n!)
- `exp_one_gt_sum_inv`: e > ∑_{k=0}^n 1/k! for finite n

### 4. Asymptotic Analysis
- Show the constant factor: n! / (n/e)^n ~ √(2πn)
- Explain why the weaker bound suffices for our application
- Reference Mathlib's `Asymptotics` library usage

### 5. Computational Verification
```lean
#eval (List.range 10).map (fun n => 
  let n' := n + 1
  (n'.factorial : Float) / ((n' : Float) / Float.exp 1) ^ n')
-- Should show all values ≥ 1
```

## Technical Specifications
- Must work with Mathlib4's current API (as of 2024)
- Handle the n = 0 edge case appropriately
- Provide both `ℕ` and `ℝ` versions if needed
- Include rate of growth analysis

## Connection to Main Theorem
Explain how this bound is used to prove:
- Factorial dominates exponential growth
- Series ∑ 1/n! converges
- 1/n! → 0 super-exponentially

## Expected Output Format
1. Complete mathematical proof (800-1200 words)
2. Working Lean 4 code with all imports
3. Numerical examples for n = 1 to 20
4. References to:
   - Concrete Mathematics (Knuth et al.)
   - Feller's probability theory
   - Modern analysis texts with Stirling's formula