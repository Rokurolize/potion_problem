#!/usr/bin/env python3
"""
Migrate non-existent API patterns from markdown to SQLite database
"""

import sqlite3
from datetime import date

db_path = 'mathlib_apis.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Non-existent API patterns from list-of-non-existent-mathlib-apis.md
non_existent_patterns = [
    # GROUP A: CONDITIONAL INFINITE SUMS
    {
        'pattern': 'tsum.*if.*then.*else',
        'description': 'No direct conditional infinite sum APIs',
        'search_context': 'Looking for APIs that handle if-then-else inside infinite sums',
        'alternative_approach': 'Use Set.indicator or manual conditional handling'
    },
    {
        'pattern': 'if.*tsum',
        'description': 'No if-tsum pattern APIs',
        'search_context': 'APIs with if conditions before tsum',
        'alternative_approach': 'Structure conditions outside the sum'
    },
    {
        'pattern': 'conditional.*sum',
        'description': 'No specialized conditional sum APIs',
        'search_context': 'General conditional summation patterns',
        'alternative_approach': 'Use Summable.tsum_eq_add_tsum_ite or indicator functions'
    },
    {
        'pattern': 'tsum.*condition',
        'description': 'No condition-based tsum APIs',
        'search_context': 'APIs that apply conditions to infinite sums',
        'alternative_approach': 'Use complement decomposition techniques'
    },
    {
        'pattern': 'ite.*tsum',
        'description': 'No ite-tsum combination APIs',
        'search_context': 'If-then-else with infinite sums',
        'alternative_approach': 'Express using indicator functions'
    },
    # GROUP B: SET-BASED CONDITIONAL OPERATIONS
    {
        'pattern': 'indicator.*set.*specialized',
        'description': 'Limited specialized indicator-set APIs',
        'search_context': 'Advanced indicator function operations',
        'alternative_approach': 'Use basic Set.indicator with manual proofs'
    },
    {
        'pattern': 'Set.*indicator.*complex',
        'description': 'No complex set indicator operations',
        'search_context': 'Sophisticated indicator manipulations',
        'alternative_approach': 'Build from basic indicator properties'
    },
    # GROUP C: COMPLEMENT AND DECOMPOSITION
    {
        'pattern': 'tsum.*complement.*direct',
        'description': 'No direct complement APIs',
        'search_context': 'Direct complement sum operations',
        'alternative_approach': 'Use subtype forms like tsum_subtype_add_tsum_subtype_compl'
    },
    {
        'pattern': 'decomposition.*sum.*automatic',
        'description': 'No automatic decomposition APIs',
        'search_context': 'Automatic sum splitting',
        'alternative_approach': 'Use Summable.sum_add_tsum_nat_add manually'
    },
    {
        'pattern': 'tsum.*split.*conditional',
        'description': 'No conditional splitting APIs',
        'search_context': 'Splitting sums based on conditions',
        'alternative_approach': 'Use complement decomposition with sets'
    },
    # GROUP D: PMF OPERATIONS
    {
        'pattern': 'pmf_tail_probability',
        'description': 'No PMF-specific tail probability APIs',
        'search_context': 'Direct tail probability calculations for PMFs',
        'alternative_approach': 'Prove from first principles using general sum APIs'
    },
    {
        'pattern': 'PMF.*tail.*direct',
        'description': 'No direct PMF tail operations',
        'search_context': 'PMF tail-specific functions',
        'alternative_approach': 'Use PMF.filter or manual construction'
    },
    {
        'pattern': 'PMF.*restrict.*conditional',
        'description': 'Limited conditional restriction APIs',
        'search_context': 'Conditional PMF restrictions',
        'alternative_approach': 'Use PMF.filter with appropriate sets'
    },
    # GROUP E: ADVANCED SUMMATION
    {
        'pattern': 'tsum.*range.*conditional',
        'description': 'No range-specific conditional patterns',
        'search_context': 'Conditional sums over ranges',
        'alternative_approach': 'Combine range operations with indicators'
    },
    {
        'pattern': 'sum.*tail.*automatic',
        'description': 'No automatic tail sum APIs',
        'search_context': 'Automatic tail extraction',
        'alternative_approach': 'Use complement decomposition manually'
    },
    {
        'pattern': 'series.*tail.*specialized',
        'description': 'No specialized tail series APIs',
        'search_context': 'Tail-specific series operations',
        'alternative_approach': 'Build using general series APIs'
    },
    # GROUP F: INDEX OPERATIONS
    {
        'pattern': 'tsum.*shift.*direct',
        'description': 'No direct shift operations for infinite sums',
        'search_context': 'Direct index shifting in infinite sums',
        'alternative_approach': 'Use sum_add_tsum_nat_add with appropriate index'
    },
    {
        'pattern': 'reindex.*sum.*infinite',
        'description': 'No infinite sum reindexing APIs',
        'search_context': 'Reindexing infinite sums',
        'alternative_approach': 'Use equivalences or bijections manually'
    },
    {
        'pattern': 'tsum.*map.*bijective',
        'description': 'No bijective mapping APIs for infinite sums',
        'search_context': 'Bijective transformations of infinite sums',
        'alternative_approach': 'Prove reindexing from first principles'
    },
    {
        'pattern': 'index.*tsum.*transform',
        'description': 'No index transformation APIs',
        'search_context': 'Index transformations in infinite sums',
        'alternative_approach': 'Manual index manipulation required'
    },
    # GROUP G: FACTORIAL OPERATIONS
    {
        'pattern': 'factorial_reciprocal_sum',
        'description': 'No specialized factorial reciprocal summation APIs',
        'search_context': 'Direct ∑ 1/n! APIs',
        'alternative_approach': 'Use NormedSpace.expSeries_div_hasSum_exp with x=1'
    },
    {
        'pattern': 'factorial.*series.*special',
        'description': 'No specialized factorial series APIs beyond exponential',
        'search_context': 'Special factorial series patterns',
        'alternative_approach': 'Use exponential series APIs'
    },
    {
        'pattern': 'inv.*factorial.*tsum',
        'description': 'No inverse factorial infinite sum APIs',
        'search_context': 'APIs for ∑ 1/n! patterns',
        'alternative_approach': 'Express as x^n/n! with x=1'
    },
    {
        'pattern': 'factorial.*tail.*sum',
        'description': 'No factorial tail sum specialized APIs',
        'search_context': 'Tail sums of factorial series',
        'alternative_approach': 'Use Complex.sum_div_factorial_le for bounds'
    },
    {
        'pattern': 'exponential.*series.*conditional',
        'description': 'No conditional exponential series APIs',
        'search_context': 'Conditional forms of exponential series',
        'alternative_approach': 'Apply conditions to standard exponential series'
    },
    # ADDITIONAL NON-EXISTENT APIS
    {
        'pattern': 'tsum_tail',
        'description': 'No specific tail sum APIs',
        'search_context': 'Direct tail sum operations',
        'alternative_approach': 'Build using complement decomposition'
    },
    {
        'pattern': 'tsum_gt',
        'description': 'No greater-than conditional sum APIs',
        'search_context': 'Sums with k > n conditions',
        'alternative_approach': 'Use Set.indicator with {k | k > n}'
    },
    {
        'pattern': 'factorial_reciprocal',
        'description': 'No specialized factorial reciprocal APIs',
        'search_context': 'Direct factorial reciprocal operations',
        'alternative_approach': 'Use 1 / n.factorial with Nat.factorial_ne_zero'
    },
    # Expert-proposed APIs that don't exist
    {
        'pattern': 'tsum_dite_right',
        'description': 'Expert proposed this as core API for handling conditional sums',
        'search_context': 'Proposed as "the most direct API for handling conditional sums"',
        'alternative_approach': 'Use Set.indicator with manual proofs, or Summable.tsum_add for decomposition'
    },
    {
        'pattern': 'tsum_indicator_eq_tsum_subtype',
        'description': 'Expert\'s revised proposal for converting indicator sums to subtype sums',
        'search_context': 'Expert claimed this was in Mathlib.Topology.Algebra.InfiniteSum.Group',
        'alternative_approach': 'Build proof manually using tsum_subtype or use alternative decomposition approaches'
    },
    {
        'pattern': 'tsum_eq_tsum_of_ne_zero',
        'description': 'Expert suggested for converting conditional sums to subtype sums',
        'search_context': 'Expert incorrectly suggested this as a standard Mathlib API',
        'alternative_approach': 'Use tsum_eq_sum when support is finite, or Summable.tsum_subtype_add_tsum_subtype_compl for decomposition'
    },
    {
        'pattern': 'Finset.sum_sdiff',
        'description': 'Expert suggested this for splitting finite sums',
        'search_context': 'While sdiff operations exist for sets, there\'s no specific sum_sdiff lemma for finsets',
        'alternative_approach': 'Use Finset.sum_union with disjoint sets, or Finset.sum_subset for subset-based splitting'
    },
    {
        'pattern': 'tsum if then else',
        'description': 'Not found in mathlib4',
        'search_context': 'Searched on 2025-07-27',
        'alternative_approach': 'Consider alternative approaches or verify the API name'
    },
    {
        'pattern': 'alternating series',
        'description': 'Not found in mathlib4',
        'search_context': 'Searched on 2025-07-27',
        'alternative_approach': 'Consider alternative approaches or verify the API name'
    },
    {
        'pattern': 'tsum_subtype_eq_if',
        'description': 'Looking for API to convert subtype sums to if-then-else expressions',
        'search_context': 'Searched on 2025-07-27',
        'alternative_approach': 'Use tsum_subtype_add_tsum_subtype_compl for decomposition or indicator functions for conditional sums'
    }
]

