# Naming Convention - The Aphrodisiac Problem

## Standard Names

**Primary**: **The Aphrodisiac Problem** (媚薬問題)
- Use in documentation, papers, formal references
- Direct translation of Japanese original
- Academic and research contexts

**Alternative**: "Potion Problem" 
- Acceptable casual reference
- Legacy usage in some files

## File Path Preservation

**Keep unchanged** (to avoid code corruption):
- Directory: `/potion_problem/`
- Package name in `lakefile.lean`: `potion_problem`
- Python package: `potion-problem`
- Import paths: `UniformHittingTime.*`

**Update freely**:
- Documentation titles and headers
- Commit messages and descriptions
- Academic references and citations

## Usage Examples

**Correct**:
```markdown
# The Aphrodisiac Problem - Implementation Report
*Also known as the Potion Problem (媚薬問題)*
```

**Import paths (unchanged)**:
```lean
import UniformHittingTime.TelescopingSeries
```

**Git references**:
```bash
git commit -m "Aphrodisiac Problem: Fix telescoping series proof"
```

## Rationale

The standardization on "Aphrodisiac Problem":
1. More accurate translation of "媚薬問題"
2. Better represents the mathematical community context
3. More distinctive for academic purposes
4. Aligns with majority usage in existing documentation

File paths remain unchanged to preserve:
- Build system integrity
- Import statement validity
- IDE and tool configurations
- Existing automation scripts