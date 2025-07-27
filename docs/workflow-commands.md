# Workflow Commands Reference

*Centralized reference for all build, test, and verification commands*

**Purpose**: Single source for all command-line operations previously duplicated across multiple documentation files.

## 🏗️ Build Commands

### Essential Build Operations

```bash
# Full project build
lake build

# Build specific module
lake build PotionProblem.Main
lake build PotionProblem.ProbabilityFoundations

# Clean build (after major changes)
lake clean && lake build

# Build with error output capture
lake build 2>&1 | tee build_errors.log
```

### Build Status Verification

```bash
# Check build success
lake build
echo "Exit code: $?"  # 0 = success

# Quick build status check
lake build 2>&1 | grep -E "(error:|Build completed)"
```

## 📊 Progress Monitoring

### Sorry Count Commands

```bash
# Count total remaining sorries
lake build 2>&1 | grep "declaration uses 'sorry'" | wc -l

# Find specific sorries with line numbers
grep -n "sorry" PotionProblem/*.lean

# Count sorries per file
for f in PotionProblem/*.lean; do 
  echo "$f: $(grep -c "sorry" "$f")"
done

# List all sorry locations
grep -n "sorry" PotionProblem/*.lean | grep -v "-- sorry"
```

### Deprecation Warning Check

```bash
# Find all deprecation warnings
lake build 2>&1 | grep "deprecated"

# Check specific deprecated APIs
grep -r "tsum_add\|cases'\|not_mem_empty" PotionProblem/
```

## 🔍 API Verification Workflow

See @/home/ubuntu/workbench/projects/potion_problem/docs/mcp-leanexplore-workflow.md for complete MCP LeanExplore usage.

### API Testing Workflow

After finding an API with MCP LeanExplore, create a test file:

```bash
# Create test file in project root
cat > test_api.lean << 'EOF'
import Mathlib.Required.Module  # From API details

variable {α : Type*} {f : ℕ → α} (hf : Summable f) (k : ℕ)
#check API.name args  # Use exact signature
EOF

# Add to .gitignore if not already there
echo "test_api.lean" >> .gitignore

# Verify compilation
lake env lean test_api.lean

# Clean up after verification
rm test_api.lean
```

## 🔧 Development Workflow

### Test-Driven Development Cycle

```bash
# 1. Make change to file
# 2. Build specific module
lake build PotionProblem.ModuleName

# 3. If errors, capture and analyze
lake build PotionProblem.ModuleName 2>&1 | tee errors.log

# 4. Fix errors and rebuild
# 5. Only commit after successful build
git add PotionProblem/ModuleName.lean
git commit -m "[TAG] Specific change description"
```

### Incremental Build Pattern

```bash
# After each significant change
lake build 2>&1 | tail -20  # See just the summary

# For continuous monitoring (in separate terminal)
watch -n 5 'lake build 2>&1 | grep -E "(error:|sorry|Build)"'
```

## 📝 Git Workflow Commands

### Pre-Commit Verification

```bash
# Always run before committing
lake build && echo "✓ Build successful"

# Check what will be committed
git status
git diff --cached

# Commit with descriptive message
git commit -m "[CATEGORY] Description"
```

### Common Commit Tags
- `[FIX]` - Sorry elimination
- `[DOCS]` - Documentation updates
- `[API]` - API usage updates
- `[BUILD]` - Build configuration changes
- `[REFACTOR]` - Code reorganization

## 🚀 Quick Reference

### Most Used Commands

```bash
# Build and count sorries
lake build && grep -c "sorry" PotionProblem/*.lean

# Build specific file and check errors
lake build PotionProblem.FileName 2>&1 | grep "error"
```

**For API Search**: See [`mcp-leanexplore-workflow.md`](mcp-leanexplore-workflow.md)

### Emergency Commands

```bash
# When build is completely broken
lake clean
lake update
lake build

# Reset to last known good state
git stash
git checkout main
lake build
```

## 🔗 Related Documentation

- For error patterns: [`common-errors.md`](common-errors.md)
- For API search: [`mcp-leanexplore-workflow.md`](mcp-leanexplore-workflow.md)
- For verified APIs: [`api-library.md`](api-library.md)
- For success metrics: [`success-metrics.md`](success-metrics.md)