# Sorry Elimination Guide

*Complete documentation index for systematic sorry elimination in Lean 4*

**Mission**: Eliminate all `sorry` statements through systematic, build-driven development.

## 📚 Documentation Structure

### 🚀 Quick Start
1. **[Common Errors](common-errors.md)** - Start here! Most frequent mistakes and how to avoid them
2. **[Workflow Commands](workflow-commands.md)** - All build, test, and verification commands
3. **[MCP LeanExplore Workflow](mcp-leanexplore-workflow.md)** - Complete API search guide with real examples
4. **[Core Principles](sorry-elimination-core.md)** - Essential workflow and decision framework

### 📖 Detailed Guides
- **[Technique Patterns](sorry-elimination-patterns.md)** - Proven patterns for specific proof types
- **[API Library](api-library.md)** - Pre-verified mathlib4 APIs with usage examples
- **[Success Metrics](success-metrics.md)** - Project progress and historical data

### 🔍 Quick References
- **[Non-Existent APIs](../list-of-non-existent-mathlib-apis.md)** - Don't search for these
- **[Main Project Guide](../CLAUDE.md)** - Overall project navigation

## ⚡ Most Critical Rule

**Field vs Direct Call** - This causes 80% of API failures:
```lean
❌ (Summable.hasSum pmf_summable).sum_add_tsum_nat_add  -- WRONG
✅ Summable.sum_add_tsum_nat_add k pmf_summable         -- CORRECT
```

See [common-errors.md](common-errors.md) for details.

## 📊 Current Status

- **3 sorries remaining** (down from 14+)
- **Main theorem complete** ✅
- **Build status** ✅

See [success-metrics.md](success-metrics.md) for detailed progress tracking.

## 🎯 Recommended Reading Order

1. Start with **[common-errors.md](common-errors.md)** to avoid common pitfalls
2. Read **[sorry-elimination-core.md](sorry-elimination-core.md)** for workflow
3. Reference **[api-library.md](api-library.md)** before using any API
4. Use **[sorry-elimination-patterns.md](sorry-elimination-patterns.md)** for specific techniques
5. Check **[workflow-commands.md](workflow-commands.md)** for command reference

## 🏆 Key Success Factors

- **API Verification First** - Always test before use
- **Build-Driven Development** - Compile after every change
- **Strategic Documentation** - Preserve understanding in retreats
- **Dependency Order** - Fix fundamental lemmas first

For philosophy and detailed insights, see individual guide documents.
