# List of Non-Existent Mathlib4 APIs

This file maintains a comprehensive list of APIs that have been confirmed NOT to exist in mathlib4.
**IMPORTANT**: Before searching for any API, check this list to avoid redundant searches.

**Last Updated**: 2025-01-27 (based on mathlib4 v4.21.0)

## Purpose

This list serves as a safeguard against unnecessary LeanExplore searches. When the LLM wrapper (`scripts/lle`) detects that an API doesn't exist (based on search results), it automatically appends the pattern to this list.

## Format

Each entry follows this pattern:
- **`api_pattern`** - Description of what was searched
  - **Search context**: What type of API was being sought
  - **Implication**: What alternative approach should be used

---

## GROUP A: CONDITIONAL INFINITE SUMS

1. **`tsum.*if.*then.*else`** - No direct conditional infinite sum APIs
   - **Search context**: Looking for APIs that handle if-then-else inside infinite sums
   - **Implication**: Use `Set.indicator` or manual conditional handling

2. **`if.*tsum`** - No if-tsum pattern APIs
   - **Search context**: APIs with if conditions before tsum
   - **Implication**: Structure conditions outside the sum

3. **`conditional.*sum`** - No specialized conditional sum APIs
   - **Search context**: General conditional summation patterns
   - **Implication**: Use `Summable.tsum_eq_add_tsum_ite` or indicator functions

4. **`tsum.*condition`** - No condition-based tsum APIs
   - **Search context**: APIs that apply conditions to infinite sums
   - **Implication**: Use complement decomposition techniques

5. **`ite.*tsum`** - No ite-tsum combination APIs
   - **Search context**: If-then-else with infinite sums
   - **Implication**: Express using indicator functions

## GROUP B: SET-BASED CONDITIONAL OPERATIONS

6. **`indicator.*set.*specialized`** - Limited specialized indicator-set APIs
   - **Search context**: Advanced indicator function operations
   - **Implication**: Use basic `Set.indicator` with manual proofs

7. **`Set.*indicator.*complex`** - No complex set indicator operations
   - **Search context**: Sophisticated indicator manipulations
   - **Implication**: Build from basic indicator properties

## GROUP C: COMPLEMENT AND DECOMPOSITION

8. **`tsum.*complement.*direct`** - No direct complement APIs
   - **Search context**: Direct complement sum operations
   - **Implication**: Use subtype forms like `tsum_subtype_add_tsum_subtype_compl`

9. **`decomposition.*sum.*automatic`** - No automatic decomposition APIs
   - **Search context**: Automatic sum splitting
   - **Implication**: Use `Summable.sum_add_tsum_nat_add` manually

10. **`tsum.*split.*conditional`** - No conditional splitting APIs
    - **Search context**: Splitting sums based on conditions
    - **Implication**: Use complement decomposition with sets

## GROUP D: PMF OPERATIONS

11. **`pmf_tail_probability`** - No PMF-specific tail probability APIs
    - **Search context**: Direct tail probability calculations for PMFs
    - **Implication**: Prove from first principles using general sum APIs

12. **`PMF.*tail.*direct`** - No direct PMF tail operations
    - **Search context**: PMF tail-specific functions
    - **Implication**: Use `PMF.filter` or manual construction

13. **`PMF.*restrict.*conditional`** - Limited conditional restriction APIs
    - **Search context**: Conditional PMF restrictions
    - **Implication**: Use `PMF.filter` with appropriate sets

## GROUP E: ADVANCED SUMMATION

14. **`tsum.*range.*conditional`** - No range-specific conditional patterns
    - **Search context**: Conditional sums over ranges
    - **Implication**: Combine range operations with indicators

15. **`sum.*tail.*automatic`** - No automatic tail sum APIs
    - **Search context**: Automatic tail extraction
    - **Implication**: Use complement decomposition manually

16. **`series.*tail.*specialized`** - No specialized tail series APIs
    - **Search context**: Tail-specific series operations
    - **Implication**: Build using general series APIs

## GROUP F: INDEX OPERATIONS

17. **`tsum.*shift.*direct`** - No direct shift operations for infinite sums
    - **Search context**: Direct index shifting in infinite sums
    - **Implication**: Use `sum_add_tsum_nat_add` with appropriate index

18. **`reindex.*sum.*infinite`** - No infinite sum reindexing APIs
    - **Search context**: Reindexing infinite sums
    - **Implication**: Use equivalences or bijections manually

19. **`tsum.*map.*bijective`** - No bijective mapping APIs for infinite sums
    - **Search context**: Bijective transformations of infinite sums
    - **Implication**: Prove reindexing from first principles

20. **`index.*tsum.*transform`** - No index transformation APIs
    - **Search context**: Index transformations in infinite sums
    - **Implication**: Manual index manipulation required

## GROUP G: FACTORIAL OPERATIONS

21. **`factorial_reciprocal_sum`** - No specialized factorial reciprocal summation APIs
    - **Search context**: Direct ∑ 1/n! APIs
    - **Implication**: Use `NormedSpace.expSeries_div_hasSum_exp` with x=1

22. **`factorial.*series.*special`** - No specialized factorial series APIs beyond exponential
    - **Search context**: Special factorial series patterns
    - **Implication**: Use exponential series APIs

23. **`inv.*factorial.*tsum`** - No inverse factorial infinite sum APIs
    - **Search context**: APIs for ∑ 1/n! patterns
    - **Implication**: Express as `x^n/n!` with x=1

24. **`factorial.*tail.*sum`** - No factorial tail sum specialized APIs
    - **Search context**: Tail sums of factorial series
    - **Implication**: Use `Complex.sum_div_factorial_le` for bounds

25. **`exponential.*series.*conditional`** - No conditional exponential series APIs
    - **Search context**: Conditional forms of exponential series
    - **Implication**: Apply conditions to standard exponential series

## ADDITIONAL NON-EXISTENT APIS

26. **`tsum_tail`** - No specific tail sum APIs
    - **Search context**: Direct tail sum operations
    - **Implication**: Build using complement decomposition

27. **`tsum_gt`** - No greater-than conditional sum APIs
    - **Search context**: Sums with k > n conditions
    - **Implication**: Use `Set.indicator` with `{k | k > n}`

28. **`factorial_reciprocal`** - No specialized factorial reciprocal APIs
    - **Search context**: Direct factorial reciprocal operations
    - **Implication**: Use `1 / n.factorial` with `Nat.factorial_ne_zero`

---

## Automatic Additions

The following entries were automatically added by the LLM wrapper when searches yielded no relevant results:

<!-- AUTO-APPEND-START -->
<!-- New entries will be automatically added below this line by scripts/lle -->
