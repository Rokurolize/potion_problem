# Lean 4 Build Error Analysis & Systematic Correction Tools

A comprehensive wrapper tool suite for systematically analyzing and fixing Lean 4 build errors with step-by-step guidance for Claude Code.

## Quick Start

```bash
# Generate complete fix guide for current errors
python tools/lean_fix_guide.py

# Analyze specific target
python tools/lean_fix_guide.py PotionProblem.ProbabilityFoundations

# Get JSON output for programmatic access  
python tools/lean_fix_guide.py --json

# Save guide to file
python tools/lean_fix_guide.py --output fix_guide.txt
```

## Tool Components

### 1. `lean_error_analyzer.py`
Core error parser that categorizes build errors:
- **Type mismatch** (casting, coercion issues)
- **Tactic failures** (deprecated/broken tactics)
- **Sorry declarations** (incomplete proofs)
- **Style warnings** (deprecated patterns)
- **API errors** (missing/changed functions)
- **Import errors** (missing imports)

### 2. `instruction_generator.py`
Generates step-by-step fix instructions for each error type with:
- Systematic approach templates
- LeanExplore integration points
- Common pitfalls and fallbacks
- Verification strategies

### 3. `verification_engine.py`
Provides build testing and rollback capabilities:
- Incremental build verification
- Git integration for safe rollbacks
- Progress tracking across fix attempts
- Success/failure analysis

### 4. `lean_fix_guide.py`
Main orchestrator that combines all components into comprehensive guidance.

## Usage Examples

### Basic Error Analysis
```bash
python tools/lean_error_analyzer.py PotionProblem.Main
```

### Complete Fix Guide
```bash
python tools/lean_fix_guide.py PotionProblem.SeriesAnalysis
```

### Verification Engine
```bash
# Check current build state
python tools/verification_engine.py status

# Verify a fix attempt
python tools/verification_engine.py verify --error "type mismatch" --description "Fixed casting issue"

# Rollback to previous state
python tools/verification_engine.py rollback --commit abc123
```

## Integration with Claude Code

The tools are designed to provide Claude Code with:

1. **Systematic Analysis**: Understanding exactly what errors exist and their priority
2. **Step-by-Step Instructions**: Clear, actionable steps for each fix
3. **Verification Workflow**: Safe fixing with rollback capabilities
4. **LeanExplore Integration**: API verification to prevent hallucinations
5. **Progress Tracking**: Recording what works and what doesn't

## Typical Workflow

1. **Analyze**: Run `lean_fix_guide.py` to get comprehensive error analysis
2. **Prioritize**: Follow the generated fix order (critical errors first)
3. **Fix**: Apply one fix at a time following step-by-step instructions
4. **Verify**: Use `lake build` after each fix to confirm success
5. **Commit**: Git commit each successful fix separately
6. **Rollback**: Use verification engine if fixes introduce new errors

## Key Features

- **Error Categorization**: Automatically identifies error types and severity
- **Context Extraction**: Shows code context around each error
- **Systematic Approach**: Prevents cascading failures through ordered fixing
- **LeanExplore Integration**: Validates API usage to prevent hallucinations
- **Git Integration**: Safe experimentation with automatic rollback
- **Progress Tracking**: Records what strategies work for future reference

## Output Formats

- **Human-readable**: Comprehensive guide with step-by-step instructions
- **JSON**: Structured data for programmatic processing
- **File output**: Save guides for reference and documentation

This tool suite significantly improves Claude Code's ability to systematically and accurately resolve Lean 4 build errors while maintaining mathematical correctness.