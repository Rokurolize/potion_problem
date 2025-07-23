/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
import UniformHittingTime.StoppingTimeBasic
import UniformHittingTime.UniformSumHittingTime

-- Suppress linter warnings for design suggestions and imports
set_option linter.upstreamableDecl false
set_option linter.minImports false

/-!
# Uniform Hitting Time Analysis

This module provides the main exports for the uniform hitting time analysis,
proving that E[τ] = e where τ is the hitting time for uniform random sums.

## Main Results

- `UniformSumHittingTime.uniform_sum_hitting_time_expectation`: The main theorem E[τ] = e
- `UniformSumHittingTime.hitting_time_expectation`: Foundation exponential series equality
- `UniformSumHittingTime.telescoping_property`: Core telescoping property

## Module Structure

- `StoppingTimeBasic`: Basic definitions and properties
- `UniformSumHittingTime`: Main theorem and proof architecture
-/
