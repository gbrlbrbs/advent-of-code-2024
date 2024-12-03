defmodule AdventOfCode.Day2 do
  defp is_increasing?([head | tail], prev) do
    if prev > head do
      false
    else
      is_increasing?(tail, head)
    end
  end

  defp is_increasing?([], _), do: true

  defp is_decreasing?([head | tail], prev) do
    if prev < head do
      false
    else
      is_decreasing?(tail, head)
    end
  end

  defp is_decreasing?([], _), do: true

  defp is_monotonic?([head | tail]) do
    is_increasing?(tail, head) or is_decreasing?(tail, head)
  end

  @spec is_safe?(list(integer())) :: boolean()
  @doc """
  Checks if a report is safe. Receives the report as a list of integer values.
  """
  def is_safe?(report) do
    diffs_safe? = report |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> abs(a - b) end)
      |> Enum.all?(fn x -> x >= 1 and x <= 3 end)
    is_monotonic?(report) and diffs_safe?
  end

  @spec safe_with_dampener?(list(integer())) :: boolean()
  def safe_with_dampener?(report) do
    is_safe?(report) or dampened?(report)
  end

  defp dampened?(report, index \\ 0) do
    if index >= length(report) do
      false
    else
      sliced = List.delete_at(report, index)

      is_safe?(sliced) or dampened?(report, index + 1)
    end
  end
end
