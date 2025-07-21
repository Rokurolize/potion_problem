# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Aphrodisiac Problem Lean 4 Formalization Project

*Also known as the Potion Problem (媚薬問題)*

## Development Environment

### Core Tools and Commands

**Build System:**
```bash
# Primary build command
lake build

# Build with full output for debugging
lake build 2>&1 | tee build-output.log

# Clean build
lake clean && lake build
```

**Version Information:**
- Lean 4 version: v4.22.0-rc3 (migrating from v4.21.0)
- Mathlib4 version: v4.22.0-rc3
- Project name: `potion_problem`

**Testing:**
```bash
# Python verification (requires uv)
uv sync
uv run python test_all.py

# Lean 4 verification
lake build
```

## Project Architecture

### Mathematical Problem Structure

This project formalizes the proof that E[τ] = e for a hitting time problem involving uniform random variables.

**Core Mathematical Components:**
1. **Hitting Time Definition**: τ = min{n ≥ 1 : ∑_{i=1}^n U_i ≥ 1} where U_i ~ Uniform[0,1)
2. **Probability Mass Function**: P(τ = n) = (n-1)/n! for n ≥ 2
3. **Expected Value**: E[τ] = ∑_{n=2}^∞ n·P(τ=n) = e

### Module Hierarchy

**Primary Modules (UniformHittingTime/):**
- `IrwinHall.lean` - Irwin-Hall distribution theory (P(S_n < 1) = 1/n!)
- `FactorialSeries.lean` - Factorial series convergence properties
- `HittingTime.lean` - Core hitting time probability theory
- `TelescopingSeries.lean` - Telescoping series manipulation (33 warnings + 2 errors)
- `UniformSumHittingTime.lean` - Main result connecting all components

**Mathematical Dependencies:**
```
IrwinHall → HittingTime → TelescopingSeries → UniformSumHittingTime
     ↓           ↓              ↓                      ↓
FactorialSeries ────────────────────────────→ Main Result: E[τ] = e
```

### Key Implementation Patterns

**API Migration Strategy:**
- Systematic migration from v4.21.0 → v4.22.0-rc3
- `Real.exp` → `rexp` conversion completed
- `cases'` → `cases` syntax modernization
- Mathlib4 API adaptations documented in research files

**Proof Architecture:**
1. **Telescoping Property**: n × P(τ = n) = 1/(n-2)! for n ≥ 2
2. **Series Reindexing**: ∑_{n≥2} 1/(n-2)! = ∑_{k≥0} 1/k! via bijection k ↔ n-2
3. **Exponential Connection**: ∑_{k≥0} 1/k! = e from fundamental analysis

## Development Workflow

### Current Migration Status

**Build Status**: Partial success with critical issues requiring resolution
- 2 compilation errors in `TelescopingSeries.lean` (lines 136, 348)
- 33 linting warnings across multiple files
- Main mathematical structure intact

**Priority Tasks:**
1. Fix compilation errors (missing pattern variables in `cases` expressions)
2. Resolve style warnings (doc-strings, line length, unused simp arguments)
3. Complete remaining `sorry` placeholders in main proofs

### Working with Warnings

**Common Warning Types:**
- **Doc-string formatting**: Ensure `/-- Text` format (space after `--`)
- **Line length**: Break lines exceeding 100 characters
- **Unused simp arguments**: Remove unused lemmas from `simp` calls
- **Command positioning**: Fix inappropriate line breaks

**Systematic Resolution:**
```bash
# Check current status
lake build 2>&1 | tee build-output.log

# After fixes, verify progress
lake build && git commit -m "Fix warnings: [specific category]"
```

## File Organization

### Documentation Structure
- `docs/state/` - Current implementation status and session restoration
- `docs/research_prompts/` - External research requests (40+ completed)
- `docs/research_response/` - Research findings and API solutions
- `docs/api-analysis/` - Version migration analysis

### Research and Delegation System

**Internal vs External Research:**
- **Internal**: Use for file reading, editing, building, Lean 4 implementation
- **External**: Use for complex domain research, unknown error investigation, community best practices

**Research Prompt Creation:**
- Place in `docs/research_prompts/` with sequential numbering
- Include complete context (external AI cannot scan directories)
- Provide exact error messages, code snippets, environment details

### Critical Implementation Notes

**Mathematical Correctness:**
- All proofs maintain mathematical integrity during API migration
- `sorry` placeholders mark incomplete proofs, not mathematical errors
- Build success indicates structural correctness

**Version-Specific Patterns:**
- Use `rexp` instead of `Real.exp` in v4.22.0-rc3
- Pattern matching with `cases` instead of `cases'`
- Explicit pattern variables required in case expressions

**Performance Considerations:**
- Avoid `exact?` in timeout-sensitive proofs
- Use direct mathematical facts with `sorry` placeholders when needed
- Maintain systematic approach to proof completion

## Quality Assurance

**Pre-commit Checks:**
1. `lake build` succeeds without errors
2. No new warnings introduced
3. Mathematical proofs remain valid
4. Git commits have descriptive messages

**Success Criteria:**
- Zero compilation errors
- Zero linting warnings
- All `sorry` placeholders resolved
- Complete formal verification of E[τ] = e

This project represents a sophisticated intersection of probability theory, formal verification, and software engineering, requiring both mathematical precision and technical implementation skills.