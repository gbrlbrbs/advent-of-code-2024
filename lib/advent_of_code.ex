defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  @spec readlines(binary()) :: list()
  def readlines(filepath) do
    filepath
    |> Path.absname()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def create_grid(lines, map_func \\ &String.graphemes/1), do: lines |> Enum.map(map_func)

  def access_grid(grid, {row, col}), do: grid |> Enum.at(row) |> Enum.at(col)

  def size_grid(grid), do: {length(grid), length(hd(grid))}

  @spec valid_position?({integer(), integer()}, {integer(), integer()}) :: boolean()
  def valid_position?({row, col}, {m, n}) do
    row >= 0 and row < m and col >= 0 and col < n
  end
end
