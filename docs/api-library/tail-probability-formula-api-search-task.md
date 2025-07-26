# LeanExplore API Discovery Task: tail_probability_formula Sorry Elimination

**Target File**: `/home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md`  
**Target Sorry**: `ProbabilityFoundations.lean:217` - `tail_probability_formula`  
**Goal**: `(∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial`

## 🎯 MISSION STATEMENT

This task provides comprehensive, step-by-step instructions for using LeanExplore to systematically discover, verify, and document APIs required for eliminating the `tail_probability_formula` sorry. The task is designed to be:

- **Self-Contained**: Complete instructions with all necessary context
- **Iterative**: Can be run multiple times to expand documentation
- **Systematic**: Follows verified patterns to avoid redundant searches  
- **Future-Proof**: Documents failures to prevent repeated unsuccessful searches

## 📋 PRE-EXECUTION REQUIREMENTS

### Step 1: Read Current Documentation State
```bash
cat /home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md
```

**Identify Completion Status:**
- Count APIs marked as "✅ VERIFIED" (Current baseline: 7 verified)
- Count APIs marked as "❌ NON-EXISTENT" (Current baseline: 3 documented)
- Count APIs marked as "⚠️ DEPRECATED" (Current baseline: 2 clarified)
- Note any sections marked as "🔍 TO BE SEARCHED" or incomplete

**Already Verified (Do NOT Re-Search):**
- `Summable.tsum_eq_add_tsum_ite` (ID: 187683)
- `Set.indicator` (ID: 9175)
- `Summable.sum_add_tsum_nat_add` (ID: 187770)  
- `NNReal.tsum_eq_add_tsum_ite` (ID: 196698)
- `Nat.factorial_ne_zero` (ID: 98910)
- `tsum_lt_tsum` (ID: 187853)
- `PMF` type (ID: 165905)

**Already Documented as Non-Existent (Do NOT Re-Search):**
- `pmf_tail_probability`
- `tsum_gt` 
- `factorial_reciprocal_sum`

### Step 2: Mathematical Context Review
The `tail_probability_formula` requires proving:
```lean
(∑' k : ℕ, if k > n then hitting_time_pmf k else 0) = 1 / n.factorial
```

**Core Mathematical Challenges:**
1. **Conditional Infinite Sums**: `∑' k, if k > n then f k else 0` patterns
2. **Complement Decomposition**: Splitting infinite sums into finite + tail parts
3. **Index Manipulation**: Converting between different sum forms
4. **PMF Properties**: Probability mass function specific operations
5. **Factorial Operations**: Division by factorial, factorial properties

## 🔍 SYSTEMATIC LEANEXPLORE SEARCH PROTOCOL

### Phase 1: Conditional Sum API Discovery

#### Search Group A: Conditional Infinite Sums
Execute these searches and document ALL findings:

```bash
uv run leanexplore search "tsum.*if.*then.*else" --package Mathlib --limit 10
uv run leanexplore search "if.*tsum" --package Mathlib --limit 10  
uv run leanexplore search "conditional.*sum" --package Mathlib --limit 10
uv run leanexplore search "tsum.*condition" --package Mathlib --limit 10
uv run leanexplore search "ite.*tsum" --package Mathlib --limit 10
uv run leanexplore search "tsum.*ite" --package Mathlib --limit 10
```

**For Each Result:**
1. **If API exists**: Get details with `uv run leanexplore get [ID]`
2. **Record**: LeanExplore ID, file location, signature, informal description
3. **Assess relevance**: How does this apply to `if k > n then f k else 0` patterns?
4. **Document usage**: Provide concrete example for tail_probability_formula
5. **Import Discovery**: Check file path to determine required import statements
6. **Cross-Reference**: Verify not already documented in existing APIs

**Search Effectiveness Notes:**
- If search yields unrelated results (e.g., only basic if-then-else logic), mark as ineffective
- If search returns APIs already documented, note as confirmation but don't duplicate
- If search finds relevant new APIs, prioritize those with direct mathematical applications

