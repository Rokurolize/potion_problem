# mathlib4 v4.22.0-rc3 Migration Guide

**Date**: January 20, 2025  
**Author**: Astolfo (Claude Assistant)  
**Purpose**: Comprehensive migration analysis from v4.21.0 to v4.22.0-rc3

## Executive Summary

This document provides a detailed analysis of the differences between the current potion_problem project (v4.21.0) and a VS Code extension-created project (v4.22.0-rc3), along with a complete migration strategy.

## Project Comparison

### 1. Project Structure Differences

| Aspect | Current (v4.21.0) | VS Code Created (v4.22.0-rc3) |
|--------|-------------------|------------------------------|
| **Project Name** | `potion_problem` | `potion-problem` |
| **Config Format** | `lakefile.lean` | `lakefile.toml` |
| **Lean Version** | `leanprover/lean4:v4.21.0` | `leanprover/lean4:v4.22.0-rc3` |
| **mathlib Version** | Fixed at `v4.21.0` | Tracking `master` branch |
| **Default Target** | Multiple libs/exes | Single lib `PotionProblem` |
| **Project Structure** | Flat structure | Module-based (`PotionProblem/`) |

### 2. Lakefile Differences

#### Current lakefile.lean (v4.21.0)
```lean
import Lake
open Lake DSL

package «potion_problem» where
  -- add package configuration options here

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.21.0"

@[default_target]
lean_lib «UniformHittingTime» where
  -- add library configuration options here

lean_lib «GenuinelyWorking» where
  -- Actually working formal verification

lean_lib «ReallyWorking» where
  -- Actually working formal verification - fixed

lean_lib «GenuineDemo» where
  -- Genuinely working formal mathematics demonstration

lean_lib «SimpleDemo» where
  -- Simple working formal mathematics demonstration

lean_exe «WorkingMinimal» where
  root := `WorkingMinimal

lean_exe «FinalDemo» where
  root := `FinalDemo
```

#### VS Code lakefile.toml (v4.22.0-rc3)
```toml
name = "potion-problem"
version = "0.1.0"
keywords = ["math"]
defaultTargets = ["PotionProblem"]

[leanOptions]
pp.unicode.fun = true # pretty-prints `fun a ↦ b`
autoImplicit = false
relaxedAutoImplicit = false
weak.linter.mathlibStandardSet = true
maxSynthPendingDepth = 3

[[require]]
name = "mathlib"
scope = "leanprover-community"

[[lean_lib]]
name = "PotionProblem"
```

### 3. Key Configuration Improvements

The new TOML format provides:
- **Better Linter Configuration**: `weak.linter.mathlibStandardSet = true`
- **Stricter Type Checking**: `autoImplicit = false`, `relaxedAutoImplicit = false`
- **Performance Optimization**: `maxSynthPendingDepth = 3`
- **Better Unicode Support**: `pp.unicode.fun = true`

### 4. Dependency Version Differences

| Package | v4.21.0 SHA | v4.22.0-rc3 SHA | Note |
|---------|-------------|-----------------|------|
| mathlib | 308445d7... | e6edd786... | Major update |
| plausible | c4aa7818... | 61c44bec... | Update |
| importGraph | d07bd64f... | 140dc642... | Update |
| proofwidgets | 6980f6ca... | 96c67159... | Update (v0.0.62 → v0.0.67) |
| aesop | 8ff27701... | a62ecd03... | Update |
| Qq | e9c65db4... | 867d9dc7... | Update |
| batteries | 8d2067bf... | 3cabaef2... | Update |
| Cli | 7c6aef5f... | e22ed088... | Update |

## Migration Procedure

### Step 1: Pre-Migration Backup

```bash
# Create backup
cd /home/ubuntu/workbench/projects/potion_problem
git add -A
git commit -m "Pre-v4.22.0-rc3 migration checkpoint"
git tag -a "v4.21.0-final" -m "Final state before v4.22.0-rc3 migration"

# Create full backup
cp -r /home/ubuntu/workbench/projects/potion_problem /home/ubuntu/workbench/projects/potion_problem_backup_v4.21.0
```

### Step 2: Update lean-toolchain

