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
end
