defmodule AdventOfCode.Day8 do
  require Matrex
  import AdventOfCode

  def parse_grid(lines) do
    grid = create_grid(lines)
    size = size_grid(grid)

    antennae_positions = map_antennae_positions(lines)

    {grid, size, antennae_positions}
  end

  defp map_antennae_positions(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_positions/2)
  end

  defp parse_positions({item, row}, acc) do
    Regex.scan(~r/[\da-zA-Z]/, item, return: :index)
    |> List.flatten()
    |> Enum.reduce(acc, fn {col, sz}, acc_internal ->
      char = item |> binary_slice(col, sz) # constant time
      if Map.has_key?(acc_internal, char) do
        %{acc_internal | char => [{row, col} | acc_internal[char]]}
      else
        acc_internal |> Map.put(char, [{row, col}])
      end
    end)
  end

  
end
