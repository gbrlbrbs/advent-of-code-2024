defmodule AdventOfCode.Day4 do
  @x_directions [{1, 1}, {1, -1}, {-1, 1}, {-1, -1}]
  @directions [{0, 1}, {0, -1}, {1, 0}, {-1, 0}] ++ @x_directions

  defp valid_position?({y, x}, {m, n}) do
    x >= 0 and x < n and y >= 0 and y < m
  end

  @spec search(list(binary()), binary(), boolean()) :: list()
  def search(lines, word, use_x \\ false) do
    m = length(lines)
    n = String.length(hd(lines))

    dirs = if use_x, do: @x_directions, else: @directions

    for row <- 0..m-1,
        col <- 0..n-1,
        dir <- dirs,
        check_word(lines, word, {row, col}, dir, {m, n}) do
          {{row, col}, dir}
    end
  end

  defp check_word(grid, word, {y, x}, {dy, dx}, {m, n}) do
    word |> String.graphemes()
     |> Enum.with_index()
     |> Enum.all?(fn {char, idx} ->
      row = y + idx * dy
      col = x + idx * dx

      if valid_position?({row, col}, {m, n}) do
        get_letter(grid, row, col) == char
      else
        false
      end
    end)
  end

  @spec get_letter(list(binary()), integer(), integer()) :: nil | binary()
  defp get_letter(grid, row, col) do
    grid |> Enum.at(row) |> String.at(col)
  end

  @spec calculate_center(list(tuple()), integer()) :: list()
  def calculate_center(found_positions, center_idx) do
    found_positions |> Enum.map(fn {{row, col}, {dy, dx}} ->
      {row + center_idx * dy, col + center_idx * dx}
    end)
  end
end
