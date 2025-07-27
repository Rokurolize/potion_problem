# Duplicate Content Frequency Report

## Most Frequently Duplicated Content

### 1. Field vs Direct Call Pattern - **5 occurrences**

**Exact/Near-Exact Duplicates:**
```lean
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add  -- WRONG
Summable.sum_add_tsum_nat_add k pmf_summable         -- CORRECT
```

**Files:**
1. **CLAUDE.md** - Implicit reference in "Owe" section about "invalid field errors"
2. **sorry-elimination-guide.md** - Lines 28-32
3. **sorry-elimination-core.md** - Lines 75-84
4. **sorry-elimination-patterns.md** - Lines 327-330
5. **api-library.md** - Lines 136-153

### 2. LeanExplore Wrapper Commands - **4 occurrences**

**Common Pattern:**
```bash
scripts/lle search "..." --package Mathlib --limit N
scripts/lle get [GROUP_ID]
scripts/lle dependencies [GROUP_ID]
```

**Files:**
1. **CLAUDE.md** - Lines 47-50, 69-82 (most comprehensive)
2. **sorry-elimination-core.md** - Lines 35-39
3. **sorry-elimination-patterns.md** - Lines 437-439
4. **Implicit in sorry-elimination-guide.md** via reference

### 3. Build Command Pattern - **4 occurrences**

**Exact Pattern:**
```bash
lake build PotionProblem.ModuleName
```

**Files:**
1. **CLAUDE.md** - Lines 30-32, 109
2. **sorry-elimination-guide.md** - Line 23
3. **sorry-elimination-core.md** - Lines 58-60, 122
4. **sorry-elimination-patterns.md** - Line 477

### 4. API Test File Creation - **4 occurrences**

**Common Pattern:**
```bash
echo "test_api.lean" >> .gitignore
lake env lean test_api.lean
```

**Files:**
1. **CLAUDE.md** - Implicit in API verification
2. **sorry-elimination-core.md** - Lines 52-54
3. **sorry-elimination-patterns.md** - Lines 440-441
4. **Referenced in sorry-elimination-guide.md**

### 5. Success Metrics Numbers - **3 occurrences**

**Exact Numbers:**
- "11+ sorries eliminated"
- "100% build success"
- "3 sorries remaining"

**Files:**
1. **CLAUDE.md** - Lines 12, 18
2. **sorry-elimination-guide.md** - Lines 41-43
3. **sorry-elimination-core.md** - Line 153

### 6. Argument Order Pattern - **3 occurrences**

**Pattern:**
```lean
Summable.sum_add_tsum_nat_add summability_proof k  -- Wrong order
Summable.sum_add_tsum_nat_add k summability_proof  -- k first, proof second
```

**Files:**
1. **sorry-elimination-core.md** - Lines 86-95
2. **sorry-elimination-patterns.md** - Lines 34-35, 332-334
3. **api-library.md** - Lines 43-44

### 7. Deprecated API: tsum_add - **3 occurrences**

**Warning Message:**
```lean
-- WARNING: `tsum_add` has been deprecated: use `Summable.tsum_add` instead
```

**Files:**
1. **sorry-elimination-patterns.md** - Lines 368-371
2. **api-library.md** - Lines 159-165
3. **Implicit in multiple code examples

### 8. Todo Update Instructions - **3 occurrences**

**Common Instructions:**
- "Mark current sorry as 'in_progress'"
- "Update TodoWrite after each sorry elimination"
- "Mark completed sorries as 'completed'"

**Files:**
1. **CLAUDE.md** - Accountability section
2. **sorry-elimination-core.md** - Lines 68-71, 130-135
3. **sorry-elimination-patterns.md** - Lines 463-468

## Unique Phrases Appearing Multiple Times

### "Never use mathlib APIs without verification" - **2 occurrences**
- sorry-elimination-guide.md: Line 34
- sorry-elimination-patterns.md: Line 336

### "Build-driven development" - **4 occurrences**
- Title/header in multiple files
- sorry-elimination-guide.md: Line 23
- sorry-elimination-core.md: Line 99
- sorry-elimination-patterns.md: Line 473

### "Strategic retreat" - **4 occurrences**
- sorry-elimination-guide.md: Lines 59-63
- sorry-elimination-patterns.md: Lines 359, 395, 397-428

### "Pre-verified APIs" - **5 occurrences**
- CLAUDE.md: Line 87
- sorry-elimination-guide.md: Line 22
- sorry-elimination-core.md: Lines 31, 160
- sorry-elimination-patterns.md: Line 436

## Code Snippet Duplication Analysis

### Most Duplicated Code Snippets:

1. **Field Access Error Example** (5 files)
   ```lean
   (Summable.hasSum pmf_summable).sum_add_tsum_nat_add
   ```

2. **LeanExplore Wrapper Command** (4 files)
   ```bash
   scripts/lle search "..." --package Mathlib
   ```

3. **Lake Build Command** (4 files)
   ```bash
   lake build PotionProblem.ModuleName
   ```

4. **Test File Creation** (4 files)
   ```bash
   echo "test_api.lean" >> .gitignore
   ```

## Recommendations Based on Frequency

### High Priority Consolidation (5+ duplicates):
1. **Field vs Direct Call Pattern** - Create single authoritative reference

### Medium Priority (3-4 duplicates):
1. **LeanExplore commands** - Standardize in one guide
2. **Build workflow** - Create central build guide
3. **API verification process** - Consolidate steps

### Low Priority (2 duplicates):
1. **Strategic retreat** - Acceptable redundancy
2. **Unique phrases** - Natural overlap

## Impact Analysis

### Positive Redundancy (Should Keep):
- Critical error patterns (field vs direct call)
- Core workflow commands (build, test)
- Safety reminders (API verification)

### Negative Redundancy (Should Remove):
- Exact success metrics in 3 places
- Identical code examples with no variation
- Repeated deprecation warnings

### Estimated Reduction Potential:
- Could reduce documentation by ~20-30% without losing critical information
- Would improve maintainability and consistency
- Reduce update burden when APIs change