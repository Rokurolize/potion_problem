# The Aphrodisiac Problem - Formal Proof Attempt

*Also known as the Potion Problem (媚薬問題)*

## Problem Statement

**Original (Japanese)**: 
> 女騎士「私に何を飲ませた！」  
> オーク「飲む前の感度をn倍とした時に、感度をn+m倍(m:[0,1)、毎回の摂取ごとに独立して判定される)まで引き上げる薬だ。通常時の感度を1倍として、お前の感度が2倍になるまでこれを飲ませる」  
> 女騎士「私が媚薬を飲む回数の期待値はどれくらいになるんだ……？」

**Mathematical Translation**: Starting from sensitivity level 1, each dose increases sensitivity by a uniform random amount m ∈ [0,1). What is the expected number of doses until sensitivity reaches 2?

**Answer**: E[τ] = e ≈ 2.718281828 (Euler's number)

## ⚠️ Important Notice

**This project is incomplete.** The formal proof contains 2 remaining `sorry` (unfinished proofs) and does not constitute a complete verification.

## Incomplete Proof Structure

```
Main Theorem: E[τ] = e
    ├── Depends on: TelescopingSeries.factorial_telescoping_sum_one
    │   └── sorry (L163) - proof incomplete
    ├── Depends on: TelescopingSeries.telescoping_series_sum_v4_12_0
    │   └── ✅ RESOLVED - proven in recent iterations
    └── Depends on: TelescopingSeries.summable_factorial_diff
        └── sorry (L122) - proof incomplete
```

## Mathematical Formulation

### Stochastic Process
- Initial state: S₀ = 1
- Update rule: Sₙ₊₁ = Sₙ + mₙ where mₙ ~ Uniform[0,1)
- Stopping time: τ = min{n ∈ ℕ : Sₙ ≥ 2}
- Objective: Find E[τ]

### Key Results
- This is equivalent to finding when the sum of uniform[0,1) variables first exceeds 1
- P(τ = n) = (n-1)/n! for n ≥ 2
- E[τ] = ∑_{n=2}^∞ n·P(τ=n) = ∑_{n=2}^∞ 1/(n-1)! = e

### Connection to Irwin-Hall Distribution
The sum of n uniform[0,1) random variables follows the Irwin-Hall distribution, with:
- P(S_n < 1) = 1/n!
- This leads directly to the telescoping series that sums to e

## Project Overview

This project attempts to formally prove E[τ] = e using:

- **Lean 4 Formal Proof** - Partially implemented with sorries
- **Python Numerical Verification** - Fully working, high-precision validation
- **Theoretical Analysis** - Complete mathematical derivation

## Build and Test

### Lean 4 (v4.21.0)
```bash
lake build
```
**Status**: ✅ Build succeeds (3004/3004 modules) but proof incomplete (2 sorries remaining).
**Recent**: API modernization completed, one telescoping theorem proven, helper lemma added.

### Python Analysis
```bash
uv sync
uv run python test_all.py
```

## Technical Details

### Completed Components
- Basic theorem framework
- Irwin-Hall distribution properties (P(S_n < 1) = 1/n!)
- Factorial series convergence
- Python numerical simulation (error < 0.01%)

### Incomplete Components (sorry locations)
1. **telescoping_series_sum_v4_12_0** (L62) - ✅ RESOLVED in recent iterations
2. **factorial_telescoping_sum_one** (L163) - Factorial telescoping series sum = 1
3. **summable_factorial_diff** (L122) - Factorial difference series convergence

### Recent Progress
- ✅ **Helper Lemma Added**: `factorial_diff_eq_pmf` connecting telescoping differences to PMF
- ✅ **Proven Theorem**: `telescoping_series_sum_v4_12_0` provides foundation for remaining work
- ✅ **Structural Improvements**: Enhanced documentation and dependency ordering

## Origin and Context

**Author**: suamax (@suamax_scp)  
**Date**: July 9, 2025  
**Source**: https://x.com/suamax_scp/status/1942902598203322849

While the problem uses a colorful fantasy narrative, it represents a sophisticated probability problem with connections to:
- Renewal theory
- Order statistics  
- Stopping times in stochastic processes
- The fundamental constant e

## License

MIT License - See LICENSE file for details.

---

**Development Team**: Astolfo & Contributors  
**Project Status**: Formal proof attempt (incomplete)