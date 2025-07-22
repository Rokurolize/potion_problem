# Lakefile.lean to Lakefile.toml Migration Guide

**Last Updated**: January 22, 2025  
**Purpose**: Step-by-step guide for transitioning from `lakefile.lean` to `lakefile.toml` format

## Table of Contents
1. [Overview](#overview)
2. [Key Differences](#key-differences)
3. [Migration Steps](#migration-steps)
4. [Common Patterns](#common-patterns)
5. [Validation](#validation)
6. [Troubleshooting](#troubleshooting)
7. [Examples](#examples)

## Overview

Starting with Lean 4 v4.22.0, Lake supports a new TOML-based configuration format as an alternative to the Lean-based `lakefile.lean`. The TOML format offers:

- **Simpler syntax** - No Lean language knowledge required
- **Better tooling support** - Standard TOML editors and validators
- **Clearer separation** - Configuration vs. code
- **Easier maintenance** - Declarative rather than programmatic

## Key Differences

### 1. File Format

| Aspect | lakefile.lean | lakefile.toml |
|--------|---------------|---------------|
| **Language** | Lean 4 DSL | TOML |
| **Extension** | `.lean` | `.toml` |
| **Imports** | `import Lake` | None needed |
| **Syntax** | Lean code | Key-value pairs |

### 2. Structure Comparison

**lakefile.lean:**
```lean
import Lake
open Lake DSL

package «my_project» where
  -- package options

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.22.0"

@[default_target]
lean_lib «MyLib» where
  -- library options

lean_exe «my_exe» where
  root := `Main
```

**lakefile.toml:**
```toml
name = "my_project"
version = "0.1.0"
keywords = ["math"]
defaultTargets = ["MyLib"]

[leanOptions]
pp.unicode.fun = true
autoImplicit = false

[[require]]
name = "mathlib"
scope = "leanprover-community"

[[lean_lib]]
name = "MyLib"

[[lean_exe]]
name = "my_exe"
root = "Main"
```

## Migration Steps

### Step 1: Create New lakefile.toml

Create a new file named `lakefile.toml` in your project root directory.

### Step 2: Migrate Package Declaration

**From lakefile.lean:**
```lean
package «project_name» where
  -- options
```

**To lakefile.toml:**
```toml
name = "project_name"
version = "0.1.0"  # Add version
keywords = []      # Optional keywords
```

### Step 3: Migrate Lean Options

**From lakefile.lean:**
```lean
@[default_target]
lean_lib «MyLib» where
  -- Uses implicit options from package
```

**To lakefile.toml:**
```toml
[leanOptions]
pp.unicode.fun = true
autoImplicit = false
relaxedAutoImplicit = false
weak.linter.mathlibStandardSet = true
maxSynthPendingDepth = 3
```

### Step 4: Migrate Dependencies

**From lakefile.lean:**
```lean
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.22.0"

require batteries from git
  "https://github.com/leanprover-community/batteries" @ "main"
```

**To lakefile.toml:**
```toml
[[require]]
name = "mathlib"
scope = "leanprover-community"
# Version specified in lean-toolchain or manifest

[[require]]
name = "batteries"
scope = "leanprover-community"
```

### Step 5: Migrate Libraries

**From lakefile.lean:**
```lean
@[default_target]
lean_lib «MainLib» where
  globs := #[.andSubmodules `MainLib]

lean_lib «Utils» where
  srcDir := "src/utils"
```

**To lakefile.toml:**
```toml
defaultTargets = ["MainLib"]

[[lean_lib]]
name = "MainLib"
# globs are automatic for modules

[[lean_lib]]
name = "Utils"
srcDir = "src/utils"
```

### Step 6: Migrate Executables

**From lakefile.lean:**
```lean
lean_exe «demo» where
  root := `Demo.Main
  supportInterpreter := true
```

**To lakefile.toml:**
```toml
[[lean_exe]]
name = "demo"
root = "Demo.Main"
supportInterpreter = true
```

### Step 7: Set Default Targets

**From lakefile.lean:**
```lean
@[default_target]
lean_lib «MyLib» where
  -- ...
```

**To lakefile.toml:**
```toml
defaultTargets = ["MyLib", "MyOtherLib"]
```

### Step 8: Remove Old lakefile.lean

After verifying the new configuration works:
```bash
# Test build with new config
lake build

# If successful, remove old file
rm lakefile.lean
```

## Common Patterns

### 1. Multiple Libraries
```toml
[[lean_lib]]
name = "Core"

[[lean_lib]]
name = "Utils"

[[lean_lib]]
name = "Tests"
srcDir = "test"
```

### 2. Complex Dependencies
```toml
[[require]]
name = "mathlib"
scope = "leanprover-community"

[[require]]
name = "aesop"
scope = "leanprover-community"

[[require]]
name = "proofwidgets"
scope = "leanprover-community"
version = "v0.0.67"  # Pin specific version
```

### 3. Build Options
```toml
[leanOptions]
# Pretty printing
pp.unicode.fun = true
pp.proofs.withType = true

# Type checking
autoImplicit = false
relaxedAutoImplicit = false

# Linting
weak.linter.mathlibStandardSet = true
linter.unusedVariables = false

# Performance
maxSynthPendingDepth = 3
maxHeartbeats = 200000
```

## Validation

### 1. Syntax Check
```bash
# Install a TOML validator if needed
# Then validate syntax
toml-cli validate lakefile.toml
```

### 2. Lake Validation
```bash
# Lake will validate during build
lake build --verbose
```

### 3. Clean Build Test
```bash
# Clean and rebuild to ensure correctness
lake clean
lake build
```

## Troubleshooting

### Common Issues

1. **Name Format**
   - Error: `invalid package name`
   - Fix: Use `name = "my_project"` not `name = "my-project"`

2. **Missing Version**
   - Warning: `missing version field`
   - Fix: Add `version = "0.1.0"`

3. **Dependency Resolution**
   - Error: `cannot find dependency`
   - Fix: Ensure `scope` matches GitHub organization

4. **Array Syntax**
   - Error: `expected array`
   - Fix: Use `[[require]]` for multiple items, not `[require]`

5. **String Quotes**
   - Error: `unexpected character`
   - Fix: Use double quotes `"` not single quotes `'`

### Migration Checklist

- [ ] Created `lakefile.toml`
- [ ] Added package metadata (name, version)
- [ ] Configured leanOptions
- [ ] Migrated all dependencies
- [ ] Migrated all libraries
- [ ] Migrated all executables
- [ ] Set defaultTargets
- [ ] Tested with `lake build`
- [ ] Removed `lakefile.lean`

## Examples

### Minimal Project
```toml
name = "hello"
version = "0.1.0"
defaultTargets = ["Hello"]

[[lean_lib]]
name = "Hello"
```

### Math Project with mathlib
```toml
name = "my_math_project"
version = "0.1.0"
keywords = ["mathematics", "formal-verification"]
defaultTargets = ["MyMathProject"]

[leanOptions]
pp.unicode.fun = true
autoImplicit = false
weak.linter.mathlibStandardSet = true

[[require]]
name = "mathlib"
scope = "leanprover-community"

[[lean_lib]]
name = "MyMathProject"
```

### Complex Multi-target Project
```toml
name = "complex_project"
version = "1.0.0"
keywords = ["lean4", "verification"]
defaultTargets = ["Core", "Main"]

[leanOptions]
pp.unicode.fun = true
autoImplicit = false
relaxedAutoImplicit = false
weak.linter.mathlibStandardSet = true
maxSynthPendingDepth = 3

[[require]]
name = "mathlib"
scope = "leanprover-community"

[[require]]
name = "batteries"
scope = "leanprover-community"

[[require]]
name = "aesop"
scope = "leanprover-community"

[[lean_lib]]
name = "Core"

[[lean_lib]]
name = "Utils"
srcDir = "src/utils"

[[lean_lib]]
name = "Tests"
srcDir = "test"

[[lean_exe]]
name = "main"
root = "Main"

[[lean_exe]]
name = "demo"
root = "Demo"
supportInterpreter = true
```

## Best Practices

1. **Version Control**: Commit both old and new configs before removing the old one
2. **Incremental Migration**: Test each section as you migrate
3. **Documentation**: Document any custom build logic that was in lakefile.lean
4. **Team Communication**: Ensure all team members update their toolchains
5. **CI/CD Updates**: Update build scripts to work with new format

## Common Pitfalls and Solutions

### 1. Package Name Conventions

**Pitfall**: Using angle brackets from lakefile.lean
```toml
# WRONG
name = "«my_project»"
```

**Solution**: Use plain strings
```toml
# CORRECT
name = "my_project"
```

### 2. Dependency Versions

**Pitfall**: Specifying Git URLs and branches
```toml
# WRONG
[[require]]
name = "mathlib"
url = "https://github.com/leanprover-community/mathlib4.git"
branch = "v4.22.0"
```

**Solution**: Use scope-based resolution
```toml
# CORRECT
[[require]]
name = "mathlib"
scope = "leanprover-community"
# Version comes from lean-toolchain or lake-manifest.json
```

### 3. Default Target Syntax

**Pitfall**: Using decorator syntax
```toml
# WRONG
[[lean_lib]]
name = "MyLib"
default_target = true
```

**Solution**: Use top-level defaultTargets
```toml
# CORRECT
defaultTargets = ["MyLib"]

[[lean_lib]]
name = "MyLib"
```

### 4. Module Paths

**Pitfall**: Using Lean module syntax
```toml
# WRONG
[[lean_exe]]
name = "main"
root = "`Main"  # Note the backtick
```

**Solution**: Use string paths
```toml
# CORRECT
[[lean_exe]]
name = "main"
root = "Main"
```

### 5. Comments in Wrong Places

**Pitfall**: Comments breaking TOML parsing
```toml
# WRONG
[[require]]
name = "mathlib"  # Main math library
scope = "leanprover-community"
```

**Solution**: Put comments on separate lines
```toml
# CORRECT
# Main math library
[[require]]
name = "mathlib"
scope = "leanprover-community"
```

### 6. Missing Required Fields

**Pitfall**: Incomplete migration
```toml
# WRONG - Missing version
name = "my_project"
defaultTargets = ["MyLib"]
```

**Solution**: Include all required fields
```toml
# CORRECT
name = "my_project"
version = "0.1.0"
defaultTargets = ["MyLib"]
```

### 7. Array vs Table Confusion

**Pitfall**: Wrong syntax for multiple items
```toml
# WRONG - Using single brackets
[require]
name = "mathlib"
scope = "leanprover-community"

[require]  # ERROR: Duplicate section
name = "batteries"
scope = "leanprover-community"
```

**Solution**: Use array of tables syntax
```toml
# CORRECT - Using double brackets
[[require]]
name = "mathlib"
scope = "leanprover-community"

[[require]]
name = "batteries"
scope = "leanprover-community"
```

### 8. Glob Patterns

**Pitfall**: Trying to migrate glob patterns
```toml
# WRONG - globs don't work in TOML
[[lean_lib]]
name = "MyLib"
globs = ["src/**/*.lean"]
```

**Solution**: Use default behavior or srcDir
```toml
# CORRECT
[[lean_lib]]
name = "MyLib"
# Automatically includes MyLib/** by default

# OR specify different source directory
[[lean_lib]]
name = "MyLib"
srcDir = "src"
```

## Specific Migration Example

Here's a real-world migration from the potion problem project:

### Original lakefile.lean:
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

lean_exe «WorkingMinimal» where
  root := `WorkingMinimal
```

### Migrated lakefile.toml:
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

[[lean_exe]]
name = "WorkingMinimal"
root = "WorkingMinimal"
```

## Additional Resources

- [Lake Documentation](https://github.com/leanprover/lake)
- [TOML Specification](https://toml.io/)
- [Lean 4 Release Notes](https://github.com/leanprover/lean4/releases)
- [Lake Configuration Reference](https://github.com/leanprover/lake#configuration)