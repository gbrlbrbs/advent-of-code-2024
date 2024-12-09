defmodule AdventOfCode.Day7 do
  def parse_line(line, ops) do
    [test_value | calibration] =
      line
      |> String.split(": ")

    test_value = String.to_integer(test_value)

    is_valid? =
      calibration
      |> Enum.at(0)
      |> String.split(" ")
      |> then(&can_solve?(tl(&1), hd(&1), test_value, ops))

    if is_valid?, do: {test_value, line}, else: {0, line}
  end

  defp can_solve?([], acc, test_value, _), do: String.to_integer(acc) == test_value

  defp can_solve?([head | tail], acc, test_value, ops) do
    acc_int = String.to_integer(acc)
    head_int = String.to_integer(head)

    if acc_int > test_value do
      false
    else
      for op <- ops do
        case op do
          :mul -> can_solve?(tail, Integer.to_string(acc_int * head_int), test_value, ops)
          :add -> can_solve?(tail, Integer.to_string(acc_int + head_int), test_value, ops)
          :concat -> can_solve?(tail, acc <> head, test_value, ops)
        end
      end
      |> Enum.any?()
    end
  end
end
