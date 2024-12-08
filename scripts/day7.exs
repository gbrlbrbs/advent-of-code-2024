require AdventOfCode
alias AdventOfCode.Day7, as: D7

lines = AdventOfCode.readlines("./scripts/data/day7.txt")

sum_valid =
  lines
  |> Enum.map(&D7.parse_line(&1, [:add, :mul, :concat]))
  |> Enum.sum()

IO.puts("Sum of valid test values: #{sum_valid}")
