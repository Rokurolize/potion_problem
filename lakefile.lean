import Lake
open Lake DSL

package «potion_problem» where
  -- add package configuration options here

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.15.0"

@[default_target]
lean_lib «UniformHittingTime» where
  -- add library configuration options here

lean_lib «GenuinelyWorking» where
  -- Actually working formal verification

lean_lib «ReallyWorking» where
  -- Actually working formal verification - fixed

lean_lib «GenuineDemo» where
  -- Genuinely working formal mathematics demonstration

lean_lib «SimpleDemo» where
  -- Simple working formal mathematics demonstration

lean_exe «WorkingMinimal» where
  root := `WorkingMinimal

lean_exe «FinalDemo» where
  root := `FinalDemo