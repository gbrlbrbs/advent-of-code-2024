defmodule AdventOfCode.Day3 do
  @spec mul_pair(list(binary())) :: integer()
  defp mul_pair(pair) do
    pair |> Enum.map(&String.to_integer/1) |> Enum.product()
  end

  @spec scan_line(binary()) :: number()
  defp scan_line(line) do
    Regex.scan(~r/mul\((?<left>\d+),(?<right>\d+)\)/, line, capture: :all_but_first)
    |> Enum.map(&mul_pair/1)
    |> Enum.sum()
  end

  def sum_mul_instructions(lines) do
    lines
    |> Enum.map(&scan_line/1)
    |> Enum.sum()
  end

  defp scan_with_conditionals(line) do
    Regex.scan(~r/(?:mul\((?<left>\d+),(?<right>\d+)\)|(?<cond>do\(\)|don't\(\)))/, line,
      capture: :all_but_first
    )
    |> Enum.map(&Enum.reject(&1, fn x -> x == "" end))
  end

  def parse_all(lines) do
    lines |> Enum.flat_map(&scan_with_conditionals/1)
  end

  defp state_machine(list, enabled \\ true)
  defp state_machine([], _), do: 0

  defp state_machine([head | tail], enabled) do
    case head do
      [a, b] ->
        mul = if enabled, do: String.to_integer(a) * String.to_integer(b), else: 0
        mul + state_machine(tail, enabled)

      ["don't()"] ->
        state_machine(tail, false)

      ["do()"] ->
        state_machine(tail, true)
    end
  end

  def sum_enabled(lines) do
    lines
    |> parse_all
    |> state_machine
  end
end
