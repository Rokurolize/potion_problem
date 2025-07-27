# LeanExplore API Discovery: Group C - Complement and Decomposition

**Target**: Find APIs for splitting infinite sums into finite head + infinite tail parts
**Goal**: Eliminate `tail_probability_formula` sorry in ProbabilityFoundations.lean
**Mathematical target**: `∑' k, PMF k = ∑_{k≤n} PMF k + ∑_{k>n} PMF k`

## Summary of Findings

### 🎯 **BREAKTHROUGH DISCOVERIES**

#### 1. Universal ENNReal Summability
- **API**: `ENNReal.summable : Summable f` (ID: 196624)
- **Location**: `Mathlib/Topology/Instances/ENNReal/Lemmas.lean:578`
- **Significance**: ANY function to ENNReal is automatically summable
- **Usage**: Eliminates summability requirements for complement decomposition
- **Import**: `Mathlib.Topology.Instances.ENNReal.Lemmas`

#### 2. Complement Decomposition Pattern (Deprecated but Functional)
- **API**: `tsum_subtype_add_tsum_subtype_compl` (ID: 187696)
- **Mathematical statement**: `∑'_{x : s} f(x) + ∑'_{x : s^c} f(x) = ∑' x, f(x)`
- **Status**: Deprecated alias for `Summable.tsum_subtype_add_tsum_subtype_compl`
- **Location**: `Mathlib/Topology/Algebra/InfiniteSum/Group.lean:324`
- **Note**: Still functional, but deprecated since 2025-04-12

#### 3. Finite + Infinite Tail Decomposition (Deprecated but Functional)
- **API**: `sum_add_tsum_compl` (ID: 187680)
- **Mathematical statement**: `∑_{i ∈ s} f(i) + ∑_{i ∈ s^c} f(i) = ∑' i, f(i)`
- **Status**: Deprecated alias for `Summable.sum_add_tsum_compl`
- **Location**: `Mathlib/Topology/Algebra/InfiniteSum/Group.lean:184`
- **Perfect for**: `∑_{k≤n} PMF k + ∑_{k>n} PMF k = ∑' k, PMF k`

#### 4. Union-Based Decomposition (Deprecated but Functional)
- **API**: `tsum_union_disjoint` (ID: 187555)
- **Mathematical statement**: `∑_{x ∈ s ∪ t} f(x) = ∑_{x ∈ s} f(x) + ∑_{x ∈ t} f(x)` when `s ∩ t = ∅`
- **Status**: Deprecated alias for `Summable.tsum_union_disjoint`
- **Location**: `Mathlib/Topology/Algebra/InfiniteSum/Basic.lean:621`
- **Deprecated since**: 2025-04-12

#### 5. Modern Measure Theory Pattern
- **API**: `MeasureTheory.Measure.sum_add_sum_compl` (ID: 140070)
- **Mathematical statement**: `∑_{i ∈ s} μ_i + ∑_{i ∈ s^c} μ_i = ∑_i μ_i`
- **Location**: `Mathlib/MeasureTheory/Measure/MeasureSpace.lean:1243`
- **Proof technique**: Uses `ENNReal.summable.tsum_add_tsum_compl` internally
- **Status**: Modern, non-deprecated

## Detailed API Analysis

### Core Complement Split APIs

#### `tsum_subtype_add_tsum_subtype_compl` (Deprecated but Working)
```lean
-- Mathematical Statement:
-- ∑'_{x : s} f(x) + ∑'_{x : s^c} f(x) = ∑' x, f(x)

alias tsum_subtype_add_tsum_subtype_compl := Summable.tsum_subtype_add_tsum_subtype_compl
```
- **File**: `Mathlib/Topology/Algebra/InfiniteSum/Group.lean:324`
- **Relevance**: Directly applicable to `∑' k, PMF k = ∑_{k≤n} PMF k + ∑_{k>n} PMF k`
- **Requirements**: Summable function (automatically satisfied for ENNReal)
- **Usage**: `apply tsum_subtype_add_tsum_subtype_compl`

#### `sum_add_tsum_compl` (Deprecated but Working)
```lean
-- Mathematical Statement:
-- ∑_{i ∈ s} f(i) + ∑_{i ∈ s^c} f(i) = ∑' i, f(i)

alias sum_add_tsum_compl := Summable.sum_add_tsum_compl
```
- **File**: `Mathlib/Topology/Algebra/InfiniteSum/Group.lean:184`
- **Relevance**: Perfect for finite sum + infinite tail pattern
- **Requirements**: Summable function + finite set `s`
- **Direct application**: Use `s = {k | k ≤ n}` for our case

### Supporting APIs

#### `ENNReal.summable` (Universal Summability)
```lean
protected theorem summable : Summable f := ⟨_, ENNReal.hasSum⟩
```
- **File**: `Mathlib/Topology/Instances/ENNReal/Lemmas.lean:578`
- **Power**: Eliminates all summability requirements for ENNReal functions
- **Usage**: Automatic instance resolution

