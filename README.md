# Potion Problem - Organized Project Structure

This repository has been reorganized for better separation of concerns. The Potion Problem (媚薬問題) project proves that E[τ] = e through Lean 4 formalization.

## 📁 Project Organization

```
potion_problem/
├── lean-core/        # Pure Lean 4 formalization
├── viz/              # TypeScript/WebGL visualizations  
├── docs/             # Consolidated documentation
└── tools/            # Support tools and utilities
```

### Component Directories

#### **lean-core/** - Lean 4 Formalization
The clean, focused Lean 4 proof that E[τ] = e with ZERO sorries in the main theorem.
- Core mathematical formalization
- Test suite
- Build configuration

#### **viz/** - Interactive Visualizations
TypeScript/WebGL visualizations illustrating the mathematical concepts.
- 3D probability simplex
- Interactive simulations
- Series convergence animations

#### **docs/** - Documentation Hub
Central location for all project documentation.
- `elegant_solution.md` - Complete mathematical exposition
- Technical guides and workflows
- API references

#### **tools/** - Development Tools
Supporting utilities for the project.
- API database for mathlib4 discovery
- Python configuration
- Build logs

## 🚀 Quick Start

### Build the Lean 4 Proof
```bash
cd lean-core
lake build
```

### Run Visualizations
```bash
cd viz
npm install
npm run dev
```

### View Documentation
Start with `docs/elegant_solution.md` for the mathematical journey.

## 📊 Project Status

✅ **Main Theorem**: Proven with ZERO sorries  
✅ **Clean Architecture**: Properly separated concerns  
✅ **Full Documentation**: Mathematical and technical guides

For detailed information about each component, see the README files in each directory.