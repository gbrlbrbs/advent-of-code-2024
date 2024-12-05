require AdventOfCode
lines = Path.absname("./scripts/data/day3.txt")
  |> AdventOfCode.readlines

sum_mults = lines
  |> AdventOfCode.Day3.sum_mul_instructions

IO.puts("Sum of mul instructions: #{sum_mults}")

sum_enabled = lines |> AdventOfCode.Day3.sum_enabled()

IO.puts("Sum of enabled mul instructions: #{sum_enabled}")
