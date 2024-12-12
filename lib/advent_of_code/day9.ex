defmodule AdventOfCode.Day9 do
  defmodule DiskMapEntry do
    defstruct [:id, offset: 0, size: 0, type: :free]

    @type t :: %DiskMapEntry{
            id: integer(),
            offset: integer(),
            size: integer(),
            type: atom()
          }

    def new(), do: %DiskMapEntry{}
    def new_free(offset, size), do: %DiskMapEntry{offset: offset, size: size}
    def new_file(id, offset, size), do:
          %DiskMapEntry{type: :file, offset: offset, size: size, id: id}
  end

  @spec parse_input(binary()) :: {list(), list()}
  def parse_input(line) do
    line
    |> String.to_charlist()
    |> Enum.scan({0, %DiskMapEntry{}}, &create_blocks/2)
    |> Enum.map(fn {_, x} -> x end)
    |> Enum.split_with(fn x -> x.type == :file end)
  end

  def checksum_dense(line) do
    {files, free} = parse_input(line)
    compacted = dense_compact(files |> Enum.reverse(), free)
    {checksum(compacted), compacted |> Enum.sort_by(&(&1.offset))}
  end

  def checksum_move(line) do
    {files, free} = parse_input(line)
    moved_files = move_files(files |> Enum.reverse(), free)
    {checksum(moved_files), moved_files |> Enum.sort_by(&(&1.offset))}
  end

  defp checksum(files) do
    files
    |> Enum.reduce(0, fn %DiskMapEntry{id: id, offset: off, size: sz}, acc ->
      acc + div(sz * (2 * off + sz - 1), 2) * id
    end)
  end

  defp create_blocks(
    c,
    {
      entrynum,
      %DiskMapEntry{type: :free, offset: off, size: sz}
    }
  ), do: {entrynum, %DiskMapEntry{offset: off + sz, size: c - ?0, type: :file, id: entrynum}}
  defp create_blocks(
    c,
    {
      entrynum,
      %DiskMapEntry{type: :file, offset: off, size: sz}
    }
  ), do: {entrynum + 1, %DiskMapEntry{type: :free, offset: off + sz, size: c - ?0}}

  defp dense_compact([], _), do: []
  defp dense_compact(files, []), do: files
  defp dense_compact(files, [%DiskMapEntry{size: 0} | free]), do: dense_compact(files, free)
  defp dense_compact(files = [%DiskMapEntry{offset: off_file} | _], [%DiskMapEntry{offset: off_free} | _])
  when off_file <= off_free, do: files
  # when whole file can be moved -> edit the free space
  defp dense_compact(
    [%DiskMapEntry{id: id, size: sz_file} | files],
    [%DiskMapEntry{offset: off_free, size: sz_free} | free]
  ) when sz_free >= sz_file do
    [
      DiskMapEntry.new_file(id, off_free, sz_file)
      | dense_compact(files, [DiskMapEntry.new_free(off_free + sz_file, sz_free - sz_file) | free])
    ]
  end
  # when some of the file can be moved -> edit the file at the end (beginning of list), create new at the beginning (head of return)
  # free space at head is deleted
  defp dense_compact(
    [%DiskMapEntry{id: id, size: sz_file, offset: off_file} | files],
    [%DiskMapEntry{offset: off_free, size: sz_free} | free]
  ) do
    [
      DiskMapEntry.new_file(id, off_free, sz_free)
      | dense_compact([DiskMapEntry.new_file(id, off_file, sz_file - sz_free) | files], free)
    ]
  end

  defp move_files([], _), do: []
  defp move_files([file | remaining_files], frees) do
    frees_before = frees |> Enum.filter(&is_before_file?(file, &1))
    case find_free_space(file, frees_before) do
      {:not_found, _, _} ->
        [file | move_files(remaining_files, frees_before)]
      {:found, new_frees, new_file} ->
        [new_file | move_files(remaining_files, new_frees)]
    end
  end

  # try to find a free space large enough for the file
  # if found, edit and return the free space list along with the moved file with the :found atom
  # if not found, return the :not_found atom
  defp find_free_space(file, frees) do
    index = frees |> Enum.find_index(&has_enough_space?(file, &1))
    case index do
      nil -> {:not_found, nil, nil}
      index ->
        free_space = frees |> Enum.at(index)
        edited_free_space = DiskMapEntry.new_free(free_space.offset + file.size, free_space.size - file.size)
        new_frees =
          frees
          |> List.replace_at(index, edited_free_space)
          |> Enum.filter(&is_before_file?(file, &1))
        # need to remove all after the file offset
        new_file = DiskMapEntry.new_file(file.id, free_space.offset, file.size)
        {:found, new_frees, new_file}
    end
  end

  defp has_enough_space?(file, free_space), do: free_space.size >= file.size
  defp is_before_file?(file, free), do: file.offset > free.offset

end
