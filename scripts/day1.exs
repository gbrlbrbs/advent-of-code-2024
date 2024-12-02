require AdventOfCode

value = Path.absname("./scripts/data/day1.txt")
  |> AdventOfCode.readlines
  |> AdventOfCode.Day1.total_distance

IO.puts("Total distance: #{value}")

sim_score = Path.absname("./scripts/data/day1.txt")
  |> AdventOfCode.readlines
  |> AdventOfCode.Day1.similarity_score

IO.puts("Sim score: #{sim_score}")
