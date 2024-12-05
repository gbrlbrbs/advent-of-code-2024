require AdventOfCode

lines = Path.absname("./scripts/data/day4.txt")
  |> AdventOfCode.readlines

found = lines |> AdventOfCode.Day4.search("XMAS")

num_found = length(found)

IO.puts("Number of found words: #{num_found}")
