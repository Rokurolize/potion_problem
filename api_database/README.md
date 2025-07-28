# Mathlib4 API Database

A SQLite database system for tracking Mathlib4 API existence, usage patterns, and evolution.

## Overview

This database replaces the previous markdown-based system (`api-library.md` and `list-of-non-existent-mathlib-apis.md`) with a structured SQLite database that provides:

- **Fast O(1) API lookups** instead of linear search through markdown
- **Structured data** with proper relationships and indexing
- **Version tracking** across Mathlib versions
- **Usage patterns** and common error documentation
- **Sorry contribution tracking** to identify which APIs help solve specific sorries
- **Export flexibility** to generate markdown views on demand

## Database Schema

The database contains the following tables:

- `apis` - Core API information (name, existence, signature, imports, etc.)
- `categories` - API categories for organization
- `api_categories` - Many-to-many relationship between APIs and categories
- `usage_patterns` - Code examples showing correct API usage
- `api_errors` - Common mistakes and corrections
- `sorry_contributions` - Maps APIs to the sorries they help solve
- `search_history` - Tracks searches to avoid redundancy
- `non_existent_apis` - Patterns that don't exist with alternatives

## Usage

### Setup

The database and tools are located in `/home/ubuntu/workbench/projects/potion_problem/api_database/`.

To use the tools, either:
1. Run directly: `./api_tools.sh <command>`
2. Source for interactive use: `source api_tools.sh`

### Available Commands

#### Check API Existence
```bash
api-exists "Summable.tsum_add_tsum_compl"
# Output: EXISTS: Summable.tsum_add_tsum_compl

api-exists "tsum_dite_right"
# Output: NOT EXISTS: tsum_dite_right
# Alternative: Use Set.indicator with manual proofs...
```

#### Add New Verified API
```bash
api-add "NewAPI.name" "signature here" "Mathlib.Import.Path" [lean_explore_id]
```

#### Mark API as Non-Existent
```bash
api-not-found "api_name" "Use this alternative approach instead"
```

#### Search for APIs
```bash
api-search "polynomial"
# Shows all APIs containing "polynomial"
```

#### Find APIs for Specific Sorry
```bash
api-for-sorry "IrwinHallTheory" 233
# Shows APIs that help solve the sorry at line 233
```

#### Show Usage Patterns
```bash
api-usage "Summable.sum_add_tsum_nat_add"
# Shows code examples and common errors
```

#### Export Categories
```bash
api-export-category "Polynomial Derivative APIs"
# Outputs markdown for all APIs in that category
```

#### Database Statistics
```bash
api-stats
# Shows counts of APIs, categories, patterns, etc.
```

#### Full Export
```bash
api-export-all [output_file.md]
# Exports entire database to markdown
```

## Workflow Integration

### Before Using a New API

1. Check if it exists:
   ```bash
   api-exists "Some.New.API"
   ```

2. If it doesn't exist in the database, search with LeanExplore

3. After verification, add to database:
   ```bash
   api-add "Some.New.API" "signature" "import.path" 12345
   ```

### When API Doesn't Exist

```bash
api-not-found "Some.Fake.API" "Use Real.API instead with this pattern..."
```

This prevents future searches for the same non-existent API.

## Benefits Over Markdown System

1. **Performance**: O(1) lookups vs O(n) grep searches
2. **Structure**: Proper relationships between APIs, categories, and usage
3. **Reduced Context**: Load only needed APIs instead of entire files
4. **Maintainability**: Easier to update and query
5. **Analytics**: Track which APIs are searched most frequently
6. **Version Control**: Track API changes across Mathlib versions

## Database Location

The SQLite database file is at:
```
/home/ubuntu/workbench/projects/potion_problem/api_database/mathlib_apis.db
```

## Migration Notes

The database was populated from:
- `docs/api-library.md` - 41 verified APIs
- `list-of-non-existent-mathlib-apis.md` - 35 non-existent patterns

Original markdown files are preserved for reference but should no longer be updated directly.

## Future Enhancements

- Automatic API verification via LeanExplore integration
- API dependency tracking
- Performance metrics on API usage
- Deprecation detection from Mathlib updates
- Web interface for easier browsing