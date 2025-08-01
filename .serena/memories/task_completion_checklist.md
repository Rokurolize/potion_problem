# Task Completion Checklist

## When Completing Any Task

### 1. Build Verification
```bash
# Always ensure build succeeds
lake build
echo "Exit code: $?"  # Should be 0
```

### 2. Check for Warnings
```bash
# Check for deprecation warnings
lake build 2>&1 | grep "deprecated"

# Check sorry count if working on proofs
lake build 2>&1 | grep "declaration uses 'sorry'" | wc -l
```

### 3. Pre-Commit Verification
```bash
# Final build check
lake build && echo "✓ Build successful"

# Review changes
git status
git diff --cached

# Ensure no test files remain
rm -f test_api.lean test_*.lean
```

### 4. Documentation Updates
- Update CLAUDE.md if main theorem status changes
- Update sorry count in documentation if sorries were eliminated
- Add new APIs to database if discovered:
  ```bash
  ./api_database/api_tools.sh api-add "API.name" "signature" "import.path" [id]
  ```

### 5. Commit with Appropriate Tag
```bash
git add <files>
git commit -m "[TAG] Description"
```
Tags: [FIX], [DOCS], [API], [BUILD], [REFACTOR]

### 6. Critical Rules
- Never commit with build failures
- Never proceed with unverified APIs
- Always maintain @-path syntax in CLAUDE.md files
- Document strategic retreats if unable to eliminate a sorry

### 7. Progress Tracking
- If using TodoWrite tool, mark tasks as completed
- Update sorry count tracking if applicable
- Note any new dependencies or blockers discovered