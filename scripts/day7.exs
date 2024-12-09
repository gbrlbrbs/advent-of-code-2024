require AdventOfCode
alias AdventOfCode.Day7, as: D7

lines = AdventOfCode.readlines("./scripts/data/day7.txt")

valid_add_mul =
  lines
  |> Enum.map(&D7.parse_line(&1, [:add, :mul]))

sum_valid =
  valid_add_mul
  |> Enum.reduce(0, fn {value, _}, acc ->
    acc + value
  end)

IO.puts("Sum of valid test values using add and mul: #{sum_valid}")

sum_valid_concat =
  valid_add_mul
  # filter out valid lines
  |> Enum.filter(fn {value, _} ->
    value == 0
  end)
  # parse invalid lines
  |> Enum.map(fn {_, line} ->
    D7.parse_line(line, [:add, :mul, :concat])
  end)
  |> Enum.reduce(0, fn {value, _}, acc -> acc + value end)

IO.puts("Sum of valid using all three: #{sum_valid + sum_valid_concat}")
