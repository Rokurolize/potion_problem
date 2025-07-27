# MCP LeanExplore Workflow

## Basic Usage

### Search for APIs
```
Tool: mcp__leanexplore__search
Parameters: {
  "query": "your_search_term",
  "limit": 10,  // optional
  "package_filters": ["Mathlib"]  // optional
}
```

**Returns**: API names, IDs, brief descriptions, imports

### Get Full Details
```
Tool: mcp__leanexplore__get_by_id
Parameters: {"group_id": 84423}
```

**Returns**: Complete signature, full proof text, imports

### Get Dependencies
```
Tool: mcp__leanexplore__get_dependencies
Parameters: {"group_id": 84423}
```

**Returns**: All required imports (may exceed token limit)

## Example: Finding `sum_div_factorial_le`

1. **Search**: `{"query": "sum_div_factorial_le", "limit": 5}`
   - Found: `Complex.sum_div_factorial_le` (ID: 84423)
   - Import: `Mathlib.Data.Complex.Exponential`

2. **Get details**: `{"group_id": 84423}`
   - Signature: `(n j : ℕ) (hn : 0 < n) : ...`

3. **Test it**:
   ```lean
   import Mathlib.Data.Complex.Exponential
   variable (n j : ℕ) (hn : 0 < n)
   #check Complex.sum_div_factorial_le n j hn
   ```

## Notes

- If `get_dependencies` exceeds token limit, use `get_by_id` instead
- Search results show deprecation warnings
- If no results found, try broader terms or check alternative phrasings