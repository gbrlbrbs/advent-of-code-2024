defmodule AdventOfCode.Day1 do
  @spec split_nums(binary()) :: list()
  defp split_nums(line) do
    Regex.scan(~r/\d+/, line)
      |> Enum.map(&Enum.at(&1, 0))
      |> Enum.map(&String.to_integer/1)
  end

  @spec transpose_lines(list(binary())) :: list(list())
  defp transpose_lines(lines) do
    lines |> Enum.map(&split_nums/1)
      |> Enum.zip_reduce([], fn elements, acc -> [elements | acc] end)
  end

  @spec total_distance(list(binary())) :: integer()
  def total_distance(lines) do
    lines |> transpose_lines
      |> Enum.map(&Enum.sort/1)
      |> Enum.zip_reduce(0, fn elements, acc ->
          abs(Enum.reduce(elements, fn x, acc -> acc - x end)) + acc
        end)
  end

  @spec similarity_id(integer(), integer(), map()) :: integer()
  defp similarity_id(id, freq_id, freqs_right) do
    freq_right = Map.get(freqs_right, id)
    case freq_right do
      nil -> 0
      _ -> id * freq_id * freq_right
    end
  end

  @spec similarity_score(list()) :: integer()
  def similarity_score(lines) do
    left = lines |> transpose_lines
      |> Enum.at(1)
    right = lines |> transpose_lines
      |> Enum.at(0)
    freqs_left = left |> Enum.frequencies
    freqs_right = right |> Enum.frequencies
    freqs_left |> Enum.map(fn {k, v} -> similarity_id(k, v, freqs_right) end)
      |> Enum.reduce(fn x, acc -> x + acc end)
  end
end
