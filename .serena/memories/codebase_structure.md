# Codebase Structure

## Root Directory
- `lakefile.toml` - Lake build configuration
- `lean-toolchain` - Lean version specification (v4.22.0-rc4)
- `CLAUDE.md` - Project documentation for Claude Code
- `README.md` - Public project documentation
- `PotionProblem.lean` - Library entry point

## Core Modules (PotionProblem/)
### Module Dependency Graph
```
Basic.lean (0 sorries) - Core hitting_time_pmf definition
├── FactorialSeries.lean (0 sorries) - Factorial convergence  
├── ProbabilityFoundations.lean (0 sorries) - PMF properties
    ├── SeriesAnalysis.lean (0 sorries) - Series manipulation
    ├── IrwinHallTheory.lean (4 sorries) - Geometric interpretation
    └── Main.lean (0 sorries) - Main theorem E[τ] = e ✅
```

### Test and Auxiliary Files
- `ComprehensiveTests.lean` - Test suite
- `test_*.lean` - Individual test files
- `MainOriginal.lean` - Historical backup
- `FormalExtensions.lean` - Supplementary content

## Documentation (docs/)
- `common-errors.md` - Critical API misuse patterns
- `workflow-commands.md` - Build and test commands
- `api-database-workflow.md` - SQLite API database guide
- `sorry-elimination-*.md` - Sorry elimination guides
- `mcp-leanexplore-workflow*.md` - API search workflows
- `api-reference/` - Verified and non-existent APIs

## Tools and Infrastructure
- `api_database/` - SQLite database for O(1) API lookups
  - `mathlib_apis.db` - API database
  - `api_tools.sh` - Command-line interface
  - Schema and migration scripts
- `scripts/` - Python scripts (mostly __pycache__)
- `.serena/` - Serena project configuration
- `.claude/` - Claude-specific configuration

## Key Files to Know
1. **For sorry tracking**: `PotionProblem/IrwinHallTheory.lean` (4 remaining sorries)
2. **For API verification**: `api_database/api_tools.sh`
3. **For workflow**: `docs/workflow-commands.md`
4. **For common errors**: `docs/common-errors.md`

## Git Ignored Files
- `test_api.lean` - Temporary API test files
- Build artifacts in `.cache/`
- Python cache in `__pycache__`