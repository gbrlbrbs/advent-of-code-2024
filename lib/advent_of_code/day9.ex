defmodule AdventOfCode.Day9 do
  @spec parse_digits(any()) :: {integer(), [integer()]}
  def parse_digits(line) do
    blocks =
      line
      |> Enum.with_index()
      |> create_blocks()
      |> List.flatten()
      |> Enum.with_index()

    file_blocks =
      blocks
      |> Enum.filter(fn {element, _} -> element > -1 end)
      |> Enum.reverse()

    compacted_blocks = compact_blocks(blocks, file_blocks)

    {calculate_checksum(compacted_blocks), compacted_blocks}
  end

  defp create_blocks(digits, is_file \\ true)
  defp create_blocks([], _), do: []
  defp create_blocks([head | tail], is_file) do
    {size, index} = head
    size_int = String.to_integer(size)
    id = div(index, 2)
    id_list =
      if size_int >= 1 do
        for _ <- 1..size_int do
          if is_file, do: id, else: -1
        end
      else
        []
      end
    [id_list | create_blocks(tail, not is_file)]
  end

  defp compact_blocks([], _), do: []
  defp compact_blocks([block_idx | remaining_blocks], [file_idx | remaining_files]) do
    # se o bloco atual for -1, trocar ele por file
    # se o bloco atual for um file, continua
    # parada: chegou ao final da primeira lista
    # retorna []
    {block, _} = block_idx
    cond do
      Enum.all?([block_idx | remaining_blocks], fn {element, _} -> element == -1 end) ->
        []
      block == -1 ->
        {file, file_index} = file_idx
        updated_remaining =
          remaining_blocks
          |> Enum.take_while(fn {_, index} -> index < file_index end)
        [file | compact_blocks(updated_remaining, remaining_files)]
      block > -1 ->
        [block | compact_blocks(remaining_blocks, [file_idx | remaining_files])]
    end
  end

  @spec calculate_checksum(list(integer())) :: integer()
  defp calculate_checksum(blocks) do
    blocks
    |> Enum.with_index()
    |> Enum.map(fn {element, index} -> element * index end)
    |> Enum.sum()
  end
end
