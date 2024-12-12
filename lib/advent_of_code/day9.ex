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
end
