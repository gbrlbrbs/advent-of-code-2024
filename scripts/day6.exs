require AdventOfCode
alias AdventOfCode.Day6, as: D6

lines = AdventOfCode.readlines("./scripts/data/day6.txt")

{visited_positions, grid, start} =
  lines
  |> D6.get_visited_positions()

num_visited =
  visited_positions
  |> MapSet.size()

num_possible_loops = D6.num_loops(visited_positions, grid, start)

IO.puts("Number of distinct visited positions: #{num_visited}")
IO.puts("Number of loops: #{num_possible_loops}")
