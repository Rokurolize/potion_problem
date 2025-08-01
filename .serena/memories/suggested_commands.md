# Suggested Commands for Potion Problem Development

## Build Commands

### Essential Build Operations
```bash
# Full project build
lake build

# Build specific module
lake build PotionProblem.Main
lake build PotionProblem.IrwinHallTheory

# Clean build (after major changes)
lake clean && lake build

# Build with error output capture
lake build 2>&1 | tee build_errors.log
```

## Progress Monitoring

### Check Remaining Sorries
```bash
# Count total remaining sorries
lake build 2>&1 | grep "declaration uses 'sorry'" | wc -l

# Find specific sorries with line numbers
grep -n "sorry" PotionProblem/*.lean

# Count sorries per file
for f in PotionProblem/*.lean; do 
  echo "$f: $(grep -c "sorry" "$f")"
done

# Quick status check
lake build && grep -c "sorry" PotionProblem/*.lean
```

## API Verification

### Check API in Database
```bash
# Check if API exists in database
./api_database/api_tools.sh api-exists "API.name"

# Find APIs for specific sorry
./api_database/api_tools.sh api-for-sorry "ModuleName" line_number

# Search APIs by pattern
./api_database/api_tools.sh api-search "pattern"

# Show API usage examples
./api_database/api_tools.sh api-usage "API.name"
```

### Test New API
```bash
# Create test file
cat > test_api.lean << 'EOF'
import Mathlib.Required.Module

variable {α : Type*} {f : ℕ → α} (hf : Summable f) (k : ℕ)
#check API.name args
EOF

# Verify compilation
lake env lean test_api.lean

# Clean up
rm test_api.lean
```

## Git Workflow

### Pre-Commit Checks
```bash
# Always run before committing
lake build && echo "✓ Build successful"

# Check what will be committed
git status
git diff --cached
```

### Commit Tags
- `[FIX]` - Sorry elimination
- `[DOCS]` - Documentation updates
- `[API]` - API usage updates
- `[BUILD]` - Build configuration changes
- `[REFACTOR]` - Code reorganization

## Emergency Commands

### When Build Breaks
```bash
# Full reset
lake clean
lake update
lake build

# Reset to last known good state
git stash
git checkout main
lake build
```

## Export for Review
```bash
# Export core formalization only
repomix --include "PotionProblem/*.lean,lakefile.toml,lean-toolchain" \
        --exclude "PotionProblem/ComprehensiveTests.lean,PotionProblem/test_*.lean,PotionProblem/MainOriginal.lean,PotionProblem/FormalExtensions.lean" \
        --output potion_problem_core.xml
```