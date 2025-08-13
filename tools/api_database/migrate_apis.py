#!/usr/bin/env python3
"""
Migrate API data from markdown files to SQLite database
"""

import sqlite3
import re
from datetime import date

db_path = 'mathlib_apis.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Sample API entries to demonstrate structure
# In production, this would parse the actual markdown files

# APIs from docs/api-reference/verified-apis.md
verified_apis = [
    # Infinite Sum APIs
    {
        'api_name': 'Summable.tsum_add_tsum_compl',
        'exists': True,
        'deprecated': False,
        'signature': 'Summable.tsum_add_tsum_compl {f : β → α} (hf : Summable f) (s : Set β) : ∑\' x, f x = (∑\' x ∈ s, f x) + (∑\' x ∈ sᶜ, f x)',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.Basic',
        'category': 'Infinite Sum APIs',
        'significance': 'Splits infinite sum into sum over set and its complement'
    },
    {
        'api_name': 'Summable.sum_add_tsum_nat_add',
        'exists': True,
        'deprecated': True,
        'replacement_api': None,
        'signature': 'Summable.sum_add_tsum_nat_add {f : ℕ → α} (hf : Summable f) (k : ℕ) : ∑ i ∈ Finset.range k, f i + ∑\' i, f (i + k) = ∑\' i, f i',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.NatInt',
        'category': 'Infinite Sum APIs',
        'significance': 'Splits infinite sum into finite head and infinite tail'
    },
    {
        'api_name': 'summable_nat_add_iff',
        'exists': True,
        'deprecated': False,
        'signature': 'summable_nat_add_iff {f : ℕ → α} (k : ℕ) : Summable (fun n => f (n + k)) ↔ Summable f',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.NatInt',
        'category': 'Infinite Sum APIs',
        'significance': 'Summability is preserved under index shifting'
    },
    {
        'api_name': 'tsum_congr',
        'exists': True,
        'deprecated': False,
        'signature': 'tsum_congr {f g : β → α} (h : ∀ b, f b = g b) : ∑\' b, f b = ∑\' b, g b',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.Basic',
        'category': 'Infinite Sum APIs',
        'significance': 'When functions agree pointwise, their sums are equal'
    },
    {
        'api_name': 'tsum_subtype',
        'exists': True,
        'deprecated': False,
        'signature': 'tsum_subtype (s : Set β) (f : β → α) : ∑\' (x : ↑s), f ↑x = ∑\' x, s.indicator f x',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.Basic',
        'category': 'Infinite Sum APIs',
        'significance': 'Converts between subtype sums and indicator sums'
    },
    {
        'api_name': 'Set.indicator',
        'exists': True,
        'deprecated': False,
        'signature': 'Set.indicator (s : Set α) (f : α → M) (a : α) : M',
        'import_path': 'Mathlib.Algebra.Group.Indicator',
        'lean_explore_id': 9175,
        'category': 'Conditional Sum Conversion',
        'significance': 'Returns f a if a ∈ s, 0 otherwise'
    },
    # Polynomial Derivative APIs
    {
        'api_name': 'Polynomial.iterate_derivative_X_sub_pow_self',
        'exists': True,
        'deprecated': False,
        'signature': 'theorem iterate_derivative_X_sub_pow_self (n : ℕ) (c : R) : derivative^[n] ((X - C c) ^ n) = n.factorial',
        'import_path': 'Mathlib.Algebra.Polynomial.Derivative',
        'lean_explore_id': 28743,
        'category': 'Polynomial Derivative APIs',
        'significance': 'The n-th derivative of (X-c)^n equals n!'
    },
    {
        'api_name': 'Polynomial.iterate_derivative_X_pow_eq_C_mul',
        'exists': True,
        'deprecated': False,
        'signature': 'theorem iterate_derivative_X_pow_eq_C_mul (n k : ℕ) : derivative^[k] (X ^ n : R[X]) = C (Nat.descFactorial n k : R) * X ^ (n - k)',
        'import_path': 'Mathlib.Algebra.Polynomial.Derivative',
        'lean_explore_id': 28721,
        'category': 'Polynomial Derivative APIs',
        'significance': 'k-th derivative of X^n = n^(k) * X^(n-k) where n^(k) is falling factorial'
    },
    {
        'api_name': 'Polynomial.iterate_derivative_eq_zero',
        'exists': True,
        'deprecated': False,
        'signature': 'theorem iterate_derivative_eq_zero {p : R[X]} {x : ℕ} (hx : p.natDegree < x) : Polynomial.derivative^[x] p = 0',
        'import_path': 'Mathlib.Algebra.Polynomial.Derivative',
        'lean_explore_id': 28688,
        'category': 'Polynomial Derivative APIs',
        'significance': 'Degree reduction property - derivatives beyond polynomial degree are zero'
    },
    {
        'api_name': 'Polynomial.iterate_derivative_X_add_pow',
        'exists': True,
        'deprecated': False,
        'signature': 'theorem iterate_derivative_X_add_pow (n k : ℕ) (c : R) : derivative^[k] ((X + C c) ^ n) = Nat.descFactorial n k • (X + C c) ^ (n - k)',
        'import_path': 'Mathlib.Algebra.Polynomial.Derivative',
        'lean_explore_id': 28725,
        'category': 'Polynomial Derivative APIs',
        'significance': 'Analogous to fwdDiff patterns - connection between polynomial derivatives and forward differences'
    },
    # Type Conversion APIs
    {
        'api_name': 'zsmul_eq_mul',
        'exists': True,
        'deprecated': False,
        'signature': '@[simp] lemma _root_.zsmul_eq_mul (a : α) : ∀ n : ℤ, n • a = n * a',
        'import_path': 'Mathlib.Data.Int.Cast.Lemmas',
        'lean_explore_id': 91820,
        'category': 'Type Conversion APIs',
        'significance': 'Integer scalar multiplication equals ordinary multiplication'
    },
    # Factorial & Series
    {
        'api_name': 'FloorSemiring.tendsto_pow_div_factorial_atTop',
        'exists': True,
        'deprecated': False,
        'signature': 'FloorSemiring.tendsto_pow_div_factorial_atTop (c : ℝ) : Tendsto (fun n => c^n / n.factorial) atTop (𝓝 0)',
        'import_path': 'Mathlib.Topology.Algebra.Order.Floor',
        'category': 'Factorial & Series',
        'significance': 'x^n/n! → 0 as n → ∞'
    },
    {
        'api_name': 'hasSum_iff_tendsto_nat_of_nonneg',
        'exists': True,
        'deprecated': False,
        'signature': 'hasSum_iff_tendsto_nat_of_nonneg {f : ℕ → ℝ} (hf_nn : ∀ n, 0 ≤ f n) : HasSum f L ↔ Tendsto (fun N => ∑ n ∈ Finset.range N, f n) atTop (𝓝 L)',
        'import_path': 'Mathlib.Topology.Instances.ENNReal.Lemmas',
        'category': 'Factorial & Series',
        'significance': 'For nonnegative sequences, HasSum is equivalent to partial sum convergence'
    },
    {
        'api_name': 'Complex.sum_div_factorial_le',
        'exists': True,
        'deprecated': False,
        'signature': 'Complex.sum_div_factorial_le (n j : ℕ) (hn : 0 < n) : (∑ m ∈ range j with n ≤ m, (1 / m.factorial : α)) ≤ n.succ / (n.factorial * n)',
        'import_path': 'Mathlib.Data.Complex.Exponential',
        'lean_explore_id': 84423,
        'category': 'Factorial & Series',
        'significance': 'Provides direct bounds for partial sums of factorial reciprocals'
    },
    {
        'api_name': 'NormedSpace.expSeries_div_hasSum_exp',
        'exists': True,
        'deprecated': False,
        'signature': 'expSeries_div_hasSum_exp (x : 𝔸) : HasSum (fun n => x ^ n / n !) (exp 𝕂 x)',
        'import_path': 'Mathlib.Analysis.Normed.Algebra.Exponential',
        'lean_explore_id': 50387,
        'category': 'Factorial & Series',
        'significance': 'Rigorous proof that ∑ x^n/n! = exp(x)'
    },
    # Finset Decomposition
    {
        'api_name': 'Finset.union_sdiff_of_subset',
        'exists': True,
        'deprecated': False,
        'signature': 'Finset.union_sdiff_of_subset {s t : Finset α} (h : s ⊆ t) : s ∪ (t \\ s) = t',
        'import_path': 'Mathlib.Data.Finset.Basic',
        'category': 'Finset Decomposition',
        'significance': 'Decompose a finset into subset and complement'
    },
    {
        'api_name': 'Finset.sum_union',
        'exists': True,
        'deprecated': False,
        'signature': 'Finset.sum_union [DecidableEq ι] (h : Disjoint s₁ s₂) : ∑ x ∈ s₁ ∪ s₂, f x = ∑ x ∈ s₁, f x + ∑ x ∈ s₂, f x',
        'import_path': 'Mathlib.Algebra.BigOperators.Group.Finset.Basic',
        'category': 'Finset Decomposition',
        'significance': 'Split sum over disjoint union'
    },
    {
        'api_name': 'Finset.disjoint_sdiff',
        'exists': True,
        'deprecated': False,
        'signature': 'Finset.disjoint_sdiff {s t : Finset α} : Disjoint s (t \\ s)',
        'import_path': 'Mathlib.Data.Finset.Basic',
        'category': 'Finset Decomposition',
        'significance': 'Automatic disjointness proof for set difference'
    },
    # Continuity APIs
    {
        'api_name': 'Continuous.if',
        'exists': True,
        'deprecated': False,
        'signature': 'Continuous.if {p : α → Prop} [∀ a, Decidable (p a)] (hp : ∀ a ∈ frontier { x | p x }, f a = g a) (hf : Continuous f) (hg : Continuous g) : Continuous fun a => if p a then f a else g a',
        'import_path': 'Mathlib.Topology.Piecewise',
        'lean_explore_id': 201977,
        'category': 'Continuity APIs',
        'significance': 'Continuity of conditional functions'
    },
    {
        'api_name': 'continuous_piecewise',
        'exists': True,
        'deprecated': False,
        'signature': 'continuous_piecewise [∀ a, Decidable (a ∈ s)] (hs : ∀ a ∈ frontier s, f a = g a) (hf : ContinuousOn f (closure s)) (hg : ContinuousOn g (closure sᶜ)) : Continuous (piecewise s f g)',
        'import_path': 'Mathlib.Topology.Piecewise',
        'lean_explore_id': 201980,
        'category': 'Continuity APIs',
        'significance': 'More flexible than Continuous.if - only requires continuity on closures'
    },
    {
        'api_name': 'continuousOn_floor',
        'exists': True,
        'deprecated': False,
        'signature': 'continuousOn_floor : ContinuousOn (fun x => floor x : α → α) (Ico n (n + 1) : Set α)',
        'import_path': 'Mathlib.Topology.Algebra.Order.Floor',
        'lean_explore_id': 189427,
        'category': 'Continuity APIs',
        'significance': 'Floor function is continuous on half-open intervals [n, n+1)'
    },
    # Additional important APIs
    {
        'api_name': 'Int.alternating_sum_range_choose',
        'exists': True,
        'deprecated': False,
        'signature': 'Int.alternating_sum_range_choose {n : ℕ} : (∑ m ∈ range (n + 1), ((-1) ^ m * n.choose m : ℤ)) = if n = 0 then 1 else 0',
        'import_path': 'Mathlib.Data.Nat.Choose.Sum',
        'lean_explore_id': 98739,
        'category': 'Arithmetic & Logic',
        'significance': 'Proves the alternating sum of binomial coefficients equals 0 for n > 0'
    },
    {
        'api_name': 'Finset.sum_bij',
        'exists': True,
        'deprecated': False,
        'signature': 'Finset.sum_bij (i : ∀ a ∈ s, κ) (hi : ∀ a ha, i a ha ∈ t) (i_inj : ∀ a₁ ha₁ a₂ ha₂, i a₁ ha₁ = i a₂ ha₂ → a₁ = a₂) (i_surj : ∀ b ∈ t, ∃ a ha, i a ha = b) (h : ∀ a ha, f a = g (i a ha)) : ∑ x ∈ s, f x = ∑ x ∈ t, g x',
        'import_path': 'Mathlib.Algebra.BigOperators.Group.Finset.Defs',
        'lean_explore_id': 2350,
        'category': 'Index Manipulation',
        'significance': 'For inclusion-exclusion rearrangements with dependent bijections'
    },
    {
        'api_name': 'fwdDiff_iter_eq_sum_shift',
        'exists': True,
        'deprecated': False,
        'signature': 'fwdDiff_iter_eq_sum_shift (f : M → G) (n : ℕ) (y : M) : Δ_[h]^[n] f y = ∑ k ∈ range (n + 1), ((-1 : ℤ) ^ (n - k) * n.choose k) • f (y + k • h)',
        'import_path': 'Mathlib.Algebra.Group.ForwardDiff',
        'lean_explore_id': 8897,
        'category': 'Index Manipulation',
        'significance': 'General formula for n-th forward difference'
    },
    {
        'api_name': 'shift_eq_sum_fwdDiff_iter',
        'exists': True,
        'deprecated': False,
        'signature': 'shift_eq_sum_fwdDiff_iter (f : M → G) (n : ℕ) (y : M) : f (y + n • h) = ∑ k ∈ range (n + 1), n.choose k • Δ_[h]^[k] f y',
        'import_path': 'Mathlib.Algebra.Group.ForwardDiff',
        'lean_explore_id': 8898,
        'category': 'Index Manipulation',
        'significance': 'Gregory-Newton interpolation formula'
    },
    # Arithmetic & Logic
    {
        'api_name': 'omega',
        'exists': True,
        'deprecated': False,
        'signature': 'tactic',
        'import_path': 'Built-in tactic (no import required)',
        'category': 'Arithmetic & Logic',
        'significance': 'Automatic arithmetic constraint solving for natural numbers and integers'
    },
    {
        'api_name': 'interval_cases',
        'exists': True,
        'deprecated': False,
        'signature': 'tactic',
        'import_path': 'Built-in tactic',
        'category': 'Arithmetic & Logic',
        'significance': 'Case analysis on finite ranges'
    },
    {
        'api_name': 'Nat.factorial_ne_zero',
        'exists': True,
        'deprecated': False,
        'signature': 'Nat.factorial_ne_zero (n : ℕ) : n.factorial ≠ 0',
        'import_path': 'Mathlib.Data.Nat.Factorial.Basic',
        'lean_explore_id': 98910,
        'category': 'Arithmetic & Logic',
        'significance': 'Factorial is never zero'
    },
    # Additional APIs for remaining sorries
    {
        'api_name': 'tsum_subtype_add_tsum_subtype_compl',
        'exists': True,
        'deprecated': True,
        'replacement_api': 'Summable.tsum_subtype_add_tsum_subtype_compl',
        'signature': 'tsum_subtype_add_tsum_subtype_compl : ∑\'_{x : s} f(x) + ∑\'_{x : s^c} f(x) = ∑\' x, f(x)',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.Group',
        'lean_explore_id': 187696,
        'category': 'Infinite Sum APIs',
        'significance': 'Perfect complement decomposition for splitting infinite sums'
    },
    {
        'api_name': 'NNReal.sum_add_tsum_nat_add',
        'exists': True,
        'deprecated': False,
        'signature': 'NNReal.sum_add_tsum_nat_add {f : ℕ → ℝ≥0} (k : ℕ) (hf : Summable f) : ∑\' i, f i = (∑ i ∈ range k, f i) + ∑\' i, f (i + k)',
        'import_path': 'Mathlib.Topology.Instances.NNReal.Lemmas',
        'lean_explore_id': 196967,
        'category': 'Infinite Sum APIs',
        'significance': 'Enhanced nonnegative real specialization for PMF decomposition'
    },
    {
        'api_name': 'Summable.tsum_eq_add_tsum_ite',
        'exists': True,
        'deprecated': False,
        'signature': 'Summable.tsum_eq_add_tsum_ite {f : β → α} (hf : Summable f) (b : β) : ∑\' n, f n = f b + ∑\' n, if n = b then 0 else f n',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.Group',
        'lean_explore_id': 187683,
        'category': 'Conditional Sum Conversion',
        'significance': 'Extract individual terms from infinite sums'
    },
    {
        'api_name': 'PMF.filter_apply',
        'exists': True,
        'deprecated': False,
        'signature': 'PMF.filter_apply (a : α) : (p.filter s h) a = s.indicator p a * (∑\' a\', (s.indicator p) a\')⁻¹',
        'import_path': 'Mathlib.Probability.ProbabilityMassFunction.Constructions',
        'lean_explore_id': 166007,
        'category': 'PMF Operations',
        'significance': 'Provides exact conditional probability formula via filtered PMF normalization'
    },
    {
        'api_name': 'ENNReal.summable',
        'exists': True,
        'deprecated': False,
        'signature': 'ENNReal.summable {α : Type*} (f : α → ℝ≥0∞) : Summable f',
        'import_path': 'Mathlib.Topology.Instances.ENNReal.Lemmas',
        'lean_explore_id': 196624,
        'category': 'Infinite Sum APIs',
        'significance': 'Any function to ENNReal is automatically summable'
    },
    {
        'api_name': 'Real.summable_one_div_int_pow',
        'exists': True,
        'deprecated': False,
        'signature': 'Real.summable_one_div_int_pow {p : ℕ} : (Summable fun n : ℤ ↦ 1 / (n : ℝ) ^ p) ↔ 1 < p',
        'import_path': 'Mathlib.Analysis.PSeries',
        'lean_explore_id': 54317,
        'category': 'Factorial & Series',
        'significance': 'Proves summability of p-series over integers'
    },
    {
        'api_name': 'NNReal.indicator_summable',
        'exists': True,
        'deprecated': False,
        'signature': 'NNReal.indicator_summable {f : α → ℝ≥0} (hf : Summable f) (s : Set α) : Summable (s.indicator f)',
        'import_path': 'Mathlib.Topology.Instances.ENNReal.Lemmas',
        'lean_explore_id': 196690,
        'category': 'Conditional Sum Conversion',
        'significance': 'Automatic summability for indicator functions on NNReal'
    },
    {
        'api_name': 'summable_of_sum_range_le',
        'exists': True,
        'deprecated': False,
        'signature': 'summable_of_sum_range_le {f : ℕ → ℝ} {c : ℝ} (hf : ∀ n, 0 ≤ f n) (h : ∀ n, ∑ i ∈ Finset.range n, f i ≤ c) : Summable f',
        'import_path': 'Mathlib.Topology.Algebra.InfiniteSum.Real',
        'lean_explore_id': 187897,
        'category': 'Infinite Sum APIs',
        'significance': 'Proves summability by bounding partial sums'
    },
    {
        'api_name': 'Int.alternating_sum_range_choose_of_ne',
        'exists': True,
        'deprecated': False,
        'signature': 'Int.alternating_sum_range_choose_of_ne {n : ℕ} (h0 : n ≠ 0) : (∑ m ∈ range (n + 1), ((-1) ^ m * n.choose m : ℤ)) = 0',
        'import_path': 'Mathlib.Data.Nat.Choose.Sum',
        'lean_explore_id': 98740,
        'category': 'Arithmetic & Logic',
        'significance': 'Direct version when n ≠ 0 is already known'
    },
    {
        'api_name': 'Antitone.tendsto_alternating_series_of_tendsto_zero',
        'exists': True,
        'deprecated': False,
        'signature': 'Antitone.tendsto_alternating_series_of_tendsto_zero (hfa : Antitone f) (hf0 : Tendsto f atTop (𝓝 0)) : ∃ l, Tendsto (fun n ↦ ∑ i ∈ range n, (-1) ^ i * f i) atTop (𝓝 l)',
        'import_path': 'Mathlib.Analysis.SpecificLimits.Normed',
        'lean_explore_id': 58273,
        'category': 'Factorial & Series',
        'significance': 'Proves convergence of alternating series'
    },
    {
        'api_name': 'ContinuousOn.piecewise',
        'exists': True,
        'deprecated': False,
        'signature': 'Continuity of piecewise functions on a set',
        'import_path': 'Mathlib.Topology.Piecewise',
        'lean_explore_id': 201974,
        'category': 'Continuity APIs',
        'significance': 'Handles piecewise definitions with frontier agreement conditions'
    },
    {
        'api_name': 'continuousOn_piecewise_ite',
        'exists': True,
        'deprecated': False,
        'signature': 'continuousOn_piecewise_ite for piecewise functions defined by indicator conditions',
        'import_path': 'Mathlib.Topology.Piecewise',
        'lean_explore_id': 201987,
        'category': 'Continuity APIs',
        'significance': 'Piecewise functions with indicator conditions'
    },
    {
        'api_name': 'tendsto_add_atTop_nat',
        'exists': True,
        'deprecated': False,
        'signature': 'tendsto_add_atTop_nat (k : ℕ) : Tendsto (fun n => n + k) atTop atTop',
        'import_path': 'Mathlib.Order.Filter.AtTopBot.Basic',
        'category': 'Topology/Filter APIs',
        'significance': 'n ↦ n + k tends to infinity'
    }
]

