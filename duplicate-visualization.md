# Duplicate Content Visualization - PotionProblem Docs

## Content Distribution Heat Map

```
                          CLAUDE  s-guide  s-core  s-patterns  api-lib  non-exist
Field vs Direct Call        ●       ●        ●●       ●●         ●●        -
LeanExplore Wrapper        ●●       ●        ●●       ●          -         ●
API Test Verification       ●       ●        ●●       ●          -         -
Build-Driven Dev           ●●       ●        ●●       ●          -         -
Success Metrics            ●       ●●        ●        -          -         -
Todo Tracking              ●       ●        ●●        ●          -         -
Deprecated APIs            -       -         -        ●●         ●●        -
Strategic Retreat          -       ●         -        ●●         -         -
Non-existent APIs         ●●       -         -        -          ●        ●●

Legend: - = Not present, ● = Present, ●● = Detailed coverage
```

## Duplication Impact Analysis

### Critical Safety Patterns (Keep Duplicated)
```
┌─────────────────────────────────────┐
│   Field vs Direct Call Pattern      │ ← Appears 5x
│   "MUST AVOID" - Causes build fails │ ← Keep in 3 places
└─────────────────────────────────────┘
         ↓            ↓            ↓
    [Guide]      [Core]      [Patterns]
```

### Workflow Instructions (Consolidate)
```
┌─────────────────────────────────────┐
│     Build + Test + Verify Flow      │ ← Appears 4x
│    "Same steps, different words"    │ ← Reduce to 1-2
└─────────────────────────────────────┘
         ↓
    [Create workflow-guide.md]
```

### Historical Data (Centralize)
```
┌─────────────────────────────────────┐
│      Success Metrics & Stats        │ ← Appears 3x
│    "11+ sorries eliminated..."      │ ← Move to summary
└─────────────────────────────────────┘
         ↓
    [Create metrics-dashboard.md]
```

## File Interconnection Map

```
                    CLAUDE.md
                   (Overview)
                  ╱    │    ╲
                ╱      │      ╲
              ╱        │        ╲
            ╱          │          ╲
     s-guide.md    s-core.md   api-library.md
    (Strategy)    (Workflow)    (Reference)
         ╲            │            ╱
           ╲          │          ╱
             ╲        │        ╱
               s-patterns.md
              (Advanced Tech)
```

## Duplication by Category

### 🔴 High Duplication (4-5x)
- Field vs Direct Call: **█████** (5)
- LeanExplore Commands: **████** (4)
- Build Commands: **████** (4)
- API Verification: **████** (4)

### 🟡 Medium Duplication (3x)
- Success Metrics: **███** (3)
- Todo Tracking: **███** (3)
- Deprecated APIs: **███** (3)
- Argument Order: **███** (3)

### 🟢 Low Duplication (2x)
- Strategic Retreat: **██** (2)
- Mathematical Context: **██** (2)

## Content Overlap Venn Diagram

```
        ┌────────────────────────────────┐
        │          CLAUDE.md             │
        │  ┌─────────────────────────┐  │
        │  │    ┌─────────────────┐  │  │
        │  │    │ ┌─────────────┐ │  │  │
        │  │    │ │Field vs Call│ │  │  │
        │  │    │ │Build Process│ │  │  │
        │  │    │ │(All 4 Docs) │ │  │  │
        │  │    │ └─────────────┘ │  │  │
        │  │    │   s-patterns    │  │  │
        │  │    └─────────────────┘  │  │
        │  │        s-core           │  │
        │  └─────────────────────────┘  │
        │           s-guide             │
        └────────────────────────────────┘
```

## Recommended Documentation Structure

### Current (Redundant)
```
Each file: 60-80% unique + 20-40% duplicate
Update burden: HIGH
User confusion: MEDIUM
```

### Proposed (Optimized)
```
Each file: 85-95% unique + 5-15% critical duplicates
Update burden: LOW
User confusion: LOW

Core references:
- common-errors.md (field patterns)
- workflow-guide.md (build/test)
- api-library.md (all APIs)
- metrics.md (progress tracking)
```

## Quick Reference: What's Where (After Consolidation)

| Looking for... | Primary Location | Also mentioned in |
|----------------|------------------|-------------------|
| Field vs Direct Call | common-errors.md | s-core (brief), s-patterns (brief) |
| Build Commands | workflow-guide.md | CLAUDE.md (essential only) |
| API Verification | api-library.md | s-core (reference only) |
| Success Metrics | metrics.md | CLAUDE.md (current status) |
| Todo Tracking | s-core.md | - |
| Deprecated APIs | api-library.md | - |
| Strategic Retreat | s-patterns.md | s-guide (concept only) |

## Implementation Priority

### Phase 1 (Immediate)
1. Extract Field vs Direct Call → `common-errors.md`
2. Consolidate build commands → `workflow-guide.md`
3. Update cross-references

### Phase 2 (This Week)
1. Centralize metrics → `metrics.md`
2. Clean up deprecated API mentions
3. Standardize code example formatting

### Phase 3 (Next Session)
1. Refactor guide hierarchy
2. Add automated duplication checking
3. Create maintenance guide

---

*This visualization demonstrates that while the PotionProblem documentation has significant duplication, much of it serves a purpose. The goal is not to eliminate all redundancy, but to be strategic about what we duplicate and why.*