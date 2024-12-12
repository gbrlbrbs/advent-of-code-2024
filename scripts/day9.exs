require AdventOfCode
alias AdventOfCode.Day9, as: D9

line = AdventOfCode.readlines("./scripts/data/day9.txt") |> Enum.at(0)
{checksum, _compacted} = D9.checksum_dense(line)

IO.inspect(checksum)

{checksum, _moved} = D9.checksum_move(line)

IO.inspect(checksum)
