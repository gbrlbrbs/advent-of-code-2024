defmodule AdventOfCode.Day6 do
  import AdventOfCode

  # {row, column} format
  @directions [[-1, 0], [0, 1], [1, 0], [0, -1]]

  @spec get_visited_positions(list()) :: tuple()
  def get_visited_positions(lines) do
    %{x: start_x, y: start_y} =
      lines
      |> start_position()

    start_guard({start_y, start_x}, lines)
  end

  defp start_position(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{y: nil, x: nil}, &search_guard/2)
  end

  defp search_guard({line, y}, acc) do
    idx =
      line
      |> String.graphemes()
      |> Enum.find_index(&(&1 == "^"))

    case idx do
      nil -> acc
      x when is_integer(x) -> %{acc | y: y, x: x}
    end
  end

  @spec start_guard(tuple(), list()) :: tuple()
  defp start_guard(start, lines) do
    grid =
      lines
      |> Enum.map(&String.graphemes/1)

    size = size_grid(grid)
    dir_idx = 0
    seen_positions = MapSet.new()

    {move_guard(start, size, grid, dir_idx, seen_positions), grid, start}
  end

  @spec move_guard(tuple(), tuple(), list(list()), integer(), map()) :: MapSet.t()
  defp move_guard({y, x}, {m, n}, grid, dir_idx, seen) do
    seen = seen |> MapSet.put({y, x})
    {next_y, next_x} = move_one({y, x}, dir_idx)

    if valid_position?({next_y, next_x}, {m, n}) do
      case access_grid(grid, next_y, next_x) do
        "#" ->
          new_dir = Integer.mod(dir_idx + 1, 4)
          move_guard({y, x}, {m, n}, grid, new_dir, seen)

        _ ->
          move_guard({next_y, next_x}, {m, n}, grid, dir_idx, seen)
      end
    else
      seen
    end
  end

  defp move_one({y, x}, dir_idx) do
    dy = @directions |> access_grid(dir_idx, 0)
    dx = @directions |> access_grid(dir_idx, 1)
    {y + dy, x + dx}
  end

  @spec num_loops(MapSet.t(), list(), tuple()) :: integer()
  def num_loops(visited_positions, grid, start) do
    size = grid |> size_grid()
    dir_idx = 0
    seen = MapSet.new()

    visited_positions
    |> MapSet.to_list()
    |> Enum.filter(&(&1 != start and will_loop?(start, &1, size, grid, dir_idx, seen)))
    |> length()
  end

  defp will_loop?({y, x}, {obs_y, obs_x}, {m, n}, grid, dir_idx, seen) do
    {next_y, next_x} = move_one({y, x}, dir_idx)

    cond do
      # final, will return true
      MapSet.member?(seen, {y, x, dir_idx}) ->
        true

      # initial, change dir and recurse
      {next_y, next_x} == {obs_y, obs_x} ->
        new_dir = Integer.mod(dir_idx + 1, 4)
        seen = seen |> MapSet.put({y, x, dir_idx})
        will_loop?({y, x}, {obs_y, obs_x}, {m, n}, grid, new_dir, seen)

      # neither, just recurse
      valid_position?({next_y, next_x}, {m, n}) ->
        seen = seen |> MapSet.put({y, x, dir_idx})

        case access_grid(grid, next_y, next_x) do
          "#" ->
            new_dir = Integer.mod(dir_idx + 1, 4)
            will_loop?({y, x}, {obs_y, obs_x}, {m, n}, grid, new_dir, seen)

          _ ->
            will_loop?({next_y, next_x}, {obs_y, obs_x}, {m, n}, grid, dir_idx, seen)
        end

      # if last one is false, the guard has gone off the map, return false
      true ->
        false
    end
  end
end
