require AdventOfCode

{rules, print_lists} = Path.absname("./scripts/data/day5.txt")
  |> AdventOfCode.readlines()
  |> Enum.split_while(fn x -> x != "" end)
  |> then(fn {rules, lists} ->
    [_ | print_lists] = lists # second list will have the ""
    {rules, print_lists}
  end)

page_map = rules |> AdventOfCode.Day5.create_page_map()

sum_middle = AdventOfCode.Day5.sum_middle_correct(print_lists, page_map)

IO.puts("Sum of middle elements: #{sum_middle}")
