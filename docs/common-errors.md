# Common Errors and API Misuse Patterns

*Centralized reference for frequent errors encountered in Lean 4 formal verification*

**Purpose**: Single source of truth for common API misuse patterns that were previously scattered across 5+ documentation files.

## 🚨 Critical: Field vs Direct Call Pattern

### The #1 Most Common Error

**❌ WRONG - Field Access Pattern**:
```lean
(Summable.hasSum pmf_summable).sum_add_tsum_nat_add  -- CAUSES BUILD FAILURE
```
**Error**: "invalid field 'sum_add_tsum_nat_add', the environment does not contain 'HasSum.sum_add_tsum_nat_add'"

**✅ CORRECT - Direct Namespace Access**:
```lean
Summable.sum_add_tsum_nat_add k pmf_summable  -- Works correctly
```

### Why This Happens
- Lean 4's type system doesn't allow accessing these APIs as fields on other objects
- The API must be called directly from its namespace
- This pattern applies to MANY mathlib4 APIs, not just sum_add_tsum_nat_add

### Other Examples of This Pattern

**❌ WRONG**:
```lean
(some_tendsto_object).api_name
(pmf_summable.hasSum).tsum_compl
(h_limit).comp
```

**✅ CORRECT**:
```lean
Namespace.api_name args
Summable.tsum_compl pmf_summable set
Tendsto.comp h_limit h_shift
```

## 🔄 Argument Order Errors

### sum_add_tsum_nat_add Argument Order

**❌ WRONG** - Proof first:
```lean
Summable.sum_add_tsum_nat_add summability_proof k
```

**✅ CORRECT** - k first, then proof:
```lean
Summable.sum_add_tsum_nat_add k summability_proof
```

### General Pattern
Many mathlib4 APIs expect "index/parameter" arguments before "proof" arguments:
- Index parameters (n, k, etc.) come first
- Proof obligations (summability, convergence) come after

## 📍 Boolean Logic Errors

### if_neg/if_pos Type Confusion

**❌ WRONG**:
```lean
simp only [if_neg h1]  -- where h1 : 0 ≤ x
```
**Error**: `if_neg` expects `¬condition`, not the condition itself

**✅ CORRECT**:
```lean
simp only [if_neg (not_lt.mpr h1)]  -- Convert to proper negation
```

### Pattern
- `if_pos` expects a proof that the condition is true
- `if_neg` expects a proof that the condition is false (negated)
- Use boolean conversion lemmas like `not_lt`, `not_le` to convert

## 🔧 API Verification Requirements

### Never Use Unverified APIs

**❌ WRONG** - Using API without verification:
```lean
-- See it in LeanExplore, immediately use in proof
have h := Some.New.API arg1 arg2
```

**✅ CORRECT** - Always verify first:
```bash
# 1. Create test file
echo "import Mathlib.Required.Module

#check Some.New.API
variable (arg1 : Type1) (arg2 : Type2)  
#check Some.New.API arg1 arg2" > test_api.lean

# 2. Verify it compiles
lake env lean test_api.lean

# 3. Only then use in actual proof
```

## 🚫 Deprecated API Usage

### Common Deprecations (as of mathlib4 v4.21.0)

**❌ DEPRECATED**:
```lean
tsum_add  -- Use Summable.tsum_add
Finset.not_mem_empty  -- Use Finset.notMem_empty  
cases'  -- Use obtain, rcases, or cases
```

**✅ REPLACEMENTS**:
```lean
Summable.tsum_add
Finset.notMem_empty
obtain ⟨x, hx⟩ := ...
```

## 🎯 Type Mismatch Patterns

### Summable.subtype Complexity

**❌ WRONG** - Expecting direct summability:
```lean
exact Summable.tsum_add pmf_summable.subtype pmf_summable.subtype
```
**Error**: Type mismatch - `Summable.subtype` returns a function, not a direct proof

**✅ CORRECT** - Use explicit set-based summability or avoid subtype patterns

### Cast and Coercion Errors

**❌ WRONG** - Missing casts:
```lean
have h : n.factorial = n * (n-1).factorial  -- Type error when n : ℕ but need ℝ
```

**✅ CORRECT** - Explicit casting:
```lean
have h : (n.factorial : ℝ) = n * (n-1).factorial
```

## 📋 Quick Reference Checklist

Before using any mathlib4 API:
1. ✅ Check if it's in [`api-library.md`](api-library.md) (pre-verified APIs)
2. ✅ Check if it's in [`list-of-non-existent-mathlib-apis.md`](../list-of-non-existent-mathlib-apis.md)
3. ✅ Create test file and verify compilation
4. ✅ Use direct namespace access, not field access
5. ✅ Verify argument order (indices before proofs)
6. ✅ Check for deprecation warnings

## 🔗 Related Documentation

- For verified APIs: [`api-library.md`](api-library.md)
- For proven techniques: [`sorry-elimination-patterns.md`](sorry-elimination-patterns.md)
- For workflow commands: [`workflow-commands.md`](workflow-commands.md)