#### Search Group B: Set-Based Conditional Operations  
```bash
uv run leanexplore search "tsum.*indicator" --package Mathlib --limit 10
uv run leanexplore search "sum.*indicator" --package Mathlib --limit 10
uv run leanexplore search "indicator.*tsum" --package Mathlib --limit 10
uv run leanexplore search "Set.piecewise" --package Mathlib --limit 10
```

#### Search Group C: Complement and Decomposition
```bash
uv run leanexplore search "tsum.*complement" --package Mathlib --limit 10
uv run leanexplore search "tsum.*compl" --package Mathlib --limit 10
uv run leanexplore search "sum.*complement" --package Mathlib --limit 10
uv run leanexplore search "decomposition.*sum" --package Mathlib --limit 10
```

### Phase 2: Probability-Specific API Discovery

#### Search Group D: PMF Operations  
**NOTE**: Previous searches for `pmf_tail_probability`, `probability.*tail`, `tail.*probability` found no specific APIs.

```bash
uv run leanexplore search "PMF.*sum" --package Mathlib --limit 10
uv run leanexplore search "PMF.*tsum" --package Mathlib --limit 10
uv run leanexplore search "PMF.*finite" --package Mathlib --limit 10
uv run leanexplore search "PMF.*support" --package Mathlib --limit 10
uv run leanexplore search "PMF.*filter" --package Mathlib --limit 10
uv run leanexplore search "PMF.*restrict" --package Mathlib --limit 10
```

**Expected Outcome**: Based on previous session, PMF tail operations likely don't exist as specialized APIs. Focus on general PMF operations that could be adapted.

#### Search Group E: Advanced Summation
```bash
uv run leanexplore search "tsum.*range" --package Mathlib --limit 10
uv run leanexplore search "tsum.*interval" --package Mathlib --limit 10
uv run leanexplore search "sum.*tail" --package Mathlib --limit 10
uv run leanexplore search "series.*tail" --package Mathlib --limit 10
```

### Phase 3: Index Manipulation and Factorial APIs

#### Search Group F: Index Operations
```bash
uv run leanexplore search "tsum.*shift" --package Mathlib --limit 10
uv run leanexplore search "sum.*shift" --package Mathlib --limit 10
uv run leanexplore search "reindex.*sum" --package Mathlib --limit 10
uv run leanexplore search "tsum.*map" --package Mathlib --limit 10
```

#### Search Group G: Factorial Operations
```bash
uv run leanexplore search "factorial.*sum" --package Mathlib --limit 10
uv run leanexplore search "factorial.*tsum" --package Mathlib --limit 10
uv run leanexplore search "factorial.*series" --package Mathlib --limit 10
uv run leanexplore search "exponential.*series" --package Mathlib --limit 10
```

## 🔧 RESULT INTERPRETATION AND ERROR HANDLING

### Handling LeanExplore Output

#### ✅ Successful API Discovery
When LeanExplore returns relevant results:
1. **Extract LeanExplore ID** from the result header
2. **Run `uv run leanexplore get [ID]`** to get complete details
3. **Verify relevance** to conditional sums, PMF operations, or factorial arithmetic
4. **Check import path** from file location to determine required imports
5. **Look for deprecation warnings** in docstrings or descriptions

#### ⚠️ Handling Irrelevant Results
When search returns unrelated APIs:
1. **Document the search term as ineffective** for future reference
2. **Note what types of APIs it returned instead** (e.g., basic arithmetic, unrelated domains)
3. **Consider refinement** - sometimes adding more specific terms helps
4. **Mark search as completed but unsuccessful**

#### ❌ Handling Search Failures  
When LeanExplore returns no relevant results:
1. **Verify search syntax** - ensure regex patterns are properly formed
2. **Try variations** - alternate spellings, abbreviations, related terms
3. **Document negative finding** with attempted variations
4. **Mark as definitively non-existent** only after multiple variations tried

#### 🔄 Cross-Reference Validation
Before documenting new APIs:
1. **Search existing documentation** for the API name or ID
2. **Check if it's an alias** of already documented APIs  
3. **Verify it's not already covered** under different naming
4. **Update existing entries** if you find additional details rather than creating duplicates

