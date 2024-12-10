defmodule Puzzle.Helpers.Algorithms do
  @moduledoc """
  Algorithms needed to solve the puzzle that was separated from the main Puzzle
  package because thet `Puzzle.solve/1` would become too big and confusing.
  """

  @doc "Generates the block lists with the file IDs and emtpy spaces."
  def map_blocks(disk_map) do
    Enum.reduce(disk_map, {[], :is_file, 0}, fn
      size, {blocks, :is_file, id} ->
        {blocks ++ List.duplicate(id, size), :is_empty, id + 1}

      size, {blocks, :is_empty, id} ->
        {blocks ++ List.duplicate(nil, size), :is_file, id}
    end)
    |> elem(0)
  end

  @doc "Iterates over a blocks list to calculate the final checksum number."
  def calc_checksum(blocks) do
    Enum.with_index(blocks)
    |> Enum.map(fn
      {nil, _} -> 0
      {num, idx} -> idx * num
    end)
    |> Enum.sum()
  end
end
