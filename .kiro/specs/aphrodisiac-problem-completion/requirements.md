# Requirements Document

## Introduction

This project aims to complete the formal verification of the Aphrodisiac Problem in Lean 4, proving that E[τ] = e where τ is the expected number of doses needed for sensitivity to reach 2 (mathematically equivalent to proving the expected value of the first passage time for uniform random variables). The project is currently in an advanced state with a working build but contains 5 incomplete proofs (`sorry` statements) that need to be resolved to achieve complete formal verification.

## Requirements

### Requirement 1: Complete TelescopingSeries Module

**User Story:** As a mathematician, I want the TelescopingSeries module to be fully proven, so that the mathematical foundation for the main theorem is rigorously established.

#### Acceptance Criteria

1. WHEN the `factorial_telescoping_sum_one` theorem is invoked THEN the system SHALL provide a complete proof that ∑(n≥2) [1/(n-1)! - 1/n!] = 1
2. WHEN the `summable_factorial_diff` theorem is invoked THEN the system SHALL provide a complete proof that the factorial difference series converges
3. WHEN the TelescopingSeries module is built THEN the system SHALL compile successfully with 0 sorry statements
4. IF the telescoping series theorems are applied THEN the system SHALL maintain mathematical correctness and type safety

### Requirement 2: Complete UniformSumHittingTime Module

**User Story:** As a researcher, I want the main theorem E[τ] = e to be fully proven, so that the Aphrodisiac Problem has a complete formal verification.

#### Acceptance Criteria

1. WHEN the main theorem `uniform_sum_hitting_time_expectation` is invoked THEN the system SHALL provide a complete proof that E[τ] = e
2. WHEN supporting lemmas in UniformSumHittingTime are invoked THEN the system SHALL provide complete proofs without sorry statements
3. WHEN the module is built THEN the system SHALL compile successfully with 0 sorry statements
4. IF the main theorem is applied THEN the system SHALL correctly connect the probability mass function to the expected value calculation

### Requirement 3: Maintain Build Integrity

**User Story:** As a developer, I want all changes to maintain build success, so that the project remains in a working state throughout the completion process.

#### Acceptance Criteria

1. WHEN any code changes are made THEN the system SHALL continue to build successfully (3004/3004 modules)
2. WHEN new proofs are added THEN the system SHALL maintain compatibility with Lean 4 v4.21.0 and mathlib4 v4.21.0
3. IF build errors occur THEN the system SHALL provide clear error messages for debugging
4. WHEN the project is complete THEN the system SHALL have 0 sorry statements across all modules

### Requirement 4: Preserve Mathematical Rigor

**User Story:** As a mathematician, I want all proofs to be mathematically sound and complete, so that the formalization represents genuine mathematical achievement.

#### Acceptance Criteria

1. WHEN proofs are constructed THEN the system SHALL use only valid mathematical reasoning and established lemmas
2. WHEN connecting different mathematical concepts THEN the system SHALL maintain logical consistency
3. IF edge cases exist in the mathematical arguments THEN the system SHALL handle them explicitly
4. WHEN the final proof is complete THEN the system SHALL demonstrate the connection between uniform random variables and Euler's number e

### Requirement 5: Document Progress and Insights

**User Story:** As a future maintainer, I want clear documentation of the completion process, so that the mathematical insights and implementation decisions are preserved.

#### Acceptance Criteria

1. WHEN significant progress is made THEN the system SHALL update the iteration history with specific achievements
2. WHEN mathematical insights are discovered THEN the system SHALL document them for future reference
3. IF implementation strategies succeed or fail THEN the system SHALL record the outcomes and reasoning
4. WHEN the project is complete THEN the system SHALL provide a comprehensive summary of the mathematical formalization