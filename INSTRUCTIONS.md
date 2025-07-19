# The Aphrodisiac Problem - v4.21.0 Clean Integration Instructions

## Goal
Merge v4.21.0 upgrade changes to main branch with clean commit history, removing problematic commit messages.

## Integration Approach

### Option 1: Squash Merge (Recommended)
1. Create new branch from main
2. Apply all v4.21.0 changes as single commit
3. Force push to main

### Option 2: Orphan Branch
1. Create orphan branch (no history)
2. Build clean history from scratch
3. Replace main branch

## Commit Message Guidelines

### DO:
- Use conventional format: `type: description`
- Keep under 72 characters
- Focus on WHAT changed, not WHY
- Examples:
  - `fix: Update import paths for mathlib4 v4.21.0`
  - `chore: Upgrade Lean toolchain to v4.21.0`
  - `docs: Update README with current project status`

### DON'T:
- No emojis
- No markdown formatting
- No excessive verbosity
- No personal commentary
- No time stamps in message

## Detailed Tasks

See docs/tasks/ directory for step-by-step instructions:
1. `01-create-clean-branch.md`
2. `02-apply-v4.21.0-changes.md`
3. `03-create-clean-main.md`
4. `04-test-build.md`

## Current Issues

The project contains:
- Working v4.21.0 upgrade
- API fixes for mathlib4 changes
- Problematic git history with verbose commit messages

## Success Criteria

- Clean git history
- All v4.21.0 changes preserved
- Build passes
- No emoji-laden commit messages