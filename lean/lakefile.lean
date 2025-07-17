import Lake
open Lake DSL

package UniformHittingTime {
  -- Uncomment the following line to use a specific lean version
  -- leanVersion := v"4.8.0"
}

@[default_target]
lean_lib UniformHittingTime {
  -- add library configuration options here
}

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.12.0"
