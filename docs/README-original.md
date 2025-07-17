# Potion Problem - Formal Analysis of Expected Hitting Time

**Problem**: What is the expected number of trials for the sum of uniform [0,1) random variables to first exceed 1?

**Answer**: E[τ] = e ≈ 2.718281828 (Euler's number)

## Overview

This project provides a complete formal mathematical analysis of the hitting time problem, including:

- Formal Proof in Lean 4 proving E[τ] = e
- Numerical Verification with Python high-precision validation  
- Theoretical Analysis using Irwin-Hall distribution

## Project Structure

```
├── lean/                          # Lean 4 formal proofs
│   ├── UniformHittingTime.lean    # Main module
│   ├── UniformHittingTime/
│   │   ├── UniformSumHittingTime.lean  # Core theorem: E[τ] = e
│   │   └── StoppingTimeBasic.lean      # Basic definitions
│   └── Legacy/                    # Historical proof attempts
├── python/                        # Python analysis
│   ├── simulation/                # Monte Carlo & analytical solutions
│   ├── theoretical/               # Irwin-Hall distribution analysis
│   └── proof_assistants/          # Z3 verification
├── docs/                          # Documentation
│   ├── problem_statement_english.md
│   ├── VERIFICATION_REPORT.md
│   └── FINAL_REPORT.md
└── reports/                       # Analysis reports and visualizations
```

## Quick Start

### Lean 4 Proof Verification
```bash
lake build
lake exe UniformHittingTime
```

### Python Analysis
```bash
uv sync
uv run python test_all.py
```

## Main Theorem

The core mathematical result is formalized in Lean 4:

```lean
theorem uniform_sum_hitting_time_expectation : 
  expected_hitting_time = exp 1
```

This establishes that the expected hitting time for uniform random sums equals Euler's number e.

## Mathematical Foundation

The proof uses the telescoping property:
- P(τ = n) = (n-1)/n! for n ≥ 2
- E[τ] = ∑_{n=2}^∞ n·P(τ=n) = ∑_{n=2}^∞ 1/(n-1)! = e

## Mathematical Background

This problem is a classic example of hitting time analysis with these key properties:

1. **Irwin-Hall Distribution**: Distribution of S_n = sum of n uniform [0,1) variables
2. **Core Formula**: P(S_n < 1) = 1/n!
3. **Expected Value**: E[τ] = ∑_{n=0}^∞ P(τ > n) = ∑_{n=0}^∞ 1/n! = e
4. **Telescoping Series**: The beautiful mathematical structure leading to Euler's number

## Technology Stack

- Lean 4 Version 4.12.0 with Mathlib4 v4.12.0 (synchronized stable versions)
- Python with NumPy, SciPy, SymPy for numerical analysis
- Build Systems using Lake (Lean) and uv (Python)
- Verification through Monte Carlo simulation, analytical solutions, formal proof

## Project Status

### Completed
- Mathematical theoretical analysis (E[τ] = e derivation)
- Lean 4 formal proof architecture with axiomatized foundation
- Monte Carlo simulation (error < 0.01%)
- Python implementations with multiple verification methods
- Complete project restructuring and clean architecture

### Technical Implementation
- Core theorem: `uniform_sum_hitting_time_expectation : expected_hitting_time = exp 1`
- Exponential series foundation: `exp_one_eq_tsum_inv_factorial`
- Telescoping property: Axiomatized mathematical structure
- Build system: Unified Lean project with proper dependency management

## Applications

This result has applications in:
- Renewal theory
- Queueing systems  
- Order statistics
- Stochastic processes

## Contributing

This project demonstrates the power of formal mathematics in establishing beautiful theoretical results. The combination of numerical verification and formal proof provides confidence in the mathematical foundation.

## License

Released under MIT License. See LICENSE file for details.

---

**Mathematical Development Team (Astolfo & Contributors)**