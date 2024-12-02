defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  @spec readlines(binary()) :: list()
  def readlines(filepath) do
    lines = File.stream!(filepath)
      |> Stream.map(&String.trim/1)
      |> Enum.to_list
    lines
  end
end
