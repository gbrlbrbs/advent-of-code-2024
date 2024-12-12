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
      # constant time
      char = item |> binary_slice(col, sz)

      if Map.has_key?(acc_internal, char) do
        %{acc_internal | char => [{row, col} | acc_internal[char]]}
      else
        acc_internal |> Map.put(char, [{row, col}])
      end
    end)
  end

  def create_edges(antennae_positions) do
    antennae_positions
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      len_pos = length(v)

      edges =
        for {x, idx} <- v |> Enum.with_index(),
            y <- v |> Enum.slice(idx..(len_pos - 1)),
            x != y do
          {x, y}
        end

      acc |> Map.put(k, edges)
    end)
  end

  def create_antinodes(edges, size, is_part1? \\ false) do
    edges
    |> Enum.map(fn {_, l} ->
      l |> Enum.map(&parse_edge(&1, size, is_part1?))
    end)
    |> List.flatten()
    |> MapSet.new()
  end

  defp parse_edge({point_a, point_b}, size, is_part1?) do
    alias Matrex.Operators, as: MO

    a = Matrex.new([point_a |> Tuple.to_list()])
    b = Matrex.new([point_b |> Tuple.to_list()])
    vec_edge = MO.-(a, b)

    antinodes_a = gen_antinodes(a, vec_edge, &MO.+/2, size, [point_a], is_part1?)
    antinodes_b = gen_antinodes(b, vec_edge, &MO.-/2, size, [point_b], is_part1?)
    [antinodes_a, antinodes_b]
  end

  defp gen_antinodes(point, edge, op, size, acc, is_part1?) do
    antinode_m = op.(point, edge)
    antinode = antinode_m |> matrex_to_int_tuple()

    cond do
      is_part1? ->
        [antinode]

      valid_position?(antinode, size) ->
        gen_antinodes(antinode_m, edge, op, size, [antinode | acc], is_part1?)

      true ->
        acc
    end
  end

  defp matrex_to_int_tuple(m) do
    m
    |> Matrex.to_list()
    |> Enum.map(&trunc/1)
    |> List.to_tuple()
  end
end