```bash
echo "leanprover/lean4:v4.22.0-rc3" > lean-toolchain
```

### Step 3: Convert lakefile.lean to lakefile.toml

Create a new `lakefile.toml` with the following content:

```toml
name = "potion_problem"
version = "0.1.0"
keywords = ["math", "probability", "formal-verification"]
defaultTargets = ["UniformHittingTime"]

[leanOptions]
pp.unicode.fun = true
autoImplicit = false
relaxedAutoImplicit = false
weak.linter.mathlibStandardSet = true
maxSynthPendingDepth = 3

[[require]]
name = "mathlib"
scope = "leanprover-community"

[[lean_lib]]
name = "UniformHittingTime"

[[lean_lib]]
name = "GenuinelyWorking"

[[lean_lib]]
name = "ReallyWorking"

[[lean_lib]]
name = "GenuineDemo"

[[lean_lib]]
name = "SimpleDemo"

[[lean_exe]]
name = "WorkingMinimal"
root = "WorkingMinimal"

[[lean_exe]]
name = "FinalDemo"
root = "FinalDemo"
```

### Step 4: Remove Old lakefile.lean

```bash
rm lakefile.lean
```

### Step 5: Update Dependencies

```bash
# Remove old lake-manifest.json
rm lake-manifest.json

# Update Lake packages
lake update

# Clean and rebuild
lake clean
lake build
```

### Step 6: Fix Breaking Changes

Expected areas requiring attention:
1. **Import paths**: May need adjustment for new mathlib structure
2. **API changes**: Some mathlib APIs may have changed
3. **Syntax updates**: New Lean features may require syntax adjustments
4. **Linter warnings**: New linter rules may flag existing code

### Step 7: Verification

```bash
# Verify build
lake build

# Run tests if available
lake test

# Check for linter warnings
lake lint
```

## Potential Risks and Mitigation

### Risk 1: API Breaking Changes
**Mitigation**: Review mathlib4 changelog for v4.21.0 → v4.22.0-rc3 changes

### Risk 2: Build Failures
**Mitigation**: 
- Keep backup of working v4.21.0 version
- Migrate incrementally, testing each module

### Risk 3: Performance Regression
**Mitigation**: 
- Monitor build times before and after
- Use `maxSynthPendingDepth` setting to limit synthesis

### Risk 4: RC Version Instability
**Mitigation**: 
- Consider waiting for v4.22.0 stable release
- Maintain v4.21.0 branch for stability

## Benefits of Upgrading

### 1. Performance Improvements
- Better synthesis performance controls
- Improved linter performance

### 2. Better Development Experience
- TOML configuration is more readable and maintainable
- Better error messages with stricter implicit checking
- Enhanced linter coverage

### 3. Latest mathlib Features
- Access to newest mathematical libraries
- Bug fixes and performance improvements
- New proof tactics and utilities

### 4. Future Compatibility
- Stay current with Lean ecosystem
- Easier future upgrades
- Access to community support for latest versions

## Rollback Procedure

If migration fails:

```bash
# Restore from git
git checkout v4.21.0-final

# Or restore from backup
rm -rf /home/ubuntu/workbench/projects/potion_problem
cp -r /home/ubuntu/workbench/projects/potion_problem_backup_v4.21.0 /home/ubuntu/workbench/projects/potion_problem

# Rebuild
cd /home/ubuntu/workbench/projects/potion_problem
lake clean
lake build
```

## Recommendation

**Proceed with caution**: While v4.22.0-rc3 offers significant improvements, it's still a release candidate. Consider:

1. **Option A**: Wait for v4.22.0 stable release (recommended for production)
2. **Option B**: Create a separate branch for v4.22.0-rc3 testing
3. **Option C**: Proceed with full migration if timeline permits debugging

The TOML configuration format and stricter linting are valuable improvements that will enhance code quality and maintainability.

## Next Steps

1. Review this migration guide with the team
2. Decide on migration timing (now vs. wait for stable)
3. Create migration branch if proceeding
4. Execute migration procedure step-by-step
5. Document any additional issues encountered

---

**Note**: This guide is based on analysis of both project structures. Actual migration may reveal additional considerations not covered here. Always maintain backups and test thoroughly.