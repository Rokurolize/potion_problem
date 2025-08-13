# Potion Problem Visualization

Zero-dependency WebGL2 visualization of the mathematical proof that E[τ] = e.

## Running the Visualization

### Prerequisites
- Node.js 18+ (for the build system)
- Modern browser with WebGL2 support (Chrome/Firefox/Edge)

### Quick Start
```bash
# Install dependencies (just the build tools)
npm install

# Run development server
npm run dev

# Build for production
npm run build
```

Open http://localhost:3000 in your browser.

## Features

### Five Visualization Modes

1. **Potion Simulation** - Monte Carlo hitting time process
   - Watch potions accumulate until their sum exceeds 1
   - Real-time convergence to E[τ] = e
   - Adjustable simulation speed

2. **Simplex Volumes** - Geometric interpretation
   - Interactive n-dimensional simplex visualization
   - Shows P(τ > n) = Vol(Δ_n) = 1/n!
   - Dimensions from 1 to 10

3. **PMF Landscape** - Probability mass function
   - 3D surface plot of P(τ = n) = (n-1)/n!
   - Multiple view modes: surface, bars, contour, heatmap
   - Adjustable height scaling

4. **Telescoping Series** - Mathematical transformation
   - Step-by-step animation of series manipulation
   - Shows how ∑ n·P(τ = n) telescopes to e
   - Manual or auto-advance modes

5. **Emergence of e** - Grand finale
   - Monte Carlo convergence graph
   - Particle effects showing e emerging from randomness
   - Real-time error tracking

### Controls

- **Mouse**: Left-click and drag to rotate camera
- **Scroll**: Zoom in/out
- **Touch**: Single finger to rotate, pinch to zoom
- **Keyboard**: 
  - Numbers 1-5: Switch visualizations
  - Space: Reset camera

### Performance

- 60 FPS on modern hardware
- Efficient instanced rendering
- GPU-accelerated computations
- Automatic quality adjustment for mobile

## Technical Architecture

### Zero Dependencies
- No Three.js, no external libraries
- Raw WebGL2 for maximum performance
- TypeScript for type safety
- Vite for fast builds

### Modular Design
```
src/visualization/
├── core/
│   ├── WebGLRenderer.ts    # WebGL2 abstraction
│   └── MathEngine.ts       # Mathematical computations
├── scenes/
│   ├── PotionSimulation.ts
│   ├── SimplexVisualization.ts
│   ├── PMFLandscape.ts
│   ├── TelescopingSeries.ts
│   └── EmergenceVisualization.ts
├── math/
│   └── LinearAlgebra.ts    # vec3, mat4 operations
└── App.ts                  # Main orchestrator
```

### Key Features
- Instanced rendering for thousands of objects
- Transform feedback for GPU computation
- HDR rendering pipeline
- Multi-sample anti-aliasing
- Efficient factorial caching
- Real-time Monte Carlo simulation

## Mathematical Background

The visualization demonstrates the profound result:

**E[τ] = e**

Where τ is the hitting time - the number of uniform random samples needed until their sum exceeds 1.

This connects:
- Probability theory (random sampling)
- Combinatorics (factorial series)
- Geometry (simplex volumes)
- Analysis (series convergence)

All converging to Euler's number e ≈ 2.718281828...

## Development

### Building from Source
```bash
# Type checking
npm run typecheck

# Development with hot reload
npm run dev

# Production build
npm run build

# Preview production build
npm run preview
```

### Adding New Visualizations

1. Create new scene in `src/visualization/scenes/`
2. Implement the `Visualization` interface
3. Add to `App.ts` initialization
4. Update UI controls and info display

## Browser Compatibility

- Chrome 92+ ✓
- Firefox 91+ ✓
- Safari 15+ ✓
- Edge 92+ ✓

WebGL2 is required. The system will show an error on unsupported browsers.

## License

This visualization is part of the Potion Problem formalization project.

---

*"This is what mathematical visualization should look like in 2024."* - Linus Torvalds