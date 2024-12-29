defmodule AdventOfCode.Day10 do
  import AdventOfCode
  alias Graph

  @directions [{0, 1}, {1, 0}, {0 ,-1}, {-1, 0}]

  def parse_lines(lines) do
    grid = create_grid(lines, &String.to_charlist/1)
    size = size_grid(grid)
    {grid, size}
  end

  def create_graph(grid, size) do
    g = Graph.new()
    create_graph({0, 0}, size, grid, g)
  end

  @spec create_graph(tuple(), tuple(), [charlist()], Graph.t()) :: Graph.t()
  defp create_graph({row, col}, {m, n}, grid, graph) when row == m and col == n do
    level = access_grid(grid, {row, col})
    graph |> Graph.add_vertex({level, {m, n}})
  end

  defp create_graph({row, col}, size, grid, graph) do
    level = access_grid(grid, {row, col})
    graph = graph |> Graph.add_vertex({level, {row, col}})
    neighbors = neighbors({row, col})
    for n <- neighbors, valid_position?(n, size), reduce: graph do
      acc ->
        next_level = access_grid(grid, n)
        if next_level - level == 1 do
          Graph.add_edge(
            create_graph(n, size, grid, acc),
            {level, {row, col}},
            {next_level, n}
          )
        else
          acc
        end
    end

  end

  defp move_one({row, col}, dir_idx) do
    {drow, dcol} = @directions |> Enum.at(dir_idx)
    {row + drow, col + dcol}
  end

  defp neighbors(position) do
    for i <- 0..3 do
      move_one(position, i)
    end
  end


end