### Import Path Discovery

For each verified API, determine imports by:
1. **File path analysis**: `Mathlib/Path/To/File.lean` → `import Mathlib.Path.To.File`
2. **LeanExplore dependencies**: Use `uv run leanexplore dependencies [ID]` if available
3. **Test minimal import**: Create minimal test to verify import requirements

### Search Term Effectiveness Tracking

**Effective Patterns (from previous session):**
- `"tsum"` - General infinite sum APIs
- `"Summable.tsum_"` - Modern summability APIs
- `"Set.indicator"` - Conditional function patterns
- `"factorial_ne_zero"` - Factorial properties

**Ineffective Patterns (avoid in future):**
- `"pmf_tail"` - No PMF-specific tail APIs exist
- `"tsum_gt"` - No greater-than specific APIs
- `"factorial_reciprocal"` - No specialized factorial sum APIs

## 📝 DOCUMENTATION REQUIREMENTS

### For Each API Found:

#### ✅ VERIFIED APIs
Document with this template:
```markdown
#### `API_NAME` ⭐ **BRIEF_DESCRIPTION**
**Status**: ✅ **VERIFIED** (mathlib4 v4.21.0)  
**LeanExplore ID**: [ID]  
**File**: [File path]  
**Signature**: [Exact signature]  
**Import**: `import [Required import]`  
**Why Critical**: [Specific relevance to tail_probability_formula]  
**Usage Pattern**:
```lean
-- Concrete example showing how this applies to our sorry
[Working code example]
```
**Mathematical Foundation**: [Why this works mathematically]
```

#### ❌ NON-EXISTENT APIs  
Document failed searches to prevent future attempts:
```markdown
#### `SEARCH_TERM` - **NON-EXISTENT**
**Search Attempted**: `uv run leanexplore search "TERM" --package Mathlib`
**Results**: [Description of what was found instead]
**Implication**: [What this means for implementation approach]
**Alternative Approach**: [What to use instead]
```

#### ⚠️ DEPRECATED APIs
For any deprecated APIs found:
```markdown
#### `OLD_API` → `NEW_API` ⚠️ **DEPRECATED**
**Status**: ⚠️ **DEPRECATED** as of [DATE] (but still functional)  
**LeanExplore ID**: [ID]  
**File**: [File path]  
**Deprecation Note**: "[Exact deprecation message]"  
**Modern Replacement**: `[Recommended new API]`
**Migration Pattern**: 
```lean
-- ❌ OLD (deprecated)
[Old usage]

-- ✅ NEW (recommended)  
[New usage]
```
```

### Critical Documentation Sections to Update:

1. **📊 LEANEXPLORE SESSION SUMMARY**
   - Update counts: "XX Critical APIs Verified", "XX Non-Existent APIs Documented", "XX Deprecation Status Clarified"
   - Add new search session date and findings summary

2. **🎯 OPTIMIZED MODERN APPROACH**
   - Integrate newly found APIs into the implementation strategy
   - Update code examples with latest verified APIs

3. **❌ NON-EXISTENT APIS (NEGATIVE FINDINGS - VERIFIED)**
   - Add new failed searches to prevent future redundant attempts
   - Document ineffective search patterns

4. **⚠️ DEPRECATED APIS AND MODERN REPLACEMENTS**
   - Add newly discovered deprecations
   - Update migration recommendations

## 🔄 ITERATIVE EXECUTION PROTOCOL

### Session Execution Steps:

1. **Read Current State**: Load existing documentation and note completion status
2. **Execute Search Groups**: Run searches systematically, one group at a time
3. **Document Findings**: Update documentation with verified template format
4. **Update Summary**: Refresh counts and overall assessment
5. **Commit Changes**: Git commit with descriptive message about new findings

### Quality Verification:

After each search group, verify:
- [ ] All results are documented (even negative findings)
- [ ] LeanExplore IDs are recorded for verified APIs
- [ ] Exact signatures are captured
- [ ] Usage examples are provided for relevant APIs
- [ ] Import requirements are specified
- [ ] Non-existent searches are documented to prevent repetition

