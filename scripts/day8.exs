require AdventOfCode
alias AdventOfCode.Day8, as: D8

lines = AdventOfCode.readlines("./scripts/data/day8.txt")

{_, size, antennae_positions} = D8.parse_grid(lines)

edges = antennae_positions |> D8.create_edges()

antinodes_pt1 =
  edges
  |> D8.create_antinodes(size, true)
  |> MapSet.size()

IO.puts("Number of distinct antinodes: #{antinodes_pt1}")

antinodes_pt2 =
  edges
  |> D8.create_antinodes(size)
  |> MapSet.size()

IO.puts("Number of antinodes in part 2: #{antinodes_pt2}")
