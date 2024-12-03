require AdventOfCode

parse_numbers = fn x ->
  Regex.scan(~r/\d+/, x)
  |> List.flatten()
  |> Enum.map(&String.to_integer/1)
end

reports = Path.absname("./scripts/data/day2.txt")
  |> AdventOfCode.readlines
  |> Enum.map(parse_numbers)

safe_reports = reports
  |> Enum.count(&AdventOfCode.Day2.is_safe?/1)

IO.puts("Number of safe reports: #{safe_reports}")

safe_with_dampener = reports
  |> Enum.count(&AdventOfCode.Day2.safe_with_dampener?/1)

IO.puts("Dampened reports: #{safe_with_dampener}")
