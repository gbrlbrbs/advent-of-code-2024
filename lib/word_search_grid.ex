defmodule WordSearchGrid do
  defmodule Location do
    defstruct [:from, :to]

    @type t :: %{
      from: %{row: integer, column: integer},
      to: %{row: integer, column: integer}
    }
  end

  @directions {{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}}

  def search(lines, words) do
    grid_map = lines |> grid

    words |> Enum.reduce(%{}, fn word, acc ->
      Map.put(acc, word, word_location(grid_map, Map.keys(grid_map), word))
    end)
  end

  defp grid(lines) do
    for {line, row} <- lines |> Enum.with_index,
        {char, col} <- line |> String.graphemes |> Enum.with_index,
        reduce: %{} do
          acc -> Map.put(acc, {row, col}, char)
    end
  end

  defp word_location(_, [], _), do: nil
  defp word_location(grid_map, [position | tail], word) do
    indexed_word = word |> String.graphemes |> Enum.with_index

    case check_position(grid_map, position, @directions, indexed_word) do
      nil -> word_location(grid_map, tail, word)
      location -> location
    end
  end

  defp check_position(_, _, [], _), do: nil
  defp check_position(_, _, _, []), do: nil
  defp check_position(grid_map, {row, col}, directions, [{letter, letter_idx} | tail]) do
    check_letter_grid = fn {x, y} ->
      row_idx = row + y * letter_idx
      col_idx = col + x * letter_idx
      grid_map[{row_idx, col_idx}] == letter
    end

    rem_dirs = directions |> Enum.filter(check_letter_grid)

    case {tail, rem_dirs} do
      {[], [{x, y} | _]} ->
        %Location{
          from: %{row: row + 1, column: col + 1},
          to: %{row: row + y * letter_idx + 1, column: col + x * letter_idx + 1}
        }
      _ -> check_position(grid_map, {row, col}, rem_dirs, tail)
    end
  end
end
