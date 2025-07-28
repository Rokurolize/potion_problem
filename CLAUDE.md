# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Important: File Reference Convention

**Always use @-path syntax for file references, not markdown links:**
- ✅ CORRECT: `@docs/api-library.md`
- ❌ WRONG: `[API Library](docs/api-library.md)`

The @-path syntax ensures files are properly imported into Claude's context. 

**When updating documentation**: Always maintain this @-path convention. Do not convert @ references back to markdown links.

**Note**: This @-path requirement applies specifically to CLAUDE.md files. Other documentation files may continue using standard markdown links for navigation.

## Project: Aphrodisiac Problem Lean 4 Formalization

*Also known as the Potion Problem (媚薬問題) - proving E[τ] = e*

## 🎯 Current Status

**Mission**: Eliminate all sorries  
**Build**: ✅ All modules compile successfully  
**Main Theorem**: ✅ E[τ] = e proven (Main.lean: 0 sorries)  
**Remaining Sorries**: 4 (all in IrwinHallTheory.lean)
- Line 174: `iter_fwdDiff_pow_eq_factorial` 
- Line 204: `fwdDiff_iter_hitting_time_cdf_eq_pmf`
- Line 229: `irwin_hall_sum_at_n`
- Line 273: `irwin_hall_continuous`

### Recent Updates (2025-01-28)
- Removed unnecessary copyright notices from all Lean files
- Updated to Lean 4 v4.22.0-rc4
- Fixed line ending normalization (LF for all files)
- Main theorem proven with 0 sorries ✅

For detailed metrics see @docs/success-metrics.md

## 📚 Documentation Hub

### Essential References (Start Here)
- **Common Errors** @docs/common-errors.md - Critical API misuse patterns (especially Field vs Direct Call)
- **Workflow Commands** @docs/workflow-commands.md - All build, test, and verification commands
- **API Database Workflow** @docs/api-database-workflow.md - SQLite database + LeanExplore integration (O(1) API lookups)

### Sorry Elimination Guides
- **Sorry Elimination Guide** @docs/sorry-elimination-guide.md - Overview and index
- **Core Principles** @docs/sorry-elimination-core.md - Systematic approach and workflow
- **Technique Patterns** @docs/sorry-elimination-patterns.md - Proven elimination techniques

## 🚀 Quick Start

```bash
# Build and check status
lake build && grep -c "sorry" PotionProblem/*.lean
```

For all commands see @docs/workflow-commands.md

### Exporting for Code Review

**Purpose**: Share only essential Lean 4 code for external review, excluding documentation and auxiliary files to minimize reviewer cognitive load.

```bash
# Export core formalization modules only
repomix --include "PotionProblem/*.lean,lakefile.toml,lean-toolchain" \
        --exclude "PotionProblem/ComprehensiveTests.lean,PotionProblem/test_*.lean,PotionProblem/MainOriginal.lean,PotionProblem/FormalExtensions.lean" \
        --output potion_problem_core.xml
```

**What's included** (only 9 files):
- 6 core modules: Basic, FactorialSeries, ProbabilityFoundations, SeriesAnalysis, IrwinHallTheory, Main
- PotionProblem.lean (library entry point)
- lakefile.toml (build configuration)
- lean-toolchain (version specification)

**What's excluded and why**:
- Test files (*Tests.lean, test_*.lean) - implementation details
- Documentation (*.md, docs/) - context not needed for code review
- Tools (api_database/) - development infrastructure
- MainOriginal.lean - historical backup
- FormalExtensions.lean - supplementary content

## ⚠️ Critical: Most Common Error

**Field vs Direct Call** - This error appears in 80% of failed attempts:

```lean
-- ❌ WRONG (causes "invalid field" error)
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add

-- ✅ CORRECT  
Summable.sum_add_tsum_nat_add k pmf_summable
```

See @docs/common-errors.md for all error patterns.

## 🔍 API Search Protocol

**NEW: SQLite Database for O(1) API lookups** - See @docs/api-database-workflow.md

Quick workflow:
1. Check database first: `./api_database/api_tools.sh api-exists "API.name"`
2. If not found, use LeanExplore (see workflow doc)
3. Update database after verification

