defmodule AdventOfCode.Day5 do
  def create_page_map(rules) do
    rules
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.reduce(%{}, fn [left, right], acc ->
      item = acc[right]

      to_insert =
        case item do
          nil -> MapSet.new([left])
          _ -> item |> MapSet.put(left)
        end

      Map.put(acc, right, to_insert)
    end)
  end

  defp parse_update(line, page_map) do
    pages = line |> String.split(",")
    middle_element = pages |> Enum.at(div(length(pages) - 1, 2))
    accum_init = %{is_ordered: true, tail: []}

    update_status =
      pages
      |> Enum.reverse()
      |> Enum.reduce_while(accum_init, fn elem, acc ->
        pages_before = page_map[elem]
        tail_list = [elem | acc[:tail]]
        has_no_pages_after = right_order?(pages_before, acc) and acc[:is_ordered]

        case has_no_pages_after do
          true -> {:cont, %{acc | is_ordered: has_no_pages_after, tail: tail_list}}
          false -> {:halt, %{acc | is_ordered: has_no_pages_after}}
        end
      end)

    case update_status[:is_ordered] do
      true -> String.to_integer(middle_element)
      false -> 0
    end
  end

  defp right_order?(pages_before, %{is_ordered: _, tail: tail_list}) do
    tail_set = MapSet.new(tail_list)

    has_intersection =
      MapSet.intersection(pages_before, tail_set)
      |> MapSet.size() > 0

    not has_intersection
  end

  def sum_middle_correct(lines, page_map) do
    lines
    |> Enum.map(&parse_update(&1, page_map))
    |> Enum.sum()
  end
end
