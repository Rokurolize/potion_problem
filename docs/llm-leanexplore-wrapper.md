# LLM-Optimized LeanExplore Wrapper

A context-aware wrapper for LeanExplore designed to minimize token usage while maximizing information density for LLM consumption.

## Features

- **Context-aware output**: Automatically adjusts detail level based on result count
- **Minimal decorative elements**: Clean, parseable output without box-drawing characters
- **Progressive detail levels**: From minimal (IDs only) to detailed (full documentation)
- **Efficient for LLMs**: Reduces context usage while maintaining information quality

## Usage

### Basic Search
```bash
# Use the wrapper directly
python scripts/llm_leanexplore.py search "hasSum"

# Or use the convenient alias
scripts/lle search "hasSum"
```

### Detail Levels

The wrapper supports three detail levels:

1. **minimal**: Just IDs and names (best for many results)
   ```bash
   scripts/lle search "summable" --limit 20 --detail minimal
   ```

2. **standard**: ID, name, file, and signature (balanced information)
   ```bash
   scripts/lle search "hasSum" --limit 5 --detail standard
   ```

3. **detailed**: Full information including docstrings and descriptions
   ```bash
   scripts/lle search "HasSum" --limit 1 --detail detailed
   ```

### Automatic Detail Selection

When no detail level is specified, the wrapper automatically selects based on result count:
- 1 result → detailed (maximum information for definitive answer)
- 2-3 results → standard (balanced view)
- 4+ results → minimal (overview for browsing)
- 0 results → minimal (just shows "No results found")

### Other Commands

Get detailed information for a specific ID:
```bash
scripts/lle get 187626
```

Get dependencies for a specific ID:
```bash
scripts/lle dependencies 187626
```

## Examples

### Searching for a specific function
```bash
# Initial broad search
scripts/lle search "tail probability" --limit 10
# Returns minimal list of IDs and names

# Narrow down to specific result
scripts/lle get 123456
# Returns full details
```

### Progressive refinement workflow
```bash
# Step 1: Broad search with many results
scripts/lle search "factorial" --limit 30 --detail minimal

# Step 2: Refine search
scripts/lle search "summable_pow_div_factorial" --limit 5

# Step 3: Get exact details
scripts/lle get 187654
```

### Package-specific search
```bash
scripts/lle search "hasSum" --package Mathlib --limit 10
```

## Implementation Notes

- The wrapper parses LeanExplore's decorative output and reformats it
- Error handling preserves original error messages
- Search always returns results (LeanExplore uses semantic search)
- The wrapper is located at `scripts/llm_leanexplore.py`
- A convenient alias `lle` is provided at `scripts/lle`

## Integration with CLAUDE.md Workflow

When using this wrapper in the sorry elimination workflow:

1. Search for the API you need:
   ```bash
   scripts/lle search "summable_pow_div_factorial"
   ```

2. Verify the exact signature:
   ```bash
   scripts/lle get [ID]
   ```

3. Check dependencies/imports:
   ```bash
   scripts/lle dependencies [ID]
   ```

This ensures you're using real mathlib4 APIs rather than hallucinated ones.