# Insert non-existent patterns
for pattern in non_existent_patterns:
    try:
        cursor.execute('''
            INSERT INTO non_existent_apis (pattern, description, search_context, 
                                         alternative_approach, verified_date, mathlib_version)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (
            pattern['pattern'],
            pattern['description'],
            pattern.get('search_context'),
            pattern['alternative_approach'],
            date.today().isoformat(),
            'v4.21.0'
        ))
    except sqlite3.IntegrityError:
        print(f"Skipping duplicate pattern: {pattern['pattern']}")

# Also add these as non-existent in the main apis table
for pattern in non_existent_patterns:
    # Extract a reasonable API name from the pattern
    api_name = pattern['pattern'].replace('.*', '.').replace('\\', '')
    
    try:
        cursor.execute('''
            INSERT INTO apis (api_name, exists_in_mathlib, signature, import_path,
                            mathematical_significance, verified_date, mathlib_version)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (
            api_name,
            False,  # does not exist
            'PATTERN: ' + pattern['pattern'],
            'N/A',
            pattern['description'],
            date.today().isoformat(),
            'v4.21.0'
        ))
    except sqlite3.IntegrityError:
        pass  # Skip duplicates

conn.commit()
print(f"Successfully migrated {len(non_existent_patterns)} non-existent API patterns")

conn.close()