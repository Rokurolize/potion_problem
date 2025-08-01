# Running and Testing the Project

## Primary Entry Points

### Lean 4 Verification
This is primarily a Lean 4 formal verification project. The main ways to interact:

1. **Build the entire project**:
   ```bash
   lake build
   ```

2. **Check specific modules**:
   ```bash
   lake build PotionProblem.Main
   lake build PotionProblem.IrwinHallTheory
   ```

3. **View the main theorem**:
   - Entry point: `PotionProblem.lean` (imports all modules)
   - Main theorem: `PotionProblem.Main.main_theorem`
   - Result: E[τ] = e (Euler's number)

### Testing Infrastructure

#### Lean Test Files (test/)
Various test files for API verification:
- `api_test.lean` - General API testing
- `test_irwin_hall_continuous.lean` - Continuity tests
- `test_alternating_series.lean` - Series convergence tests
- `comprehensive_api_test.lean` - Full API test suite

Run individual test:
```bash
lake env lean test/test_file.lean
```

#### Comprehensive Tests
```bash
lake build PotionProblem.ComprehensiveTests
```

### Python Support (Optional)
The project has Python dependencies for numerical verification:

```bash
# Install with uv (recommended)
uv sync

# Or with pip
pip install -e ".[numerical,dev]"

# Run numerical tests (if implemented)
potion-test
```

### Verification Workflow

1. **Check current status**:
   ```bash
   # Build and count sorries
   lake build && grep -c "sorry" PotionProblem/*.lean
   ```

2. **Verify specific theorem**:
   ```bash
   # Check if main theorem builds
   lake build PotionProblem.Main
   ```

3. **API testing before use**:
   ```bash
   # Create test file
   echo 'import Mathlib.Module
   #check API.name' > test_api.lean
   
   # Test it
   lake env lean test_api.lean
   
   # Clean up
   rm test_api.lean
   ```

### Interactive Development

For interactive theorem proving:
1. Open `.lean` files in VS Code with Lean 4 extension
2. Lake will automatically provide the Lean environment
3. Hover over definitions to see types
4. Use `#check`, `#eval`, `#print` commands

### Current Focus
The main remaining work is eliminating 4 sorries in `IrwinHallTheory.lean`. The main theorem is already proven!