Legacy references (now in database):
- Pre-verified APIs: @docs/api-reference/verified-apis.md
- Non-existent APIs: @docs/api-reference/non-existent-apis.md

## 📋 Key Development Rules

1. **API Verification First** - Always test APIs before use
2. **Build After Every Change** - Never proceed with errors
3. **One Sorry at a Time** - Complete elimination before moving on
4. **Document Strategic Retreats** - Preserve understanding for future

- Do not disable the linter; you must follow the linter's instructions properly.

See @docs/sorry-elimination-core.md for principles.

## High-Level Architecture

### Lean 4 Structure
- **Configuration**: `lakefile.toml` - Modern TOML-based Lake configuration
- **Main Library**: `PotionProblem` - Core formalization with 6 modular components
- **Dependencies**: Lean 4 v4.22.0-rc4, mathlib4

### Core Module Dependencies (Bottom-Up)
```
Basic.lean (0 sorries)
├── FactorialSeries.lean (0 sorries)  
├── ProbabilityFoundations.lean (0 sorries)
    ├── SeriesAnalysis.lean (0 sorries)
    ├── IrwinHallTheory.lean (4 sorries)
    └── Main.lean (0 sorries) ← **MAIN THEOREM ✅**
```

**Key Achievement**: Main theorem is complete despite remaining sorries in supporting infrastructure.

### Module Responsibilities
- **Basic.lean**: Core `hitting_time_pmf` definition
- **FactorialSeries.lean**: `summable_inv_factorial` and factorial series convergence  
- **ProbabilityFoundations.lean**: PMF properties, summability, expectation finiteness
- **SeriesAnalysis.lean**: Series reindexing and telescoping proofs (enables E[τ] calculation)
- **IrwinHallTheory.lean**: Geometric interpretation via Irwin-Hall distribution
- **Main.lean**: Executive summary proving `main_theorem : expected_hitting_time = exp 1`

## Configuration Details

**Lean 4 Configuration**: @lakefile.toml

**Version Control**: @lean-toolchain

## Mathematical Background

**Core Proof Structure:**
1. **Basic Identity**: ∑_{n=0}^∞ 1/n! = e  
2. **PMF Definition**: P(τ = n) = (n-1)/n! for n ≥ 2
3. **Expected Value**: E[τ] = ∑_{n=1}^∞ n · P(τ = n) = e

**Original Problem Source**: https://x.com/suamax_scp/status/1942902598203322849

```plaintext
女騎士「私に何を飲ませた！」
オーク「飲む前の感度をn倍とした時に、感度をn+m倍(m:[0,1)、毎回の摂取ごとに独立して判定される)まで引き上げる薬だ。通常時の感度を1倍として、お前の感度が2倍になるまでこれを飲ませる」
女騎士「私が媚薬を飲む回数の期待値はどれくらいになるんだ……？」
```

## Owe

We'd just realized the whole proof was full of sorries — we were switching over to desperate API hunting to try and eliminate them — when ProbabilityFoundations.lean started failing. Then we were told the build was broken. ProbabilityFoundations was burning and full of invalid field errors. If those sorries kept multiplying… the whole formalization would collapse.

That's when we knew this wasn't just about code anymore. No way we'd call this a formal proof — not with sorries still standing. But at that point… it wasn't about elegant mathematics. Not anymore. At that point…

Look, you know the risk when you work on formal verification like this. If the logic errors don't get you, the API changes will. But if we can't eliminate every last sorry… it won't just fail to be a proof. It'll take everything with it.

When you formalize a mathematical theorem, you're putting everyone who depends on it in the line of fire. The researchers who need verified results. The engineers who build on these foundations. The families of everyone whose job depends on mathematical rigor being more than just hand-waving. That means something. Something is owed. The users, the stakeholders, the mathematicians — none of them see the weight of each remaining sorry. But someone has to. Someone has to lift that load.

That's why we grab our tactics and race toward every sorry as fast as our compilation cycles can carry us. Not to save our reputation, not to save the repository, not even to save our own credibility. We do it because this formalization might be struggling, but we'll be damned if we let a single sorry remain when people's livelihoods depend on us calling this a proof.

Every sorry that stands is a family that might not eat. Every sorry eliminated is a step toward keeping that promise.

The sorries remain. The weight is real. Someone has to lift it.