# Insert verified APIs
for api in verified_apis:
    try:
        cursor.execute('''
            INSERT INTO apis (api_name, exists_in_mathlib, deprecated, replacement_api, signature, 
                            import_path, lean_explore_id, mathematical_significance, 
                            verified_date, mathlib_version)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            api['api_name'],
            api['exists'],
            api.get('deprecated', False),
            api.get('replacement_api'),
            api['signature'],
            api['import_path'],
            api.get('lean_explore_id'),
            api.get('significance'),
            date.today().isoformat(),
            'v4.21.0'
        ))
        
        # Add category mapping
        if 'category' in api:
            cursor.execute('''
                INSERT INTO api_categories (api_name, category_id)
                SELECT ?, category_id FROM categories WHERE category_name = ?
            ''', (api['api_name'], api['category']))
            
    except sqlite3.IntegrityError as e:
        print(f"Skipping duplicate API: {api['api_name']}")

# Insert some usage patterns
usage_patterns = [
    {
        'api_name': 'Summable.sum_add_tsum_nat_add',
        'pattern': '''have h_eq := Summable.sum_add_tsum_nat_add k summability_proof
rw [← h_eq]  -- Note: reverse direction often needed''',
        'description': 'Note argument order: k first, then summability proof. Often used in reverse direction.'
    },
    {
        'api_name': 'tsum_subtype',
        'pattern': '''-- Convert conditional sum to subtype sum
-- From: ∑' k, if k > n then f k else 0
-- To: ∑' (k : {k // k > n}), f k
rw [← tsum_subtype {k | k > n} f]''',
        'description': 'Use reverse direction for conditional-to-subtype conversion'
    },
    {
        'api_name': 'Polynomial.iterate_derivative_X_sub_pow_self',
        'pattern': '''-- Direct proof that n-th derivative of (X-c)^n is n!
have h := Polynomial.iterate_derivative_X_sub_pow_self n c
-- Special case c=0: derivative^[n] (X^n) = n.factorial''',
        'description': 'For c=0, this gives the n-th derivative of X^n'
    },
    {
        'api_name': 'zsmul_eq_mul',
        'pattern': '''-- Convert from scalar action to multiplication
have h : (n : ℤ) • (r : ℝ) = (n : ℝ) * r := zsmul_eq_mul r n
-- Allows rewriting fwdDiff formulas using ordinary multiplication''',
        'description': 'Essential for converting between scalar actions and multiplication'
    }
]

for pattern in usage_patterns:
    cursor.execute('''
        INSERT INTO usage_patterns (api_name, pattern_code, description)
        VALUES (?, ?, ?)
    ''', (pattern['api_name'], pattern['pattern'], pattern['description']))

# Insert common errors
api_errors = [
    {
        'api_name': 'Summable.sum_add_tsum_nat_add',
        'error_pattern': '(Summable.hasSum pmf_summable).sum_add_tsum_nat_add',
        'correct_pattern': 'Summable.sum_add_tsum_nat_add k pmf_summable',
        'error_message': "invalid field 'sum_add_tsum_nat_add'",
        'explanation': 'Must be called directly on Summable namespace, not as field access'
    }
]

for error in api_errors:
    cursor.execute('''
        INSERT INTO api_errors (api_name, error_pattern, correct_pattern, error_message, explanation)
        VALUES (?, ?, ?, ?, ?)
    ''', (error['api_name'], error['error_pattern'], error['correct_pattern'], 
          error.get('error_message'), error.get('explanation')))

# Insert sorry contributions
sorry_contributions = [
    {
        'api_name': 'Polynomial.iterate_derivative_X_sub_pow_self',
        'module': 'IrwinHallTheory',
        'sorry_line': 233,
        'contribution_level': 5,
        'notes': 'Direct proof that n-th derivative yields factorial for iter_fwdDiff_pow_eq_factorial'
    },
    {
        'api_name': 'Polynomial.iterate_derivative_X_pow_eq_C_mul',
        'module': 'IrwinHallTheory',
        'sorry_line': 233,
        'contribution_level': 4,
        'notes': 'General k-th derivative formula, use with k=n'
    },
    {
        'api_name': 'Polynomial.iterate_derivative_eq_zero',
        'module': 'IrwinHallTheory',
        'sorry_line': 233,
        'contribution_level': 4,
        'notes': 'Degree reduction property for polynomial derivatives'
    },
    {
        'api_name': 'zsmul_eq_mul',
        'module': 'IrwinHallTheory',
        'sorry_line': 274,
        'contribution_level': 5,
        'notes': 'Critical for converting ℤ-valued scalar actions to ℝ multiplication'
    },
    {
        'api_name': 'fwdDiff_iter_eq_sum_shift',
        'module': 'IrwinHallTheory',
        'sorry_line': 274,
        'contribution_level': 5,
        'notes': 'General formula for n-th forward difference'
    },
    {
        'api_name': 'shift_eq_sum_fwdDiff_iter',
        'module': 'IrwinHallTheory',
        'sorry_line': 274,
        'contribution_level': 4,
        'notes': 'Gregory-Newton interpolation formula'
    },
    {
        'api_name': 'Int.alternating_sum_range_choose',
        'module': 'IrwinHallTheory',
        'sorry_line': 179,
        'contribution_level': 4,
        'notes': 'For proving inclusion-exclusion formulas equal zero'
    }
]

for contrib in sorry_contributions:
    cursor.execute('''
        INSERT INTO sorry_contributions (api_name, module, sorry_line, contribution_level, notes)
        VALUES (?, ?, ?, ?, ?)
    ''', (contrib['api_name'], contrib['module'], contrib['sorry_line'], 
          contrib['contribution_level'], contrib.get('notes')))

# Commit all changes
conn.commit()
print(f"Successfully migrated {len(verified_apis)} APIs to database")
print(f"Added {len(usage_patterns)} usage patterns")
print(f"Added {len(api_errors)} error patterns")
print(f"Added {len(sorry_contributions)} sorry contributions")

conn.close()