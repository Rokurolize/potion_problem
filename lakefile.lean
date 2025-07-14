import Lake
open Lake DSL

package «potion_problem» where
  -- add package configuration options here

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.12.0"

@[default_target]
lean_lib «UniformHittingTime» where
  -- add library configuration options here