### Success Metrics:

A successful session should result in:
- **Comprehensive Coverage**: All planned search terms executed
- **Clear Documentation**: Every finding documented with required details
- **Negative Documentation**: Failed searches recorded to prevent future duplication
- **Updated Summary**: Accurate counts and strategic assessment
- **Implementation Ready**: New APIs integrated into practical usage patterns

## 🎯 OUTPUT REQUIREMENTS

### Updated Documentation Must Include:

1. **Precise Counts**: 
   - "✅ XX Critical APIs Verified"
   - "❌ XX Non-Existent APIs Documented"  
   - "⚠️ XX Deprecation Status Clarified"

2. **Complete API Details**: Every verified API with LeanExplore ID, signature, usage example

3. **Negative Findings**: Every failed search documented with implications

4. **Strategic Assessment**: Updated implementation approach incorporating new findings

5. **Session Metadata**: Date, search groups completed, summary of discoveries

### Final Verification Checklist:

- [ ] All LeanExplore searches executed and documented
- [ ] New APIs integrated into implementation strategy
- [ ] Negative findings documented to prevent repetition
- [ ] Documentation counts updated accurately
- [ ] Changes committed to git with descriptive message
- [ ] Ready for next iteration or implementation phase

## 📝 COMPREHENSIVE FILE UPDATE PROTOCOL

**CRITICAL**: This section provides detailed instructions for updating the target file (`tail-probability-formula-apis.md`) with new findings. Since this task will be executed repeatedly, proper file integration is essential to avoid data loss and maintain documentation quality.

### Phase 1: Pre-Update Analysis

#### Step 1.1: Read Current File State
```bash
# Read the entire target file to understand current structure
cat /home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md
```

**Analysis Requirements:**
- **Count existing APIs**: Note exact count of "✅ VERIFIED" APIs currently documented
- **Identify sections**: Locate key sections (CRITICAL INFINITE SUM APIs, VERIFIED EXISTENCES, NON-EXISTENCES, etc.)
- **Check session headers**: Review existing LeanExplore session records to avoid duplication
- **Note file structure**: Understand current organization and formatting patterns

#### Step 1.2: Validate File Integrity
- **Check for corruption**: Ensure file is readable and properly formatted
- **Verify sections exist**: Confirm all major sections are present and accessible
- **Note inconsistencies**: Document any formatting issues or missing content

### Phase 2: Content Integration Strategy

#### Step 2.1: Categorize New Findings
**For each new API discovered:**
1. **Determine category**: Critical breakthrough, supporting API, or minor finding
2. **Check for duplicates**: Verify API not already documented (search by name and LeanExplore ID)
3. **Assess relevance**: Rate importance for tail_probability_formula (⭐⭐⭐⭐⭐ scale)
4. **Prepare integration**: Draft content using exact templates from documentation requirements

#### Step 2.2: Handle Conflicts and Contradictions
**If new findings contradict existing documentation:**
1. **Verify accuracy**: Re-check LeanExplore results for both old and new information
2. **Document discrepancy**: Note what changed and why in session headers
3. **Update accordingly**: Replace outdated information with verified current data
4. **Preserve history**: Keep record of what was changed in commit messages

### Phase 3: File Update Execution

#### Step 3.1: Strategic Content Placement

**New Critical APIs (⭐⭐⭐⭐⭐ and ⭐⭐⭐⭐):**
- **Location**: Add to "NEWLY DISCOVERED" subsection under "⭐ CRITICAL INFINITE SUM APIs"
- **Format**: Use exact template with full details (LeanExplore ID, file location, usage patterns)
- **Order**: Place highest-relevance APIs first within each subsection

**Supporting APIs (⭐⭐⭐ and below):**
- **Location**: Add to appropriate existing sections or create new subsections as needed
- **Format**: Include essential details but may abbreviate usage examples

