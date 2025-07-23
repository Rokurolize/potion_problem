/-
Copyright (c) 2025 Mathematical Development Team. All rights reserved.
Released under MIT License as described in the file LICENSE.
Authors: Astolfo and Contributors
-/
import UniformHittingTime.UniformSumHittingTime
import UniformHittingTime.FactorialSeries
import UniformHittingTime.HittingTime
import UniformHittingTime.IrwinHall

/-!
# Uniform Hitting Time Analysis

This module provides the main exports for the uniform hitting time analysis,
proving that E[τ] = e where τ is the hitting time for uniform random sums.

## Main Results

- `UniformSumHittingTime.uniform_sum_hitting_time_expectation`: The main theorem E[τ] = e
- `UniformSumHittingTime.hitting_time_expectation`: Foundation exponential series equality
- `UniformSumHittingTime.telescoping_property`: Core telescoping property

## Module Structure

- `IrwinHall`: Irwin-Hall distribution properties
- `FactorialSeries`: Factorial series convergence results
- `HittingTime`: Hitting time PMF formulas
- `UniformSumHittingTime`: Main theorem and proof architecture
-/

-- Re-export main results
open UniformSumHittingTime
