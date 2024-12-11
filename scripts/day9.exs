require AdventOfCode
alias AdventOfCode.Day9, as: D9

line =
  AdventOfCode.readlines("./scripts/data/day9.txt")
  |> Enum.at(0)
  |> String.graphemes()

{checksum, blocks} = D9.parse_digits(line)

IO.puts("Checksum; #{checksum}")
IO.inspect(blocks)
IO.inspect(blocks |> Enum.all?(&(&1 > -1)))