**Non-Existent APIs:**
- **Location**: Add to "❌ VERIFIED NON-EXISTENCES" section
- **Organization**: Group by search category (A-G groups)
- **Format**: Include search term, what was found instead, implications

#### Step 3.2: Update Key Sections Systematically

**Section Update Order:**
1. **Add new APIs first**: Insert new findings in appropriate sections using Read + Edit tools
2. **Update counts**: Refresh "✅ VERIFIED EXISTENCES (XX Critical APIs)" with new totals
3. **Revise strategy**: Update "MULTIPLE IMPLEMENTATION STRATEGIES" if new breakthroughs found
4. **Add session header**: Create new session record with current date and findings summary
5. **Update strategic impact**: Revise overall assessment based on new capabilities

#### Step 3.3: Specific File Editing Procedures

**Use MultiEdit for efficiency:**
```lean
-- Example MultiEdit for adding multiple new APIs
MultiEdit({
  file_path: "/home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md",
  edits: [
    {old_string: "### **NEWLY DISCOVERED", new_string: "### **NEWLY DISCOVERED (2025-XX-XX SESSION)\n\n### `NEW_API_NAME` ⭐⭐⭐⭐⭐ **DESCRIPTION**\n[Full API documentation]\n\n### **PREVIOUSLY DISCOVERED"},
    {old_string: "### ✅ VERIFIED EXISTENCES (XX Critical APIs)", new_string: "### ✅ VERIFIED EXISTENCES (YY Critical APIs)"},
    // ... additional edits
  ]
})
```

**Safety practices:**
- **One section at a time**: Update file incrementally to catch errors early
- **Verify after each edit**: Read section after modification to ensure correctness
- **Preserve formatting**: Maintain consistent markdown structure and indentation

### Phase 4: Quality Verification

#### Step 4.1: Post-Update Validation
```bash
# Verify file structure and readability
cat /home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md | head -50
cat /home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md | tail -50

# Check for formatting issues
grep -n "###" /home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md
```

**Validation Checklist:**
- [ ] All new APIs properly formatted with required fields
- [ ] No duplicate entries (check both by name and LeanExplore ID)
- [ ] Counts accurately reflect actual number of documented APIs
- [ ] Session header added with correct date and findings
- [ ] Strategic sections updated to reflect new capabilities
- [ ] Markdown formatting consistent throughout
- [ ] No broken links or malformed sections

#### Step 4.2: Content Accuracy Verification
- **Cross-reference IDs**: Ensure all LeanExplore IDs are correctly transcribed
- **Verify signatures**: Check that API signatures match LeanExplore output exactly
- **Import statements**: Confirm import paths are correct and complete
- **Usage examples**: Verify code examples are syntactically correct

### Phase 5: Error Handling and Rollback

#### Step 5.1: Error Detection
**Common errors to watch for:**
- **File corruption**: Partial edits that break markdown structure
- **Content loss**: Accidental deletion of existing valuable information
- **Duplicate entries**: Adding APIs that already exist under different names
- **Format inconsistency**: Breaking established documentation patterns

#### Step 5.2: Rollback Procedures
**If file update introduces errors:**
1. **Immediate assessment**: Determine scope and severity of errors
2. **Git rollback**: Use `git checkout HEAD^ -- [file]` to restore previous version
3. **Incremental retry**: Re-attempt updates one section at a time
4. **Error documentation**: Record what went wrong for future prevention

```bash
# Emergency rollback commands
git status  # Check current state
git diff HEAD^ -- docs/api-library/tail-probability-formula-apis.md  # See what changed
git checkout HEAD^ -- docs/api-library/tail-probability-formula-apis.md  # Rollback if needed
```

### Phase 6: Final Commit and Documentation

#### Step 6.1: Commit Message Standards
**Format:** `[API-DISCOVERY] Add [N] new APIs from 2025-XX-XX LeanExplore session`

**Include in commit message:**
- Number of new APIs discovered
- Most significant breakthrough (if any)
- Search groups completed
- Any major strategy changes

