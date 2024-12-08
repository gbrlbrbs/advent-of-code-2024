require AdventOfCode
alias AdventOfCode.Day8, as: D8

lines = AdventOfCode.readlines("./scripts/data/day8.txt")

{_, size, antennae_positions} = D8.parse_grid(lines)

edges = antennae_positions |> D8.create_edges()

antinodes =
  edges
  |> D8.create_antinodes(size)
  |> MapSet.size()

IO.puts("Number of distinct antinodes: #{antinodes}")
