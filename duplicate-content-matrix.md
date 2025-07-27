# Duplicate Content Matrix - PotionProblem Documentation

## Content Duplication Matrix

Legend: ✓ = Present, ✓✓ = Detailed coverage, - = Not present

| Content Pattern | CLAUDE.md | sorry-elim-guide | sorry-elim-core | sorry-elim-patterns | api-library | non-existent-apis |
|-----------------|-----------|------------------|-----------------|---------------------|-------------|-------------------|
| **Field vs Direct Call Anti-Pattern** | ✓ | ✓ | ✓✓ | ✓✓ | ✓✓ | - |
| **LeanExplore Wrapper Usage** | ✓✓ | ✓ | ✓✓ | ✓ | - | ✓ |
| **Test API Verification Process** | ✓ | ✓ | ✓✓ | ✓ | - | - |
| **Build-Driven Development** | ✓✓ | ✓ | ✓✓ | ✓ | - | - |
| **Success Metrics (11+ sorries)** | ✓ | ✓✓ | ✓ | - | - | - |
| **Todo Tracking Instructions** | ✓ | ✓ | ✓✓ | ✓ | - | - |
| **Deprecated API Warnings** | - | - | - | ✓✓ | ✓✓ | - |
| **Strategic Retreat Framework** | - | ✓ | - | ✓✓ | - | - |
| **Pre-verified API Check** | ✓ | ✓ | ✓✓ | ✓ | - | - |
| **Argument Order Mistakes** | - | ✓ | ✓✓ | ✓ | ✓ | - |
| **Non-existent API Reference** | ✓✓ | - | - | - | ✓ | ✓✓ |
| **Build Error Analysis Pattern** | - | ✓ | ✓ | ✓ | - | - |
| **Commit Workflow** | ✓ | ✓ | ✓ | ✓ | - | - |
| **"Fight One Sorry" Principle** | - | - | ✓✓ | - | - | - |
| **Mathematical Background** | ✓✓ | ✓ | - | - | - | - |
| **Module Architecture** | ✓✓ | - | - | - | - | - |

## Duplication Frequency Analysis

### Content Appearing in 5 Files:
- **Field vs Direct Call Anti-Pattern**

### Content Appearing in 4 Files:
- **LeanExplore Wrapper Usage**
- **Build-Driven Development**
- **Pre-verified API Check**
- **Commit Workflow**

### Content Appearing in 3 Files:
- **Test API Verification Process**
- **Success Metrics**
- **Todo Tracking Instructions**
- **Argument Order Mistakes**
- **Build Error Analysis Pattern**

### Content Appearing in 2 Files:
- **Deprecated API Warnings**
- **Strategic Retreat Framework**
- **Non-existent API Reference**
- **Mathematical Background**

## Detailed Duplication Examples

### 1. Most Duplicated: Field vs Direct Call Pattern

**sorry-elimination-guide.md:**
```lean
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add  -- WRONG
Summable.sum_add_tsum_nat_add k pmf_summable         -- CORRECT
```

**sorry-elimination-core.md:**
```lean
# Field vs Direct Call Confusion
**❌ WRONG** - Causes "invalid field" errors:
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add
**✅ CORRECT** - Direct namespace access:
Summable.sum_add_tsum_nat_add k pmf_summable
```

**sorry-elimination-patterns.md:**
```lean
**❌ Accessing APIs as Fields Instead of Direct Calls**:
- **Wrong**: `(Summable.hasSum pmf_summable).sum_add_tsum_nat_add` 
- **Error**: "invalid field 'sum_add_tsum_nat_add'"
- **Correct**: `Summable.sum_add_tsum_nat_add k pmf_summable`
```

**api-library.md:**
```lean
### Field Access Pattern
-- WRONG: Trying to access API as field
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add
### ✅ Correct Direct Call Pattern
-- CORRECT: Direct namespace access with proper argument order
Summable.sum_add_tsum_nat_add k summability_proof
```

### 2. LeanExplore Wrapper Usage Pattern

**CLAUDE.md (Most Detailed):**
- Full usage examples with all flags
- Rationale for wrapper requirement
- Multiple command examples

**sorry-elimination-core.md:**
```bash
scripts/lle search "lemma_name" --package Mathlib --limit 5
scripts/lle get [GROUP_ID]  # Get exact signature
scripts/lle dependencies [GROUP_ID]  # Get import requirements
```

**sorry-elimination-patterns.md:**
```bash
scripts/lle search "api_name" --package Mathlib    # Only if not in library (use wrapper!)
scripts/lle get [GROUP_ID]                        # Get exact signature (use wrapper!)
```

### 3. Success Metrics Duplication

**CLAUDE.md:**
- Primary metric: Sorry count reduction
- Secondary metrics: Build success
- 3 sorries remaining = MISSION FAILED

**sorry-elimination-guide.md:**
- ✅ **11+ sorries eliminated** using systematic approach
- ✅ **100% build success** maintained throughout
- ✅ **Main theorem complete** (E[τ] = e) with 0 sorries

**sorry-elimination-core.md:**
- Same metrics repeated with "Based on Actual Experience" qualifier

## Content Organization Insights

### Intentional Redundancy (Valuable):
1. **Field vs Direct Call** - Critical error pattern, worth emphasizing
2. **Build-Driven Development** - Core workflow principle
3. **API Verification** - Prevents common failures

### Unintentional Redundancy (Could Consolidate):
1. **Success Metrics** - Could be in one summary location
2. **Argument Order Mistakes** - Subset of Field vs Direct Call
3. **Deprecated API Lists** - Should be centralized

### Well-Distributed Content:
1. **Strategic Retreat** - Appropriately in guide + patterns
2. **Mathematical Background** - Correctly in CLAUDE.md only
3. **Module Architecture** - Unique to CLAUDE.md

## Recommendations for Consolidation

1. **Create `common-patterns.md`** for the Field vs Direct Call pattern
2. **Centralize deprecated APIs** in api-library.md only
3. **Move success metrics** to a single dashboard file
4. **Keep critical patterns** duplicated for emphasis but with consistent wording
5. **Add cross-references** instead of full duplication for some content