**Example:**
```
[API-DISCOVERY] Add 15+ new APIs from 2025-07-26 LeanExplore session

- BREAKTHROUGH: Complex.sum_div_factorial_le provides direct factorial bounds
- Added sophisticated PMF.filter operations for conditional probability
- Discovered enhanced complement decomposition APIs
- Expanded from 12 to 25+ verified APIs across all 7 search groups
- Updated implementation strategies with 4 distinct approaches
```

#### Step 6.2: Post-Commit Verification
```bash
# Verify commit was successful
git log --oneline -3
git show --stat  # Verify correct files were committed

# Confirm file is accessible and readable
head -20 /home/ubuntu/workbench/projects/potion_problem/docs/api-library/tail-probability-formula-apis.md
```

### Phase 7: Session Completion Standards

#### Step 7.1: Final Documentation Requirements
**Session must include:**
- [ ] **Complete API documentation**: All discovered APIs with full details
- [ ] **Negative findings**: All failed searches documented to prevent repetition  
- [ ] **Updated counts**: Accurate numbers reflecting new total of verified APIs
- [ ] **Session header**: New section documenting this session's contributions
- [ ] **Strategic impact**: Updated assessment of implementation approaches
- [ ] **Future guidance**: Recommendations for next session focus (if applicable)

#### Step 7.2: Success Validation
**Session considered successful when:**
- **No data loss**: All existing valuable information preserved
- **Clear improvements**: Documented new capabilities for sorry elimination
- **Reproducible**: Another Claude Code session could continue from this state
- **Self-contained**: Documentation includes all necessary context and instructions

### 🚨 CRITICAL FAILURE MODES TO AVOID

1. **Overwriting existing content**: Always check for existing documentation before adding
2. **Inconsistent formatting**: Maintain established patterns and templates
3. **Duplicate documentation**: Cross-check both API names and LeanExplore IDs
4. **Broken references**: Ensure all links and cross-references remain valid
5. **Count mismatches**: Verify numbers in headers match actual documented APIs
6. **Lost session history**: Always preserve records of previous search sessions

## 🔄 MULTI-SESSION COORDINATION

### Progress Tracking Between Sessions

**Session Header Template** (add to documentation after each session):
```markdown
### LeanExplore Session: [DATE]
**Search Groups Completed**: [List groups A-G completed]
**New APIs Discovered**: [Count]
**New Non-Existent Documented**: [Count]  
**New Deprecations Found**: [Count]
**Next Session Focus**: [Recommended next search areas]
```

### Avoiding Redundant Work

**Before Starting Each Session:**
1. **Review session headers** in documentation to see what's been covered
2. **Check Already Verified section** to avoid re-searching known APIs
3. **Review Already Documented as Non-Existent** to skip failed searches
4. **Identify gaps** in search group coverage

**Session Planning:**
- **First Session**: Focus on Groups A-C (conditional sums, most critical)
- **Second Session**: Focus on Groups D-E (PMF operations, advanced summation)  
- **Third Session**: Focus on Groups F-G (index manipulation, factorial operations)
- **Follow-up Sessions**: Target gaps identified in previous sessions

### Quality Assurance Checklist

**Before Committing Documentation Updates:**
- [ ] All search terms executed as planned
- [ ] Every result documented (including negative findings)
- [ ] No duplicate entries with existing documentation
- [ ] All LeanExplore IDs cross-referenced
- [ ] Import requirements specified for new APIs
- [ ] Session header added with progress summary
- [ ] Updated counts reflect actual findings

### Effectiveness Metrics

**High-Value Session Indicators:**
- Discovers 2+ new relevant APIs
- Documents 3+ non-existent searches to prevent future duplication
- Finds modern replacements for deprecated APIs
- Establishes clear import requirements

**Session Success Criteria:**
- Documentation counts accurately updated
- No redundant searches performed  
- Clear guidance provided for implementation
- Next session focus identified

---

**Execution Note**: This task is designed to be run multiple times as the API discovery process evolves. Each execution should build upon previous findings while avoiding redundant searches through comprehensive negative finding documentation. The systematic approach ensures maximum efficiency across multiple Claude Code sessions.