#### `tsum_union_disjoint` (Deprecated Union Approach)
```lean
-- Mathematical Statement:
-- ∑_{x ∈ s ∪ t} f(x) = ∑_{x ∈ s} f(x) + ∑_{x ∈ t} f(x) when s ∩ t = ∅

alias tsum_union_disjoint := Summable.tsum_union_disjoint
```
- **File**: `Mathlib/Topology/Algebra/InfiniteSum/Basic.lean:621`
- **Usage**: Alternative approach via set union
- **Requirements**: Disjoint sets `s` and `t`

### Modern API Pattern

#### `MeasureTheory.Measure.sum_add_sum_compl` (Non-Deprecated Example)
```lean
theorem sum_add_sum_compl (s : Set ι) (μ : ι → Measure α) :
    ((sum fun i : s => μ i) + sum fun i : ↥sᶜ => μ i) = sum μ := by
  ext1 t ht
  simp only
  exact ENNReal.summable.tsum_add_tsum_compl (f := fun i => μ i t) ENNReal.summable
```
- **File**: `Mathlib/MeasureTheory/Measure/MeasureSpace.lean:1243`
- **Key insight**: Proof uses `ENNReal.summable.tsum_add_tsum_compl`
- **Modern pattern**: Leverage ENNReal summability

## Implementation Strategy

### Recommended Approach for `tail_probability_formula`

1. **Primary Strategy**: Use deprecated but functional APIs
   - `sum_add_tsum_compl` for finite head + infinite tail
   - `tsum_subtype_add_tsum_subtype_compl` for subtype approach
   - Leverage `ENNReal.summable` for automatic summability

2. **Implementation Steps**:
   ```lean
   -- Set up the complement split
   let finite_set := {k | k ≤ n}
   let complement_set := {k | k > n}
   
   -- Apply the decomposition theorem
   rw [← sum_add_tsum_compl finite_set]
   -- or
   rw [← tsum_subtype_add_tsum_subtype_compl finite_set]
   ```

3. **Required Imports**:
   ```lean
   import Mathlib.Topology.Algebra.InfiniteSum.Group      -- For deprecated APIs
   import Mathlib.Topology.Instances.ENNReal.Lemmas       -- For ENNReal.summable
   ```

### Alternative Modern Approach

If avoiding deprecated APIs:
1. Look for the non-deprecated versions of `Summable.tsum_add_tsum_compl`
2. Use the measure theory pattern as template
3. Implement custom decomposition using `ENNReal.summable`

## Deprecation Analysis

### Status of Key APIs
- **Deprecated (but working)**: All `tsum.*compl` aliases deprecated since 2025-04-12
- **Reason**: Part of API cleanup, aliases removed in favor of namespaced versions
- **Timeline**: Still functional in mathlib4 v4.21.0
- **Risk**: May be removed in future versions

### Modern Replacement Strategy
- **Pattern**: Use `ENNReal.summable` + explicit proof construction
- **Example**: Follow `MeasureTheory.Measure.sum_add_sum_compl` pattern
- **Advantage**: Future-proof, non-deprecated
- **Cost**: More verbose, requires understanding underlying theory

## Breakthrough Potential: HIGH

### Why This Solves `tail_probability_formula`

1. **Direct Mathematical Match**: `∑' k, PMF k = ∑_{k≤n} PMF k + ∑_{k>n} PMF k`
2. **Universal Summability**: `ENNReal.summable` eliminates all summability proofs
3. **Working APIs**: Multiple functional approaches available
4. **Proven Pattern**: Measure theory implementation provides template

### Implementation Priority

1. **Immediate**: Try `sum_add_tsum_compl` with finite set `{k | k ≤ n}`
2. **Backup**: Use `tsum_subtype_add_tsum_subtype_compl` with subtype approach
3. **Future-proof**: Develop modern version following measure theory pattern

## Dependencies and Imports

### Required Imports
```lean
import Mathlib.Topology.Algebra.InfiniteSum.Group           -- Complement decomposition
import Mathlib.Topology.Instances.ENNReal.Lemmas           -- Universal summability
import Mathlib.Topology.Algebra.InfiniteSum.Basic          -- Union-based approaches
```

### Optional Supporting Imports
```lean
import Mathlib.MeasureTheory.Measure.MeasureSpace          -- Modern pattern example
import Mathlib.Logic.Equiv.Set                             -- Set complement equivalences
```

## Conclusion

**MISSION ASSESSMENT**: **HIGH SUCCESS PROBABILITY**

The complement decomposition search has discovered multiple working APIs that directly address the `tail_probability_formula` need. The combination of:

1. **Universal ENNReal summability** (eliminates proof obligations)
2. **Direct mathematical match** (complement decomposition theorems)
3. **Multiple working approaches** (deprecated but functional)
4. **Modern patterns available** (measure theory template)

Provides a clear path to eliminating the `tail_probability_formula` sorry. The deprecated status of key APIs is a minor concern since they remain functional and modern alternatives exist.

**RECOMMENDED NEXT ACTION**: Implement `tail_probability_formula` using `sum_add_tsum_compl` with finite set approach, leveraging `ENNReal.summable` for automatic summability.