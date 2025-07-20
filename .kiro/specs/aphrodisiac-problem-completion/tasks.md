# Implementation Plan

- [ ] 1. Set up development environment and verify current state
  - Verify current build status with `lake build`
  - Identify exact locations of remaining sorry statements
  - Confirm mathematical foundation is intact
  - _Requirements: 3.1, 3.2_

- [ ] 2. Complete TelescopingSeries.summable_factorial_diff proof
  - [ ] 2.1 Implement comparison test approach for factorial difference series
    - Write proof using comparison with exponential series ∑ 1/n!
    - Apply existing `factorial_diff_abs_bound` lemma for boundedness
    - Use mathlib4's `Summable.of_norm_bounded_eventually` theorem
    - _Requirements: 1.1, 4.1_

  - [ ] 2.2 Connect to existing summability infrastructure
    - Leverage `FactorialSeries.summable_inv_factorial` for comparison series
    - Handle index shifting from n-1 to n factorial terms
    - Ensure proper handling of n ≥ 2 condition in series definition
    - _Requirements: 1.1, 4.2_

- [ ] 3. Complete TelescopingSeries.factorial_telescoping_sum_one proof
  - [ ] 3.1 Establish finite partial sum formula
    - Prove telescoping property for finite sums: ∑(k=2 to N) [1/(k-1)! - 1/k!] = 1 - 1/(N-1)!
    - Use existing `telescoping_series_partial_sum` as foundation
    - Handle index boundaries and edge cases properly
    - _Requirements: 1.1, 4.1_

  - [ ] 3.2 Prove limit convergence to 1
    - Show that 1/(N-1)! → 0 as N → ∞ using `FactorialSeries.inv_factorial_tendsto_zero`
    - Connect finite partial sums to infinite sum via limit theory
    - Apply `HasSum` construction from convergent limits
    - _Requirements: 1.1, 4.2_

  - [ ] 3.3 Integrate with existing telescoping framework
    - Use proven `telescoping_series_sum_v4_12_0` theorem as foundation
    - Handle index set transformation from general telescoping to factorial-specific case
    - Ensure compatibility with existing `pmf_partial_sums_tend_to_one` result
    - _Requirements: 1.1, 4.3_

- [ ] 4. Resolve UniformSumHittingTime series reindexing
  - [ ] 4.1 Establish formal bijection between index sets
    - Create explicit bijection function between {n // n ≥ 2} and ℕ via k = n-2
    - Prove bijection properties (injective, surjective) using mathlib4 equivalence theory
    - Handle type system requirements for subtype reindexing
    - _Requirements: 2.1, 4.1_

  - [ ] 4.2 Prove summability inheritance via reindexing
    - Show that ∑_{n≥2} 1/(n-2)! inherits summability from ∑_{k≥0} 1/k!
    - Use established bijection to transfer summability properties
    - Apply mathlib4's equivalence-based summability theorems
    - _Requirements: 2.1, 4.2_

  - [ ] 4.3 Connect mathematical equivalence to formal proof
    - Bridge the gap between mathematical reasoning and Lean 4 API requirements
    - Use `telescoping_property` lemma to establish term-by-term equivalence
    - Ensure proper handling of indicator functions and conditional sums
    - _Requirements: 2.1, 4.3_

- [ ] 5. Complete main theorem assembly in UniformSumHittingTime
  - [ ] 5.1 Resolve summable_hitting_time lemma
    - Use completed reindexing results from task 4
    - Apply summability inheritance from factorial series
    - Ensure proper integration with existing `telescoping_property` result
    - _Requirements: 2.1, 2.2_

  - [ ] 5.2 Complete main_result theorem proof
    - Combine all resolved components from tasks 2-4
    - Establish complete proof chain: E[τ] = ∑ n·P(τ=n) = ∑_{n≥2} 1/(n-2)! = ∑_{k≥0} 1/k! = e
    - Use existing `hitting_time_expectation` and `exp_one_eq_tsum_inv_factorial` results
    - _Requirements: 2.1, 2.2, 4.4_

  - [ ] 5.3 Verify complete mathematical proof chain
    - Ensure all dependencies are resolved and properly connected
    - Test that main theorem compiles and type-checks correctly
    - Validate that proof maintains mathematical rigor throughout
    - _Requirements: 2.2, 4.4_

- [ ] 6. Final verification and cleanup
  - [ ] 6.1 Comprehensive build verification
    - Run full project build to ensure 0 sorry statements remain
    - Verify all modules compile successfully (3004/3004 target)
    - Test individual module builds for TelescopingSeries and UniformSumHittingTime
    - _Requirements: 3.1, 3.2, 3.3_

  - [ ] 6.2 Update project documentation
    - Update current-state.md to reflect completion status
    - Document mathematical insights discovered during implementation
    - Record final sorry count (target: 0) and build status
    - _Requirements: 5.1, 5.2, 5.3_

  - [ ] 6.3 Validate mathematical correctness
    - Verify that completed proof maintains connection to original Aphrodisiac Problem
    - Ensure E[τ] = e result is properly established and accessible
    - Test integration with existing Python numerical verification
    - _Requirements: 4.4, 5.4_