# Enhanced MCP LeanExplore Workflow

*Refined workflow based on practical experience with IrwinHallTheory.lean search session*

## Core Principle: Extract Before Search

### Step 1: Systematic Comment Mining

**BEFORE any search**, create a structured extraction:

```markdown
## Sorry Analysis: [module:line]

### APIs Explicitly Mentioned:
- Line 233: `Polynomial.iterate_derivative_X_sub_pow_self` ✓
- Line 233: `fwdDiff_iter_eq_sum_shift` ✓
- Line 318: `Filter.EventuallyEq.continuousAt` (to search)
- Line 318: `continuous_piecewise` ✓

### Mathematical Concepts:
- B-spline theory (confirmed NOT in mathlib4)
- Polynomial derivatives ↔ forward differences connection
- Piecewise polynomial continuity
- Finite sum continuity

### Warnings in Comments:
- "B-spline theory (not in mathlib4)"
- "mathlib4 lacks B-spline theory (confirmed by API search)"
```

This would have saved 5+ minutes of searching.

## Enhanced Search Strategy

### 1. Database-First Pattern Mining

```bash
# Step 1: Check exact APIs from comments
for api in extracted_apis; do
  ./api_tools.sh api-exists "$api"
done

# Step 2: Mine patterns from existing related APIs
./api_tools.sh api-export-category "Polynomial Derivative APIs"
./api_tools.sh api-search "continuous.*piecewise"

# Step 3: Identify naming conventions
# Found: iterate_derivative_* pattern
# Found: continuous_* pattern for topology
```

### 2. Batch Search Planning

Instead of scattered searches, group by mathematical relationship:

```yaml
polynomial_batch:
  - "Polynomial.iterate_derivative function evaluate"
  - "polynomial aeval comp"
  - "polynomial derivative forward difference relation"

continuity_batch:
  - "continuous finset_sum"
  - "ContinuousAt eventually constant"
  - "continuous polynomial evaluation"
```

### 3. Search Result Documentation Template

For EVERY search, document:

```markdown
## Search: "continuous finset sum"
**Found APIs**: None directly matching
**Related Found**: 
  - `ContinuousMultilinearMap.map_sum_finset` (multilinear specific)
  - `smooth_finset_sum` (deprecated alias)
**Pattern Learned**: No general continuous finset sum API
**Alternative**: Build from `continuous_add` inductively
**Database Action**: Add pattern to non-existent APIs
```

### 4. Immediate Contribution Scoring

When finding useful APIs:

```bash
# Don't just add the API
./api_tools.sh api-add "Polynomial.aeval_comp" "..." "..."

# Immediately add contribution
sqlite3 mathlib_apis.db "INSERT INTO sorry_contributions VALUES 
  ('Polynomial.aeval_comp', 'IrwinHallTheory', 233, 3, 
   'Connects polynomial operations to function evaluation')"
```

### 5. Failed Search Caching

Document what doesn't exist:

```bash
./api_tools.sh api-not-found "continuous_finset_sum" \
  "No direct API. Use induction with continuous_add or build from continuous_iff_continuousAt"

./api_tools.sh api-not-found "B-spline.*" \
  "B-spline theory not in mathlib4. Use alternative approaches or strategic retreat"
```

## Time Analysis

### Current Session (Actual):
- 8 searches performed
- 3 directly useful (37.5%)
- ~10 minutes total

### With Optimized Workflow (Estimated):
- 4 searches needed (50% reduction)
- 3 directly useful (75% hit rate)
- ~5 minutes total

### Savings: 50% time reduction

## Key Improvements

1. **Comment extraction first** - Would have found 4 APIs immediately
2. **Batch related searches** - Reduces context switching
3. **Document non-existence** - Prevents future redundant searches
4. **Score contributions immediately** - Better sorry prioritization
5. **Pattern recognition** - Use existing API patterns to formulate better queries

## Recommended Workflow Diagram

```
Read Sorry
    ↓
Extract API Names & Concepts
    ↓
Check Database for Exact Matches ←─┐
    ↓                               │
Found? → Yes → Check Usage → Done ─┘
    ↓
    No
    ↓
Mine Related API Patterns
    ↓
Formulate Targeted Batch Queries
    ↓
LeanExplore Search
    ↓
Document Results & Add to DB
```

This workflow emphasizes preparation and pattern recognition over exploratory searching.