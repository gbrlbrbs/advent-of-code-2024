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

  defp parse_update(update, page_map) do
    pages = update |> Enum.reverse()
    accum_init = %{is_ordered: true, tail: []}

    pages
    |> Enum.reduce_while(accum_init, fn elem, acc ->
      pages_before = page_map[elem]
      tail_list = [elem | acc[:tail]]
      has_no_pages_after = right_order?(pages_before, acc) and acc[:is_ordered]

      case has_no_pages_after do
        true -> {:cont, %{acc | is_ordered: true, tail: tail_list}}
        false -> {:halt, %{acc | is_ordered: false}}
      end
    end)
  end

  defp parse_line_and_get_middle(line, page_map) do
    update = line |> String.split(",")
    middle_element = update |> Enum.at(div(length(update) - 1, 2))

    update_status = parse_update(update, page_map)

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
    |> Enum.map(&parse_line_and_get_middle(&1, page_map))
    |> Enum.sum()
  end

  @spec sorting_with_map(binary(), binary(), map()) :: boolean()
  defp sorting_with_map(left, right, page_map) do
    preceding_left = page_map[left]

    case preceding_left do
      # not in the page map, so their relative ordering doesn't matter
      nil ->
        true

      # a set
      left_set ->
        # if right is in this set, then they should switch
        # if right is not in this set -> either left is in or is not in the right set -> true for both cases
        not MapSet.member?(left_set, right)
    end
  end

  defp sort_incorrect(line, page_map) do
    update = line |> String.split(",")

    update_status = parse_update(update, page_map)

    case update_status[:is_ordered] do
      true ->
        0

      false ->
        update
        |> Enum.sort(&sorting_with_map(&1, &2, page_map))
        |> Enum.at(div(length(update) - 1, 2))
        |> String.to_integer()
    end
  end

  @spec sum_middle_incorrect(list(binary()), map()) :: number()
  def sum_middle_incorrect(lines, page_map) do
    lines |> Enum.map(&sort_incorrect(&1, page_map)) |> Enum.sum()
  end
end
