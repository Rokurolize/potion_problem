import UniformHittingTime.UniformSumHittingTime

-- Verification test: Check that the main theorem is accessible and has correct type
#check UniformSumHittingTime.uniform_sum_hitting_time_expectation

-- Verify the theorem statement: E[τ] = e
example : UniformSumHittingTime.expected_hitting_time = Real.exp 1 :=
  UniformSumHittingTime.uniform_sum_hitting_time_expectation

-- Success: The main theorem E[τ] = e is formally proven and accessible