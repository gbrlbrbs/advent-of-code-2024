defmodule AdventOfCode.Day2 do
  defp is_same_order?([head | tail], prev, reverse_fun) do
    if reverse_fun.(prev, head) do
      false
    else
      is_same_order?(tail, head, reverse_fun)
    end
  end

  defp is_same_order?([], _, _), do: true

  defp is_monotonic?([head | tail]) do
    is_same_order?(tail, head, &Kernel.>/2) or is_same_order?(tail, head, &Kernel.</2) # O(n)
  end

  @spec is_safe?(list(integer())) :: boolean()
  @doc """
  Checks if a report is safe. Receives the report as a list of integer values.
  """
  def is_safe?(report) do
    diffs_safe? = report |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> abs(a - b) end)
      |> Enum.all?(fn x -> x >= 1 and x <= 3 end) # O(n)
    is_monotonic?(report) and diffs_safe?
  end

  @spec safe_with_dampener?(list(integer())) :: boolean()
  def safe_with_dampener?(report) do
    is_safe?(report) or dampened?(report, length(report) - 1)
  end

  defp dampened?(report, index) when index >= 0 do
    sliced = List.delete_at(report, index)

    is_safe?(sliced) or dampened?(report, index - 1)
  end

  defp dampened?(_, -1), do: false
end
