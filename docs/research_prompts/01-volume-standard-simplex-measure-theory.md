# Research Prompt: Volume of Standard Simplex via Measure Theory in Lean 4

## Objective
Provide a complete formal proof in Lean 4 that the volume of the n-dimensional standard simplex equals 1/n!, using measure theory constructs available in Mathlib4.

## Mathematical Context
The standard n-simplex is defined as:
```
Δⁿ = {(x₁, ..., xₙ) ∈ ℝⁿ : xᵢ ≥ 0, ∑xᵢ ≤ 1}
```

## Required Deliverables

### 1. Measure-Theoretic Foundation
- Identify the correct measure space structure in Mathlib4 for Lebesgue measure on ℝⁿ
- Show how to construct the simplex as a measurable set
- Reference specific Mathlib4 modules: `MeasureTheory.Measure.Lebesgue`, `MeasureTheory.Constructions.Prod`

### 2. Volume Calculation Methods
Provide at least TWO different approaches:

**Method A: Direct Integration**
- Set up the iterated integral ∫₀¹ ∫₀^(1-x₁) ... ∫₀^(1-x₁-...-xₙ₋₁) dx_n ... dx₁
- Show step-by-step evaluation leading to 1/n!
- Include Lean 4 code using `MeasureTheory.integral_prod` or similar

**Method B: Linear Transformation**
- Express the simplex as the image of the unit cube under a linear transformation
- Use the Jacobian determinant formula: |det(A)| = 1/n!
- Reference `MeasureTheory.Measure.AddHaar` for transformation properties

### 3. Lean 4 Implementation
```lean
import MeasureTheory.Measure.Lebesgue
import MeasureTheory.Integral.IntervalIntegral

theorem volume_standard_simplex (n : ℕ) :
  volume {x : Fin n → ℝ | (∀ i, 0 ≤ x i) ∧ (∑ i, x i) ≤ 1} = 1 / n.factorial := by
  -- Your proof here
```

### 4. Connection to Probability
- Explain why this equals P(S_n ≤ 1) for sum of uniform random variables
- Reference the connection to order statistics

### 5. Alternative Characterizations
- Beta function representation: B(1, n) = 1/n!
- Gamma function formulation: Γ(1)ⁿ/Γ(n+1)
- Dirichlet distribution normalization constant

## Technical Requirements
- All measure theory notation must match Mathlib4 conventions
- Provide explicit imports needed
- Handle edge cases (n = 0, n = 1)
- Include references to authoritative sources (Folland, Rudin, etc.)

## Expected Output Format
1. Mathematical proof outline (500-1000 words)
2. Complete Lean 4 implementation
3. List of all required imports
4. Bibliography with page numbers

Note: This is for the IrwinHall.lean module, specifically replacing the `sorry` at line 64.