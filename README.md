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

**This project uses formal verification in Lean 4.** The automated system continuously tracks proof obligations and guides systematic completion of the mathematical formalization.

## Proof Architecture

**Mathematical Structure**: The proof follows a telescoping series decomposition approach, breaking down E[τ] = e into foundational lemmas about factorial convergence and probability mass function relationships.

**Automated Tracking**: The system monitors remaining proof obligations and provides strategic guidance for systematic completion. Progress is measured through concrete mathematical milestones rather than arbitrary metrics.

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

- **Lean 4 Formal Proof** - Systematic verification with automated proof obligation tracking
- **Python Numerical Verification** - High-precision validation supporting formal results
- **Theoretical Analysis** - Complete mathematical derivation with telescoping series foundation

## 🤖 Automated Continuation System

This project includes an intelligent automation system (`.claude/hooks/auto_iteration_continuation.py`) that ensures systematic progress toward formal verification completion.

### Key Features

**Mathematical Priority**: 
- Continues work automatically while proof obligations remain unresolved
- Prioritizes mathematical completeness over arbitrary session boundaries
- Applies resource limits only after formal verification is achieved

**Evidence-Based Assessment**:
- **Git Analysis**: Inspects actual commits and file changes to verify progress
- **Build Verification**: Executes compilation directly to confirm code validity
- **File Monitoring**: Checks modification timestamps to detect substantive work
- **Proof Obligation Tracking**: Monitors and locates unresolved formal requirements

**Strategic Guidance**:
- **Difficulty Analysis**: Evaluates proof complexity based on mathematical context and required tactics
- **Infinite Loop Prevention**: Detects repeated unsuccessful approaches and suggests alternatives
- **Targeted Recommendations**: Provides specific, actionable guidance based on proof structure analysis

### How It Works

The system operates during Claude Code's `Stop` events:

1. **Evidence Collection**: Analyzes git history, file timestamps, and build results
2. **Progress Assessment**: Determines if meaningful mathematical progress was made  
3. **Decision Making**: Blocks stopping if sorries remain and progress is possible
4. **Feedback Generation**: Provides specific, actionable guidance for next steps

### User Control

To temporarily disable the automation system:
```python
# Edit .claude/hooks/auto_iteration_continuation.py
HOOK_ENABLED = False  # Set to True to re-enable
```

**When to disable**: 
- Need to make non-mathematical changes (documentation, refactoring)
- Want to pause work temporarily
- Debugging other project components

The system ensures efficient, focused mathematical work while preventing both premature stopping and infinite loops.

## Build and Test

### Lean 4 (v4.21.0)
```bash
lake build
```
**Status**: ✅ Build succeeds with complete formal verification - 0 sorries remaining.
**Achievement**: Full mathematical proof that E[τ] = e has been formally verified in Lean 4.

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

### Mathematical Components
The proof architecture follows a telescoping series decomposition with three foundational components:
1. **Telescoping Series Foundation** - Core series manipulation framework
2. **Factorial Convergence Analysis** - Convergence properties of factorial-based series  
3. **Probability Mass Function Connection** - Bridge between combinatorial and probabilistic perspectives

**Automated Progress Tracking**: The system monitors completion status and provides guidance for remaining work.

### Development Methodology
- **Systematic Approach**: Telescoping series decomposition with rigorous dependency management
- **Evidence-Based Development**: Git analysis, build verification, and automated proof obligation tracking
- **Mathematical Automation**: Intelligent continuation system ensuring focused progress toward completion
- **Helper Lemma Strategy**: Connecting mathematical structures through bridging theorems
- **Quality Assurance**: Continuous compilation verification and formal proof validation

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
**Project Status**: ✅ Formal proof complete (July 2025)