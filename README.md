# Potion Problem: E[τ] = e

A complete formal verification in Lean 4 proving that the expected hitting time equals Euler's number.

## 🎯 Main Result

**Theorem**: For the "Potion Problem" (media-yaku mondai, 媚薬問題), the expected hitting time E[τ] equals e.

```lean
theorem main_theorem : expected_hitting_time = exp 1
```

**Status**: ✅ **PROVEN** with all Lean modules fully verified.

## 📚 Mathematical Background

### Original Problem Statement (媚薬問題)

> **女騎士**「私に何を飲ませた！」  
> **オーク**「飲む前の感度を n 倍とした時に、感度を n+m 倍まで引き上げる薬だ。ここで m ∈ [0,1) は毎回の摂取ごとに独立に判定される。一方、通常時の感度を 1 倍として、お前の感度が 2 倍になるまでこれを飲ませる」  
> **女騎士**「私が媚薬を飲む回数の期待値はどれくらいになるんだ……？」

Behind this colorful fantasy narrative lies a profound mathematical problem connecting randomness with one of mathematics' most fundamental constants.

### Mathematical Formulation

The Potion Problem asks: Given a sequence of independent uniform [0,1) random variables X₁, X₂, ..., what is the expected value of the stopping time τ = min{n : X₁ + X₂ + ... + Xₙ > 1}?

The elegant answer is **e ≈ 2.718**, proven through:
1. Establishing the PMF: P(τ = n) = (n-1)/n! for n ≥ 2
2. Computing expectation: E[τ] = ∑_{n=1}^∞ n · P(τ = n) 
3. Series manipulation showing this equals ∑_{n=0}^∞ 1/n! = e

## 🏗️ Project Structure

```
PotionProblem.lean              # Library entry point
PotionProblem/
├── Basic.lean                  # Core definitions and PMF
├── FactorialSeries.lean        # Summability of 1/n!
├── ProbabilityFoundations.lean # PMF properties  
├── SeriesAnalysis.lean         # Telescoping series proofs
├── IrwinHallTheory.lean        # Geometric insights
├── KilledPotential.lean        # Killed Poisson-equation certificate
├── JanossyConfiguration.lean   # Poisson configuration normalization
├── SolutionZoo.lean            # Six deliberately extreme proof presentations
├── AudienceLadder.lean         # Sixteen audience-targeted proof presentations
├── Main.lean                   # Main theorem
└── MainWithGeometry.lean       # Extended version with geometry
```

## 🚀 Quick Start

### Prerequisites
- [Lean 4](https://leanprover.github.io/lean4/doc/quickstart.html) v4.30.0-rc2
- [Lake](https://github.com/leanprover/lake) (Lean's build tool)

### Build Instructions

```bash
# Clone the repository
git clone https://github.com/Rokurolize/potion_problem.git
cd potion_problem

# Build the project
lake build

# Expected output:
# Build completed successfully.
```

### Verify Main Theorem

```bash
# Build only the main theorem module
lake build PotionProblem.Main

# Check the main theorem
echo "import PotionProblem.Main
#check main_theorem" | lake env lean --stdin
```

## 📋 Module Dependencies

The proof is structured with clear dependencies:

```
Basic.lean
├── FactorialSeries.lean
├── ProbabilityFoundations.lean
    └── SeriesAnalysis.lean
        └── Main.lean ← **MAIN THEOREM**

Optional:
IrwinHallTheory.lean → MainWithGeometry.lean
```

**Key Property**: Main theorem is available through the core module chain, with
the geometric module provided as an optional extension.

## 🔍 Proof Strategy

### Core Mathematical Approach
1. **PMF Establishment**: Define hitting_time_pmf and prove it satisfies probability mass function axioms
2. **Summability**: Prove ∑ 1/n! converges using exponential series theory  
3. **Telescoping Identity**: Show ∑_{k=0}^{n-1} (1/(k+1)! - 1/(k+2)!) = 1 - 1/(n+1)!
4. **Expectation Calculation**: E[τ] = ∑_{n=2}^∞ n · (n-1)/n! = ∑_{n=0}^∞ 1/n! = e

### Alternative Surprise Proof

See [DeepSolutionSurvey.md](DeepSolutionSurvey.md) for the broad-search verdict and
[KilledExponentialSolution.md](KilledExponentialSolution.md) for the compact proof.
See [JanossySolution.md](JanossySolution.md) for the Poisson configuration-space
normalization proof implemented in
[PotionProblem/JanossyConfiguration.lean](PotionProblem/JanossyConfiguration.lean).
See [SolutionZoo.md](SolutionZoo.md) for six deliberately extreme presentations:
interesting, boring, elegant, short, confusing, and brute-force.
See [AudienceLadder.md](AudienceLadder.md) for sixteen audience-targeted
presentations from first intuition through executive metrics.
See [FourOperationsPotionStory.md](FourOperationsPotionStory.md) for a
dialogue-driven story solution that keeps the computation to the four
arithmetic operations.
Open [visualization.html](visualization.html) for the standalone interactive
certificate visualization.
The strongest version is a killed Markov-chain Poisson-equation certificate:
find `h` with `(I - K) h = 1`; here `h(r) = exp(r)`, so the expected lifetime
from remaining distance `1` is `e`.

### Technical Implementation
- **API Verification**: All mathlib4 APIs verified before use
- **Build-Driven Development**: Compilation success after every change
- **Proof Gap Removal**: All Lean proof placeholders have been eliminated

## 🏆 Achievement

- **Main Theorem**: Proven with all dependencies verified
- **Complete Build**: All modules compile successfully
- **Clean Architecture**: 6 focused modules with clear separation
- **Mathematical Rigor**: Full formal verification in Lean 4

## 📖 Related Work

This formalization connects to several areas of mathematics:
- **Probability Theory**: Expected values and infinite series convergence
- **Real Analysis**: Exponential function and factorial series  
- **Combinatorics**: Stirling numbers and inclusion-exclusion (optional module)

## 🤝 Contributing

This is primarily a research/educational project demonstrating formal verification techniques. The Lean development currently builds with all modules verified.

## 📄 License

[MIT License](LICENSE)

## 🙏 Acknowledgments

- [Lean 4](https://lean-lang.org/) and [mathlib4](https://github.com/leanprover-community/mathlib4) communities
- Inspired by the elegant mathematical problem known as the "Potion Problem"
