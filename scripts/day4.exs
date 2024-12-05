require AdventOfCode

lines = Path.absname("./scripts/data/day4.txt")
  |> AdventOfCode.readlines

found = lines |> AdventOfCode.Day4.search("XMAS")

num_found = length(found)

IO.puts("Number of found words: #{num_found}")

found_x_mas = lines |> AdventOfCode.Day4.search("MAS", true)
mas_centers = found_x_mas |> AdventOfCode.Day4.calculate_center(1)
  |> Enum.frequencies()

IO.inspect(mas_centers)

num_found_x_mas = mas_centers |> Enum.count(fn {_, v} -> v == 2 end)

IO.puts("Found X-MAS: #{num_found_x_mas}")
