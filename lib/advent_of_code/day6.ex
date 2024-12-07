defmodule AdventOfCode.Day6 do
  alias AdventOfCode.Day4, as: D4

  @directions [{-1, 0}, {0, 1}, {1, 0}, {0, -1}] # {row, column} format

  def get_visited_positions(lines) do
    %{x: start_x, y: start_y} = lines
    |> Enum.with_index()
    |> Enum.reduce(%{y: nil, x: nil}, &search_guard/2)

    start_guard({start_x, start_y}, lines)
  end

  defp search_guard({line, y}, acc) do
    idx = line
     |> String.graphemes()
     |> Enum.find_index(&(&1 == "^"))
    case idx do
      nil -> acc
      x when is_integer(x) -> %{acc | y: y, x: x}
    end
  end

  defp start_guard({start_y, start_x}, lines) do
    grid =
      lines
      |> Enum.map(&String.graphemes/1)
    {m, n} = D4.size_grid(grid)
    dir_idx = 0
    seen_positions = MapSet.new()

    move_guard({start_y, start_x}, {m, n}, grid, dir_idx, seen_positions)
  end

  @spec move_guard(tuple(), tuple(), list(list()), integer(), map()) :: map()
  defp move_guard({y, x}, {m, n}, grid, dir_idx, seen) do
    if D4.valid_position?({y, x}, {m, n}) do
      seen = seen |> MapSet.put({y, x})
      {next_y, next_x} = move_one({y, x}, dir_idx)
      {next_y, next_x} =
        case grid[next_y][next_x] do
          "#" ->
            dir_idx = Integer.mod(dir_idx + 1, 4)
            move_one({y, x}, dir_idx)
          _ ->
            {next_y, next_x}
        end
      move_guard({next_y, next_x}, {m, n}, grid, dir_idx, seen)
    else
      seen
    end
  end

  defp move_one({y, x}, dir_idx) do
    {y + @directions[dir_idx][0], x + @directions[dir_idx][1]}
  end

end
