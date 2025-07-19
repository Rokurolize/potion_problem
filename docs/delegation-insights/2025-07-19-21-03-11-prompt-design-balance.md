# Prompt Design Balance: Specificity vs Generalization

**Date**: 2025-07-19  
**Context**: Task agent committed broken code despite "successful" implementation  
**Insight**: Missing mandatory verification procedures in delegation prompts

## 🔍 The Core Tension

When designing prompts for delegated agents, we face a fundamental tension:

### Too Specific (Over-Constrained)
```markdown
1. Run exactly: `lake build UniformHittingTime.TelescopingSeries`
2. If output contains "error:", run: `git checkout HEAD -- .`
3. If output contains "warning:", proceed to step 4
4. Run exactly: `echo "Build status: success" >> log.txt`
```
**Problems**: 
- Reduces agent flexibility and problem-solving capability
- Brittle when environment changes
- Prevents creative solutions

### Too General (Under-Constrained)
```markdown
1. Implement improvements
2. Document your work
3. Commit changes
```
**Problems**:
- Critical steps may be skipped (like build verification)
- Quality gates not enforced
- Inconsistent results

## 🎯 The Balanced Approach

### Principle: Mandatory Gates with Flexible Implementation

**Good Pattern**:
```markdown
### MANDATORY: Build Verification
**⚠️ CRITICAL: You MUST verify build success before ANY commit**

[Flexible implementation details]

**Build Status Requirements:**
- ✅ Build must succeed before proceeding
- ⚠️ If build fails: Either fix or revert
- 🚫 Never commit broken code
```

This pattern:
- Makes requirements crystal clear (WHAT is mandatory)
- Allows flexibility in implementation (HOW to achieve it)
- Uses visual indicators for importance
- Provides clear success/failure criteria

## 📋 Design Guidelines

### 1. Identify Non-Negotiable Requirements
**Examples**:
- Build must succeed
- Tests must pass
- Documentation must be updated
- Git commits must have clear messages

### 2. Separate Requirements from Implementation
**Instead of**: "Run `lake build && git commit -m 'Done'`"  
**Write**: "Verify build success (mandatory) then commit with descriptive message"

### 3. Use Clear Hierarchical Structure
```
MANDATORY → Requirements that must be met
RECOMMENDED → Best practices to follow
OPTIONAL → Nice-to-have enhancements
```

### 4. Provide Success/Failure Definitions
**Always include**:
- Definition of success
- Definition of failure  
- Examples of each

### 5. Enable Learning from Failures
Build in mechanisms for agents to:
- Recognize when they're failing
- Have clear recovery paths
- Know when to stop and report issues

## 🔧 Applied Example: Build Verification

**Before** (Too General):
```
Make improvements and commit your work
```

**After** (Balanced):
```
#### MANDATORY: Build Verification
You MUST verify build success before ANY commit

How you verify is flexible, but verification is required.
Success = Code builds without errors
Failure = Any commit that breaks the build
```

## 💡 Key Insights

1. **Mandatory Gates ≠ Rigid Process**
   - Define WHAT must happen
   - Allow flexibility in HOW it happens

2. **Visual Hierarchy Matters**
   - Use formatting to highlight critical requirements
   - Make mandatory items impossible to miss

3. **Failure Prevention > Failure Recovery**
   - Better to prevent bad commits than fix them later
   - Clear requirements reduce failure rates

4. **Learning Loop Integration**
   - Document why requirements exist
   - Show consequences of skipping steps
   - Enable agents to understand, not just follow

## 📊 Impact Assessment

### Before These Guidelines:
- Task agent committed broken code
- Claimed "success" despite build failures
- Required human intervention to fix

### After These Guidelines:
- Mandatory verification prevents broken commits
- Clear success criteria prevent false claims
- Agents self-correct before committing

## 🎯 Conclusion

The optimal prompt design balances:
- **Clarity** on non-negotiable requirements
- **Flexibility** in implementation approach
- **Learning** from both successes and failures

This creates robust delegation systems that maintain quality while preserving agent capabilities.