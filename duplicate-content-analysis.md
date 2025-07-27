# Duplicate Content Analysis for PotionProblem Documentation

## Executive Summary

This analysis identifies duplicate content patterns across the PotionProblem documentation files. Significant duplication exists in critical areas, particularly around API verification workflows, anti-patterns, and build-driven development processes.

## Files Analyzed

1. **CLAUDE.md** - Main project documentation
2. **docs/sorry-elimination-guide.md** - Overview guide
3. **docs/sorry-elimination-core.md** - Core workflow guide
4. **docs/sorry-elimination-patterns.md** - Technical patterns guide
5. **docs/api-library.md** - Verified API reference
6. **list-of-non-existent-mathlib-apis.md** - Non-existent API tracking

## Major Duplicate Content Patterns

### 1. Field vs Direct Call Anti-Pattern (APPEARS 5 TIMES)

**Locations:**
- CLAUDE.md (implicitly referenced)
- sorry-elimination-guide.md (lines 28-32)
- sorry-elimination-core.md (lines 75-84)
- sorry-elimination-patterns.md (lines 327-330)
- api-library.md (lines 136-153)

**Exact Pattern:**
```lean
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add  -- WRONG
Summable.sum_add_tsum_nat_add k pmf_summable         -- CORRECT
```

**Analysis:** This is the most duplicated pattern, appearing in every major documentation file. Shows critical importance but also redundancy.

### 2. API Verification Workflow (APPEARS 4 TIMES)

**Locations:**
- CLAUDE.md (lines 44-83) - LeanExplore wrapper usage
- sorry-elimination-core.md (lines 34-55) - Pre-attack checklist
- sorry-elimination-patterns.md (lines 432-441) - API-first verification
- sorry-elimination-guide.md (references core.md)

**Common Elements:**
- Use `scripts/lle` wrapper, not raw LeanExplore
- Create test_api.lean for verification
- Check pre-verified APIs first
- `lake env lean test_api.lean` verification step

### 3. Build-Driven Development Process (APPEARS 4 TIMES)

**Locations:**
- CLAUDE.md (lines 109-110) - "lake build after every change"
- sorry-elimination-guide.md (line 23)
- sorry-elimination-core.md (lines 99-125)
- sorry-elimination-patterns.md (lines 473-482)

**Common Pattern:**
```bash
lake build PotionProblem.ModuleName  # After each change
# Only commit if build succeeds
```

### 4. Success Metrics & Patterns (APPEARS 3 TIMES)

**Locations:**
- CLAUDE.md (lines 113-116) - Accountability metrics
- sorry-elimination-guide.md (lines 38-50)
- sorry-elimination-core.md (lines 150-163)

**Common Metrics:**
- 11+ sorries eliminated
- 100% build success maintained
- Main theorem complete (E[τ] = e)

### 5. Deprecated API Warnings (APPEARS 3 TIMES)

**Locations:**
- sorry-elimination-patterns.md (lines 23-36) - sum_add_tsum_nat_add
- sorry-elimination-patterns.md (lines 368-371) - tsum_add, cases'
- api-library.md (lines 34-45, 159-179)

**Common Deprecated APIs:**
- `Summable.sum_add_tsum_nat_add` (deprecated but functional)
- `tsum_add` → `Summable.tsum_add`
- `cases'` → `obtain`/`rcases`/`cases`
- `Finset.not_mem_empty` → `Finset.notMem_empty`

### 6. Todo Tracking Instructions (APPEARS 3 TIMES)

**Locations:**
- CLAUDE.md (implicitly in accountability)
- sorry-elimination-guide.md (line 24)
- sorry-elimination-core.md (lines 67-71, 129-135)

**Common Pattern:**
- Mark current sorry as "in_progress"
- Update after completion
- Maintain clear progress visibility

### 7. Strategic Retreat Documentation (APPEARS 2 TIMES)

**Locations:**
- sorry-elimination-guide.md (lines 59-63)
- sorry-elimination-patterns.md (lines 397-428)

**Full Pattern Appears in sorry-elimination-patterns.md:**
```lean
-- STRATEGIC RETREAT: Enhanced Documentation for Future Sessions
-- [Complete framework with mathematical foundation, validation, challenges]
sorry
```

### 8. Non-Existent API Reference (APPEARS 3 TIMES)

**Locations:**
- CLAUDE.md (lines 87-99) - References list file
- sorry-elimination-guide.md (references api-library.md)
- list-of-non-existent-mathlib-apis.md (full list)

## Content Redundancy Analysis

### High Redundancy Items (4+ occurrences):
1. **Field vs Direct Call Pattern** - 5 occurrences
2. **API Verification Workflow** - 4 occurrences  
3. **Build-Driven Development** - 4 occurrences

### Medium Redundancy Items (3 occurrences):
1. **Success Metrics** - 3 occurrences
2. **Deprecated API Warnings** - 3 occurrences
3. **Todo Tracking** - 3 occurrences
4. **Non-Existent API References** - 3 occurrences

### Low Redundancy Items (2 occurrences):
1. **Strategic Retreat Framework** - 2 occurrences

## Unique Content by File

### CLAUDE.md Unique Content:
- Essential development commands
- High-level architecture diagram
- Mathematical background
- "Owe" narrative section
- Module dependencies visualization

### sorry-elimination-core.md Unique Content:
- "Fight One Sorry to the Death" principle
- Pre-attack checklist detail
- Progressive refinement patterns
- TDD-style verification

### sorry-elimination-patterns.md Unique Content:
- Extensive technical patterns (20+ specific patterns)
- Session anti-patterns
- January 2025 session insights
- Complex proof recognition patterns

### api-library.md Unique Content:
- Comprehensive API signatures
- Import requirements
- API IDs and verification status
- Session warnings detail

## Recommendations

1. **Consolidate Field vs Direct Call Pattern**: Create single reference point since it appears 5 times

2. **Unify API Verification Workflow**: Standardize in one location and reference from others

3. **Create Central Success Metrics Dashboard**: Instead of repeating in multiple files

4. **Deprecation Warning Central List**: Maintain in api-library.md only

5. **Reduce Build Process Redundancy**: Keep detailed version in one place, brief references elsewhere

6. **Strategic Value of Current Redundancy**: Some redundancy (like critical anti-patterns) may be intentional for emphasis and accessibility from different entry points