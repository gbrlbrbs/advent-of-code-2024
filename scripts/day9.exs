require AdventOfCode
alias AdventOfCode.Day9, as: D9

line = AdventOfCode.readlines("./scripts/data/day9_test.txt") |> Enum.at(0)
{checksum, compacted} = D9.checksum_dense(line)

IO.inspect(checksum)
IO.inspect(compacted)

{checksum, moved} = D9.checksum_move(line)

IO.inspect(checksum)
IO.inspect(moved)
